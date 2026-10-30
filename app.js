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

// Campo de contraseña con ojito 👁 para ver lo que se escribe (sin mayúscula ni corrector automático del celular)
const campoClave = (id, placeholder, autocomplete) => `
  <div class="campo-clave">
    <input type="password" id="${id}" required minlength="6" placeholder="${placeholder}" autocomplete="${autocomplete}"
      autocapitalize="off" autocorrect="off" spellcheck="false">
    <button type="button" class="ojo" data-ojo="${id}" aria-label="Mostrar contraseña" title="Mostrar contraseña">👁</button>
  </div>`;
document.addEventListener("click", (e) => {
  const b = e.target.closest("[data-ojo]");
  if (!b) return;
  const inp = document.getElementById(b.dataset.ojo);
  const ver = inp.type === "password";
  inp.type = ver ? "text" : "password";
  b.textContent = ver ? "🙈" : "👁";
  b.title = b.ariaLabel = ver ? "Ocultar contraseña" : "Mostrar contraseña";
  inp.focus();
});
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
        <input type="email" id="email" required placeholder="tu@correo.com" autocomplete="email"
          autocapitalize="off" autocorrect="off" spellcheck="false" inputmode="email">
        ${modo !== "olvide" ? campoClave("clave", "Contraseña", modo === "crear" ? "new-password" : "current-password") : ""}
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
    // En el celular el teclado a veces pone mayúscula al inicio o un espacio al final: se limpia
    const email = document.getElementById("email").value.trim().toLowerCase();
    const clave = document.getElementById("clave")?.value;
    const btn = document.getElementById("btn-enviar");
    const out = document.getElementById("login-msg");
    btn.disabled = true; out.textContent = "Un momento…";
    let error;
    if (modo === "entrar") {
      ({ error } = await db.auth.signInWithPassword({ email, password: clave }));
      // Si falló y la clave tiene espacios al inicio o al final (típico del teclado del celular), se intenta sin ellos
      if (error && clave !== clave.trim()) ({ error } = await db.auth.signInWithPassword({ email, password: clave.trim() }));
      if (!error) return router();
      if (/Invalid login credentials/i.test(error.message)) {
        btn.disabled = false;
        out.textContent = "Correo o contraseña incorrectos. Toca el 👁 para revisar la contraseña: en el celular a veces se pone una mayúscula al inicio sin que te des cuenta.";
        return;
      }
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
        ${campoClave("c1", "Nueva contraseña", "new-password")}
        ${campoClave("c2", "Repítela", "new-password")}
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
async function vistaInicio(user, perfil) {
  pintar(`
    <h1>Hola${perfil.nombre ? " " + esc(perfil.nombre) : ""} 👋</h1>
    <p class="muted">${esc(user.email)} ·
      <a href="#/clave">Mi contraseña</a>
      ${perfil.rol === "admin" ? ` · <a href="#/admin">👑 Administrar accesos</a>` : ""}</p>
    <div id="wk-lugar"></div>
    <div class="grid">
      <a class="card" href="#/ingles">
        <h2>🇬🇧 Inglés</h2>
        <p class="muted">Mi camino por niveles, mis temas, práctica libre y tarjetas de repaso.</p>
        <span class="tag">Entrar →</span>
      </a>
      <div class="card">
        <h2>💻 Programación</h2>
        <p class="muted">Temas del técnico en programación de software.</p>
        <span class="tag">Próximamente</span>
      </div>
    </div>`);
  const lugar = document.getElementById("wk-lugar");
  const html = await htmlWakoInicio();
  if (lugar && document.body.contains(lugar)) { lugar.innerHTML = html; conectarWakoInicio(); }
}

async function vistaIngles() {
  pintar(`<p class="muted">Cargando unidades…</p>`);
  const [u, t, p, tj, lec] = await Promise.all([
    db.from("unidades").select("*").eq("materia_id", "ingles").order("numero"),
    db.from("temas").select("*").order("orden"),
    contarPendientes(),
    db.from("tarjetas").select("id, unidad_id").eq("materia_id", "ingles"),
    datosLecciones()
  ]);
  if (u.error || t.error) return pintar(errorBox(u.error || t.error));

  const porUnidad = {};
  for (const tema of t.data) (porUnidad[tema.unidad_id] ||= []).push(tema);
  const tarjetasPorUnidad = {};
  for (const c of tj.data || []) tarjetasPorUnidad[c.unidad_id] = (tarjetasPorUnidad[c.unidad_id] || 0) + 1;

  const htmlUnidad = (un) => `
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
    </details>`;

  // Si todavía no se corrió db/002_lecciones.sql, la app sigue funcionando como antes
  if (lec.error) {
    return pintar(`
      <a href="#/" class="link">← Inicio</a>
      <h1>🇬🇧 Inglés</h1>
      ${faltaSQL(lec.error) ? avisoSQL : errorBox(lec.error)}
      <div class="card" style="margin:16px 0">
        <h2>Repaso del día</h2>
        <p class="muted">${p} tarjeta(s) para hoy.</p>
        <a class="btn" href="#/ingles/repaso">Repasar ahora</a>
      </div>
      <h2 style="margin-top:24px">Libro 1 · Unidades</h2>
      ${u.data.map(htmlUnidad).join("")}`);
  }

  // Agrupar las unidades por episodio (así evalúa el instituto)
  const numEp = (un) => Number(String(un.episodio || "").replace(/\D/g, "")) || 0;
  const episodios = [...new Set(u.data.map(numEp))].filter(Boolean).sort((a, b) => a - b);
  const epActual = (WK.fila ? nivelActual() : null) ?? lec.siguiente?.episodio ?? episodios[0];
  const episodiosHtml = episodios.map((ep) => `
    <details class="episodio" ${ep === epActual ? "open" : ""}>
      <summary>Nivel ${ep} <span class="muted" style="font-weight:600">· Ep. ${ep} del instituto</span>
        ${ep === epActual ? `<span class="pill ok">Estás aquí</span>` : ""}
        <span class="muted" style="font-weight:400">· Unidades ${u.data.filter((un) => numEp(un) === ep).map((un) => un.numero).join(", ")}</span>
      </summary>
      <div class="episodio-body">
        ${htmlLeccionesDe(ep, lec) || `<p class="muted">Lecciones de este nivel: próximamente.</p>`}
        ${htmlLecturasDe(ep)}
        <div class="sec" style="margin-top:14px">Temas del libro</div>
        ${u.data.filter((un) => numEp(un) === ep).map(htmlUnidad).join("")}
      </div>
    </details>`).join("");
  const sinEpisodio = u.data.filter((un) => !numEp(un));

  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <h1>🇬🇧 Inglés</h1>
    ${htmlPanelHoy(lec, p)}
    <h2 style="margin-top:24px">Niveles</h2>
    ${episodiosHtml}
    ${sinEpisodio.map(htmlUnidad).join("")}`);
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
// velocidad: 0.9 normal · 0.55 lenta (🐢) · 0.75 palabra suelta
const VEL = { normal: 0.9, lenta: 0.55, palabra: 0.75 };
function hablar(texto, rate = VEL.normal) {
  if (!("speechSynthesis" in window)) return alert("Tu navegador no tiene voz disponible.");
  const limpio = String(texto).replace(/[→/]/g, ", ").replace(/[—…]/g, " ").replace(/_+/g, " ").replace(/\s+/g, " ").trim();
  if (!limpio) return;
  speechSynthesis.cancel();
  const voz = new SpeechSynthesisUtterance(limpio);
  voz.lang = "en-US";
  voz.rate = rate;
  const ingles = speechSynthesis.getVoices().find((v) => v.lang?.startsWith("en"));
  if (ingles) voz.voice = ingles;
  speechSynthesis.speak(voz);
}
// Botones 🔊 normal + 🐢 lento
const btnVoz = (texto) =>
  `<button class="voz" title="Escuchar" data-voz="${esc(texto)}">🔊</button>` +
  `<button class="voz" title="Escuchar despacio" data-voz-lento="${esc(texto)}">🐢</button>`;
// Frase con cada palabra tocable: al tocarla se oye sola
const fraseTocable = (texto) => String(texto).split(/(\s+)/).map((w) => {
  const palabra = w.replace(/^[^A-Za-z0-9']+|[^A-Za-z0-9']+$/g, "");
  return palabra && !/^_+$/.test(w) ? `<span class="palabra" data-palabra="${esc(palabra)}">${esc(w)}</span>` : esc(w);
}).join("");
document.addEventListener("click", (e) => { // en la página y en el tutor flotante
  const b = e.target.closest("[data-voz]");
  if (b) return hablar(b.dataset.voz);
  const l = e.target.closest("[data-voz-lento]");
  if (l) return hablar(l.dataset.vozLento, VEL.lenta);
  const p = e.target.closest("[data-palabra]");
  if (p) {
    p.classList.add("oida"); setTimeout(() => p.classList.remove("oida"), 600);
    hablar(p.dataset.palabra, VEL.palabra);
  }
});
async function contarPendientes() {
  try { return (await tarjetasDeHoy()).length; } catch { return "?"; }
}

// Tarjetas: sale la frase en español y la dices en inglés (o la escribes). Si la dices bien, pasa sola a la siguiente.
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
  cola = mezclar(cola);
  let i = 0, bien = 0, mal = 0, xp = 0;
  const inicio = Date.now();
  // Qué se pide: la frase de ejemplo si existe (más natural para decir); si no, la palabra o expresión
  const meta = (c) => c.ejemplo && c.traduccion
    ? { es: c.traduccion, en: c.ejemplo, respuestas: [c.ejemplo] }
    : { es: c.reverso, en: c.frente, respuestas: [c.frente.replace(/\s*\/\s*/g, " "), ...c.frente.split("/").map((x) => x.trim())] };

  const mostrar = () => {
    if (i >= cola.length) {
      try { if (typeof energiaSumarMinutos === "function") energiaSumarMinutos(Math.max(2, Math.round((Date.now() - inicio) / 60000))); } catch {}
      try { if (xp) sumarXP(xp); } catch {}
      return pintar(`
        <a href="#/ingles" class="link">← Inglés</a>
        <div class="card flash" style="margin-top:16px">
          <div class="big">🎉 ¡Repaso terminado!</div>
          <p class="muted">Dichas bien a la primera: ${bien} · Por reforzar: ${mal}${xp ? ` · +${xp} XP` : ""}</p>
          <div class="row"><a class="btn" href="#/ingles" style="text-decoration:none">Volver a Inglés</a></div>
        </div>`);
    }
    const c = cola[i], m = meta(c);
    let intentos = 0;
    ponerContexto(`Tarjeta de repaso ${i + 1} de ${cola.length} (debe DECIR la frase en inglés)`,
      `Frase en español: ${m.es}\nRespuesta: ${m.en}\nEstado: aún no responde (dale una pista, no la respuesta, salvo que la pida).`);
    pintar(`
      <a href="#/ingles" class="link">← Inglés</a>
      <div class="stats muted"><span>Tarjeta ${i + 1} de ${cola.length}</span><span>✅ ${bien}</span><span>🔁 ${mal}</span></div>
      <div class="card flash tarjeta-voz">
        <div class="sec">${esc(c.tema || "")}</div>
        <div class="muted">🗣 Dilo en inglés:</div>
        <div class="big">${esc(m.es)}</div>
        <div id="tj-zona">
          <div class="row"><button class="btn mic-grande" id="tj-mic">🎤 Toca y dilo</button></div>
          <div class="row" style="margin-top:6px">
            <button class="link" id="tj-tec">⌨️ Escribirlo</button>
            <button class="link" id="tj-ver">🙈 No sé, ver respuesta</button>
          </div>
          <input type="text" id="tj-in" hidden autocomplete="off" autocapitalize="off" spellcheck="false" placeholder="Escríbelo en inglés y presiona Enter">
        </div>
        <p class="error" id="tj-err"></p>
        <div id="tj-fb"></div>
      </div>`);
    const err = (t) => (document.getElementById("tj-err").textContent = t || "");
    const fb = document.getElementById("tj-fb");
    const respuestaHtml = () => `<div class="practica"><b>${fraseTocable(m.en)}</b> ${btnVoz(m.en)}${c.ejemplo && m.en !== c.frente ? `<div class="muted">${esc(c.frente)} = ${esc(c.reverso)}</div>` : ""}</div>`;
    const siguiente = (acerto) => responder(c, acerto);
    const fallar = (dicho) => {
      intentos++;
      fb.innerHTML = `
        <div class="fb fb-mal">
          <b>${dicho ? "Casi. Se dice así:" : "Se dice así:"}</b>
          ${dicho ? `<div class="muted">Dijiste: ${esc(dicho)}</div>` : ""}
          ${respuestaHtml()}
          <div class="row"><button class="btn alt" id="tj-otra">🔁 Intentar otra vez</button><button class="btn" id="tj-sig">Siguiente →</button></div>
        </div>`;
      try { hablar(m.en); } catch {}
      document.getElementById("tj-otra").onclick = () => { fb.innerHTML = ""; err(""); };
      document.getElementById("tj-sig").onclick = () => siguiente(false);
    };
    const revisar = (dicho) => {
      err("");
      const r = parecido(dicho, m.respuestas);
      if (!r.ok) return fallar(dicho);
      const primera = intentos === 0;
      if (primera) xp += 2;
      fb.innerHTML = `<div class="fb fb-ok"><b>✅ ¡Bien dicho!${r.casi ? " (casi perfecto)" : ""}</b>${respuestaHtml()}</div>`;
      document.getElementById("tj-zona").hidden = true;
      try { hablar(m.en); } catch {}
      setTimeout(() => siguiente(primera), 1700); // pasa sola a la siguiente
    };
    const mic = document.getElementById("tj-mic");
    mic.onclick = () => grabarVoz(mic, revisar, err);
    const inp = document.getElementById("tj-in");
    document.getElementById("tj-tec").onclick = (e) => { inp.hidden = false; inp.focus(); e.target.hidden = true; };
    inp.onkeydown = (e) => { if (e.key === "Enter" && inp.value.trim()) { revisar(inp.value); inp.value = ""; } };
    document.getElementById("tj-ver").onclick = () => fallar("");
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

// Nombre de cada pantalla para el tutor flotante y la barra de abajo
function nombrePantalla(ruta) {
  if (ruta === "/") return "Inicio";
  if (ruta === "/ingles") return "Inglés: panel Hoy y lista de episodios";
  if (ruta === "/wako") return "Wako, su compañero de estudio (bot que crece con su inglés)";
  if (ruta === "/temas") return "Mis temas: semáforo de dominio por tema del nivel";
  if (ruta === "/ubicacion") return "Examen de ubicación (no des respuestas)";
  if (ruta === "/nowican") return "Now I Can: examen para subir de nivel (no des respuestas)";
  if (ruta.startsWith("/ingles/repaso")) return "Tarjetas de repaso";
  if (ruta === "/ingles/errores") return "Mis errores";
  if (ruta === "/ingles/lecturas") return "Lista de Leer y escuchar";
  if (ruta.startsWith("/ingles/lectura/")) return "Leer y escuchar";
  if (ruta.startsWith("/ingles/leccion/")) return "Lección";
  return "App de estudio";
}
function marcarNavegacion(ruta, visible) {
  const enFoco = /^\/ingles\/(leccion|errores|repaso|lectura\/)/.test(ruta) || /^\/(camino|ubicacion)$/.test(ruta); // pantallas sin distracciones
  const nav = document.getElementById("nav");
  nav.hidden = !visible || enFoco;
  document.body.classList.toggle("con-nav", !nav.hidden);
  nav.querySelectorAll("a").forEach((a) => a.classList.toggle("activo", a.dataset.ruta === ruta));
  // El tutor flotante va en todas las pantallas, menos en el tutor completo y en "Mi vida"
  tfVisible(visible && !/^\/ingles\/(tutor|mi-vida)/.test(ruta) && !/^\/(clave|admin|ubicacion|nowican)$/.test(ruta));
}

async function router() {
  const user = await usuarioActual();
  if (!user) { marcarNavegacion("/", false); return vistaLogin(); }
  btnSalir.hidden = false;
  if (modoRecuperacion) return vistaClave("Llegaste desde el enlace de recuperación. Crea tu nueva contraseña.");
  const ruta = location.hash.replace(/^#/, "") || "/";
  if (ruta === "/clave") { marcarNavegacion(ruta, true); return vistaClave(); }
  const perfil = await miPerfil();
  if (!perfil || !perfil.activo) { marcarNavegacion(ruta, false); return vistaPendiente(user); }
  ponerContexto(nombrePantalla(ruta));
  marcarNavegacion(ruta, true);
  if (ruta === "/admin" && perfil.rol === "admin") return vistaAdmin(perfil);
  if (ruta === "/wako") return vistaWako();
  if (ruta === "/camino") return vistaCamino();
  if (ruta === "/temas") return vistaTemas();
  if (ruta === "/ubicacion") return vistaUbicacion();
  if (ruta === "/nowican") return vistaNowICan();
  if (ruta === "/ingles") { await cargarHechas(); try { await wakoCargar(); } catch {} return vistaIngles(); }
  if (ruta === "/ingles/repaso") return vistaRepaso();
  const m = ruta.match(/^\/ingles\/repaso\/(\d+)$/);
  if (m) return vistaRepaso(Number(m[1]));
  if (ruta === "/ingles/errores") return vistaLeccion("errores");
  if (ruta === "/ingles/lecturas") return vistaLecturas();
  if (ruta === "/ingles/tutor") return vistaTutor();
  if (ruta === "/ingles/mi-vida") return vistaMiVida();
  const mr = ruta.match(/^\/ingles\/lectura\/([\w-]+)$/);
  if (mr) return vistaLectura(mr[1]);
  const ml = ruta.match(/^\/ingles\/leccion\/([\w-]+)$/);
  if (ml) return vistaLeccion(ml[1]);
  return vistaInicio(user, perfil);
}

btnSalir.onclick = async () => { await db.auth.signOut(); location.hash = "/"; vistaLogin("Sesión cerrada."); };
window.addEventListener("hashchange", () => { modoRecuperacion = false; router(); });
db.auth.onAuthStateChange((evento) => {
  if (evento === "PASSWORD_RECOVERY") { modoRecuperacion = true; router(); }
  else if (evento === "SIGNED_IN") router();
});
router();
