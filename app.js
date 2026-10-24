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

function vistaLogin(msg = "") {
  btnSalir.hidden = true;
  pintar(`
    <div class="box card">
      <h1>Entrar</h1>
      <p class="muted">Escribe tu correo y te llega un enlace para entrar. Sin contraseñas.</p>
      <form id="f-login">
        <input type="email" id="email" required placeholder="tu@correo.com" autocomplete="email">
        <button class="btn" id="btn-enviar">Enviarme el enlace</button>
      </form>
      <p id="login-msg" class="muted">${esc(msg)}</p>
    </div>`);
  document.getElementById("f-login").onsubmit = async (ev) => {
    ev.preventDefault();
    const email = document.getElementById("email").value.trim();
    const btn = document.getElementById("btn-enviar");
    const out = document.getElementById("login-msg");
    btn.disabled = true; out.textContent = "Enviando…";
    const { error } = await db.auth.signInWithOtp({
      email, options: { emailRedirectTo: location.origin + location.pathname }
    });
    btn.disabled = false;
    out.textContent = error ? "Error: " + error.message
      : "¡Listo! Revisa tu correo (y la carpeta de spam) y toca el enlace.";
  };
}

// ---------- vistas ----------
function vistaInicio(user) {
  pintar(`
    <h1>Hola 👋</h1>
    <p class="muted">${esc(user.email)}</p>
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
  const [u, t, p] = await Promise.all([
    db.from("unidades").select("*").eq("materia_id", "ingles").order("numero"),
    db.from("temas").select("*").order("orden"),
    contarPendientes()
  ]);
  if (u.error || t.error) return pintar(errorBox(u.error || t.error));

  const porUnidad = {};
  for (const tema of t.data) (porUnidad[tema.unidad_id] ||= []).push(tema);

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
      </div>
    </details>`).join("");

  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <h1>🇬🇧 Inglés</h1>
    <div class="card" style="margin:16px 0">
      <h2>Tarjetas de repaso</h2>
      <p class="muted">${p} tarjeta(s) para repasar hoy.</p>
      <a class="btn" href="#/ingles/repaso" style="display:inline-block;text-decoration:none;margin-top:8px">Repasar ahora</a>
    </div>
    <h2 style="margin-top:24px">Libro 1 · Unidades</h2>
    ${unidadesHtml}`);
}

// Tarjetas que tocan hoy: las nuevas (sin progreso) + las vencidas
async function tarjetasDeHoy() {
  const [tj, pr] = await Promise.all([
    db.from("tarjetas").select("*").eq("materia_id", "ingles").order("id"),
    db.from("progreso").select("*")
  ]);
  if (tj.error) throw tj.error;
  if (pr.error) throw pr.error;
  const prog = Object.fromEntries(pr.data.map((x) => [x.tarjeta_id, x]));
  return tj.data
    .map((c) => ({ ...c, prog: prog[c.id] }))
    .filter((c) => !c.prog || c.prog.proxima_revision <= hoy());
}
async function contarPendientes() {
  try { return (await tarjetasDeHoy()).length; } catch { return "?"; }
}

async function vistaRepaso() {
  pintar(`<p class="muted">Preparando tarjetas…</p>`);
  let cola;
  try { cola = await tarjetasDeHoy(); } catch (e) { return pintar(errorBox(e)); }
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
        <div class="big">${esc(c.frente)}</div>
        ${volteada ? `
          <div style="font-size:1.2rem">${esc(c.reverso)}</div>
          ${c.ejemplo ? `<div class="practica"><b>${esc(c.ejemplo)}</b><br><span class="muted">${esc(c.traduccion)}</span></div>` : ""}
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
async function router() {
  const user = await usuarioActual();
  if (!user) return vistaLogin();
  btnSalir.hidden = false;
  const ruta = location.hash.replace(/^#/, "") || "/";
  if (ruta === "/ingles") return vistaIngles();
  if (ruta === "/ingles/repaso") return vistaRepaso();
  return vistaInicio(user);
}

btnSalir.onclick = async () => { await db.auth.signOut(); location.hash = "/"; vistaLogin("Sesión cerrada."); };
window.addEventListener("hashchange", router);
db.auth.onAuthStateChange((evento) => { if (evento === "SIGNED_IN") router(); });
router();
