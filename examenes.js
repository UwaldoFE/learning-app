// ============================================================
// 🏁 Exámenes (Pasos 8 y 9 de la hoja de ruta)
// - Examen de ubicación: niveles 1, 2, 3… seguidos; se aprueba con 80 %. Wako arranca donde de verdad estás.
// - Now I Can (como el instituto): Test Yourself (preguntas reservadas, con ronda rápida) + Workshop (lo califica Wako).
//   Se abre con todos los temas del nivel en 🟢. 80 % en cada parte. Si fallas, lo repites al día siguiente.
// Usa: db, esc, pintar, mezclar, fechaLocal, jugarEjercicios, evaluarConWako, grabarVoz, wakoCargar, wakoGuardar,
//      WK, caminoDatos, resumenNivel, nivelActual, confeti, etapaDe, htmlWako, CAM.
// ============================================================
const APROBAR = 80;

// Workshop de cada nivel: tarea de producción con rúbrica (la califica Wako)
const WORKSHOPS = {
  1: { tarea: "Describe a person you know: name, job, where he or she is from, what he or she looks like, and compare him or her with you.",
       tarea_es: "Describe a una persona que conozcas: nombre, trabajo, de dónde es, cómo es físicamente, y compárala contigo.",
       rubrica: ["to be correct (am / is / are)", "a job with a / an", "adjectives before nouns to describe the body or appearance", "he/she and his/her used correctly", "at least one comparative (taller than, older than…)"],
       ejemplo: "This is my brother Carlos. He is a lawyer. He is from Cúcuta. He has short black hair and brown eyes. He is taller than me." },
  2: { tarea: "Describe your daily routine and the routine of a person in your family. Say the times.",
       tarea_es: "Describe tu rutina diaria y la de una persona de tu familia. Di las horas.",
       rubrica: ["present simple with -s for he/she (works, wakes up)", "routine verbs (wake up, have breakfast, go to bed…)", "times (at seven o'clock, half past eight…)", "at least one question or negative with do/does", "plurals or this/that used correctly"],
       ejemplo: "I wake up at six o'clock and I have breakfast at seven. My wife wakes up at half past six. She doesn't drink coffee. Does she work on Sundays? No, she doesn't." },
  3: { tarea: "Write a short phone call: you call a friend and invite him or her to do something. Your friend can't at first, and you agree on another plan.",
       tarea_es: "Escribe una llamada corta: llamas a un amigo y lo invitas a hacer algo. Al principio no puede y acuerdan otro plan.",
       rubrica: ["would like to invite or offer (Would you like to…? I'd like…)", "can / can't / could", "may or might for a possibility", "connectors: and, but, so, because", "question words (what time, where, when…)"],
       ejemplo: "A: Hi Tom! Would you like to go to the cinema tonight? B: Sorry, I can't because I work late. A: What about Saturday? B: Yes, I can. It might rain, so let's meet at the mall at seven." }
};
const workshopDe = (n) => WORKSHOPS[n] || {
  tarea: `Write a short text (6–8 sentences) about your life using the topics of level ${n}.`,
  tarea_es: `Escribe un texto corto (6–8 frases) sobre tu vida usando los temas del nivel ${n}.`,
  rubrica: ["uses the grammar of this level correctly", "clear and understandable", "answers the task"], ejemplo: ""
};

async function examenesDe(nivel) {
  const { data, error } = await db.from("mis_examenes").select("*").eq("episodio", nivel).order("creado", { ascending: false });
  return error ? { error } : { filas: data };
}
async function guardarExamen(nivel, tipo, puntaje, detalle) {
  const user = await usuarioActual();
  const { error } = await db.from("mis_examenes").insert({ user_id: user.id, episodio: nivel, tipo, puntaje, aprobado: puntaje >= APROBAR, fecha: fechaLocal(), detalle });
  if (error) throw error;
}
async function ejerciciosReservados(nivel) {
  const [r, rap] = await Promise.all([
    db.from("ejercicios").select("*").eq("leccion_id", `examen-ep${nivel}`),
    db.from("ejercicios").select("*").eq("leccion_id", `banco-ep${nivel}`).eq("tipo", "rapido")
  ]);
  if (r.error) return { error: r.error };
  return { reservados: r.data || [], rapidos: rap.data || [] };
}
const avisoExamenSQL = `<a href="#/" class="link">← Inicio</a>
  <div class="card" style="margin-top:16px"><h2>Falta un paso en Supabase</h2>
  <p class="muted">Para los exámenes, corre en Supabase → <b>SQL Editor</b>, en orden: <code>006_temas_y_dominio.sql</code>, <code>007_ejercicios_4_patas.sql</code> y <code>008_energia_y_examenes.sql</code>. Luego recarga.</p></div>`;

// ---------- examen de ubicación ----------
async function vistaUbicacion() {
  pintar(`<p class="muted">Preparando el examen…</p>`);
  try { await wakoCargar(true); } catch {}
  if (WK.fila?.certificado) return pintar(`
    <a href="#/wako" class="link">← Wako</a>
    <div class="card" style="margin-top:16px"><h2>Ya presentaste el examen de ubicación ✅</h2>
    <p class="muted">Estás en el <b>Nivel ${nivelActual()}</b>. Para subir, domina los temas en <b>Mi camino</b> y aprueba el <b>Now I Can</b>.</p>
    <div class="row"><a class="btn" href="#/camino">▶ Mi camino</a><a class="btn alt" href="#/temas">🚦 Mis temas</a></div></div>`);
  const prueba = await examenesDe(1);
  if (prueba.error) return pintar(avisoExamenSQL);
  pintar(`
    <a href="#/" class="link">← Inicio</a>
    <div class="card wk-grande" style="text-align:center">
      <div class="wk-escena">${htmlWako(WK.estado, { alto: 200, etapa: 1, animo: "feliz" })}</div>
      <h1>🎯 Examen de ubicación</h1>
      <p class="muted">Vamos nivel por nivel (Nivel 1, 2, 3…), con preguntas que no has visto: leer, escuchar, escribir, decir y una ronda rápida.
        Cada nivel tiene unas 10 preguntas y se pasa con <b>${APROBAR} %</b>. Cuando un nivel no se pase, ahí empiezas.</p>
      <p class="muted">No te muestro las respuestas durante el examen. Tómalo con calma, sin traductor: es para que Wako sepa dónde estás de verdad.</p>
      <div class="row"><button class="btn" id="u-go">Empezar</button></div>
      <p class="error" id="u-err"></p>
    </div>`);
  document.getElementById("u-go").onclick = () => ubicacionNivel(1, 0);
}
async function ubicacionNivel(nivel, aprobados) {
  pintar(`<p class="muted">Preparando el Nivel ${nivel}…</p>`);
  const r = await ejerciciosReservados(nivel);
  if (r.error) return pintar(avisoExamenSQL);
  if (!r.reservados.length) return terminarUbicacion(aprobados); // ya no hay más niveles con examen
  // una pregunta por tema (al azar) + 2 de ronda rápida
  const porTema = {};
  for (const e of mezclar(r.reservados)) (porTema[e.tema_id] ||= e);
  const preguntas = [...mezclar(Object.values(porTema)).slice(0, 8), ...mezclar(r.rapidos).slice(0, 2)];
  jugarEjercicios({
    titulo: `Ubicación · Nivel ${nivel}`, ejercicios: preguntas, modo: "examen", salir: "#/", episodio: nivel,
    clave: `ubicacion-${nivel}`, pool: [...r.reservados, ...r.rapidos],
    alTerminar: async ({ precision, resultados }) => {
      try { await guardarExamen(nivel, "ubicacion", precision, { aciertos: resultados.filter((x) => x.ok).length, total: resultados.length }); } catch {}
      if (precision >= APROBAR) {
        pintar(`
          <div class="card flash" style="margin-top:16px">
            <div class="big">✅ Nivel ${nivel} superado</div>
            <p class="muted">Sacaste ${precision} %. ¿Seguimos con el Nivel ${nivel + 1}?</p>
            <div class="row"><button class="btn" id="u-sig">▶ Nivel ${nivel + 1}</button><button class="btn alt" id="u-fin">Terminar aquí</button></div>
          </div>`);
        confeti();
        document.getElementById("u-sig").onclick = () => ubicacionNivel(nivel + 1, nivel);
        document.getElementById("u-fin").onclick = () => terminarUbicacion(nivel);
      } else {
        pintar(`
          <div class="card flash" style="margin-top:16px">
            <div class="big">📍 Tu punto de partida: Nivel ${nivel}</div>
            <p class="muted">En el Nivel ${nivel} sacaste ${precision} % (se necesita ${APROBAR} %). Ahí empieza tu camino: lo vas a dominar con Mi camino.</p>
            <div class="row"><button class="btn" id="u-fin">Continuar</button></div>
          </div>`);
        document.getElementById("u-fin").onclick = () => terminarUbicacion(aprobados);
      }
    }
  });
}
async function terminarUbicacion(aprobados) {
  try {
    await wakoGuardar({ episodios_aprobados: aprobados, certificado: true, etapa_vista: 1 });
  } catch (e) { return pintar(`<a href="#/" class="link">← Inicio</a>${errorBox(e)}`); }
  CAM.cache = null; WK.cargado = false;
  location.hash = "/wako"; // si nace en una etapa mayor, ahí se ve la evolución
}

// ---------- Now I Can ----------
async function vistaNowICan() {
  pintar(`<p class="muted">Revisando tu nivel…</p>`);
  try { await wakoCargar(true); } catch {}
  const nivel = nivelActual();
  const datos = await caminoDatos(true);
  const ex = await examenesDe(nivel);
  if (datos.error || ex.error) return pintar(avisoExamenSQL);
  const res = resumenNivel(nivel, datos);
  const hoy = fechaLocal();
  const testOk = ex.filas.some((x) => x.tipo === "test" && x.aprobado);
  const workshopOk = ex.filas.some((x) => x.tipo === "workshop" && x.aprobado);
  const falloHoy = (tipo) => ex.filas.some((x) => x.tipo === tipo && !x.aprobado && x.fecha === hoy);
  const ultimo = (tipo) => ex.filas.find((x) => x.tipo === tipo);
  if (testOk && workshopOk) return subirDeNivel(nivel);
  if (!res.completo) {
    const pendientes = res.temas.filter((t) => res.estados[t.id].estado !== "verde");
    return pintar(`
      <a href="#/temas" class="link">← Mis temas</a>
      <div class="card" style="margin-top:12px">
        <h1>🔒 Now I Can · Nivel ${nivel}</h1>
        <p class="muted">Se abre cuando todos los temas del nivel están en 🟢. Llevas <b>${res.verdes} de ${res.total}</b>.</p>
        <div class="sec">Te falta dominar</div>
        ${pendientes.map((t) => `<div class="tema-fila"><span class="semaforo s-${res.estados[t.id].estado}"></span><b>${esc(t.nombre_es)}</b></div>`).join("")}
        <div class="row"><a class="btn" href="#/camino">▶ Mi camino</a></div>
      </div>`);
  }
  const ws = workshopDe(nivel);
  const parte = (tipo, titulo, desc, ok) => {
    const u = ultimo(tipo), fallo = falloHoy(tipo);
    return `<div class="card nic-parte ${ok ? "nic-ok" : ""}">
      <div class="sec">${titulo}</div>
      <p class="muted" style="margin:4px 0">${desc}</p>
      ${ok ? `<b>✅ Aprobado (${u.puntaje} %)</b>` : fallo ? `<b>Hoy sacaste ${u.puntaje} %. Puedes intentarlo de nuevo mañana 📅</b>`
        : `<button class="btn" data-parte="${tipo}">${u ? "Intentar de nuevo" : "Empezar"}</button>${u ? ` <span class="muted">Último intento: ${u.puntaje} %</span>` : ""}`}
    </div>`;
  };
  pintar(`
    <a href="#/temas" class="link">← Mis temas</a>
    <h1>🏁 Now I Can · Nivel ${nivel}</h1>
    <p class="muted">¡Dominaste todos los temas! Aprueba las dos partes con <b>${APROBAR} %</b> para subir al Nivel ${nivel + 1}.</p>
    ${parte("test", "Parte 1 · Test Yourself", "Preguntas nuevas de todo el nivel (leer, escuchar, escribir, decir) y una ronda rápida. Sin ver las respuestas hasta el final.", testOk)}
    ${parte("workshop", "Parte 2 · Workshop con Wako", `${esc(ws.tarea_es)} Lo puedes escribir o dictar.`, workshopOk)}`);
  app.querySelectorAll("[data-parte]").forEach((b) => (b.onclick = () => (b.dataset.parte === "test" ? nicTest(nivel) : nicWorkshop(nivel))));
}

async function nicTest(nivel) {
  pintar(`<p class="muted">Preparando el Test Yourself…</p>`);
  const r = await ejerciciosReservados(nivel);
  if (r.error || !r.reservados.length) return pintar(avisoExamenSQL);
  const preguntas = [...mezclar(r.reservados.filter((x) => x.tipo !== "libre")).slice(0, 15), ...mezclar(r.rapidos).slice(0, 3)];
  jugarEjercicios({
    titulo: `Now I Can ${nivel} · Test Yourself`, ejercicios: preguntas, modo: "examen", salir: "#/nowican", episodio: nivel,
    clave: `nowican-${nivel}`, pool: [...r.reservados, ...r.rapidos],
    alTerminar: async ({ precision, resultados }) => {
      try { await guardarExamen(nivel, "test", precision, { aciertos: resultados.filter((x) => x.ok).length, total: resultados.length }); }
      catch (e) { return pintar(errorBox(e)); }
      const falladas = resultados.filter((x) => !x.ok).map((x) => x.ejercicio);
      if (precision >= APROBAR) confeti();
      pintar(`
        <div class="card flash" style="margin-top:16px">
          <div class="big">${precision >= APROBAR ? "✅ ¡Test Yourself aprobado!" : "💪 Casi"}</div>
          <p><b>${precision} %</b> (se necesita ${APROBAR} %)</p>
          ${falladas.length ? `<div class="practica" style="text-align:left"><b>Para repasar:</b><br>${falladas.map((e) => esc(e.datos.mostrar || e.datos.audio || (e.datos.opciones ? e.datos.opciones[e.datos.correcta] : "") || "")).filter(Boolean).map((t) => `• ${t}`).join("<br>")}</div>` : ""}
          ${precision < APROBAR ? `<p class="muted">Repasa con Mi camino y vuelve a intentarlo mañana.</p>` : ""}
          <div class="row"><a class="btn" href="#/nowican" onclick="setTimeout(router,0)">Continuar</a></div>
        </div>`);
    }
  });
}

function nicWorkshop(nivel) {
  const ws = workshopDe(nivel);
  pintar(`
    <a href="#/nowican" class="link">← Now I Can</a>
    <div class="card lec">
      <div class="muted lec-tipo">🏁 Workshop · Nivel ${nivel} · lo califica Wako</div>
      <div class="lec-frase">${fraseTocable(ws.tarea)}</div>
      <div class="muted">🇪🇸 ${esc(ws.tarea_es)}</div>
      <div class="practica"><b>Wako revisará que uses:</b><br>${ws.rubrica.map((r) => `• ${esc(r)}`).join("<br>")}</div>
      <textarea id="ws-txt" rows="7" placeholder="Escribe aquí en inglés (mínimo 5 frases)… o toca 🎤 para dictar"></textarea>
      <div class="row" style="justify-content:space-between;margin-top:8px">
        <button class="btn alt" id="ws-mic">🎤 Dictar</button>
        <span class="muted" id="ws-cont">0 palabras</span>
        <button class="btn" id="ws-ok">Entregar a Wako</button>
      </div>
      <p class="error" id="ws-err"></p>
      <div id="ws-fb"></div>
    </div>`);
  const txt = document.getElementById("ws-txt"), err = (m) => (document.getElementById("ws-err").textContent = m);
  const contar = () => (document.getElementById("ws-cont").textContent = `${txt.value.trim() ? txt.value.trim().split(/\s+/).length : 0} palabras`);
  txt.oninput = contar;
  const mic = document.getElementById("ws-mic");
  mic.onclick = () => grabarVoz(mic, (t) => { txt.value = (txt.value ? txt.value + " " : "") + t; contar(); err(""); }, err);
  document.getElementById("ws-ok").onclick = async (e) => {
    const v = txt.value.trim();
    if (v.split(/\s+/).length < 25) return err("Escribe un poco más: al menos 25 palabras (unas 5 frases).");
    e.target.disabled = true; e.target.textContent = "Wako está calificando…";
    try {
      const r = await evaluarConWako({ pregunta: ws.tarea, pregunta_es: ws.tarea_es, criterio: ws.rubrica.join("; "), ejemplo: ws.ejemplo, rubrica: ws.rubrica }, v, nivel);
      await guardarExamen(nivel, "workshop", r.puntaje, { texto: v.slice(0, 2000), criterios: r.criterios, correccion: r.correccion });
      if (r.puntaje >= APROBAR) confeti();
      document.getElementById("ws-fb").innerHTML = `
        <div class="fb ${r.puntaje >= APROBAR ? "fb-ok" : "fb-mal"}">
          <b>🤖 Wako: ${r.puntaje}/100 ${r.puntaje >= APROBAR ? "· ¡Aprobado!" : `· se necesita ${APROBAR}`}</b>
          <div>${esc(r.comentario)}</div>
          ${r.criterios ? `<div class="muted">${ws.rubrica.map((x, i) => `${r.criterios[i] >= 70 ? "✅" : "⚠️"} ${esc(x)}${r.criterios[i] !== undefined ? ` (${r.criterios[i]})` : ""}`).join("<br>")}</div>` : ""}
          ${r.correccion ? `<div class="fb-resp">✏️ ${esc(r.correccion)}</div>${r.correccion_es ? `<div class="muted">🇪🇸 ${esc(r.correccion_es)}</div>` : ""}` : ""}
          ${r.puntaje < APROBAR ? `<div class="muted">Practica los puntos con ⚠️ y vuelve a intentarlo mañana.</div>` : ""}
        </div>
        <div class="row"><a class="btn" href="#/nowican" onclick="setTimeout(router,0)">Continuar</a></div>`;
      e.target.hidden = true;
    } catch (er) { e.target.disabled = false; e.target.textContent = "Entregar a Wako"; err(er.message); }
  };
}

async function subirDeNivel(nivel) {
  const etapaAntes = etapaDe(WK.fila?.episodios_aprobados || 0).n;
  try { await wakoGuardar({ episodios_aprobados: Math.max(nivel, WK.fila?.episodios_aprobados || 0), certificado: true }); }
  catch (e) { return pintar(errorBox(e)); }
  CAM.cache = null; WK.cargado = false;
  const etapaAhora = etapaDe(nivel).n;
  confeti();
  try { hablar("Level up! Great job!"); } catch {}
  pintar(`
    <div class="card flash wk-grande" style="margin-top:16px">
      <div class="big">🎉 ¡Subiste al Nivel ${nivel + 1}!</div>
      <p class="muted">Aprobaste el Now I Can del Nivel ${nivel} (Ep. ${nivel} del instituto).</p>
      ${etapaAhora > etapaAntes ? `<p><b>¡Y Wako está a punto de evolucionar! 🌟</b></p>` : ""}
      <div class="row">
        ${etapaAhora > etapaAntes ? `<a class="btn" href="#/wako">🌟 Ver la evolución</a>` : `<a class="btn" href="#/camino">▶ Empezar el Nivel ${nivel + 1}</a>`}
        <a class="btn alt" href="#/temas">🚦 Mis temas</a>
      </div>
    </div>`);
}
