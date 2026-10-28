// ============================================================
// 🤖 Wako — tu compañero tipo Tamagotchi
// - ENERGÍA (su alimento): sale de lo que estudias cada día (XP de lecciones, lecturas y tutor).
// - ETAPAS (crecer): solo suben con los episodios que apruebas en el instituto. De huevo (0) a adulto (B2).
// - No muere: sin estudiar se pone triste (1–2 días), se enferma (3–6) y se apaga (7+). Nunca pierde etapas.
// Usa funciones de app.js y lecciones.js (db, esc, pintar, hablar, usuarioActual, datosLecciones, confeti, META_XP, fechaLocal).
// ============================================================
const WAKO_EPISODIOS = 19; // B2 = Episodio 19 aprobado

// Imagen de cada etapa: r = ancho/alto; v = visor, p = batería del pecho, a = antena (en % de la imagen)
const WAKO_IMG = {"1":{"r":0.6306,"v":[0.1792,0.3795,0.6631,0.2041],"p":null,"a":[0.5827,0.0514,0.1171]},"2":{"r":0.7806,"v":[0.177,0.3727,0.6405,0.2442],"p":[0.4303,0.7783,0.1338,0.0466],"a":[0.573,0.0821,0.1316]},"3":{"r":0.5944,"v":[0.1799,0.2943,0.6388,0.185],"p":[0.4049,0.633,0.1851,0.0482],"a":[0.6066,0.0549,0.1285]},"4":{"r":0.5208,"v":[0.2361,0.2055,0.5435,0.142],"p":[0.4215,0.4672,0.1686,0.0385],"a":[0.6026,0.0424,0.1064]},"5":{"r":0.4875,"v":[0.2372,0.1896,0.5421,0.1116],"p":[0.4207,0.4176,0.1655,0.035],"a":[0.6059,0.0394,0.1103]},"6":{"r":0.4361,"v":[0.2733,0.1521,0.4613,0.0957],"p":[0.4171,0.3558,0.1706,0.033],"a":[0.6048,0.0355,0.1058]},"7":{"r":0.4139,"v":[0.3186,0.1181,0.3596,0.0706],"p":[0.4072,0.2824,0.1823,0.0251],"a":[0.592,0.0301,0.0936]},"8":{"r":0.4639,"v":[0.3725,0.0976,0.2478,0.0552],"p":[0.4638,0.245,0.1478,0.0249],"a":[0.5663,0.0253,0.0681]},"9":{"r":0.5056,"v":[0.4087,0.0896,0.2011,0.0495],"p":[0.4524,0.2241,0.168,0.0288],"a":[0.5584,0.0235,0.0556]},"10":{"r":0.5667,"v":[0.425,0.0783,0.1594,0.0435],"p":[0.4427,0.2,0.1275,0.0288],"a":[0.5474,0.0221,0.046]}};

// desde = episodios aprobados que se necesitan para llegar a esa etapa
const WAKO_ETAPAS = [
  { n: 1, nombre: "Huevo", en: "Egg", desde: 0, nivel: "0" },
  { n: 2, nombre: "Recién nacido", en: "Newborn", desde: 1, nivel: "Pre-A1" },
  { n: 3, nombre: "Bebé", en: "Baby", desde: 2, nivel: "A1" },
  { n: 4, nombre: "Bebé grande", en: "Toddler", desde: 3, nivel: "A1" },
  { n: 5, nombre: "Niño", en: "Child", desde: 5, nivel: "A1+" },
  { n: 6, nombre: "Niño grande", en: "Older kid", desde: 8, nivel: "A2" },
  { n: 7, nombre: "Preadolescente", en: "Pre-teen", desde: 11, nivel: "A2+" },
  { n: 8, nombre: "Adolescente", en: "Teenager", desde: 14, nivel: "B1" },
  { n: 9, nombre: "Joven", en: "Young adult", desde: 17, nivel: "B1+" },
  { n: 10, nombre: "Adulto", en: "Master", desde: 19, nivel: "B2" }
];
const WAKO_MARCAS = [{ nivel: "A1", ep: 2 }, { nivel: "A2", ep: 8 }, { nivel: "B1", ep: 14 }, { nivel: "B2", ep: 19 }];

// Lo que dice Wako al tocarlo (en inglés, con traducción): así también practicas
const WAKO_FRASES = {
  emocionado: [["I'm fully charged!", "¡Estoy a tope de energía!"], ["You are amazing!", "¡Eres increíble!"], ["Let's keep going!", "¡Sigamos así!"]],
  feliz: [["Let's learn English!", "¡Aprendamos inglés!"], ["I feel good today.", "Hoy me siento bien."], ["One more lesson?", "¿Una lección más?"]],
  triste: [["I need energy. Can we study?", "Necesito energía. ¿Estudiamos?"], ["I miss you!", "¡Te extraño!"]],
  enfermo: [["I'm very tired. Please help me!", "Estoy muy cansado. ¡Ayúdame, por favor!"], ["My battery is almost empty.", "Mi batería está casi vacía."]],
  apagado: [["Zzz... Wake me up with a lesson!", "Zzz... ¡Despiértame con una lección!"]]
};
const WAKO_MENSAJE = {
  emocionado: "¡Cumpliste tu meta de hoy! Wako está a tope ⚡",
  feliz: "Wako tiene energía. Completa tu meta de hoy para llenarlo del todo.",
  triste: "Wako está triste: hoy no ha recibido energía. Una lección lo anima.",
  enfermo: "Wako está muy débil. ¡Estudia hoy para recuperarlo!",
  apagado: "Wako se apagó por falta de energía. Una lección lo despierta (no pierde su etapa)."
};

const WK = { cargado: false, sinTabla: false, fila: null, estado: null };

const etapaDe = (aprobados) => [...WAKO_ETAPAS].reverse().find((e) => aprobados >= e.desde) || WAKO_ETAPAS[0];
const siguienteEtapa = (n) => WAKO_ETAPAS.find((e) => e.n === n + 1) || null;
const nivelDe = (aprobados) => aprobados >= 19 ? "B2" : aprobados >= 14 ? "B1" : aprobados >= 8 ? "A2" : aprobados >= 2 ? "A1" : "Pre-A1";

// ---------- datos: episodios aprobados (tabla mi_wako) + energía (mi_estudio) ----------
async function wakoCargar(forzar = false) {
  if (WK.cargado && !forzar) return WK.estado;
  const desde = fechaLocal(new Date(Date.now() - 30 * 864e5));
  const [fw, fe] = await Promise.all([
    db.from("mi_wako").select("*").maybeSingle(),
    db.from("mi_estudio").select("fecha, xp").gte("fecha", desde)
  ]);
  WK.sinTabla = !!(fw.error && faltaSQL(fw.error));
  WK.fila = fw.error ? null : fw.data;
  if (WK.fila) EPISODIO_EVALUACION = Math.min(WK.fila.episodios_aprobados + 1, WAKO_EPISODIOS);

  // Energía: días desde la última vez que estudiaste y XP de hoy
  const xpDe = Object.fromEntries((fe.data || []).map((r) => [r.fecha, r.xp]));
  const xpHoy = xpDe[fechaLocal()] || 0;
  let dias = 99;
  for (let i = 0; i <= 30; i++) if ((xpDe[fechaLocal(new Date(Date.now() - i * 864e5))] || 0) > 0) { dias = i; break; }
  let energia, animo;
  if (dias === 0) { energia = Math.min(100, 40 + Math.round((xpHoy / META_XP) * 60)); animo = xpHoy >= META_XP ? "emocionado" : "feliz"; }
  else if (dias <= 2) { energia = dias === 1 ? 35 : 28; animo = "triste"; }
  else if (dias <= 6) { energia = 24 - (dias - 3) * 6; animo = "enfermo"; }
  else { energia = 0; animo = "apagado"; }

  // Crecimiento: episodios aprobados + lo que llevas del episodio actual
  const aprobados = WK.fila?.episodios_aprobados ?? 0;
  let fraccion = 0;
  try {
    const d = await datosLecciones();
    const delEp = (d.lecciones || []).filter((l) => l.episodio === aprobados + 1);
    if (delEp.length) fraccion = Math.min(0.95, delEp.filter((l) => d.mias[l.id]?.mejor_precision >= 80).length / delEp.length);
    WK.siguienteLeccion = d.siguiente?.id || null;
  } catch {}
  const etapa = etapaDe(aprobados);
  WK.estado = {
    aprobados, etapa, animo, energia, xpHoy, dias,
    progreso: Math.min(100, ((aprobados + (aprobados < WAKO_EPISODIOS ? fraccion : 0)) / WAKO_EPISODIOS) * 100),
    nivel: nivelDe(aprobados), registrado: !!WK.fila,
    evoluciona: !!WK.fila && etapa.n > (WK.fila.etapa_vista || 1)
  };
  WK.cargado = true;
  return WK.estado;
}

async function wakoGuardar(cambios) {
  const user = await usuarioActual();
  const fila = { user_id: user.id, episodios_aprobados: WK.fila?.episodios_aprobados ?? 0, etapa_vista: WK.fila?.etapa_vista ?? 1, ...cambios, actualizado: new Date().toISOString() };
  const { error } = await db.from("mi_wako").upsert(fila);
  if (error) throw error;
  WK.fila = fila;
}

// ---------- dibujo de Wako: imagen 3D + cara, batería y antena hechas con código ----------
const VERDE = "#5CFF4A", AMARILLO = "#FFD23F", ROJO = "#FF4B4B", CELESTE = "#6AD4FF";
function wakoCara(animo, n) {
  const brillo = `<defs><filter id="brillo${n}" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="3" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs>`;
  const bateriaMini = (color, barras, parpadea) => `
    <rect x="88" y="70" width="40" height="20" rx="4" fill="none" stroke="${color}" stroke-width="3"/>
    <rect x="129" y="76" width="4" height="8" rx="1" fill="${color}"/>
    ${Array.from({ length: barras }, (_, i) => `<rect class="${parpadea ? "wk-parpadea" : ""}" x="${92 + i * 9}" y="74" width="6" height="12" rx="1" fill="${color}"/>`).join("")}`;
  const caras = {
    feliz: `<g class="wk-ojos"><path d="M48 54 Q68 26 88 54" fill="none" stroke="${VERDE}" stroke-width="10" stroke-linecap="round"/>
      <path d="M132 54 Q152 26 172 54" fill="none" stroke="${VERDE}" stroke-width="10" stroke-linecap="round"/></g>
      <path d="M95 70 Q110 84 125 70" fill="none" stroke="${VERDE}" stroke-width="8" stroke-linecap="round"/>`,
    emocionado: `<g class="wk-giro">${[68, 152].map((cx) => `<polygon fill="${VERDE}" points="${Array.from({ length: 10 }, (_, i) => {
      const r = i % 2 ? 11 : 26, a = Math.PI / 5 * i - Math.PI / 2; return `${(cx + r * Math.cos(a)).toFixed(1)},${(50 + r * Math.sin(a)).toFixed(1)}`; }).join(" ")}"/>`).join("")}</g>`,
    cargando: `${[0, 1, 2, 3, 4].map((i) => `<rect class="wk-carga" style="animation-delay:${i * 0.18}s" x="${34 + i * 28}" y="26" width="20" height="48" rx="4" fill="${VERDE}"/>`).join("")}
      <polygon points="186,22 172,54 184,54 176,80 198,44 186,44 194,22" fill="${VERDE}"/>`,
    triste: `<g class="wk-ojos"><path d="M48 34 L88 34 Q86 58 68 58 Q50 58 48 34 Z" fill="${AMARILLO}" transform="rotate(10 68 46)"/>
      <path d="M132 34 L172 34 Q170 58 152 58 Q134 58 132 34 Z" fill="${AMARILLO}" transform="rotate(-10 152 46)"/></g>${bateriaMini(AMARILLO, 2)}`,
    enfermo: `<g class="wk-ojos"><path d="M48 38 L88 38 Q86 56 68 56 Q50 56 48 38 Z" fill="${ROJO}" transform="rotate(12 68 46)"/>
      <path d="M132 38 L172 38 Q170 56 152 56 Q134 56 132 38 Z" fill="${ROJO}" transform="rotate(-12 152 46)"/></g>${bateriaMini(ROJO, 1, true)}`,
    apagado: `<path d="M50 52 Q68 66 86 52" fill="none" stroke="${CELESTE}" stroke-width="7" stroke-linecap="round"/>
      <path d="M134 52 Q152 66 170 52" fill="none" stroke="${CELESTE}" stroke-width="7" stroke-linecap="round"/>
      <text class="wk-z" x="176" y="34" fill="${CELESTE}" font-size="22" font-weight="900" font-family="Nunito, sans-serif">z</text>
      <text class="wk-z" style="animation-delay:.7s" x="192" y="20" fill="${CELESTE}" font-size="28" font-weight="900" font-family="Nunito, sans-serif">Z</text>`
  };
  return `${brillo}<g filter="url(#brillo${n})">${caras[animo] || caras.feliz}</g>`;
}
function wakoPecho(animo, energia) {
  const color = energia >= 50 ? VERDE : energia >= 25 ? AMARILLO : ROJO;
  const barras = animo === "apagado" ? 0 : Math.max(1, Math.ceil(energia / 25));
  return Array.from({ length: barras }, (_, i) => `<rect x="${8 + i * 22}" y="8" width="17" height="24" rx="3" fill="${color}"/>`).join("");
}
let wakoContador = 0;
function htmlWako(est, { alto = 220, etapa = null, animo = null, id = "" } = {}) {
  const n = etapa || est.etapa.n, im = WAKO_IMG[n], a = animo || est.animo, k = ++wakoContador;
  const pct = (x) => (x * 100).toFixed(2) + "%";
  return `
    <div class="wako wk-${a}" ${id ? `id="${id}"` : ""} data-etapa="${n}" style="height:${alto}px;width:${Math.round(alto * im.r)}px">
      <div class="wk-cuerpo">
        <img src="wako/etapa-${String(n).padStart(2, "0")}.webp" alt="Wako, etapa ${n}" draggable="false">
        <div class="wk-antena" style="left:${pct(im.a[0])};top:${pct(im.a[1])};width:${pct(im.a[2])}"></div>
        <svg class="wk-visor" viewBox="0 0 220 100" style="left:${pct(im.v[0])};top:${pct(im.v[1])};width:${pct(im.v[2])};height:${pct(im.v[3])}">${wakoCara(a, k)}</svg>
        ${im.p ? `<svg class="wk-pecho" viewBox="0 0 100 40" preserveAspectRatio="none" style="left:${pct(im.p[0])};top:${pct(im.p[1])};width:${pct(im.p[2])};height:${pct(im.p[3])}">${wakoPecho(a, est.energia)}</svg>` : ""}
      </div>
    </div>`;
}

// Al tocar a Wako: salta, cambia de cara un momento y dice una frase en inglés
function wakoTocar(el, est, burbuja) {
  if (!el || el.dataset.ocupado) return;
  el.dataset.ocupado = "1";
  const lista = WAKO_FRASES[est.animo] || WAKO_FRASES.feliz;
  const [en, es] = lista[Math.floor(Math.random() * lista.length)];
  if (burbuja) burbuja.innerHTML = `<b>${esc(en)}</b><span class="muted">🇪🇸 ${esc(es)}</span>`;
  try { hablar(en); } catch {}
  const visor = el.querySelector(".wk-visor");
  const antes = visor.innerHTML;
  if (est.animo !== "apagado") { visor.innerHTML = wakoCara("emocionado", ++wakoContador); el.classList.add("wk-salto"); }
  else el.classList.add("wk-sacude");
  setTimeout(() => { visor.innerHTML = antes; el.classList.remove("wk-salto", "wk-sacude"); delete el.dataset.ocupado; }, 1600);
}

// Animación de "cargando" al abrir: las barras se llenan y luego aparece su cara
function wakoAnimarCarga(el, est) {
  if (!el || est.animo === "apagado") return;
  const visor = el.querySelector(".wk-visor");
  const cara = visor.innerHTML;
  visor.innerHTML = wakoCara("cargando", ++wakoContador);
  setTimeout(() => { visor.innerHTML = cara; }, 1500);
}

function htmlBarraB2(est) {
  return `
    <div class="wk-b2">
      <div class="wk-b2-top"><span>Camino a <b>B2</b></span><span>${Math.round(est.progreso)}% · nivel aprox. <b>${est.nivel}</b></span></div>
      <div class="wk-b2-barra"><i style="width:${est.progreso}%"></i>
        ${WAKO_MARCAS.map((m) => `<span class="wk-marca" style="left:${(m.ep / WAKO_EPISODIOS) * 100}%"><em>${m.nivel}</em></span>`).join("")}
      </div>
    </div>`;
}

// ---------- tarjeta de Wako en Inicio ----------
async function htmlWakoInicio() {
  let est;
  try { est = await wakoCargar(true); } catch { return ""; }
  if (!est.registrado) return `
    <a class="card wk-card wk-nuevo" href="#/wako">
      ${htmlWako(est, { alto: 150, etapa: 1, animo: "apagado" })}
      <div><div class="sec">Nuevo</div><h2>Conoce a Wako 🥚</h2>
      <p class="muted">Tu compañero de estudio: crece contigo desde huevo hasta B2. Toca para despertarlo.</p></div>
    </a>`;
  const sig = siguienteEtapa(est.etapa.n);
  return `
    <div class="card wk-card">
      <div class="wk-fila">
        <div class="wk-lado" id="wk-inicio">${htmlWako(est, { alto: 210 })}</div>
        <div class="wk-info">
          <div class="sec">Wako · etapa ${est.etapa.n} de 10</div>
          <h2>${esc(est.etapa.nombre)} <span class="muted wk-en">${esc(est.etapa.en)}</span></h2>
          <div class="wk-energia"><span>⚡ Energía</span><div class="wk-barra wk-e-${est.animo}"><i style="width:${est.energia}%"></i></div><b>${est.energia}%</b></div>
          <p class="muted wk-msg">${WAKO_MENSAJE[est.animo]}</p>
          <div class="wk-burbuja" id="wk-burbuja"></div>
          <div class="row" style="justify-content:flex-start;margin-top:8px">
            <a class="btn" href="${WK.siguienteLeccion ? `#/ingles/leccion/${WK.siguienteLeccion}` : "#/ingles"}">⚡ Cargar a Wako</a>
            <a class="btn alt" href="#/wako">Ver su evolución</a>
          </div>
        </div>
      </div>
      ${htmlBarraB2(est)}
      ${sig ? `<p class="muted wk-sig">Siguiente etapa: <b>${esc(sig.nombre)}</b> al aprobar el Episodio ${sig.desde} en el instituto.</p>` : ""}
    </div>`;
}
function conectarWakoInicio() {
  const cont = document.getElementById("wk-inicio");
  if (!cont || !WK.estado) return;
  const el = cont.querySelector(".wako");
  wakoAnimarCarga(el, WK.estado);
  el.onclick = () => wakoTocar(el, WK.estado, document.getElementById("wk-burbuja"));
  if (WK.estado.evoluciona) location.hash = "/wako"; // si creció, se muestra la evolución
}

// ---------- pantalla completa de Wako ----------
async function vistaWako() {
  pintar(`<p class="muted">Despertando a Wako…</p>`);
  let est;
  try { est = await wakoCargar(true); } catch (e) { return pintar(errorBox(e)); }
  if (WK.sinTabla) return pintar(`<a href="#/" class="link">← Inicio</a>
    <div class="card" style="margin-top:16px"><h2>Falta un paso en Supabase</h2>
    <p class="muted">Para activar a Wako, abre Supabase → <b>SQL Editor</b>, pega el archivo <code>db/005_wako.sql</code> completo y dale <b>Run</b>. Luego recarga.</p></div>`);
  if (!est.registrado) return vistaWakoBienvenida();
  if (est.evoluciona) return wakoEvolucion(est);

  const sig = siguienteEtapa(est.etapa.n);
  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <div class="card wk-grande">
      <div class="wk-escena" id="wk-escena">${htmlWako(est, { alto: 300 })}</div>
      <div class="wk-burbuja wk-burbuja-c" id="wk-burbuja"><span class="muted">Toca a Wako 👆</span></div>
      <h1 style="text-align:center">${esc(est.etapa.nombre)} <span class="muted wk-en">${esc(est.etapa.en)}</span></h1>
      <div class="wk-energia"><span>⚡ Energía</span><div class="wk-barra wk-e-${est.animo}"><i style="width:${est.energia}%"></i></div><b>${est.energia}%</b></div>
      <p class="muted" style="text-align:center">${WAKO_MENSAJE[est.animo]}</p>
      <div class="row"><a class="btn" href="${WK.siguienteLeccion ? `#/ingles/leccion/${WK.siguienteLeccion}` : "#/ingles"}">⚡ Cargar a Wako con una lección</a></div>
      ${htmlBarraB2(est)}
    </div>

    <h2 style="margin-top:24px">Su evolución</h2>
    <p class="muted">Wako crece cuando apruebas episodios en el instituto. La energía la gana con lo que estudias cada día.</p>
    <div class="wk-galeria">
      ${WAKO_ETAPAS.map((e) => {
        const llegada = est.etapa.n >= e.n, actual = est.etapa.n === e.n;
        return `<div class="wk-g ${llegada ? "" : "wk-bloq"} ${actual ? "wk-actual" : ""}">
          <div class="wk-g-img">${htmlWako(est, { alto: 110, etapa: e.n, animo: llegada ? (actual ? est.animo : "feliz") : "apagado" })}${llegada ? "" : `<span class="wk-candado">?</span>`}</div>
          <b>${e.n}. ${esc(e.nombre)}</b>
          <span class="muted">${e.desde ? `Ep ${e.desde}` : "Inicio"} · ${e.nivel}</span>
        </div>`;
      }).join("")}
    </div>

    <div class="card" style="margin-top:20px">
      <div class="sec">Instituto</div>
      <h2>Episodios aprobados: ${est.aprobados} de ${WAKO_EPISODIOS}</h2>
      <p class="muted">${est.aprobados < WAKO_EPISODIOS ? `Cuando te califiquen el Episodio ${est.aprobados + 1}, regístralo aquí.${sig ? ` Wako evoluciona a <b>${esc(sig.nombre)}</b> en el Episodio ${sig.desde}.` : ""}` : "¡Llegaste al final del curso! 🏆"}</p>
      <div class="row" style="justify-content:flex-start">
        ${est.aprobados < WAKO_EPISODIOS ? `<button class="btn" id="wk-aprobe">✅ Aprobé el Episodio ${est.aprobados + 1}</button>` : ""}
        <button class="btn alt" id="wk-corregir">Corregir</button>
      </div>
      <p class="error" id="wk-err"></p>
    </div>`);
  const el = document.querySelector("#wk-escena .wako");
  wakoAnimarCarga(el, est);
  el.onclick = () => wakoTocar(el, est, document.getElementById("wk-burbuja"));
  const err = (m) => (document.getElementById("wk-err").textContent = m);
  const ap = document.getElementById("wk-aprobe");
  if (ap) ap.onclick = async () => {
    if (!confirm(`¿Confirmas que aprobaste el Episodio ${est.aprobados + 1} en el instituto?`)) return;
    try { await wakoGuardar({ episodios_aprobados: est.aprobados + 1 }); vistaWako(); } catch (e) { err("No se pudo guardar: " + e.message); }
  };
  document.getElementById("wk-corregir").onclick = () => vistaWakoBienvenida(true);
}

// Primera vez (o corregir): cuántos episodios ha aprobado
function vistaWakoBienvenida(corrigiendo = false) {
  const actual = WK.fila?.episodios_aprobados ?? 0;
  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <div class="card wk-grande" style="text-align:center">
      <div class="wk-escena">${htmlWako(WK.estado, { alto: 240, etapa: 1, animo: corrigiendo ? WK.estado.animo : "apagado" })}</div>
      <h1>${corrigiendo ? "Corregir episodios" : "Este es Wako 🥚"}</h1>
      ${corrigiendo ? "" : `<p class="muted">Es tu compañero de estudio. Se alimenta de <b>energía</b> que ganas estudiando cada día,
        y <b>crece</b> cada vez que apruebas episodios en el instituto, desde huevo hasta adulto (nivel B2).
        Si dejas de estudiar no muere: se pone triste y se apaga, y vuelve a encenderse con una lección.</p>`}
      <p><b>¿Cuántos episodios has aprobado en el instituto?</b></p>
      <select id="wk-n" style="font-size:1.1rem;padding:10px 14px">
        ${Array.from({ length: WAKO_EPISODIOS + 1 }, (_, i) => `<option value="${i}" ${i === actual ? "selected" : ""}>${i === 0 ? "Ninguno todavía" : `${i} (hasta el Episodio ${i})`}</option>`).join("")}
      </select>
      <div class="row"><button class="btn" id="wk-ok">${corrigiendo ? "Guardar" : "¡Despertar a Wako!"}</button></div>
      <p class="error" id="wk-err"></p>
    </div>`);
  document.getElementById("wk-ok").onclick = async (e) => {
    e.target.disabled = true;
    const n = Number(document.getElementById("wk-n").value);
    try {
      // al corregir hacia abajo, no se repite la evolución; al registrar por primera vez, sí se ve
      await wakoGuardar({ episodios_aprobados: n, ...(corrigiendo ? { etapa_vista: Math.min(WK.fila?.etapa_vista ?? 1, etapaDe(n).n) } : { etapa_vista: 1 }) });
      vistaWako();
    } catch (er) { e.target.disabled = false; document.getElementById("wk-err").textContent = "No se pudo guardar: " + er.message; }
  };
}

// 🌟 Evolución: destello, cambia de etapa (una por una si subió varias), confeti y frase
async function wakoEvolucion(est) {
  const desde = WK.fila.etapa_vista || 1, hasta = est.etapa.n;
  pintar(`
    <div class="wk-evo">
      <div class="wk-evo-luz"></div>
      <div class="wk-escena" id="wk-evo-escena">${htmlWako(est, { alto: 300, etapa: desde, animo: "feliz" })}</div>
      <h1 id="wk-evo-t">¿Qué le pasa a Wako?</h1>
      <p class="muted" id="wk-evo-s">¡Está creciendo!</p>
      <div class="row"><button class="btn" id="wk-evo-ok" hidden>¡Genial!</button></div>
    </div>`);
  const esc2 = document.getElementById("wk-evo-escena");
  for (let n = desde + 1; n <= hasta; n++) {
    esc2.firstElementChild.classList.add("wk-brilla");
    await new Promise((r) => setTimeout(r, n === desde + 1 ? 1400 : 900));
    esc2.innerHTML = htmlWako(est, { alto: 300, etapa: n, animo: "emocionado" });
    esc2.firstElementChild.classList.add("wk-aparece");
  }
  try { confeti(); } catch {}
  const e = WAKO_ETAPAS[hasta - 1];
  document.getElementById("wk-evo-t").textContent = `¡Wako evolucionó a ${e.nombre}!`;
  document.getElementById("wk-evo-s").textContent = `Etapa ${e.n} de 10 · nivel aprox. ${e.nivel}`;
  try { hablar(hasta === 10 ? "I am a master now! Thank you!" : "I'm growing up! Thank you!"); } catch {}
  try { await wakoGuardar({ etapa_vista: hasta }); } catch {}
  const ok = document.getElementById("wk-evo-ok");
  ok.hidden = false; ok.onclick = () => vistaWako();
}
