// ============================================================
// Lecciones tipo Duolingo: ejercicios, XP, racha y "Mis errores"
// Usa funciones de app.js (db, pintar, esc, hablar, errorBox, usuarioActual).
// ============================================================
const META_XP = 50;          // meta diaria de XP
const XP_PRIMERA = 10;       // XP por acertar al primer intento
const XP_SEGUNDA = 5;        // XP por acertar un ejercicio que se repitió
let EPISODIO_EVALUACION = 3; // próxima evaluación en el instituto (Wako la actualiza con tus episodios aprobados)

// Fecha local de Colombia (no UTC), para que la racha cuente bien de noche
const fechaLocal = (d = new Date()) =>
  `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;

const faltaSQL = (e) => /does not exist|Could not find the table|schema cache/i.test(e?.message || "");
const avisoSQL = `
  <div class="card" style="margin:16px 0">
    <h2>Falta un paso en Supabase</h2>
    <p class="muted">Para activar las lecciones, abre Supabase → <b>SQL Editor</b>, pega el archivo
    <code>db/002_lecciones.sql</code> completo y dale <b>Run</b>. Luego recarga esta página.</p>
  </div>`;

// Voz segura: si el celular no tiene voz o falla, la lección sigue igual
const decir = (t, rate) => { try { hablar(t, rate); } catch (e) { /* sin voz */ } };

const mezclar = (arr) => {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; }
  return a;
};

// Compara respuestas escritas sin importar mayúsculas, apóstrofos ni puntuación
const normalizar = (s) => String(s).toLowerCase()
  .replace(/[’'`´]/g, "").replace(/[.,!?¿¡;:"]/g, " ").replace(/\s+/g, " ").trim();

function distancia(a, b) { // cuántas letras hay que cambiar para pasar de a a b
  const m = Array.from({ length: a.length + 1 }, (_, i) => [i]);
  for (let j = 1; j <= b.length; j++) m[0][j] = j;
  for (let i = 1; i <= a.length; i++)
    for (let j = 1; j <= b.length; j++)
      m[i][j] = Math.min(m[i - 1][j] + 1, m[i][j - 1] + 1, m[i - 1][j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
  return m[a.length][b.length];
}

// ---------- dominio por tema (Paso 1 de la hoja de ruta) ----------
// Cada respuesta suma al tema del pénsum y a su pata (estudio, input, output, fluidez).
// Si todavía no se corrió db/006, simplemente no guarda nada.
function registrarDominio(tema, pata, ok) {
  if (!tema) return;
  try {
    db.rpc("registrar_dominio", { p_tema: tema, p_pata: pata || "estudio", p_ok: !!ok, p_fecha: fechaLocal() })
      .then(({ error }) => { if (error && !/registrar_dominio|does not exist|schema cache|PGRST202/i.test(error.message)) console.warn("dominio:", error.message); });
  } catch {}
}

// ---------- XP y racha ----------
async function resumenEstudio() {
  const desde = fechaLocal(new Date(Date.now() - 60 * 864e5));
  const { data, error } = await db.from("mi_estudio").select("fecha, xp").gte("fecha", desde);
  if (error) throw error;
  const xpDe = Object.fromEntries(data.map((r) => [r.fecha, r.xp]));
  const xpHoy = xpDe[fechaLocal()] || 0;
  let racha = 0;
  const d = new Date();
  if (!xpDe[fechaLocal(d)]) d.setDate(d.getDate() - 1); // si hoy no has estudiado, la racha sigue viva desde ayer
  while (xpDe[fechaLocal(d)] > 0) { racha++; d.setDate(d.getDate() - 1); }
  return { xpHoy, racha };
}

async function guardarResultado({ user, leccionId, xp, precision, fallados, acertados, modoErrores, sinResolver = false }) {
  const f = fechaLocal();
  const hoyRow = await db.from("mi_estudio").select("*").eq("fecha", f).maybeSingle();
  await db.from("mi_estudio").upsert({
    user_id: user.id, fecha: f, xp: (hoyRow.data?.xp || 0) + xp, lecciones: (hoyRow.data?.lecciones || 0) + 1
  });
  if (!modoErrores) {
    const prev = await db.from("mis_lecciones").select("*").eq("leccion_id", leccionId).maybeSingle();
    await db.from("mis_lecciones").upsert({
      user_id: user.id, leccion_id: leccionId,
      veces: (prev.data?.veces || 0) + 1,
      mejor_precision: Math.max(prev.data?.mejor_precision || 0, precision),
      xp_total: (prev.data?.xp_total || 0) + xp,
      ultima: new Date().toISOString()
    });
  }
  if (fallados.length) {
    const { data: previos } = await db.from("mis_errores").select("*").in("ejercicio_id", fallados);
    const fallosDe = Object.fromEntries((previos || []).map((r) => [r.ejercicio_id, r.fallos]));
    await db.from("mis_errores").upsert(fallados.map((id) => ({
      user_id: user.id, ejercicio_id: id, fallos: (fallosDe[id] || 0) + 1, resuelto: false, ultimo: new Date().toISOString()
    })));
  }
  if (modoErrores && !sinResolver && acertados.length) {
    await db.from("mis_errores").update({ resuelto: true }).in("ejercicio_id", acertados);
  }
}

// ---------- panel "Hoy" + lecciones por episodio (se usa en vistaIngles) ----------
async function datosLecciones() {
  const [l, mis, err, est] = await Promise.all([
    db.from("lecciones").select("*").eq("materia_id", "ingles").order("episodio").order("orden"),
    db.from("mis_lecciones").select("*"),
    db.from("mis_errores").select("ejercicio_id").eq("resuelto", false),
    resumenEstudio().catch((e) => ({ error: e }))
  ]);
  const error = l.error || mis.error || err.error || est.error;
  if (error) return { error };
  const mias = Object.fromEntries(mis.data.map((m) => [m.leccion_id, m]));
  const bancos = l.data.filter((x) => x.tipo === "banco").map((x) => x.episodio);
  l.data = l.data.filter((x) => x.tipo !== "banco" && x.tipo !== "examen"); // los bancos los usa "Mi camino"
  // Primero lo del episodio que viene en el instituto; después, el resto en orden
  const pendiente = (x) => !mias[x.id] || mias[x.id].mejor_precision < 80;
  const siguiente = l.data.find((x) => x.episodio === EPISODIO_EVALUACION && pendiente(x))
    || l.data.find(pendiente) || null;
  return { lecciones: l.data, mias, errores: err.data.length, ...est, siguiente, bancos };
}

function htmlPanelHoy(d, tarjetasPendientes) {
  const pct = Math.min(100, Math.round((d.xpHoy / META_XP) * 100));
  return `
    <div class="card hoy">
      <div class="hoy-top">
        <div><div class="hoy-num">🔥 ${d.racha}</div><div class="muted">día(s) de racha</div></div>
        <div style="flex:1;min-width:180px">
          <div class="muted" style="display:flex;justify-content:space-between"><span>Meta de hoy</span><span>${d.xpHoy} / ${META_XP} XP</span></div>
          <div class="barra"><i style="width:${pct}%"></i></div>
        </div>
      </div>
      <a class="btn grande" href="#/camino">▶ Mi camino · bloque de 10 min</a>
      ${d.siguiente ? `<div style="margin-top:8px"><a class="link" href="#/ingles/leccion/${d.siguiente.id}">o práctica libre: ${esc(d.siguiente.titulo)}</a></div>` : ""}
      <div class="row" style="justify-content:flex-start">
        <a class="btn alt" href="#/temas">🚦 Mis temas</a>
        ${d.errores ? `<a class="btn alt" href="#/ingles/errores">🎯 Mis errores (${d.errores})</a>` : ""}
        <a class="btn alt" href="#/ingles/tutor">💬 Tutor</a>
        <a class="btn alt" href="#/ingles/lecturas">📖 Leer y escuchar</a>
        <a class="btn alt" href="#/ingles/repaso">🃏 Tarjetas (${tarjetasPendientes})</a>
      </div>
    </div>`;
}

function htmlLeccionesDe(episodio, d) {
  const ls = d.lecciones.filter((x) => x.episodio === episodio);
  if (!ls.length) return "";
  const vista = d.bancos?.includes(episodio) ? `<a class="card leccion" href="#/ingles/leccion/banco-ep${episodio}">
      <div><b>🧪 Vista previa: las 4 patas</b> <span class="pill">nuevo</span></div>
      <div class="muted">12 ejercicios mezclados: escuchar, leer, decir en voz alta, escribir libre y ronda rápida.</div></a>` : "";
  const icono = { refuerzo: "🔧", tema: "📘", simulacro: "📝" };
  return `<div class="lecciones">${vista}${ls.map((x) => {
    const m = d.mias[x.id];
    const estado = !m ? "" : m.mejor_precision >= 80 ? `<span class="pill ok">✓ ${m.mejor_precision}%</span>`
      : `<span class="pill">${m.mejor_precision}%</span>`;
    return `
      <a class="card leccion ${d.siguiente?.id === x.id ? "actual" : ""}" href="#/ingles/leccion/${x.id}">
        <div><b>${icono[x.tipo] || "📘"} ${esc(x.titulo)}</b> ${estado}</div>
        <div class="muted">${esc(x.descripcion || "")}</div>
      </a>`;
  }).join("")}</div>`;
}

// 🎉 Confeti cuando la lección queda dominada
function confeti() {
  const c = document.createElement("div");
  c.className = "confeti";
  const colores = ["#6c4cf5", "#ff5fa2", "#ffc93c", "#22c55e", "#ff9a1f", "#38bdf8"];
  c.innerHTML = Array.from({ length: 60 }, () => `<i style="left:${Math.random() * 100}%;background:${colores[Math.floor(Math.random() * colores.length)]};
    animation-delay:${Math.random() * 0.6}s;animation-duration:${1.8 + Math.random() * 1.4}s"></i>`).join("");
  document.body.appendChild(c);
  setTimeout(() => c.remove(), 3500);
}

// ---------- utilidades de voz para ejercicios ----------
// Compara lo dicho en voz (o escrito) sin importar mayúsculas, puntuación ni "50,000" vs "50000"
const CONTRACCIONES = { im: "i am", youre: "you are", hes: "he is", shes: "she is", its: "it is", were: "we are", theyre: "they are",
  isnt: "is not", arent: "are not", dont: "do not", doesnt: "does not", cant: "can not", cannot: "can not", id: "i would",
  whats: "what is", thats: "that is", theres: "there is", wont: "will not", didnt: "did not", ill: "i will", ive: "i have" };
// Se aplica igual a lo dicho y a la respuesta, así "They're" y "They are" cuentan igual
const normalizarVoz = (s) => normalizar(String(s).replace(/(\d)[,.](\d)/g, "$1$2"))
  .split(" ").map((w) => CONTRACCIONES[w] || w).join(" ");
function parecido(dicho, respuestas) {
  const v = normalizarVoz(dicho);
  if (!v) return { ok: false, casi: false };
  const ops = respuestas.map(normalizarVoz);
  if (ops.includes(v)) return { ok: true, casi: false };
  const tol = (r) => Math.max(1, Math.floor(r.length * 0.12));
  if (v.length > 6 && ops.some((r) => distancia(v, r) <= tol(r))) return { ok: true, casi: true };
  return { ok: false, casi: false };
}
// Graba con el micrófono (toca para empezar, toca para terminar) y devuelve el texto (usa /api/voz)
function grabarVoz(boton, alTexto, alError) {
  if (boton.dataset.grabando) { boton._rec?.stop(); return; }
  if (!(navigator.mediaDevices?.getUserMedia && window.MediaRecorder)) return alError("Este navegador no deja usar el micrófono. Usa la opción de escribir.");
  try { speechSynthesis.cancel(); } catch {}
  navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true } }).then((stream) => {
    const tipo = ["audio/webm;codecs=opus", "audio/webm", "audio/mp4", "audio/ogg"].find((t) => MediaRecorder.isTypeSupported?.(t)) || "";
    const rec = new MediaRecorder(stream, tipo ? { mimeType: tipo } : undefined);
    const trozos = [], textoAntes = boton.innerHTML;
    rec.ondataavailable = (e) => { if (e.data?.size) trozos.push(e.data); };
    rec.onstop = async () => {
      stream.getTracks().forEach((t) => t.stop());
      delete boton.dataset.grabando; boton.classList.remove("grabando");
      boton.innerHTML = "⏳ Escuchando…"; boton.disabled = true;
      try {
        const blob = new Blob(trozos, { type: rec.mimeType || tipo || "audio/webm" });
        if (blob.size < 1000) throw new Error("No se escuchó nada. Toca el micrófono, habla y vuelve a tocar.");
        const b64 = await new Promise((ok, mal) => { const r = new FileReader(); r.onload = () => ok(String(r.result).split(",")[1] || ""); r.onerror = mal; r.readAsDataURL(blob); });
        const { data } = await db.auth.getSession();
        const r = await fetch("/api/voz", { method: "POST", headers: { "Content-Type": "application/json", Authorization: `Bearer ${data.session?.access_token || ""}` },
          body: JSON.stringify({ audio: b64, tipo: blob.type }) });
        const j = await r.json().catch(() => ({}));
        if (!r.ok) throw new Error(j.error || "No se pudo pasar el audio a texto.");
        alTexto(j.texto);
      } catch (e) { alError(e.message); }
      finally { boton.innerHTML = textoAntes; boton.disabled = false; }
    };
    rec.start(250);
    boton._rec = rec; boton.dataset.grabando = "1"; boton.classList.add("grabando");
    boton.innerHTML = "⏹ Toca para terminar";
    try { navigator.vibrate?.(40); } catch {}
    setTimeout(() => rec.state !== "inactive" && rec.stop(), 30000);
  }).catch(() => alError("No tengo permiso para el micrófono. Actívalo en el candado 🔒 de la barra de direcciones."));
}
// Wako califica una respuesta abierta (Paso 7): devuelve { puntaje, correccion, correccion_es, comentario, bien }
async function evaluarConWako(datos, respuesta, episodio) {
  const { data } = await db.auth.getSession();
  const r = await fetch("/api/evaluar", { method: "POST", headers: { "Content-Type": "application/json", Authorization: `Bearer ${data.session?.access_token || ""}` },
    body: JSON.stringify({ tarea: datos.pregunta, tarea_es: datos.pregunta_es, criterio: datos.criterio, ejemplo: datos.ejemplo, respuesta, episodio, tema: datos.tema || "", rubrica: datos.rubrica || null }) });
  const j = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(j.error || "Wako no pudo calificar. Intenta de nuevo.");
  return j;
}

// ---------- reproductor de la lección ----------
async function vistaLeccion(leccionId) {
  const modoErrores = leccionId === "errores";
  pintar(`<p class="muted">Preparando la lección…</p>`);
  let titulo = "Mis errores", ejercicios;
  if (modoErrores) {
    const { data, error } = await db.from("mis_errores").select("ejercicio_id, ejercicios(*)")
      .eq("resuelto", false).order("ultimo").limit(12);
    if (error) return pintar(faltaSQL(error) ? avisoSQL : errorBox(error));
    ejercicios = mezclar(data.map((r) => r.ejercicios).filter(Boolean));
  } else {
    const [l, e] = await Promise.all([
      db.from("lecciones").select("*").eq("id", leccionId).maybeSingle(),
      db.from("ejercicios").select("*").eq("leccion_id", leccionId).order("orden")
    ]);
    if (l.error || e.error) return pintar(faltaSQL(l.error || e.error) ? avisoSQL : errorBox(l.error || e.error));
    if (!l.data || l.data.tipo === "examen") return pintar(`<a href="#/ingles" class="link">← Inglés</a><p>No encontré esa lección.</p>`);
    titulo = l.data.titulo;
    ejercicios = e.data;
    // El banco de práctica se ve como una muestra corta y mezclada (sin repetir lo reservado para exámenes)
    if (l.data.tipo === "banco") { titulo = `Vista previa · 4 patas · Nivel ${l.data.episodio}`; ejercicios = mezclar(ejercicios.filter((x) => !x.reservado)).slice(0, 12); }
  }
  if (!ejercicios.length) return pintar(`
    <a href="#/ingles" class="link">← Inglés</a>
    <div class="card flash" style="margin-top:16px"><div class="big">✅ Nada pendiente</div>
    <p class="muted">No tienes errores por repasar. ¡Bien!</p></div>`);
  // Cada vez que empiezas, las preguntas salen en otro orden
  const todos = ejercicios;
  jugarEjercicios({ titulo, ejercicios: mezclar(todos), leccionId, modo: modoErrores ? "errores" : "leccion",
    clave: `leccion-${leccionId}`, pool: todos, alReiniciar: () => mezclar(todos) });
}

// Reproductor general: lecciones, Mis errores, "Mi camino" y exámenes.
// modo: "leccion" | "errores" | "camino" | "examen". En examen no se muestran respuestas ni se repiten ejercicios.
// alTerminar({ xp, precision, resultados }) se usa en camino y examen.
// ---------- avance guardado: si sales o se corta la conexión, retomas donde ibas ----------
const AVANCE_HORAS = 18; // después de esto, el avance guardado se descarta
const claveAvance = (uid, clave) => `avance-${uid}-${clave}`;
function leerAvance(uid, clave) {
  try {
    const a = JSON.parse(localStorage.getItem(claveAvance(uid, clave)));
    if (!a || Date.now() - a.t > AVANCE_HORAS * 3600e3) return null;
    return a;
  } catch { return null; }
}
const borrarAvance = (uid, clave) => { try { localStorage.removeItem(claveAvance(uid, clave)); } catch {} };
// Pantalla "¿Continuar o empezar de nuevo?". Devuelve true si continúa.
function preguntarContinuar(titulo, a, salir) {
  return new Promise((resolver) => {
    pintar(`
      <a href="${salir}" class="link">← Volver</a>
      <div class="card flash" style="margin-top:16px">
        <div class="big">⏸ Tienes esto a medias</div>
        <p><b>${esc(titulo)}</b></p>
        <p class="muted">Llevas ${a.hechos} de ${a.total} completadas${a.xp ? ` y ${a.xp} XP` : ""}.</p>
        <div class="row">
          <button class="btn" id="av-si">▶ Continuar donde iba</button>
          <button class="btn alt" id="av-no">🔀 Empezar de nuevo</button>
        </div>
        <p class="muted" style="font-size:.85rem">Si empiezas de nuevo, las preguntas salen en otro orden.</p>
      </div>`);
    document.getElementById("av-si").onclick = () => resolver(true);
    document.getElementById("av-no").onclick = () => resolver(false);
  });
}

// clave: dónde se guarda el avance (si no hay clave, no se guarda). pool: ejercicios disponibles para reconstruir lo guardado.
// alReiniciar(): devuelve una lista NUEVA de ejercicios (otro orden u otras preguntas) cuando eligen empezar de nuevo.
async function jugarEjercicios({ titulo, ejercicios, leccionId = null, modo = "leccion", salir = "#/ingles", alTerminar = null, episodio = null,
  clave = null, pool = null, alReiniciar = null }) {
  const user = await usuarioActual();
  const modoErrores = modo === "errores", examen = modo === "examen";
  const primerIntento = {};            // id → true/false
  const puntajes = {};                 // id → 0..100 (respuestas calificadas por Wako)
  const yaRepetido = new Set();
  let xp = 0, combo = 0, hechos = 0;
  let actual, estado, comprobado, reloj = null;
  let cola;

  // ¿Hay avance guardado? En exámenes se retoma siempre (no se puede reiniciar buscando otras preguntas).
  const guardado = clave && user ? leerAvance(user.id, clave) : null;
  const porId = Object.fromEntries([...(pool || []), ...ejercicios].map((e) => [e.id, e]));
  const reconstruible = guardado && guardado.ids.every((id) => porId[id]) && guardado.cola.every((id) => porId[id]);
  if (reconstruible && (examen || await preguntarContinuar(titulo, guardado, salir))) {
    ejercicios = guardado.ids.map((id) => porId[id]);
    cola = guardado.cola.map((id) => porId[id]);
    Object.assign(primerIntento, guardado.primerIntento || {});
    Object.assign(puntajes, guardado.puntajes || {});
    (guardado.repetidos || []).forEach((id) => yaRepetido.add(id));
    ({ xp, combo, hechos } = guardado);
  } else {
    if (guardado) borrarAvance(user.id, clave);
    if (reconstruible && alReiniciar) ejercicios = await alReiniciar();
    cola = [...ejercicios];
  }
  const total = ejercicios.length;
  const guardar = (pendientes) => {
    if (!clave || !user) return;
    try {
      localStorage.setItem(claveAvance(user.id, clave), JSON.stringify({
        t: Date.now(), titulo, total, ids: ejercicios.map((e) => e.id), cola: pendientes.map((e) => e.id),
        primerIntento, puntajes, repetidos: [...yaRepetido], xp, combo, hechos
      }));
    } catch {}
  };

  const sig = () => {
    clearInterval(reloj);
    if (!cola.length) return final();
    actual = cola.shift();
    estado = {}; comprobado = false;
    guardar([actual, ...cola]); // si sale ahora, al volver le sale esta misma pregunta
    pintarEjercicio();
  };

  function cabecera() {
    const pct = Math.round((hechos / total) * 100);
    return `
      <div class="lec-top">
        <a href="${salir}" class="link" title="Salir">✕</a>
        <div class="barra" style="flex:1"><i style="width:${pct}%"></i></div>
        <span class="muted">${examen ? `${hechos + 1}/${total}` : `${combo >= 3 ? `🔥${combo} · ` : ""}${xp} XP`}</span>
      </div>
      <div class="sec" style="margin-top:8px">${esc(titulo)}</div>`;
  }

  const etiquetas = { elegir: "Elige la correcta", escuchar: "Escucha y elige", ordenar: "Ordena la frase",
    escribir: "Escríbelo en inglés", emparejar: "Une cada pareja", decir: "🗣 Dilo en voz alta",
    libre: "✍️ Con tus palabras (lo califica Wako)", rapido: "⚡ Ronda rápida" };
  const etiquetaPata = { estudio: "📘 Estudio", input: "📖 Input", output: "🗣 Output", fluidez: "⚡ Fluidez" };
  const opcionesHtml = (d) => `<div class="opciones">${d.opciones.map((o, i) => `<button class="opcion" data-op="${i}">${esc(o)}</button>`).join("")}</div>`;
  const lineasHtml = (d, conEs) => d.lineas.map((l) => `<div class="lect-linea">${fraseTocable(l.en)}${conEs ? `<div class="muted lect-es">${esc(l.es)}</div>` : ""}</div>`).join("");

  function pintarEjercicio() {
    const d = actual.datos, t = actual.tipo;
    ponerContexto(`${examen ? "EXAMEN (no des respuestas)" : "Lección"} «${titulo}» · ejercicio ${hechos + 1} de ${total}`, describirEjercicio(actual));
    let cuerpo = "", etiqueta = t === "comprension" ? (d.modo === "escuchar" ? "📖 Escucha y responde" : "📖 Lee y responde") : etiquetas[t];
    if (t === "elegir") {
      cuerpo = `<div class="lec-frase">${d.frase.startsWith("¿") ? esc(d.frase) : fraseTocable(d.frase)} ${d.pista ? `<span class="muted">${esc(d.pista)}</span>` : ""}</div>
        ${d.es ? `<div class="muted">${esc(d.es)}</div>` : ""}${opcionesHtml(d)}`;
    } else if (t === "escuchar") {
      cuerpo = `<div class="row" style="justify-content:flex-start"><button class="btn alt" id="b-oir">🔊 Escuchar otra vez</button>
        <button class="btn alt" id="b-lento">🐢 Despacio</button></div>${opcionesHtml(d)}`;
    } else if (t === "comprension") {
      cuerpo = (d.modo === "escuchar"
        ? `<div class="row" style="justify-content:flex-start"><button class="btn alt" id="b-oir">🔊 Escuchar</button>
            <button class="btn alt" id="b-lento">🐢 Despacio</button></div><div id="c-texto" hidden class="practica">${lineasHtml(d, true)}</div>`
        : `<div class="practica">${lineasHtml(d, false)}</div>`) +
        `<div class="lec-frase" style="margin-top:14px">${fraseTocable(d.pregunta)}</div>
         ${d.pregunta_es ? `<div class="muted">🇪🇸 ${esc(d.pregunta_es)}</div>` : ""}${opcionesHtml(d)}`;
    } else if (t === "rapido") {
      cuerpo = `<div class="rapido-reloj"><i id="r-reloj"></i></div>
        <div class="lec-frase rapido-frase">${esc(d.frase)}</div>${d.es ? `<div class="muted">${esc(d.es)}</div>` : ""}
        <div class="opciones rapido-ops">${d.opciones.map((o, i) => `<button class="opcion" data-op="${i}">${esc(o)}</button>`).join("")}</div>`;
    } else if (t === "decir") {
      cuerpo = `<div class="lec-frase">${esc(d.es)}</div>
        <div class="row"><button class="btn mic-grande" id="b-mic">🎤 Toca y dilo en inglés</button></div>
        <div id="dicho" class="dicho"></div>
        <div style="text-align:center"><button class="link" id="b-teclado">⌨️ No puedo hablar ahora: lo escribo</button></div>
        <input type="text" id="resp" hidden autocomplete="off" autocapitalize="off" spellcheck="false" placeholder="Escríbelo en inglés…">`;
    } else if (t === "libre") {
      cuerpo = `<div class="lec-frase">${fraseTocable(d.pregunta)}</div><div class="muted">🇪🇸 ${esc(d.pregunta_es)}</div>
        <textarea id="resp" rows="3" placeholder="Escribe en inglés… o toca 🎤 y dilo"></textarea>
        <div class="row" style="justify-content:flex-start;margin-top:8px"><button class="btn alt" id="b-mic">🎤 Decirlo</button></div>`;
    } else if (t === "ordenar") {
      const palabras = d.frase.split(" ");
      let fichas = mezclar(palabras);
      for (let k = 0; k < 5 && fichas.join(" ") === d.frase; k++) fichas = mezclar(palabras);
      estado.elegidas = [];
      cuerpo = `<div class="lec-frase">${esc(d.es)}</div>
        <div class="linea" id="linea"></div>
        <div id="banco">${fichas.map((w, i) => `<button class="ficha" data-f="${i}">${esc(w)}</button>`).join("")}</div>`;
    } else if (t === "escribir") {
      cuerpo = `<div class="lec-frase">${esc(d.es)}</div>
        <input type="text" id="resp" autocomplete="off" autocapitalize="off" spellcheck="false" placeholder="Escribe en inglés…">`;
    } else if (t === "emparejar") {
      const izq = mezclar(d.pares.map((p) => p[0])), der = mezclar(d.pares.map((p) => p[1]));
      estado.hechos = 0; estado.fallos = 0;
      cuerpo = `<div class="pares">
        <div>${izq.map((x) => `<button class="opcion par" data-l="${esc(x)}">${esc(x)}</button>`).join("")}</div>
        <div>${der.map((x) => `<button class="opcion par" data-r="${esc(x)}">${esc(x)}</button>`).join("")}</div></div>`;
    }
    pintar(`${cabecera()}
      <div class="card lec">
        <div class="muted lec-tipo">${etiqueta}${modo === "camino" && actual.pata ? ` <span class="pill">${etiquetaPata[actual.pata] || ""}</span>` : ""}</div>
        ${cuerpo}
        <p class="error" id="lec-err"></p>
        <div id="lec-fb"></div>
        <div class="row" style="justify-content:flex-end">
          <button class="btn" id="b-go" ${t === "emparejar" || t === "rapido" ? "hidden" : ""}>Comprobar</button>
        </div>
      </div>`);
    conectar();
  }

  function conectar() {
    const d = actual.datos, t = actual.tipo;
    const err = (m) => (document.getElementById("lec-err").textContent = m);
    const go = document.getElementById("b-go");
    go.onclick = () => (comprobado ? sig() : comprobar());

    if (["elegir", "escuchar", "comprension", "rapido"].includes(t)) {
      app.querySelectorAll("[data-op]").forEach((b) => (b.onclick = () => {
        if (comprobado) return;
        app.querySelectorAll("[data-op]").forEach((x) => x.classList.remove("sel"));
        b.classList.add("sel"); estado.sel = Number(b.dataset.op); err("");
        if (t === "rapido") comprobar(); // en la ronda rápida, tocar = responder
      }));
      const audio = t === "escuchar" ? d.audio : (t === "comprension" && d.modo === "escuchar" ? d.lineas.map((l) => l.en).join(" ") : null);
      if (audio) {
        document.getElementById("b-oir").onclick = () => decir(audio);
        document.getElementById("b-lento").onclick = () => decir(audio, VEL.lenta);
        setTimeout(() => decir(audio), 300);
      }
      if (t === "rapido") {
        const seg = d.segundos || 6, inicio = Date.now(), barra = document.getElementById("r-reloj");
        reloj = setInterval(() => {
          if (!document.body.contains(barra) || comprobado) return clearInterval(reloj);
          const quedan = Math.max(0, 1 - (Date.now() - inicio) / (seg * 1000));
          barra.style.width = (quedan * 100) + "%";
          if (quedan <= 0) { clearInterval(reloj); estado.sel = -1; comprobar(); }
        }, 100);
      }
    } else if (t === "decir" || t === "libre") {
      const mic = document.getElementById("b-mic"), inp = document.getElementById("resp");
      mic.onclick = () => grabarVoz(mic, (texto) => {
        err("");
        if (t === "decir") { estado.dicho = texto; document.getElementById("dicho").innerHTML = `Dijiste: <b>${esc(texto)}</b>`; }
        else { inp.value = (inp.value ? inp.value + " " : "") + texto; }
      }, err);
      if (t === "decir") document.getElementById("b-teclado").onclick = (e) => { inp.hidden = false; inp.focus(); e.target.hidden = true; };
      if (inp && t === "decir") inp.onkeydown = (e) => { if (e.key === "Enter") go.click(); };
    } else if (t === "ordenar") {
      const linea = document.getElementById("linea");
      app.querySelectorAll("[data-f]").forEach((b) => (b.onclick = () => {
        if (comprobado || b.classList.contains("usada")) return;
        b.classList.add("usada");
        decir(b.textContent, VEL.palabra);
        const chip = document.createElement("button");
        chip.className = "ficha"; chip.textContent = b.textContent;
        estado.elegidas.push(b.textContent);
        chip.onclick = () => {
          if (comprobado) return;
          const i = [...linea.children].indexOf(chip);
          estado.elegidas.splice(i, 1); chip.remove(); b.classList.remove("usada");
        };
        linea.appendChild(chip); err("");
      }));
    } else if (t === "escribir") {
      const inp = document.getElementById("resp");
      inp.focus();
      inp.oninput = () => err("");
      inp.onkeydown = (e) => { if (e.key === "Enter") go.click(); };
    } else if (t === "emparejar") {
      let izq = null;
      app.querySelectorAll("[data-l]").forEach((b) => (b.onclick = () => {
        app.querySelectorAll("[data-l]").forEach((x) => x.classList.remove("sel"));
        b.classList.add("sel"); izq = b; decir(b.dataset.l);
      }));
      app.querySelectorAll("[data-r]").forEach((b) => (b.onclick = () => {
        if (!izq) return err("Primero toca una palabra de la izquierda.");
        err("");
        const ok = d.pares.some((p) => p[0] === izq.dataset.l && p[1] === b.dataset.r);
        if (ok) {
          izq.classList.add("hecha"); b.classList.add("hecha"); izq.classList.remove("sel"); izq = null;
          if (++estado.hechos === d.pares.length) comprobar();
        } else {
          estado.fallos++; b.classList.add("mal"); setTimeout(() => b.classList.remove("mal"), 500);
        }
      }));
    }
  }

  async function comprobar() {
    const d = actual.datos, t = actual.tipo;
    const err = (m) => (document.getElementById("lec-err").textContent = m);
    let ok, correcta, ortografia = false, ingles = "", tuya = "", extra = "", puntaje = null;
    if (["elegir", "escuchar", "comprension", "rapido"].includes(t)) {
      if (estado.sel === undefined) return err("Elige una opción primero.");
      clearInterval(reloj);
      ok = estado.sel === d.correcta;
      correcta = d.opciones[d.correcta];
      tuya = estado.sel >= 0 ? d.opciones[estado.sel] : "(se acabó el tiempo)";
      if (!examen) app.querySelectorAll("[data-op]").forEach((b) => {
        const i = Number(b.dataset.op);
        b.classList.remove("sel");
        if (i === d.correcta) b.classList.add("bien");
        else if (i === estado.sel) b.classList.add("mal");
      });
      if (t === "escuchar") ingles = d.audio;
      else if (t === "elegir" || t === "rapido") ingles = d.frase.includes("___") ? d.frase.replace("___", correcta) : (d.frase.startsWith("¿") ? "" : correcta);
      if (t === "rapido" && estado.sel === -1) extra = `<div>⏰ Se acabó el tiempo.</div>`;
      if (t === "comprension") { const tx = document.getElementById("c-texto"); if (tx) tx.hidden = false; if (!examen) extra = `<div class="muted">${d.lineas.map((l) => esc(l.es)).join(" ")}</div>`; }
    } else if (t === "decir") {
      const v = estado.dicho || document.getElementById("resp").value;
      if (!normalizarVoz(v)) return err("Toca 🎤 y di la frase (o escríbela).");
      const r = parecido(v, d.respuestas);
      ok = r.ok; ortografia = r.casi; tuya = v;
      correcta = ingles = d.mostrar;
    } else if (t === "libre") {
      const v = document.getElementById("resp").value.trim();
      if (v.split(/\s+/).length < 3) return err("Escribe al menos una frase completa.");
      const go = document.getElementById("b-go"); go.disabled = true; go.textContent = "Wako está calificando…";
      try {
        const r = await evaluarConWako({ ...d, tema: actual.tema_id }, v, episodio || null);
        puntaje = r.puntaje; ok = r.puntaje >= 70; tuya = v;
        correcta = r.correccion || "";
        ingles = r.correccion || "";
        extra = `<div>🤖 <b>Wako: ${r.puntaje}/100.</b> ${esc(r.comentario || "")}</div>
          ${r.correccion ? `<div class="fb-resp">✏️ ${esc(r.correccion)}</div>${r.correccion_es ? `<div class="muted">🇪🇸 ${esc(r.correccion_es)}</div>` : ""}` : ""}
          ${d.ejemplo ? `<div class="muted">Ejemplo: ${esc(d.ejemplo)}</div>` : ""}`;
      } catch (e) {
        go.disabled = false; go.textContent = "Comprobar";
        return err(e.message);
      }
      go.disabled = false;
    } else if (t === "ordenar") {
      if (!estado.elegidas.length) return err("Toca las palabras para armar la frase.");
      ok = estado.elegidas.join(" ") === d.frase;
      correcta = ingles = d.frase.replace(/ ([?.!,])/g, "$1");
      tuya = estado.elegidas.join(" ");
    } else if (t === "escribir") {
      const v = normalizar(document.getElementById("resp").value);
      if (!v) return err("Escribe tu respuesta primero.");
      const opciones = d.respuestas.map(normalizar);
      ok = opciones.includes(v);
      if (!ok && v.length > 8 && opciones.some((r) => distancia(v, r) <= 1)) { ok = true; ortografia = true; }
      correcta = ingles = d.mostrar;
      tuya = document.getElementById("resp").value;
    } else if (t === "emparejar") {
      ok = estado.fallos === 0;
      correcta = d.pares.map((p) => `${p[0]} = ${p[1]}`).join(" · ");
      tuya = `${estado.fallos} error(es) al unir`;
    }
    comprobado = true;
    ponerContexto(TF.contexto.pantalla, describirEjercicio(actual, { ok, tuya }));
    const primera = !(actual.id in primerIntento);
    if (primera) primerIntento[actual.id] = ok;
    if (puntaje !== null) puntajes[actual.id] = puntaje;
    if (primera) registrarDominio(actual.tema_id, actual.pata || (t === "escuchar" ? "input" : "estudio"), ok);
    if (ok) {
      combo++; hechos++;
      xp += primera ? XP_PRIMERA : XP_SEGUNDA;
    } else {
      combo = 0;
      if (!examen && !yaRepetido.has(actual.id) && t !== "libre") { yaRepetido.add(actual.id); cola.push(actual); } else hechos++;
    }
    guardar(cola); // respuesta guardada: al volver sigue con la próxima
    const go = document.getElementById("b-go");
    if (examen) { // en examen no se muestra la respuesta: sigue al próximo
      document.getElementById("lec-fb").innerHTML = `<div class="fb"><b>Respuesta guardada ✔</b></div>`;
      go.hidden = false; go.textContent = "Siguiente"; go.focus();
      if (t === "rapido") setTimeout(() => comprobado && document.body.contains(go) && sig(), 700);
      return;
    }
    if (ingles) decir(ingles);
    document.getElementById("lec-fb").innerHTML = `
      <div class="fb ${ok ? "fb-ok" : "fb-mal"}">
        <b>${ok ? (ortografia ? (t === "decir" ? "¡Bien! Casi perfecto." : "¡Bien! Ojo con la ortografía.") : "¡Correcto!") : (t === "libre" ? "Todavía no. Mira la corrección:" : "Casi. La respuesta es:")}</b>
        ${extra}
        ${(!ok || ortografia) && t !== "libre" ? `<div class="fb-resp">${esc(correcta)}</div>` : ""}
        ${t === "decir" && tuya ? `<div class="muted">Dijiste: ${esc(tuya)}</div>` : ""}
        ${ingles && t !== "libre" ? `<div class="fb-ingles">${btnVoz(ingles)} <span>${fraseTocable(ingles)}</span></div>
        <div class="muted pista-palabra">👆 Toca una palabra para oírla sola</div>` : ""}
        ${d.es && !["escribir", "ordenar", "decir"].includes(t) ? `<div class="muted">🇪🇸 ${esc(d.es)}</div>` : ""}
        ${d.explicacion && t !== "libre" ? `<div class="fb-ex">💡 ${esc(d.explicacion)}</div>` : ""}
        ${!ok && cola.includes(actual) ? `<div class="muted">Este ejercicio volverá al final.</div>` : ""}
      </div>`;
    go.hidden = false; go.textContent = "Continuar"; go.focus();
  }

  async function final() {
    clearInterval(reloj);
    if (clave && user) borrarAvance(user.id, clave);
    const ids = Object.keys(primerIntento);
    const bien = ids.filter((id) => primerIntento[id]).length;
    const precision = Math.round((bien / Math.max(1, total)) * 100);
    const fallados = ids.filter((id) => !primerIntento[id]);
    const resultados = ejercicios.map((e) => ({ ejercicio: e, ok: !!primerIntento[e.id], puntaje: puntajes[e.id] ?? null }));
    if (alTerminar) {
      // Mi camino y exámenes: guardan XP y errores, y quien llama decide qué mostrar
      if (!examen) { try { await guardarResultado({ user, leccionId: null, xp, precision, fallados, acertados: ids.filter((id) => primerIntento[id]), modoErrores: true, sinResolver: true }); } catch {} }
      return alTerminar({ xp, precision, resultados });
    }
    pintar(`<p class="muted">Guardando…</p>`);
    try {
      await guardarResultado({ user, leccionId, xp, precision, fallados, acertados: ids.filter((id) => primerIntento[id]), modoErrores });
      if (typeof energiaSumarMinutos === "function") energiaSumarMinutos(Math.min(15, Math.max(3, Math.round(total * 0.8))));
    } catch (e) { /* si falla el guardado, igual mostramos el resultado */ }
    let est = { xpHoy: xp, racha: 1 };
    try { est = await resumenEstudio(); } catch {}
    const metaOk = est.xpHoy >= META_XP;
    if (precision >= 80) confeti();
    pintar(`
      <div class="card flash" style="margin-top:16px">
        <div class="big">${precision >= 80 ? "🎉 ¡Lección completada!" : "💪 Lección terminada"}</div>
        <div class="resumen">
          <div><div class="hoy-num">+${xp}</div><div class="muted">XP</div></div>
          <div><div class="hoy-num">${precision}%</div><div class="muted">al primer intento</div></div>
          <div><div class="hoy-num">🔥 ${est.racha}</div><div class="muted">día(s) de racha</div></div>
        </div>
        <p class="muted">${metaOk ? `✅ Cumpliste tu meta de hoy (${est.xpHoy}/${META_XP} XP).` : `Llevas ${est.xpHoy}/${META_XP} XP de tu meta de hoy.`}</p>
        ${fallados.length ? `<p class="muted">Los ${fallados.length} ejercicio(s) que fallaste quedaron en <b>Mis errores</b> para repasarlos.</p>` : ""}
        ${precision < 80 && !modoErrores ? `<p class="muted">Con 80% o más la lección queda dominada. ¡Repítela cuando quieras!</p>` : ""}
        <div class="row">
          ${!modoErrores && leccionId ? `<a class="btn alt" href="#/ingles/leccion/${leccionId}" onclick="setTimeout(router,0)">Repetir</a>` : ""}
          <a class="btn" href="#/ingles">Seguir</a>
        </div>
      </div>`);
  }

  sig();
}
