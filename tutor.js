// ============================================================
// 💬 Tutor IA (pata de OUTPUT) + ficha "Mi vida"
// Habla con la función secreta /api/tutor (la clave de OpenAI está en Vercel).
// Usa funciones de app.js y lecciones.js (db, pintar, esc, btnVoz, fraseTocable, hablar, VEL, datosLecciones).
// ============================================================
const XP_TUTOR = 2; // XP por mensaje enviado al tutor

const MODOS_TUTOR = {
  clase: { icono: "📘", nombre: "Clase", desc: "Te explica un tema con ejemplos de tu vida y te pone a practicar." },
  rol: { icono: "🎭", nombre: "Juego de rol", desc: "Practica una situación del episodio: tú hablas, el tutor actúa." },
  libre: { icono: "💬", nombre: "Conversación libre", desc: "La pregunta del día: hablas de tu día y te va corrigiendo." },
  traducir: { icono: "🔁", nombre: "¿Cómo digo esto?", desc: "Escribe en español lo que quieres decir y te lo pasa a inglés." }
};

const TEMAS_CLASE = {
  1: ["to be (am/is/are)", "a / an", "his / her", "profesiones y clima", "adjetivos y partes del cuerpo", "comparativos y superlativos"],
  2: ["la -s con he/she/it", "do / does", "plurales irregulares", "la hora"],
  3: ["would like", "can / could", "may / might", "and, but, so, because", "question words", "whose"],
  4: ["pasado simple regular", "pasado simple irregular", "días de la semana"],
  5: ["there is / there are", "this, that, these, those", "neither / either / both"],
  6: ["some / any", "contables e incontables", "too / enough", "adverbios de frecuencia"],
  7: ["preposiciones", "my / mine, your / yours", "adverbios"]
};
const ESCENARIOS = {
  1: ["Conocer a alguien nuevo", "Describir a un amigo"],
  2: ["Contar tu rutina a un compañero", "Preguntar la hora en el aeropuerto"],
  3: ["Pedir un taxi al aeropuerto", "Llamar a un amigo para invitarlo al cine", "Encontrar un objeto perdido (whose?)"],
  4: ["Registrarte en un hotel", "Llamada formal a una oficina"],
  5: ["Primer día en una oficina", "Pedir ayuda con el computador"],
  6: ["Reservar una mesa en un restaurante", "Hacer el mercado"],
  7: ["En un bar con amigos", "Explicar dónde están las cosas en tu casa"]
};

const sesionTutor = { modo: null, episodio: 3, escenario: "", mensajes: [], usados: 0, limite: 60 };

async function episodioActual() {
  try { const d = await datosLecciones(); return d.siguiente?.episodio || 3; } catch { return 3; }
}

// ---------- pantalla de inicio del tutor ----------
async function vistaTutor() {
  pintar(`<p class="muted">Abriendo el tutor…</p>`);
  const ep = sesionTutor.episodio = sesionTutor.mensajes.length ? sesionTutor.episodio : await episodioActual();
  pintar(`
    <a href="#/ingles" class="link">← Inglés</a>
    <h1>💬 Tutor</h1>
    <p class="muted">Practica escribiendo. Te corrige con la traducción y una explicación corta.</p>
    <div class="row" style="justify-content:flex-start;margin:10px 0">
      <label class="muted">Episodio:
        <select id="t-ep">${[1, 2, 3, 4, 5, 6, 7].map((n) => `<option ${n === ep ? "selected" : ""}>${n}</option>`).join("")}</select>
      </label>
      <a class="btn alt" href="#/ingles/mi-vida">📝 Mi vida</a>
    </div>
    <div class="grid" id="t-modos">
      ${Object.entries(MODOS_TUTOR).map(([k, m]) => `
        <button class="card t-modo" data-modo="${k}">
          <div style="font-size:1.6rem">${m.icono}</div><b>${m.nombre}</b><div class="muted">${m.desc}</div>
        </button>`).join("")}
    </div>
    ${sesionTutor.mensajes.length ? `<div class="row" style="justify-content:flex-start;margin-top:14px">
      <button class="btn" id="t-volver">↩ Volver a la conversación</button></div>` : ""}
    <div id="t-sub"></div>`);
  const tv = document.getElementById("t-volver"); if (tv) tv.onclick = pintarChat;
  document.getElementById("t-ep").onchange = (e) => { sesionTutor.episodio = Number(e.target.value); document.getElementById("t-sub").innerHTML = ""; };
  app.querySelectorAll("[data-modo]").forEach((b) => (b.onclick = () => elegirModo(b.dataset.modo)));
}

function elegirModo(modo) {
  const ep = sesionTutor.episodio;
  const sub = document.getElementById("t-sub");
  if (modo === "clase" || modo === "rol") {
    const lista = modo === "clase" ? TEMAS_CLASE[ep] : ESCENARIOS[ep];
    sub.innerHTML = `<div class="card" style="margin-top:14px">
      <div class="sec">${modo === "clase" ? "¿Qué tema quieres?" : "Elige la situación"}</div>
      <div class="opciones">${lista.map((t, i) => `<button class="opcion" data-sub="${i}">${esc(t)}</button>`).join("")}</div></div>`;
    sub.querySelectorAll("[data-sub]").forEach((b) => (b.onclick = () => {
      const t = lista[Number(b.dataset.sub)];
      empezarChat(modo, modo === "rol" ? t : "", modo === "clase" ? `Quiero una clase corta sobre: ${t}` : "");
    }));
    sub.scrollIntoView({ behavior: "smooth" });
  } else empezarChat(modo, "", "");
}

function empezarChat(modo, escenario, primerMensaje) {
  Object.assign(sesionTutor, { modo, escenario, mensajes: [] });
  pintarChat();
  if (modo === "traducir") return; // aquí empieza él escribiendo
  enviarAlTutor(primerMensaje, { oculto: !primerMensaje });
}

// ---------- chat ----------
function htmlRespuesta(r) {
  const corr = r.correccion ? `
    <div class="t-corr">
      <div>✏️ <b>${esc(r.correccion)}</b> ${btnVoz(r.correccion)}</div>
      ${r.correccion_es ? `<div class="muted">🇪🇸 ${esc(r.correccion_es)}</div>` : ""}
      ${r.explicacion ? `<div>💡 ${esc(r.explicacion)}</div>` : ""}
    </div>` : (r.explicacion ? `<div class="t-corr"><div>💡 ${esc(r.explicacion)}</div></div>` : "");
  return `${corr}
    ${r.nota ? `<div class="t-nota">${esc(r.nota).replace(/\n/g, "<br>")}</div>` : ""}
    ${r.mensaje ? `<div class="t-msg">👉 ${fraseTocable(r.mensaje)} ${btnVoz(r.mensaje)}</div>
      ${r.mensaje_es ? `<div class="muted">🇪🇸 ${esc(r.mensaje_es)}</div>` : ""}` : ""}`;
}

function pintarChat() {
  const m = MODOS_TUTOR[sesionTutor.modo];
  const burbujas = sesionTutor.mensajes.filter((x) => !x.oculto).map((x) => x.role === "user"
    ? `<div class="t-yo">${esc(x.content)}</div>`
    : `<div class="t-ia">${x.bien && sesionTutor.modo !== "traducir" && x.tras ? `<div class="t-ok">✅ ¡Bien dicho!</div>` : ""}${htmlRespuesta(x.r)}</div>`).join("");
  pintar(`
    <div class="lec-top">
      <a href="#/ingles/tutor" class="link" id="t-menu">← Modos</a>
      <span class="muted" style="flex:1;text-align:right">${m.icono} ${m.nombre}${sesionTutor.escenario ? " · " + esc(sesionTutor.escenario) : ""} · Ep ${sesionTutor.episodio}</span>
    </div>
    <div class="t-chat" id="t-chat">
      ${burbujas || (sesionTutor.modo === "traducir"
        ? `<div class="t-ia"><div class="t-msg">Escribe en <b>español</b> lo que quieres decir (por ejemplo, un mensaje para un cliente) y te muestro cómo se dice en inglés.</div></div>` : "")}
      <div id="t-pensando" class="muted" hidden>El tutor está escribiendo…</div>
    </div>
    <p class="error" id="t-err"></p>
    <div class="t-caja">
      <textarea id="t-in" rows="2" placeholder="${sesionTutor.modo === "traducir" ? "Escribe en español…" : "Write in English…"}"></textarea>
      <button class="btn" id="t-env">Enviar</button>
    </div>
    <div class="muted pista-palabra">👆 Toca una palabra para oírla · ${sesionTutor.usados}/${sesionTutor.limite} mensajes hoy</div>`);
  document.getElementById("t-menu").onclick = (e) => { e.preventDefault(); vistaTutor(); };
  const inp = document.getElementById("t-in");
  document.getElementById("t-env").onclick = () => { const v = inp.value.trim(); if (v) enviarAlTutor(v); };
  inp.onkeydown = (e) => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); document.getElementById("t-env").click(); } };
  const chat = document.getElementById("t-chat");
  chat.lastElementChild?.previousElementSibling?.scrollIntoView({ block: "start" });
}

async function enviarAlTutor(texto, { oculto = false } = {}) {
  if (texto) sesionTutor.mensajes.push({ role: "user", content: texto, oculto });
  pintarChat();
  document.getElementById("t-pensando").hidden = false;
  document.getElementById("t-env").disabled = true;
  try {
    const { data } = await db.auth.getSession();
    const r = await fetch("/api/tutor", {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${data.session?.access_token || ""}` },
      body: JSON.stringify({
        modo: sesionTutor.modo, episodio: sesionTutor.episodio, escenario: sesionTutor.escenario,
        mensajes: sesionTutor.mensajes.map((x) => ({ role: x.role, content: x.role === "user" ? x.content : JSON.stringify(x.r) }))
      })
    });
    const j = await r.json().catch(() => ({}));
    if (!r.ok) {
      if (j.codigo === "falta_sql") return pintar(`<a href="#/ingles" class="link">← Inglés</a>
        <div class="card" style="margin-top:16px"><h2>Falta un paso en Supabase</h2>
        <p class="muted">Para activar el tutor, abre Supabase → <b>SQL Editor</b>, pega el archivo <code>db/003_tutor.sql</code> completo y dale <b>Run</b>.</p></div>`);
      if (texto && !oculto) { sesionTutor.mensajes.pop(); pintarChat(); document.getElementById("t-in").value = texto; }
      document.getElementById("t-err").textContent = j.error || "El tutor no pudo responder. Revisa tu internet e intenta de nuevo.";
      return;
    }
    sesionTutor.usados = j.usados; sesionTutor.limite = j.limite;
    const ultimoYo = [...sesionTutor.mensajes].reverse().find((x) => x.role === "user" && !x.oculto);
    sesionTutor.mensajes.push({ role: "assistant", r: j.respuesta, bien: j.respuesta.bien, tras: !!(texto && !oculto && ultimoYo) });
    pintarChat();
    if (texto && !oculto) { try { await sumarXP(XP_TUTOR); } catch {} }
  } catch (e) {
    document.getElementById("t-err").textContent = "Sin conexión con el tutor. Intenta de nuevo.";
  } finally {
    const b = document.getElementById("t-env"); if (b) b.disabled = false;
    const p = document.getElementById("t-pensando"); if (p) p.hidden = true;
  }
}

// ---------- ficha "Mi vida" ----------
async function vistaMiVida() {
  pintar(`<p class="muted">Cargando…</p>`);
  const { data, error } = await db.from("mi_vida").select("texto").maybeSingle();
  if (error && faltaSQL(error)) return pintar(`<a href="#/ingles/tutor" class="link">← Tutor</a>
    <div class="card" style="margin-top:16px"><h2>Falta un paso en Supabase</h2>
    <p class="muted">Abre Supabase → <b>SQL Editor</b>, pega el archivo <code>db/003_tutor.sql</code> completo y dale <b>Run</b>.</p></div>`);
  pintar(`
    <a href="#/ingles/tutor" class="link">← Tutor</a>
    <h1>📝 Mi vida</h1>
    <p class="muted">Lo que escribas aquí lo usa el tutor para darte ejemplos de tu vida real. Escribe en español o en inglés,
      solo lo que quieras compartir. Puedes cambiarlo cuando quieras.</p>
    <textarea id="mv" rows="9" placeholder="Ej.: A qué te dedicas, tu rutina, tu familia, qué estudias, qué te gusta hacer…">${esc(data?.texto || "")}</textarea>
    <p class="error" id="mv-err"></p>
    <div class="row" style="justify-content:flex-end"><button class="btn" id="mv-g">Guardar</button></div>`);
  document.getElementById("mv-g").onclick = async (e) => {
    e.target.disabled = true;
    const user = await usuarioActual();
    const { error: er } = await db.from("mi_vida").upsert({ user_id: user.id, texto: document.getElementById("mv").value.slice(0, 1500), actualizado: new Date().toISOString() });
    e.target.disabled = false;
    document.getElementById("mv-err").textContent = er ? "No se pudo guardar: " + er.message : "";
    if (!er) { e.target.textContent = "✓ Guardado"; setTimeout(() => (location.hash = "/ingles/tutor"), 700); }
  };
}
