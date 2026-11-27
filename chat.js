// ---------- Chat entre amigas y primos + regalos de energía (030) ----------
// Solo se puede escribir a amistades aprobadas. El administrador puede leer todo.
let chatTimer = null;
const pararChat = () => { if (chatTimer) { clearInterval(chatTimer); chatTimer = null; } };
const horaChat = (t) => new Date(t).toLocaleTimeString("es-CO", { hour: "2-digit", minute: "2-digit" });

async function contactosDe(uid = null) {
  const { data, error } = await db.rpc("contactos_de", uid ? { uid } : {});
  if (error) throw error;
  return data || [];
}

async function nombresDe(ids) {
  const { data } = await db.from("perfiles").select("id, nombre, email").in("id", ids);
  const mapa = {};
  (data || []).forEach((p) => (mapa[p.id] = p.nombre || p.email || ""));
  return mapa;
}

// ----- lista de amistades -----
async function vistaChatLista() {
  pararChat();
  pintar(`<p class="muted">Cargando chat…</p>`);
  let cs;
  try { cs = await contactosDe(); } catch (e) { return pintar(errorBox(e)); }
  const recibidas = cs.filter((c) => c.estado === "pendiente" && !c.pedida_por_mi);
  const enviadas = cs.filter((c) => c.estado === "pendiente" && c.pedida_por_mi);
  const amigos = cs.filter((c) => c.estado === "aceptada" && c.aprobada);
  const esperando = cs.filter((c) => c.estado === "aceptada" && !c.aprobada);

  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <h1>💬 Chat</h1>
    <div class="card">
      <h2>Agregar amigo o primo</h2>
      <p class="muted">Escribe su correo. Verás su nombre antes de pedir la amistad.</p>
      <form id="c-buscar" class="row">
        <input id="c-email" type="email" placeholder="correo@ejemplo.com" required>
        <button class="btn alt">Buscar</button>
      </form>
      <div id="c-resultado"></div>
    </div>
    ${recibidas.length ? `<h2>Solicitudes para ti</h2>${recibidas.map((c) => `
      <div class="card" style="margin:8px 0">
        <b>${esc(c.nombre)}</b>
        <div class="row" style="margin-top:8px">
          <button class="btn" data-de="${c.otro}" data-acc="si">Aceptar</button>
          <button class="btn alt" data-de="${c.otro}" data-acc="no">Rechazar</button>
        </div>
      </div>`).join("")}` : ""}
    <h2>Mis amigos</h2>
    ${amigos.length ? amigos.map((c) => `
      <a class="card" href="#/chat/${c.otro}" style="display:block;margin:8px 0">
        <b>${esc(c.nombre)}</b> <span class="tag">Abrir →</span>
      </a>`).join("") : `<p class="muted">Todavía no tienes amigos en el chat.</p>`}
    ${esperando.length ? `<h2>Esperando aprobación</h2>${esperando.map((c) => `<p class="muted">${esc(c.nombre)}: el administrador debe aprobar esta amistad.</p>`).join("")}` : ""}
    ${enviadas.length ? `<h2>Solicitudes enviadas</h2>${enviadas.map((c) => `<p class="muted">${esc(c.nombre)}: esperando que acepte.</p>`).join("")}` : ""}
  `);

  document.getElementById("c-buscar").onsubmit = async (ev) => {
    ev.preventDefault();
    const out = document.getElementById("c-resultado");
    const email = document.getElementById("c-email").value.trim();
    const { data, error } = await db.rpc("buscar_usuario", { p_email: email });
    if (error) return (out.innerHTML = errorBox(error));
    if (!data || !data.length) return (out.innerHTML = `<p class="muted">No encontramos a nadie con ese correo.</p>`);
    const u = data[0];
    out.innerHTML = `<p>Encontrado: <b>${esc(u.nombre)}</b> <button class="btn" id="c-pedir">Pedir amistad</button></p>`;
    document.getElementById("c-pedir").onclick = async () => {
      const { data: msg, error: e2 } = await db.rpc("pedir_amistad", { p_para: u.id });
      out.innerHTML = e2 ? errorBox(e2) : `<p class="muted">${esc(msg)}</p>`;
    };
  };

  document.querySelectorAll("[data-de]").forEach((b) => (b.onclick = async () => {
    const { error } = await db.rpc("responder_amistad", { p_de: b.dataset.de, p_aceptar: b.dataset.acc === "si" });
    if (error) return alert(error.message);
    vistaChatLista();
  }));
}

// ----- conversación -----
// Modo normal: yo escribo con mi amiga. Modo admin (admin): solo lectura de la conversación de dos personas.
async function vistaConversacion(yo, otroId, admin = null) {
  pararChat();
  const ruta = location.hash;
  const dueno = admin ? admin.uid : yo.id;
  const volver = admin
    ? `<a href="#/admin/supervisar/${admin.uid}" class="link">← Conversaciones</a>`
    : `<a href="#/chat" class="link">← Chat</a>`;
  pintar(`${volver}<p class="muted">Cargando conversación…</p>`);

  let nombres;
  try {
    nombres = await nombresDe([dueno, otroId]);
    if (!admin) {
      const cs = await contactosDe();
      const c = cs.find((x) => x.otro === otroId);
      if (!c || c.estado !== "aceptada" || !c.aprobada) return pintar(volver + `<p class="muted">Esta conversación no está disponible.</p>`);
      nombres[otroId] = c.nombre;
    }
  } catch (e) { return pintar(volver + errorBox(e)); }

  const titulo = admin ? `${esc(nombres[dueno])} con ${esc(nombres[otroId])}` : esc(nombres[otroId] || "Amiga o primo");
  const yoId = admin ? null : yo.id;

  pintar(`
    ${volver}
    <h1>💬 ${titulo}</h1>
    ${admin ? `<p class="muted">Vista de supervisión: solo lectura.</p>` : `
    <div class="row" style="margin:8px 0">
      <button class="btn alt" id="b-reg-1">🎁 Regalar ½ raya</button>
      <button class="btn alt" id="b-reg-2">🎁 Regalar 1 raya</button>
      <button class="btn bad" id="b-bloq">Bloquear</button>
    </div>
    <p id="c-aviso" class="muted"></p>`}
    <div id="c-caja" class="caja-chat"></div>
    ${admin ? "" : `
    <form id="c-form" class="row" style="margin-top:10px">
      <input id="c-texto" maxlength="500" placeholder="Escribe un mensaje…" autocomplete="off" required>
      <button class="btn">Enviar</button>
    </form>`}
  `);

  const caja = document.getElementById("c-caja");
  const aviso = (t) => { const a = document.getElementById("c-aviso"); if (a) a.textContent = t; };

  const pintarMensajes = async () => {
    const { data, error } = await db.from("mensajes").select("id, de, para, texto, creado, reportado")
      .or(`and(de.eq.${dueno},para.eq.${otroId}),and(de.eq.${otroId},para.eq.${dueno})`)
      .order("creado", { ascending: true }).limit(300);
    if (error) return;
    const cerca = caja.scrollTop + caja.clientHeight >= caja.scrollHeight - 60;
    caja.innerHTML = (data || []).map((m) => {
      const mio = admin ? m.de === dueno : m.de === yoId;
      const quien = admin ? `<b>${esc(nombres[m.de] || "")}</b> · ` : "";
      const rep = !admin && !mio ? ` · <a href="#" data-rep="${m.id}">reportar</a>` : "";
      return `<div class="msg ${mio ? "mio" : "otro"}">
        <div>${quien}${esc(m.texto)}</div>
        <small class="muted">${horaChat(m.creado)}${m.reportado ? " · ⚠️ reportado" : ""}${rep}</small>
      </div>`;
    }).join("") || `<p class="muted">Aún no hay mensajes.</p>`;
    if (cerca) caja.scrollTop = caja.scrollHeight;
  };
  await pintarMensajes();

  if (admin) return; // supervisión: solo lectura, sin refresco de escritura

  // Refresco automático mientras estés en esta conversación
  chatTimer = setInterval(() => {
    if (location.hash !== ruta) return pararChat();
    pintarMensajes();
  }, 8000);

  document.getElementById("c-form").onsubmit = async (ev) => {
    ev.preventDefault();
    const input = document.getElementById("c-texto");
    const texto = input.value.trim();
    if (!texto) return;
    const { error } = await db.rpc("enviar_mensaje", { p_para: otroId, p_texto: texto });
    if (error) return aviso(error.message);
    input.value = "";
    await pintarMensajes();
  };

  const regalar = async (rayas) => {
    const { data, error } = await db.rpc("enviar_regalo", { p_para: otroId, p_rayas: rayas });
    if (error) return aviso(error.message);
    aviso(`🎁 Regalo enviado. Te quedan ${Number(data).toFixed(1)} rayas hoy.`);
  };
  document.getElementById("b-reg-1").onclick = () => regalar(0.5);
  document.getElementById("b-reg-2").onclick = () => regalar(1);

  document.getElementById("b-bloq").onclick = async () => {
    if (!confirm(`¿Bloquear a ${nombres[otroId] || "esta persona"}? Ya no podrán escribirse.`)) return;
    const { error } = await db.rpc("bloquear", { p_otro: otroId });
    if (error) return aviso(error.message);
    location.hash = "#/chat";
  };

  caja.onclick = async (ev) => {
    const a = ev.target.closest("[data-rep]");
    if (!a) return;
    ev.preventDefault();
    const motivo = prompt("¿Qué pasó? (opcional)") ?? "";
    const { error } = await db.rpc("reportar_mensaje", { p_id: Number(a.dataset.rep), p_motivo: motivo });
    aviso(error ? error.message : "Reporte enviado. El administrador lo revisará.");
    pintarMensajes();
  };
}

// ----- administración: supervisar -----
async function vistaSupervisar(uid) {
  pararChat();
  pintar(`<p class="muted">Cargando…</p>`);
  let cs, nombre = "";
  try {
    cs = await contactosDe(uid);
    const { data: p } = await db.from("perfiles").select("nombre, email, nino").eq("id", uid).single();
    nombre = p ? (p.nombre || p.email) : "";
  } catch (e) { return pintar(`<a href="#/admin" class="link">← Accesos</a>` + errorBox(e)); }

  const porAprobar = cs.filter((c) => c.estado === "aceptada" && !c.aprobada);
  const amigos = cs.filter((c) => c.estado === "aceptada" && c.aprobada);
  const pendientes = cs.filter((c) => c.estado === "pendiente");

  pintar(`
    <a href="#/admin" class="link">← Accesos</a>
    <h1>💬 Chat de ${esc(nombre)}</h1>
    ${porAprobar.length ? `<h2>Amistades por aprobar</h2>${porAprobar.map((c) => `
      <div class="card" style="margin:8px 0">
        <b>${esc(c.nombre)}</b>
        <div class="row" style="margin-top:8px"><button class="btn" data-aprobar="${c.amistad_id}">Aprobar</button></div>
      </div>`).join("")}` : ""}
    <h2>Conversaciones</h2>
    ${amigos.length ? amigos.map((c) => `
      <a class="card" href="#/admin/chat/${uid}/${c.otro}" style="display:block;margin:8px 0">
        <b>${esc(c.nombre)}</b> <span class="tag">Leer →</span>
      </a>`).join("") : `<p class="muted">Sin conversaciones aprobadas.</p>`}
    ${pendientes.length ? `<h2>Solicitudes pendientes</h2>${pendientes.map((c) => `<p class="muted">${esc(c.nombre)} · ${c.pedida_por_mi ? "pidió" : "le pidieron"} amistad</p>`).join("")}` : ""}
  `);

  document.querySelectorAll("[data-aprobar]").forEach((b) => (b.onclick = async () => {
    const { error } = await db.rpc("aprobar_amistad", { p_id: Number(b.dataset.aprobar) });
    if (error) return alert(error.message);
    vistaSupervisar(uid);
  }));
}

// ----- administración: reportes -----
async function vistaReportesChat() {
  pararChat();
  pintar(`<p class="muted">Cargando reportes…</p>`);
  const { data, error } = await db.from("reportes_chat")
    .select("id, motivo, creado, revisado, reporta, mensajes(texto, de, para, creado)")
    .order("creado", { ascending: false }).limit(100);
  if (error) return pintar(`<a href="#/admin" class="link">← Accesos</a>` + errorBox(error));
  const ids = [...new Set((data || []).flatMap((r) => [r.reporta, r.mensajes?.de, r.mensajes?.para]).filter(Boolean))];
  const nombres = ids.length ? await nombresDe(ids) : {};

  pintar(`
    <a href="#/admin" class="link">← Accesos</a>
    <h1>🚩 Reportes del chat</h1>
    <p class="muted">${(data || []).filter((r) => !r.revisado).length} sin revisar</p>
    ${(data || []).length ? data.map((r) => `
      <div class="card" style="margin:8px 0;${r.revisado ? "opacity:.6" : ""}">
        <div><b>${esc(nombres[r.mensajes?.de] || "")}</b> → ${esc(nombres[r.mensajes?.para] || "")}</div>
        <p>“${esc(r.mensajes?.texto || "(mensaje borrado)")}”</p>
        <p class="muted">Reportado por ${esc(nombres[r.reporta] || "")}${r.motivo ? ": " + esc(r.motivo) : ""} · ${horaChat(r.creado)}</p>
        <div class="row">
          ${r.mensajes ? `<a class="btn alt" href="#/admin/chat/${r.mensajes.de}/${r.mensajes.para}">Ver conversación</a>` : ""}
          ${r.revisado ? "" : `<button class="btn" data-revisar="${r.id}">Marcar revisado</button>`}
        </div>
      </div>`).join("") : `<p class="muted">No hay reportes.</p>`}
  `);

  document.querySelectorAll("[data-revisar]").forEach((b) => (b.onclick = async () => {
    const { error } = await db.from("reportes_chat").update({ revisado: true }).eq("id", Number(b.dataset.revisar));
    if (error) return alert(error.message);
    vistaReportesChat();
  }));
}
