// ============================================================
// 🚀 Mi camino (Pasos 3–5 de la hoja de ruta)
// - Bloques de ~10 min con ejercicios ALEATORIOS de las 4 patas + repaso. Cada bloque = 1 raya de Wako.
// - Dominio por tema: un tema queda 🟢 cuando lo aciertas en todas sus patas y en días distintos.
// - "Mis temas": semáforo por tema y unidad; con todo en verde se abre el "Now I Can".
// Usa: db, esc, pintar, mezclar, fechaLocal, faltaSQL, jugarEjercicios, wakoCargar, WK, htmlWako, confeti.
// ============================================================
const NIVELES = 19; // Nivel = Episodio del instituto; el 19 es B2

// Unidades del libro y sus temas (igual que en el instituto)
const UNIDADES = {
  1: [{ n: 1, nombre: "The Characters", temas: ["ep1-to-be", "ep1-a-an", "ep1-pronombres", "ep1-profesiones", "ep1-clima"] },
      { n: 2, nombre: "Describing the Characters", temas: ["ep1-adjetivos", "ep1-cuerpo", "ep1-comparativos"] }],
  2: [{ n: 3, nombre: "An Airplane", temas: ["ep2-presente-s", "ep2-do-does", "ep2-rutinas", "ep2-plurales", "ep2-this-that", "ep2-the"] },
      { n: 4, nombre: "At the Airport", temas: ["ep2-numeros", "ep2-hora"] }],
  3: [{ n: 5, nombre: "Informal Telephone Call", temas: ["ep3-would-like", "ep3-can-could", "ep3-may-might", "ep3-conectores"] },
      { n: 6, nombre: "Taking a Taxi", temas: ["ep3-question-words", "ep3-whose"] }]
};

// Cuánto hay que demostrar en cada pata para que un tema quede dominado
const REGLA = {
  estudio: { aciertos: 3, precision: 0.75 },
  input: { aciertos: 2, precision: 0.7 },
  output: { aciertos: 2, precision: 0.6 },
  fluidez: { aciertos: 3, precision: 0.7 }
};
const DIAS_PARA_DOMINAR = 2;
const PATAS = { estudio: "📘", input: "📖", output: "🗣", fluidez: "⚡" };
const NOMBRE_PATA = { estudio: "Estudio", input: "Escuchar y leer", output: "Hablar y escribir", fluidez: "Rapidez" };

const CAM = { cache: null };

const nivelActual = () => Math.min((WK.fila?.episodios_aprobados ?? (EPISODIO_EVALUACION - 1)) + 1, NIVELES);
const precisionReciente = (r) => (r && r.length ? [...r].filter((c) => c === "1").length / r.length : 0);

// ---------- datos: temas, ejercicios y dominio ----------
async function caminoDatos(forzar = false) {
  if (CAM.cache && !forzar) return CAM.cache;
  const [t, l, d] = await Promise.all([
    db.from("pensum_temas").select("*").order("episodio").order("orden"),
    db.from("lecciones").select("id, episodio, tipo").eq("materia_id", "ingles"),
    db.from("mi_dominio").select("*")
  ]);
  if (t.error || l.error) return { error: t.error || l.error };
  const leccionEp = Object.fromEntries(l.data.map((x) => [x.id, x]));
  const idsLec = l.data.filter((x) => x.tipo !== "examen").map((x) => x.id);
  const e = await db.from("ejercicios").select("*").in("leccion_id", idsLec);
  if (e.error) return { error: e.error };
  const ejercicios = e.data.filter((x) => !x.reservado && x.tema_id).map((x) => ({ ...x, episodio: leccionEp[x.leccion_id]?.episodio }));
  const dominio = {};
  for (const r of d.data || []) (dominio[r.tema_id] ||= {})[r.pata] = r;
  CAM.cache = { temas: t.data, ejercicios, dominio };
  return CAM.cache;
}

// Estado de un tema: { estado: "rojo"|"amarillo"|"verde", patas: {pata: {ok, aciertos, precision, falta}}, dias }
function estadoTema(tema, datos) {
  const patasDisponibles = [...new Set(datos.ejercicios.filter((x) => x.tema_id === tema.id).map((x) => x.pata))];
  const dom = datos.dominio[tema.id] || {};
  const patas = {};
  let todas = patasDisponibles.length > 0, algo = false, dias = 0;
  for (const p of ["estudio", "input", "output", "fluidez"]) {
    if (!patasDisponibles.includes(p)) continue;
    const r = dom[p], regla = REGLA[p];
    const aciertos = r?.aciertos || 0, prec = precisionReciente(r?.recientes);
    const ok = aciertos >= regla.aciertos && prec >= regla.precision;
    if (r?.intentos) algo = true;
    dias = Math.max(dias, r?.dias_acierto || 0);
    if (!ok) todas = false;
    patas[p] = { ok, aciertos, precision: Math.round(prec * 100), falta: Math.max(0, regla.aciertos - aciertos) };
  }
  const verde = todas && dias >= DIAS_PARA_DOMINAR;
  return { estado: verde ? "verde" : algo ? "amarillo" : "rojo", patas, dias, faltaDia: todas && dias < DIAS_PARA_DOMINAR };
}
function resumenNivel(nivel, datos) {
  const temas = datos.temas.filter((t) => t.episodio === nivel);
  const estados = Object.fromEntries(temas.map((t) => [t.id, estadoTema(t, datos)]));
  const verdes = temas.filter((t) => estados[t.id].estado === "verde").length;
  return { temas, estados, verdes, total: temas.length, completo: temas.length > 0 && verdes === temas.length };
}

// ---------- armar un bloque de ~10 minutos ----------
function armarBloque(datos, nivel) {
  const { estados } = resumenNivel(nivel, datos);
  const delNivel = datos.ejercicios.filter((x) => x.episodio === nivel);
  const anteriores = datos.ejercicios.filter((x) => x.episodio < nivel && x.tipo !== "libre");
  // peso: temas que te faltan salen más; patas que te faltan, todavía más
  const peso = (x) => {
    const est = estados[x.tema_id];
    if (!est) return 1;
    if (est.estado === "verde") return 1;
    const p = est.patas[x.pata];
    return p && !p.ok ? 6 : 3;
  };
  const elegir = (lista, n, usados) => {
    const res = [];
    let pool = lista.filter((x) => !usados.has(x.id));
    while (res.length < n && pool.length) {
      const total = pool.reduce((s, x) => s + peso(x), 0);
      let r = Math.random() * total, i = 0;
      while ((r -= peso(pool[i])) > 0 && i < pool.length - 1) i++;
      const x = pool[i];
      res.push(x); usados.add(x.id);
      pool = pool.filter((y) => y.id !== x.id && !(y.tema_id === x.tema_id && y.tipo === x.tipo && res.filter((z) => z.tema_id === x.tema_id).length >= 2));
    }
    return res;
  };
  const usados = new Set();
  const dePata = (lista, pata, tipos) => lista.filter((x) => x.pata === pata && (!tipos || tipos.includes(x.tipo)));
  const estudio = elegir(dePata(delNivel, "estudio"), 4, usados);
  const input = elegir(dePata(delNivel, "input"), 2, usados);
  const decir = elegir(dePata(delNivel, "output", ["decir"]), 1, usados);
  const libre = elegir(dePata(delNivel, "output", ["libre"]), 1, usados);
  const repaso = elegir(anteriores.filter((x) => x.pata !== "fluidez"), nivel > 1 ? 1 : 0, usados);
  const rapido = elegir([...dePata(delNivel, "fluidez"), ...dePata(anteriores, "fluidez")], 3, usados);
  let bloque = [...estudio, ...input, ...decir, ...libre, ...repaso];
  // si a algún tipo le faltan ejercicios, se completa con estudio
  const faltan = 9 - bloque.length;
  if (faltan > 0) bloque.push(...elegir(delNivel.filter((x) => x.pata !== "fluidez"), faltan, usados));
  return [...mezclar(bloque), ...rapido]; // la ronda rápida siempre al final
}

// ---------- energía (lo llaman los bloques y la práctica libre) ----------
async function energiaSumar(bloques, minutos) {
  try {
    const { data, error } = await db.rpc("sumar_energia", { p_fecha: fechaLocal(), p_bloques: bloques, p_minutos: minutos });
    if (error) return null;
    WK.cargado = false; // Wako recalcula su batería la próxima vez
    return data;
  } catch { return null; }
}
const energiaSumarBloque = () => energiaSumar(1, 0);
function energiaSumarMinutos(min) { if (min > 0) energiaSumar(0, Math.round(min)); }

// ---------- pantalla "Mi camino" ----------
async function vistaCamino() {
  pintar(`<p class="muted">Preparando tu bloque…</p>`);
  try { await wakoCargar(); } catch {}
  const datos = await caminoDatos(true);
  if (datos.error) return pintar(faltaSQL(datos.error) ? avisoCaminoSQL("006_temas_y_dominio.sql y 007_ejercicios_4_patas.sql") : errorBox(datos.error));
  if (WK.fila && WK.fila.certificado === false && !WK.ubicacionVista) {
    WK.ubicacionVista = true; // primera vez: se ofrece el examen de ubicación
    return (location.hash = "/ubicacion");
  }
  const nivel = nivelActual();
  const bloque = armarBloque(datos, nivel);
  if (bloque.length < 4) return pintar(`<a href="#/" class="link">← Inicio</a>
    <div class="card" style="margin-top:16px"><h2>Nivel ${nivel}: contenido en camino</h2>
    <p class="muted">Todavía no hay ejercicios cargados para este nivel. Mientras tanto, repasa con la práctica libre.</p></div>`);
  jugarEjercicios({
    titulo: `Mi camino · Nivel ${nivel}`, ejercicios: bloque, modo: "camino", salir: "#/", episodio: nivel,
    alTerminar: (r) => finBloque(r, nivel)
  });
}
function avisoCaminoSQL(archivos) {
  return `<a href="#/" class="link">← Inicio</a>
    <div class="card" style="margin-top:16px"><h2>Falta un paso en Supabase</h2>
    <p class="muted">Para activar "Mi camino", corre en Supabase → <b>SQL Editor</b> los archivos <code>${archivos}</code>, en orden. Luego recarga.</p></div>`;
}

async function finBloque({ xp, precision }, nivel) {
  pintar(`<p class="muted">Cargando a Wako…</p>`);
  const fila = await energiaSumarBloque();
  let est = null;
  try { est = await wakoCargar(true); } catch {}
  const datos = await caminoDatos(true);
  const res = datos.error ? null : resumenNivel(nivel, datos);
  const meta = WK.fila?.meta_rayas || 4;
  const rayas = fila ? fila.bloques + Math.floor((fila.minutos_libre || 0) / 10) / 2 : null;
  if (precision >= 70) confeti();
  pintar(`
    <div class="card flash" style="margin-top:12px">
      ${est ? `<div class="wk-escena" id="wk-fin">${htmlWako(est, { alto: 200, animo: "cargando" })}</div>` : ""}
      <div class="big">⚡ ¡Bloque completado!</div>
      ${rayas !== null ? `<p><b>${rayas >= meta ? `¡Batería llena! ${rayas} de ${meta} rayas 🎉${rayas > meta ? " · el extra va a la reserva 🔋" : ""}` : `Wako tiene ${rayas} de ${meta} rayas hoy`}</b></p>
        <div class="rayas">${Array.from({ length: Math.max(meta, Math.ceil(rayas)) }, (_, i) => `<i class="${i < rayas ? (rayas - i >= 1 ? "llena" : "media") : ""} ${i >= meta ? "extra" : ""}"></i>`).join("")}</div>` : ""}
      <div class="resumen">
        <div><div class="hoy-num">+${xp}</div><div class="muted">XP</div></div>
        <div><div class="hoy-num">${precision}%</div><div class="muted">al primer intento</div></div>
        ${res ? `<div><div class="hoy-num">🟢 ${res.verdes}/${res.total}</div><div class="muted">temas dominados</div></div>` : ""}
      </div>
      ${res?.completo ? `<p><b>¡Dominaste todos los temas del Nivel ${nivel}! Ya puedes presentar el Now I Can.</b></p>` : ""}
      <div class="row">
        <a class="btn" href="#/camino" onclick="setTimeout(router,0)">▶ Otro bloque</a>
        <a class="btn alt" href="#/temas">Mis temas</a>
        ${res?.completo ? `<a class="btn alt" href="#/nowican">🏁 Now I Can</a>` : ""}
      </div>
    </div>`);
  const el = document.querySelector("#wk-fin .wako");
  if (el && est) setTimeout(() => { const v = el.querySelector(".wk-visor"); if (v) v.innerHTML = wakoCara(est.animo, ++wakoContador); }, 1800);
}

// ---------- pantalla "Mis temas" (semáforo) ----------
async function vistaTemas() {
  pintar(`<p class="muted">Revisando tus temas…</p>`);
  try { await wakoCargar(); } catch {}
  const datos = await caminoDatos(true);
  if (datos.error) return pintar(faltaSQL(datos.error) ? avisoCaminoSQL("006_temas_y_dominio.sql y 007_ejercicios_4_patas.sql") : errorBox(datos.error));
  const nivel = nivelActual();
  const niveles = [...new Set(datos.temas.map((t) => t.episodio))].sort((a, b) => a - b);
  const htmlNivel = (n) => {
    const res = resumenNivel(n, datos);
    const unidades = UNIDADES[n] || [{ n: "", nombre: "Temas", temas: res.temas.map((t) => t.id) }];
    return `
      <details class="episodio" ${n === nivel ? "open" : ""}>
        <summary>Nivel ${n} <span class="muted" style="font-weight:600">· Ep. ${n} del instituto</span>
          ${n < nivel ? `<span class="pill ok">✅ Aprobado</span>` : n === nivel ? `<span class="pill ok">Estás aquí</span> <span class="muted" style="font-weight:600">· 🟢 ${res.verdes}/${res.total}</span>` : `<span class="pill">🔒</span>`}</summary>
        <div class="episodio-body">
          ${unidades.map((u) => `
            <div class="sec" style="margin-top:12px">Unidad ${u.n} · ${esc(u.nombre)}</div>
            ${u.temas.map((id) => res.temas.find((t) => t.id === id)).filter(Boolean).map((t) => {
              const e = res.estados[t.id];
              return `<div class="tema-fila">
                <span class="semaforo s-${e.estado}"></span>
                <div style="flex:1;min-width:0"><b>${esc(t.nombre_es)}</b> <span class="muted">${esc(t.nombre_en || "")}</span>
                  <div class="patas">${Object.entries(e.patas).map(([p, v]) => `<span class="pata ${v.ok ? "ok" : ""}" title="${NOMBRE_PATA[p]}: ${v.aciertos} aciertos, ${v.precision}% reciente">${PATAS[p]} ${NOMBRE_PATA[p]}${v.ok ? " ✓" : ""}</span>`).join("")}</div>
                  ${e.faltaDia ? `<div class="muted" style="font-size:.85rem">Casi: acierta este tema otro día para confirmarlo 📅</div>` : ""}
                </div></div>`;
            }).join("")}`).join("")}
          ${n === nivel ? `<div class="row" style="justify-content:flex-start">
            <a class="btn" href="#/camino">▶ Mi camino</a>
            <a class="btn ${res.completo ? "" : "alt"}" href="#/nowican">${res.completo ? "🏁 Presentar Now I Can" : "🔒 Now I Can"}</a></div>` : ""}
        </div>
      </details>`;
  };
  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <h1>🚦 Mis temas</h1>
    <p class="muted">Cada tema queda 🟢 cuando lo dominas en todas sus patas (${Object.entries(PATAS).map(([p, i]) => `${i} ${NOMBRE_PATA[p]}`).join(", ")}) y en <b>días distintos</b>. Con todos en verde se abre el <b>Now I Can</b> para subir de nivel.</p>
    <div class="leyenda"><span><span class="semaforo s-rojo"></span> Por aprender</span><span><span class="semaforo s-amarillo"></span> En progreso</span><span><span class="semaforo s-verde"></span> Dominado</span></div>
    ${niveles.map(htmlNivel).join("")}`);
}
