// ============================================================
// Mi App de Estudio — lógica principal (JavaScript sin frameworks)
// ============================================================
const { SUPABASE_URL, SUPABASE_KEY } = window.APP_CONFIG;
const db = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
const app = document.getElementById("app");
const btnSalir = document.getElementById("btn-salir");

// Días de espera según la "caja" de la tarjeta (repaso espaciado tipo Leitner)
const INTERVALOS = [0, 0, 1, 3, 7, 14, 30]; // índice = caja (1 a 6)

// ---------- utilidades ----------
const esc = (s) => String(s ?? "").replace(/[&<>"']/g, (c) =>
  ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
const hoy = () => new Date().toISOString().slice(0, 10);
const sumarDias = (n) => { const d = new Date(); d.setDate(d.getDate() + n); return d.toISOString().slice(0, 10); };
const pintar = (html) => { app.innerHTML = html; window.scrollTo(0, 0); };
const errorBox = (e) => `<p class="error">Algo falló: ${esc(e?.message || e)}</p>`;

// ---------- sesión ----------
async function usuarioActual() {
  const { data } = await db.auth.getSession();
  return data.session?.user ?? null;
}

async function miPerfil() {
  const user = await usuarioActual();
  if (!user) return null;
  const { data } = await db.from("perfiles").select("*").eq("id", user.id).maybeSingle();
  return data;
}

const URL_APP = location.origin + location.pathname;
const traducirError = (m = "") =>
  /Invalid login credentials/i.test(m) ? "Correo o contraseña incorrectos."
  : /Email not confirmed/i.test(m) ? "Primero confirma tu correo: revisa tu bandeja (y spam)."
  : /already registered/i.test(m) ? "Ese correo ya tiene cuenta. Usa “Entrar”."
  : /at least 6/i.test(m) ? "La contraseña debe tener al menos 6 caracteres."
  : m;

// modo: "entrar" | "crear" | "olvide"
function vistaLogin(msg = "", modo = "entrar") {
  btnSalir.hidden = true;
  const titulos = { entrar: "Entrar", crear: "Crear cuenta", olvide: "Recuperar contraseña" };
  pintar(`
    <div class="box card">
      <h1>${titulos[modo]}</h1>
      <form id="f-login">
        ${modo === "crear" ? `<input type="text" id="nombre" required placeholder="Tu nombre" autocomplete="name">` : ""}
        <input type="email" id="email" required placeholder="tu@correo.com" autocomplete="email">
        ${modo !== "olvide" ? `<input type="password" id="clave" required minlength="6" placeholder="Contraseña"
            autocomplete="${modo === "crear" ? "new-password" : "current-password"}">` : ""}
        <button class="btn" id="btn-enviar">${modo === "olvide" ? "Enviarme el enlace" : titulos[modo]}</button>
      </form>
      <p id="login-msg" class="muted">${esc(msg)}</p>
      <div class="row" style="justify-content:flex-start">
        ${modo !== "entrar" ? `<button class="link" data-modo="entrar">Ya tengo cuenta</button>` : ""}
        ${modo !== "crear" ? `<button class="link" data-modo="crear">Crear cuenta</button>` : ""}
        ${modo !== "olvide" ? `<button class="link" data-modo="olvide">Olvidé mi contraseña</button>` : ""}
      </div>
    </div>`);
  app.querySelectorAll("[data-modo]").forEach((b) => (b.onclick = () => vistaLogin("", b.dataset.modo)));

  document.getElementById("f-login").onsubmit = async (ev) => {
    ev.preventDefault();
    const email = document.getElementById("email").value.trim();
    const clave = document.getElementById("clave")?.value;
    const btn = document.getElementById("btn-enviar");
    const out = document.getElementById("login-msg");
    btn.disabled = true; out.textContent = "Un momento…";
    let error;
    if (modo === "entrar") {
      ({ error } = await db.auth.signInWithPassword({ email, password: clave }));
      if (!error) return router();
    } else if (modo === "crear") {
      const nombre = document.getElementById("nombre").value.trim();
      ({ error } = await db.auth.signUp({
        email, password: clave, options: { data: { nombre }, emailRedirectTo: URL_APP }
      }));
      if (!error) out.textContent = "¡Cuenta creada! Revisa tu correo para confirmarla. Luego el administrador debe aprobarte.";
    } else {
      ({ error } = await db.auth.resetPasswordForEmail(email, { redirectTo: URL_APP }));
      if (!error) out.textContent = "Te enviamos un enlace para crear una contraseña nueva. Revisa tu correo (y spam).";
    }
    btn.disabled = false;
    if (error) out.textContent = traducirError(error.message);
  };
}

// Pantalla para poner / cambiar contraseña (también llega aquí desde "Olvidé mi contraseña")
function vistaClave(msg = "") {
  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <div class="box card">
      <h1>Mi contraseña</h1>
      <p class="muted">${esc(msg || "Escribe tu nueva contraseña (mínimo 6 caracteres).")}</p>
      <form id="f-clave">
        <input type="password" id="c1" required minlength="6" placeholder="Nueva contraseña" autocomplete="new-password">
        <input type="password" id="c2" required minlength="6" placeholder="Repítela" autocomplete="new-password">
        <button class="btn" id="b-clave">Guardar contraseña</button>
      </form>
      <p id="clave-msg" class="muted"></p>
    </div>`);
  document.getElementById("f-clave").onsubmit = async (ev) => {
    ev.preventDefault();
    const c1 = document.getElementById("c1").value, c2 = document.getElementById("c2").value;
    const out = document.getElementById("clave-msg");
    if (c1 !== c2) return (out.textContent = "Las dos contraseñas no coinciden.");
    const { error } = await db.auth.updateUser({ password: c1 });
    out.textContent = error ? traducirError(error.message) : "✅ Contraseña guardada. Ya puedes entrar con tu correo y esta contraseña.";
  };
}

function vistaPendiente(user) {
  pintar(`
    <div class="box card">
      <h1>Cuenta pendiente ⏳</h1>
      <p>Hola${user?.user_metadata?.nombre ? " " + esc(user.user_metadata.nombre) : ""}, tu cuenta (<b>${esc(user?.email)}</b>) ya está creada.</p>
      <p class="muted">El administrador debe darte acceso. Cuando lo haga, recarga esta página.</p>
      <div class="row"><button class="btn alt" onclick="location.reload()">Recargar</button></div>
    </div>`);
}

async function vistaAdmin(yo) {
  pintar(`<p class="muted">Cargando usuarios…</p>`);
  const { data, error } = await db.from("perfiles").select("*").order("creado");
  if (error) return pintar(errorBox(error));
  const pendientes = data.filter((p) => !p.activo).length;
  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <h1>👑 Administrar accesos</h1>
    <p class="muted">${data.length} usuario(s) · ${pendientes} pendiente(s) de aprobar</p>
    ${data.map((p) => `
      <div class="card" style="margin:10px 0">
        <div style="display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;align-items:center">
          <div>
            <b>${esc(p.nombre || "(sin nombre)")}</b>
            <span class="pill">${p.rol === "admin" ? "Administrador" : "Estudiante"}</span>
            <span class="pill" style="color:${p.activo ? "var(--accent)" : "var(--bad)"}">${p.activo ? "Con acceso" : "Pendiente"}</span>
            <div class="muted">${esc(p.email)}</div>
          </div>
          ${p.id === yo.id ? `<span class="muted">(tú)</span>` : `
          <div class="row" style="margin:0">
            <button class="btn ${p.activo ? "bad" : ""}" data-acc="activo" data-id="${p.id}" data-val="${!p.activo}">
              ${p.activo ? "Quitar acceso" : "Dar acceso"}</button>
            <button class="btn alt" data-acc="rol" data-id="${p.id}" data-val="${p.rol === "admin" ? "estudiante" : "admin"}">
              ${p.rol === "admin" ? "Quitar admin" : "Hacer admin"}</button>
          </div>`}
        </div>
      </div>`).join("")}`);
  app.querySelectorAll("[data-acc]").forEach((b) => (b.onclick = async () => {
    const cambio = b.dataset.acc === "activo" ? { activo: b.dataset.val === "true" } : { rol: b.dataset.val };
    b.disabled = true;
    const { error } = await db.from("perfiles").update(cambio).eq("id", b.dataset.id);
    if (error) return alert("No se pudo guardar: " + error.message);
    vistaAdmin(yo);
  }));
}

// ---------- vistas ----------
function vistaInicio(user, perfil) {
  pintar(`
    <h1>Hola${perfil.nombre ? " " + esc(perfil.nombre) : ""} 👋</h1>
    <p class="muted">${esc(user.email)} ·
      <a href="#/clave">Mi contraseña</a>
      ${perfil.rol === "admin" ? ` · <a href="#/admin">👑 Administrar accesos</a>` : ""}</p>
    <div class="grid">
      <a class="card" href="#/ingles">
        <h2>🇬🇧 Inglés</h2>
        <p class="muted">English My Way · Libro 1: unidades, temas y tarjetas de repaso.</p>
        <span class="tag">Entrar →</span>
      </a>
      <div class="card">
        <h2>💻 Programación</h2>
        <p class="muted">Temas del técnico en programación de software.</p>
        <span class="tag">Próximamente</span>
      </div>
    </div>`);
}

async function vistaIngles() {
  pintar(`<p class="muted">Cargando unidades…</p>`);
  const [u, t, p, tj] = await Promise.all([
    db.from("unidades").select("*").eq("materia_id", "ingles").order("numero"),
    db.from("temas").select("*").order("orden"),
    contarPendientes(),
    db.from("tarjetas").select("id, unidad_id").eq("materia_id", "ingles")
  ]);
  if (u.error || t.error) return pintar(errorBox(u.error || t.error));

  const porUnidad = {};
  for (const tema of t.data) (porUnidad[tema.unidad_id] ||= []).push(tema);
  const tarjetasPorUnidad = {};
  for (const c of tj.data || []) tarjetasPorUnidad[c.unidad_id] = (tarjetasPorUnidad[c.unidad_id] || 0) + 1;

  const unidadesHtml = u.data.map((un) => `
    <details class="unidad">
      <summary>Unidad ${un.numero}
        ${un.episodio ? `<span class="pill">${esc(un.episodio)}</span>` : ""}
        <span class="pill">págs. ${esc(un.paginas)}</span>
        ${un.objetivo ? `<div class="muted" style="font-weight:400">${esc(un.objetivo)}</div>` : ""}
      </summary>
      <div class="unidad-body">
        ${(porUnidad[un.id] || []).map((tm) => `
          <div class="tema">
            <div class="sec">${esc(tm.seccion)} · págs. ${esc(tm.paginas)}</div>
            <div>${esc(tm.tema_en)}</div>
            <div class="muted">${esc(tm.tema_es)}</div>
          </div>`).join("")}
        ${un.practica ? `<div class="practica">✍️ <b>Práctica:</b> ${esc(un.practica)}</div>` : ""}
        ${tarjetasPorUnidad[un.id] ? `
          <a class="btn alt" href="#/ingles/repaso/${un.id}" style="display:inline-block;text-decoration:none;margin-top:12px">
            🃏 Repasar esta unidad (${tarjetasPorUnidad[un.id]} tarjetas)</a>` : ""}
      </div>
    </details>`).join("");

  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <h1>🇬🇧 Inglés</h1>
    <div class="card" style="margin:16px 0">
      <h2>Repaso del día</h2>
      <p class="muted">${p} tarjeta(s) para hoy: las que te tocan repasar + hasta ${NUEVAS_POR_DIA} nuevas.
        Para practicar una unidad completa, ábrela abajo.</p>
      <a class="btn" href="#/ingles/repaso" style="display:inline-block;text-decoration:none;margin-top:8px">Repasar ahora</a>
    </div>
    <h2 style="margin-top:24px">Libro 1 · Unidades</h2>
    ${unidadesHtml}`);
}

// Máximo de tarjetas NUEVAS por día en el repaso general (para no abrumar)
const NUEVAS_POR_DIA = 15;

// Tarjetas que tocan hoy: las vencidas + las nuevas (sin progreso).
// Con unidadId: todas las pendientes de esa unidad. Sin unidadId: vencidas + hasta 15 nuevas.
async function tarjetasDeHoy(unidadId = null) {
  let consulta = db.from("tarjetas").select("*").eq("materia_id", "ingles")
    .order("unidad_id", { ascending: true }).order("id");
  if (unidadId) consulta = consulta.eq("unidad_id", unidadId);
  const [tj, pr] = await Promise.all([consulta, db.from("progreso").select("*")]);
  if (tj.error) throw tj.error;
  if (pr.error) throw pr.error;
  const prog = Object.fromEntries(pr.data.map((x) => [x.tarjeta_id, x]));
  const todas = tj.data.map((c) => ({ ...c, prog: prog[c.id] }));
  const vencidas = todas.filter((c) => c.prog && c.prog.proxima_revision <= hoy());
  let nuevas = todas.filter((c) => !c.prog);
  if (!unidadId) nuevas = nuevas.slice(0, NUEVAS_POR_DIA);
  return [...vencidas, ...nuevas];
}

// 🔊 Pronunciación con la voz del navegador (gratis, sin internet extra)
function hablar(texto) {
  if (!("speechSynthesis" in window)) return alert("Tu navegador no tiene voz disponible.");
  const limpio = String(texto).replace(/[→/]/g, ", ").replace(/[—…]/g, " ").replace(/\s+/g, " ").trim();
  speechSynthesis.cancel();
  const voz = new SpeechSynthesisUtterance(limpio);
  voz.lang = "en-US";
  voz.rate = 0.9;
  const ingles = speechSynthesis.getVoices().find((v) => v.lang?.startsWith("en"));
  if (ingles) voz.voice = ingles;
  speechSynthesis.speak(voz);
}
const btnVoz = (texto) =>
  `<button class="voz" title="Escuchar" data-voz="${esc(texto)}">🔊</button>`;
app.addEventListener("click", (e) => {
  const b = e.target.closest("[data-voz]");
  if (b) hablar(b.dataset.voz);
});
async function contarPendientes() {
  try { return (await tarjetasDeHoy()).length; } catch { return "?"; }
}

async function vistaRepaso(unidadId = null) {
  pintar(`<p class="muted">Preparando tarjetas…</p>`);
  let cola;
  try { cola = await tarjetasDeHoy(unidadId); } catch (e) { return pintar(errorBox(e)); }
  if (!cola.length) return pintar(`
    <a href="#/ingles" class="link">← Inglés</a>
    <div class="card flash" style="margin-top:16px">
      <div class="big">✅ Al día</div>
      <p class="muted">No tienes tarjetas pendientes ${unidadId ? "en esta unidad" : "hoy"}. ¡Vuelve mañana!</p>
    </div>`);
  let i = 0, bien = 0, mal = 0;

  const mostrar = (volteada = false) => {
    if (i >= cola.length) {
      return pintar(`
        <a href="#/ingles" class="link">← Inglés</a>
        <div class="card flash" style="margin-top:16px">
          <div class="big">🎉 ¡Repaso terminado!</div>
          <p class="muted">Sabías ${bien} · Por reforzar ${mal}</p>
          <div class="row"><a class="btn" href="#/ingles" style="text-decoration:none">Volver a Inglés</a></div>
        </div>`);
    }
    const c = cola[i];
    pintar(`
      <a href="#/ingles" class="link">← Inglés</a>
      <div class="stats muted"><span>Tarjeta ${i + 1} de ${cola.length}</span><span>✅ ${bien}</span><span>🔁 ${mal}</span></div>
      <div class="card flash">
        <div class="sec">${esc(c.tema)}</div>
        <div class="big">${esc(c.frente)} ${btnVoz(c.frente)}</div>
        ${volteada ? `
          <div style="font-size:1.2rem">${esc(c.reverso)}</div>
          ${c.ejemplo ? `<div class="practica"><b>${esc(c.ejemplo)}</b> ${btnVoz(c.ejemplo)}<br><span class="muted">${esc(c.traduccion)}</span></div>` : ""}
          <div class="row">
            <button class="btn bad" id="b-no">No lo sabía</button>
            <button class="btn" id="b-si">Lo sabía</button>
          </div>`
        : `<div class="row"><button class="btn alt" id="b-ver">Ver respuesta</button></div>`}
      </div>`);
    if (!volteada) document.getElementById("b-ver").onclick = () => mostrar(true);
    else {
      document.getElementById("b-si").onclick = () => responder(c, true);
      document.getElementById("b-no").onclick = () => responder(c, false);
    }
  };

  const responder = async (c, acerto) => {
    const p = c.prog || { caja: 1, aciertos: 0, fallos: 0 };
    const caja = acerto ? Math.min(p.caja + 1, 6) : 1;
    const fila = {
      tarjeta_id: c.id, caja,
      proxima_revision: acerto ? sumarDias(INTERVALOS[caja]) : hoy(),
      aciertos: p.aciertos + (acerto ? 1 : 0),
      fallos: p.fallos + (acerto ? 0 : 1),
      actualizado: new Date().toISOString()
    };
    const { error } = await db.from("progreso").upsert(fila);
    if (error) return pintar(errorBox(error));
    acerto ? bien++ : mal++;
    i++; mostrar();
  };

  mostrar();
}

// ---------- enrutador (cambia de pantalla según el # de la dirección) ----------
let modoRecuperacion = false;

async function router() {
  const user = await usuarioActual();
  if (!user) return vistaLogin();
  btnSalir.hidden = false;
  if (modoRecuperacion) return vistaClave("Llegaste desde el enlace de recuperación. Crea tu nueva contraseña.");
  const ruta = location.hash.replace(/^#/, "") || "/";
  if (ruta === "/clave") return vistaClave();
  const perfil = await miPerfil();
  if (!perfil || !perfil.activo) return vistaPendiente(user);
  if (ruta === "/admin" && perfil.rol === "admin") return vistaAdmin(perfil);
  if (ruta === "/ingles") return vistaIngles();
  if (ruta === "/ingles/repaso") return vistaRepaso();
  const m = ruta.match(/^\/ingles\/repaso\/(\d+)$/);
  if (m) return vistaRepaso(Number(m[1]));
  return vistaInicio(user, perfil);
}

btnSalir.onclick = async () => { await db.auth.signOut(); location.hash = "/"; vistaLogin("Sesión cerrada."); };
window.addEventListener("hashchange", () => { modoRecuperacion = false; router(); });
db.auth.onAuthStateChange((evento) => {
  if (evento === "PASSWORD_RECOVERY") { modoRecuperacion = true; router(); }
  else if (evento === "SIGNED_IN") router();
});
router();
