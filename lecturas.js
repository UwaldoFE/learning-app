// ============================================================
// "Leer y escuchar" — pata de INPUT (Paul Nation)
// Historias cortas con personajes inventados que viven las situaciones
// de cada episodio. Contenido propio (no copiado de ningún curso).
// Flujo: 1) escuchar sin leer · 2) leer (palabras tocables, 🇪🇸 oculto) · 3) preguntas.
// Usa funciones de app.js (db, pintar, esc, hablar, VEL, btnVoz, fraseTocable, usuarioActual).
// ============================================================
const XP_PREGUNTA = 5;

const LECTURAS = [
  {
    id: "ep1-meet-laura", episodio: 1, titulo: "Meet Laura", es: "Te presento a Laura",
    tema: "to be, a/an, his/her, adjetivos y clima",
    lineas: [
      { en: "This is Laura.", es: "Esta es Laura." },
      { en: "She is a nurse. She is thirty years old.", es: "Ella es enfermera. Tiene treinta años." },
      { en: "Her friend is Tom.", es: "Su amigo (de ella) es Tom." },
      { en: "He is an engineer.", es: "Él es ingeniero." },
      { en: "His car is red and old.", es: "Su carro (de él) es rojo y viejo." },
      { en: "Laura is tall, and Tom is taller.", es: "Laura es alta, y Tom es más alto." },
      { en: "Today it is sunny and hot.", es: "Hoy está soleado y hace calor." }
    ],
    preguntas: [
      { q: "What is Laura's job?", es: "¿Cuál es el trabajo de Laura?", opciones: ["She is a nurse.", "She is an engineer.", "She is a teacher."], correcta: 0, ex: "\"She is a nurse\" = Ella es enfermera." },
      { q: "Tom is ___ engineer.", es: "Tom es ingeniero.", opciones: ["a", "an", "the"], correcta: 1, ex: "\"an\" va antes de sonido de vocal: an engineer, an umbrella." },
      { q: "What color is Tom's car?", es: "¿De qué color es el carro de Tom?", opciones: ["Blue", "Black", "Red"], correcta: 2, ex: "\"His car is red\" = Su carro es rojo. His = de él." },
      { q: "Who is taller?", es: "¿Quién es más alto?", opciones: ["Laura", "Tom"], correcta: 1, ex: "\"Tom is taller\" = Tom es más alto. Tall → taller." }
    ]
  },
  {
    id: "ep2-toms-day", episodio: 2, titulo: "Tom's Day", es: "El día de Tom",
    tema: "presente simple (-s con he/she), do/does, la hora",
    lineas: [
      { en: "Tom wakes up at six o'clock.", es: "Tom se despierta a las seis." },
      { en: "He takes a shower and has breakfast.", es: "Se ducha y desayuna." },
      { en: "He drinks black coffee.", es: "Toma café negro." },
      { en: "He goes to work by bus at a quarter past seven.", es: "Va al trabajo en bus a las siete y cuarto." },
      { en: "Tom works in an office.", es: "Tom trabaja en una oficina." },
      { en: "He has lunch at twelve o'clock.", es: "Almuerza a las doce." },
      { en: "Laura doesn't work in an office. She works in a hospital.", es: "Laura no trabaja en una oficina. Trabaja en un hospital." },
      { en: "Does Tom like his job? Yes, he does.", es: "¿A Tom le gusta su trabajo? Sí." }
    ],
    preguntas: [
      { q: "What time does Tom wake up?", es: "¿A qué hora se despierta Tom?", opciones: ["At six o'clock.", "At seven o'clock.", "At twelve o'clock."], correcta: 0, ex: "\"Tom wakes up at six\": con he/she el verbo lleva -s (wakes)." },
      { q: "How does Tom go to work?", es: "¿Cómo va Tom al trabajo?", opciones: ["By car.", "By bus.", "By taxi."], correcta: 1, ex: "\"He goes to work by bus\" = Va en bus. go → goes con he." },
      { q: "Where does Laura work?", es: "¿Dónde trabaja Laura?", opciones: ["In an office.", "In a school.", "In a hospital."], correcta: 2, ex: "\"She works in a hospital.\" Pregunta con does, respuesta con -s." },
      { q: "Does Tom like his job?", es: "¿A Tom le gusta su trabajo?", opciones: ["Yes, he do.", "Yes, he does.", "Yes, he likes."], correcta: 1, ex: "Respuesta corta con he/she: \"Yes, he does\" / \"No, he doesn't\"." }
    ]
  },
  {
    id: "ep3-phone-call", episodio: 3, titulo: "A Phone Call", es: "Una llamada",
    tema: "llamada informal, would like, can",
    lineas: [
      { quien: "Tom", en: "Hello?", es: "¿Aló?" },
      { quien: "Laura", en: "Hi, Tom! It's Laura. How are you?", es: "¡Hola, Tom! Habla Laura. ¿Cómo estás?" },
      { quien: "Tom", en: "I'm fine, thanks. And you?", es: "Bien, gracias. ¿Y tú?" },
      { quien: "Laura", en: "Great! Would you like to go to the cinema tomorrow?", es: "¡Muy bien! ¿Te gustaría ir al cine mañana?" },
      { quien: "Tom", en: "Yes, I'd like that. What time?", es: "Sí, me gustaría. ¿A qué hora?" },
      { quien: "Laura", en: "Can you meet me at seven?", es: "¿Puedes encontrarte conmigo a las siete?" },
      { quien: "Tom", en: "Sorry, I can't. I work until seven. Can we meet at eight?", es: "Lo siento, no puedo. Trabajo hasta las siete. ¿Podemos vernos a las ocho?" },
      { quien: "Laura", en: "Sure! See you tomorrow. Bye!", es: "¡Claro! Nos vemos mañana. ¡Chao!" }
    ],
    preguntas: [
      { q: "What would Laura like to do?", es: "¿Qué le gustaría hacer a Laura?", opciones: ["Go to the cinema.", "Go to the airport.", "Have lunch."], correcta: 0, ex: "\"Would you like to go…?\" = ¿Te gustaría ir…? Sirve para invitar." },
      { q: "Can Tom meet at seven?", es: "¿Tom puede verse a las siete?", opciones: ["Yes, he can.", "No, he can't."], correcta: 1, ex: "\"Sorry, I can't\" = Lo siento, no puedo. can't = can not." },
      { q: "Why can't Tom meet at seven?", es: "¿Por qué Tom no puede a las siete?", opciones: ["He is tired.", "He works until seven.", "He has a class."], correcta: 1, ex: "\"I work until seven\" = Trabajo hasta las siete." },
      { q: "\"I'd like that\" means…", es: "\"I'd like that\" significa…", opciones: ["Me gusta eso.", "Me gustaría (eso).", "No me gusta."], correcta: 1, ex: "I'd like = I would like = me gustaría. Es más cortés que \"I want\"." }
    ]
  },
  {
    id: "ep3-weekend", episodio: 3, titulo: "Plans for the Weekend", es: "Planes para el fin de semana",
    tema: "might/may, and/but/so/because",
    lineas: [
      { en: "Tom's sister, Anna, is in the city this weekend.", es: "La hermana de Tom, Anna, está en la ciudad este fin de semana." },
      { en: "She would like to visit the museum, but it is closed on Sunday.", es: "Le gustaría visitar el museo, pero está cerrado el domingo." },
      { en: "So they might go to the park.", es: "Así que tal vez vayan al parque." },
      { en: "It may rain in the afternoon, so Anna takes an umbrella.", es: "Puede que llueva en la tarde, así que Anna lleva un paraguas." },
      { en: "Tom is tired because he works a lot.", es: "Tom está cansado porque trabaja mucho." },
      { en: "He might stay home and watch TV.", es: "Tal vez se quede en casa y vea televisión." },
      { en: "But Anna says: \"Come on, Tom! We can have lunch in the park.\"", es: "Pero Anna dice: \"¡Vamos, Tom! Podemos almorzar en el parque.\"" },
      { en: "Tom smiles and says: \"OK, you win!\"", es: "Tom sonríe y dice: \"¡Está bien, tú ganas!\"" }
    ],
    preguntas: [
      { q: "Why can't Anna visit the museum on Sunday?", es: "¿Por qué Anna no puede visitar el museo el domingo?", opciones: ["It is closed.", "It is far.", "It is expensive."], correcta: 0, ex: "\"…but it is closed on Sunday\". But = pero (contraste)." },
      { q: "Why does Anna take an umbrella?", es: "¿Por qué Anna lleva un paraguas?", opciones: ["It is sunny.", "It may rain.", "She likes it."], correcta: 1, ex: "\"It may rain\" = Puede que llueva. May/might = posibilidad." },
      { q: "Why is Tom tired?", es: "¿Por qué Tom está cansado?", opciones: ["Because he works a lot.", "Because he watches TV.", "Because he is sick."], correcta: 0, ex: "Because = porque (da la razón). So = así que (da la consecuencia)." },
      { q: "\"He might stay home\" means…", es: "\"He might stay home\" significa…", opciones: ["Debe quedarse en casa.", "Tal vez se quede en casa.", "Se quedó en casa."], correcta: 1, ex: "might + verbo = tal vez / puede que. No cambia: he might stay (sin -s)." }
    ]
  },
  {
    id: "ep3-taxi", episodio: 3, titulo: "Taking a Taxi", es: "Tomando un taxi",
    tema: "could you…?, question words (where, how long, how much)",
    lineas: [
      { quien: "Laura", en: "Hello! Could you take me to the airport, please?", es: "¡Hola! ¿Me podría llevar al aeropuerto, por favor?" },
      { quien: "Driver", en: "Of course. Get in, please.", es: "Claro. Suba, por favor." },
      { quien: "Laura", en: "How long does it take?", es: "¿Cuánto se demora?" },
      { quien: "Driver", en: "About thirty minutes. Where do you fly to?", es: "Unos treinta minutos. ¿A dónde vuela?" },
      { quien: "Laura", en: "To Miami. My flight is at ten.", es: "A Miami. Mi vuelo es a las diez." },
      { quien: "Driver", en: "Do you have family there?", es: "¿Tiene familia allá?" },
      { quien: "Laura", en: "Yes, my brother lives there.", es: "Sí, mi hermano vive allá." },
      { quien: "Laura", en: "Here we are! How much is it?", es: "¡Llegamos! ¿Cuánto es?" },
      { quien: "Driver", en: "Twenty-five dollars.", es: "Veinticinco dólares." },
      { quien: "Laura", en: "Here you are. Could I have a receipt, please?", es: "Aquí tiene. ¿Me podría dar un recibo, por favor?" }
    ],
    preguntas: [
      { q: "Where does Laura want to go?", es: "¿A dónde quiere ir Laura?", opciones: ["To the hospital.", "To the airport.", "To the museum."], correcta: 1, ex: "\"Could you take me to the airport?\" = ¿Me podría llevar al aeropuerto? Could = forma cortés de pedir." },
      { q: "How long does it take?", es: "¿Cuánto se demora?", opciones: ["Ten minutes.", "Thirty minutes.", "One hour."], correcta: 1, ex: "How long = cuánto tiempo. \"About thirty minutes\" = unos treinta minutos." },
      { q: "Who lives in Miami?", es: "¿Quién vive en Miami?", opciones: ["Her sister.", "Her brother.", "The driver."], correcta: 1, ex: "\"My brother lives there\": brother = hermano; lives con -s (he)." },
      { q: "How much is the taxi?", es: "¿Cuánto cuesta el taxi?", opciones: ["$15", "$25", "$35"], correcta: 1, ex: "How much = cuánto (precio). Twenty-five = 25." }
    ]
  },
  {
    id: "ep3-whose-bag", episodio: 3, titulo: "Whose Bag Is This?", es: "¿De quién es este bolso?",
    tema: "whose, posesivos, la hora",
    lineas: [
      { en: "At the airport, Laura sees a black bag on a chair.", es: "En el aeropuerto, Laura ve un bolso negro en una silla." },
      { quien: "Laura", en: "Excuse me, whose bag is this?", es: "Disculpe, ¿de quién es este bolso?" },
      { quien: "A man", en: "It isn't my bag. My bag is blue.", es: "No es mi bolso. Mi bolso es azul." },
      { quien: "A woman", en: "Maybe it's that boy's bag.", es: "Tal vez es el bolso de ese niño." },
      { quien: "Laura", en: "Excuse me! Is this your bag?", es: "¡Disculpa! ¿Este es tu bolso?" },
      { quien: "The boy", en: "Yes, it's my bag! Thank you very much!", es: "¡Sí, es mi bolso! ¡Muchas gracias!" },
      { quien: "His mother", en: "Thank you! You're very kind.", es: "¡Gracias! Usted es muy amable." },
      { en: "Laura smiles. Then she looks at her watch. It's a quarter to ten!", es: "Laura sonríe. Luego mira su reloj. ¡Son las diez menos cuarto!" },
      { en: "She runs to her gate.", es: "Corre a su puerta de embarque." }
    ],
    preguntas: [
      { q: "What color is the bag?", es: "¿De qué color es el bolso?", opciones: ["Blue", "Black", "Red"], correcta: 1, ex: "\"a black bag\": en inglés el color va antes de la cosa." },
      { q: "Whose bag is it?", es: "¿De quién es el bolso?", opciones: ["The man's bag.", "The woman's bag.", "The boy's bag."], correcta: 2, ex: "Whose = de quién. Se responde con 's: the boy's bag = el bolso del niño." },
      { q: "Complete: \"___ phone is this?\"", es: "¿De quién es este teléfono?", opciones: ["Who", "Whose", "Where"], correcta: 1, ex: "Para preguntar el dueño: Whose + cosa + is this?" },
      { q: "\"A quarter to ten\" is…", es: "\"A quarter to ten\" es…", opciones: ["10:15", "9:45", "10:45"], correcta: 1, ex: "\"to\" = para / menos: un cuarto para las diez = 9:45. \"past\" = y: a quarter past ten = 10:15." }
    ]
  }
];

// ---------- progreso (se guarda en este dispositivo; el XP sí va a tu cuenta) ----------
const claveLect = "lecturas-hechas";
const leerHechas = () => { try { return JSON.parse(localStorage.getItem(claveLect)) || {}; } catch { return {}; } };
const guardarHecha = (id, aciertos) => {
  try {
    const h = leerHechas();
    h[id] = Math.max(h[id] || 0, aciertos);
    localStorage.setItem(claveLect, JSON.stringify(h));
  } catch { /* sin almacenamiento: no pasa nada */ }
};

// Trae lo que ya hiciste desde tu cuenta (si la tabla existe) y lo junta con lo del dispositivo
async function cargarHechas() {
  try {
    const { data, error } = await db.from("mis_lecturas").select("lectura_id, aciertos");
    if (error) return;
    const h = leerHechas();
    data.forEach((r) => { h[r.lectura_id] = Math.max(h[r.lectura_id] || 0, r.aciertos); });
    localStorage.setItem(claveLect, JSON.stringify(h));
  } catch { /* sin conexión o sin tabla: se usa lo del dispositivo */ }
}
async function guardarHechaCuenta(id, aciertos) {
  try {
    const user = await usuarioActual();
    const prev = await db.from("mis_lecturas").select("*").eq("lectura_id", id).maybeSingle();
    if (prev.error) return;
    await db.from("mis_lecturas").upsert({ user_id: user.id, lectura_id: id,
      aciertos: Math.max(prev.data?.aciertos || 0, aciertos), veces: (prev.data?.veces || 0) + 1, ultima: new Date().toISOString() });
  } catch { /* si falla, queda en el dispositivo */ }
}

async function sumarXP(xp) {
  const user = await usuarioActual();
  if (!user || !xp) return;
  const f = fechaLocal();
  const prev = await db.from("mi_estudio").select("*").eq("fecha", f).maybeSingle();
  await db.from("mi_estudio").upsert({
    user_id: user.id, fecha: f, xp: (prev.data?.xp || 0) + xp, lecciones: prev.data?.lecciones || 0
  });
}

// ---------- lectura en voz alta, línea por línea (marca la línea que suena) ----------
function leerEnCola(lineas, rate, alMarcar) {
  if (!("speechSynthesis" in window)) return alert("Tu navegador no tiene voz disponible.");
  speechSynthesis.cancel();
  const ingles = speechSynthesis.getVoices().find((v) => v.lang?.startsWith("en"));
  lineas.forEach((l, i) => {
    const u = new SpeechSynthesisUtterance(l.en.replace(/["“”]/g, ""));
    u.lang = "en-US"; u.rate = rate;
    if (ingles) u.voice = ingles;
    u.onstart = () => alMarcar(i);
    if (i === lineas.length - 1) u.onend = () => alMarcar(-1);
    speechSynthesis.speak(u);
  });
}

// ---------- vistas ----------
function htmlLecturasDe(episodio) {
  const ls = LECTURAS.filter((x) => x.episodio === episodio);
  if (!ls.length) return "";
  const h = leerHechas();
  return `<div class="sec" style="margin-top:14px">📖 Leer y escuchar</div>
    <div class="lecciones">${ls.map((x) => `
      <a class="card leccion" href="#/ingles/lectura/${x.id}">
        <div><b>${esc(x.titulo)}</b> ${x.id in h ? `<span class="pill ok">✓ ${h[x.id]}/${x.preguntas.length}</span>` : ""}</div>
        <div class="muted">${esc(x.es)} · ${esc(x.tema)}</div>
      </a>`).join("")}</div>`;
}

async function vistaLecturas() {
  await cargarHechas();
  const eps = [...new Set(LECTURAS.map((x) => x.episodio))].sort((a, b) => b - a);
  pintar(`
    <a href="#/ingles" class="link">← Inglés</a>
    <h1>📖 Leer y escuchar</h1>
    <p class="muted">Historias cortas con lo de cada episodio. Primero escucha sin leer, luego lee, y al final responde.</p>
    ${eps.map((ep) => `<h2 style="margin-top:20px">Episodio ${ep}</h2>${htmlLecturasDe(ep).replace(/<div class="sec"[^>]*>.*?<\/div>/, "")}`).join("")}`);
}

async function vistaLectura(id) {
  await cargarHechas();
  const L = LECTURAS.find((x) => x.id === id);
  if (!L) return pintar(`<a href="#/ingles/lecturas" class="link">← Leer y escuchar</a><p>No encontré esa historia.</p>`);
  const total = L.preguntas.length;

  pintar(`
    <a href="#/ingles/lecturas" class="link">← Leer y escuchar</a>
    <h1>${esc(L.titulo)}</h1>
    <p class="muted">Episodio ${L.episodio} · ${esc(L.tema)}</p>

    <div class="card lect-paso">
      <div class="sec">1 · Escucha primero, sin leer</div>
      <p class="muted">Trata de entender la idea general. Puedes oírla las veces que quieras.</p>
      <div class="row" style="justify-content:flex-start">
        <button class="btn" id="l-todo">🔊 Escuchar la historia</button>
        <button class="btn alt" id="l-lento">🐢 Despacio</button>
        <button class="btn alt" id="l-stop">⏹</button>
      </div>
    </div>

    <div class="card lect-paso">
      <div class="sec">2 · Ahora lee</div>
      <button class="btn alt" id="l-mostrar">👀 Mostrar el texto</button>
      <div id="l-texto" hidden>
        <div class="row" style="justify-content:flex-start;margin:8px 0">
          <button class="btn alt" id="l-es-todo">🇪🇸 Ver todo en español</button>
        </div>
        <div class="muted pista-palabra">👆 Toca una palabra para oírla sola · 🇪🇸 para ver la traducción de una línea</div>
        ${L.lineas.map((l, i) => `
          <div class="lect-linea" data-i="${i}">
            <div>${l.quien ? `<b class="quien">${esc(l.quien)}:</b> ` : ""}${fraseTocable(l.en)}</div>
            <div class="lect-acc">${btnVoz(l.en)} <button class="voz" data-es="${i}" title="Ver en español">🇪🇸</button></div>
            <div class="muted lect-es" hidden>${esc(l.es)}</div>
          </div>`).join("")}
      </div>
    </div>

    <div class="card lect-paso">
      <div class="sec">3 · ¿Entendiste?</div>
      ${L.preguntas.map((p, i) => `
        <div class="lect-preg" data-p="${i}">
          <div class="lec-frase" style="font-size:1.1rem">${i + 1}. ${fraseTocable(p.q)}</div>
          <button class="link" data-pes="${i}">🇪🇸 ver pregunta en español</button>
          <div class="muted" id="pes-${i}" hidden>${esc(p.es)}</div>
          <div class="opciones">${p.opciones.map((o, j) => `<button class="opcion" data-op="${i}-${j}">${esc(o)}</button>`).join("")}</div>
          <div id="pfb-${i}"></div>
        </div>`).join("")}
      <p class="error" id="l-err"></p>
      <div class="row" style="justify-content:flex-end"><button class="btn" id="l-comprobar">Comprobar</button></div>
      <div id="l-final"></div>
    </div>`);

  // Paso 1: escuchar (marca la línea que suena si el texto está visible)
  const marcar = (i) => app.querySelectorAll(".lect-linea").forEach((el) => el.classList.toggle("sonando", Number(el.dataset.i) === i));
  document.getElementById("l-todo").onclick = () => leerEnCola(L.lineas, VEL.normal, marcar);
  document.getElementById("l-lento").onclick = () => leerEnCola(L.lineas, VEL.lenta, marcar);
  document.getElementById("l-stop").onclick = () => { try { speechSynthesis.cancel(); } catch {} marcar(-1); };

  // Paso 2: leer, con traducción oculta
  document.getElementById("l-mostrar").onclick = (e) => { document.getElementById("l-texto").hidden = false; e.target.remove(); };
  let todoEs = false;
  document.getElementById("l-es-todo").onclick = (e) => {
    todoEs = !todoEs;
    app.querySelectorAll(".lect-es").forEach((el) => (el.hidden = !todoEs));
    e.target.textContent = todoEs ? "🇪🇸 Ocultar español" : "🇪🇸 Ver todo en español";
  };
  app.querySelectorAll("[data-es]").forEach((b) => (b.onclick = () => {
    const el = b.closest(".lect-linea").querySelector(".lect-es"); el.hidden = !el.hidden;
  }));
  app.querySelectorAll("[data-pes]").forEach((b) => (b.onclick = () => {
    const el = document.getElementById(`pes-${b.dataset.pes}`); el.hidden = !el.hidden;
  }));

  // Paso 3: preguntas
  const sel = {};
  let comprobado = false;
  app.querySelectorAll("[data-op]").forEach((b) => (b.onclick = () => {
    if (comprobado) return;
    const [i, j] = b.dataset.op.split("-").map(Number);
    app.querySelectorAll(`[data-op^="${i}-"]`).forEach((x) => x.classList.remove("sel"));
    b.classList.add("sel"); sel[i] = j;
    document.getElementById("l-err").textContent = "";
  }));
  document.getElementById("l-comprobar").onclick = async (e) => {
    if (comprobado) return;
    if (Object.keys(sel).length < total) return (document.getElementById("l-err").textContent = "Responde todas las preguntas primero.");
    comprobado = true; e.target.hidden = true;
    let bien = 0;
    L.preguntas.forEach((p, i) => {
      const ok = sel[i] === p.correcta;
      if (ok) bien++;
      app.querySelectorAll(`[data-op^="${i}-"]`).forEach((b) => {
        const j = Number(b.dataset.op.split("-")[1]);
        b.classList.remove("sel");
        if (j === p.correcta) b.classList.add("bien"); else if (j === sel[i]) b.classList.add("mal");
      });
      document.getElementById(`pfb-${i}`).innerHTML = `
        <div class="fb ${ok ? "fb-ok" : "fb-mal"}">
          <b>${ok ? "¡Correcto!" : "La respuesta es: " + esc(p.opciones[p.correcta])}</b>
          <div class="muted">🇪🇸 ${esc(p.es)}</div>
          <div class="fb-ex">💡 ${esc(p.ex)}</div>
        </div>`;
    });
    const anterior = leerHechas()[L.id];
    const xp = anterior === undefined ? bien * XP_PREGUNTA : Math.max(0, bien - anterior) * XP_PREGUNTA;
    guardarHecha(L.id, bien);
    guardarHechaCuenta(L.id, bien);
    try { await sumarXP(xp); } catch { /* si falla, igual mostramos el resultado */ }
    const idx = LECTURAS.indexOf(L), siguiente = LECTURAS[idx + 1];
    document.getElementById("l-final").innerHTML = `
      <div class="card flash" style="margin-top:12px">
        <div class="big">${bien === total ? "🎉 ¡Entendiste todo!" : "💪 ¡Bien!"}</div>
        <p><b>${bien}/${total}</b> correctas · <b>+${xp} XP</b>${anterior !== undefined && xp === 0 ? " (ya la habías hecho)" : ""}</p>
        <p class="muted">Consejo: vuelve a escucharla mañana sin leer. Si la entiendes toda, ¡ese es tu progreso!</p>
        <div class="row">
          <a class="btn alt" href="#/ingles/lecturas">Más historias</a>
          ${siguiente ? `<a class="btn" href="#/ingles/lectura/${siguiente.id}">Siguiente: ${esc(siguiente.titulo)}</a>` : `<a class="btn" href="#/ingles">Seguir</a>`}
        </div>
      </div>`;
  };
}
