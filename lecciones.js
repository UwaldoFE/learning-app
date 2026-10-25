// ============================================================
// Lecciones tipo Duolingo: ejercicios, XP, racha y "Mis errores"
// Usa funciones de app.js (db, pintar, esc, hablar, errorBox, usuarioActual).
// ============================================================
const META_XP = 50;          // meta diaria de XP
const XP_PRIMERA = 10;       // XP por acertar al primer intento
const XP_SEGUNDA = 5;        // XP por acertar un ejercicio que se repitió

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
const decir = (t) => { try { hablar(t); } catch (e) { /* sin voz */ } };

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

async function guardarResultado({ user, leccionId, xp, precision, fallados, acertados, modoErrores }) {
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
  if (modoErrores && acertados.length) {
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
  const siguiente = l.data.find((x) => !mias[x.id] || mias[x.id].mejor_precision < 80) || null;
  return { lecciones: l.data, mias, errores: err.data.length, ...est, siguiente };
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
      ${d.siguiente ? `
        <a class="btn grande" href="#/ingles/leccion/${d.siguiente.id}">
          ▶ ${d.mias[d.siguiente.id] ? "Repetir" : "Continuar"}: ${esc(d.siguiente.titulo)}</a>` : `
        <p class="muted">¡Completaste todas las lecciones cargadas! 🎉</p>`}
      <div class="row" style="justify-content:flex-start">
        ${d.errores ? `<a class="btn alt" href="#/ingles/errores">🎯 Mis errores (${d.errores})</a>` : ""}
        <a class="btn alt" href="#/ingles/repaso">🃏 Tarjetas (${tarjetasPendientes})</a>
      </div>
    </div>`;
}

function htmlLeccionesDe(episodio, d) {
  const ls = d.lecciones.filter((x) => x.episodio === episodio);
  if (!ls.length) return "";
  const icono = { refuerzo: "🔧", tema: "📘", simulacro: "📝" };
  return `<div class="lecciones">${ls.map((x) => {
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

// ---------- reproductor de la lección ----------
async function vistaLeccion(leccionId) {
  const modoErrores = leccionId === "errores";
  pintar(`<p class="muted">Preparando la lección…</p>`);
  const user = await usuarioActual();
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
    if (!l.data) return pintar(`<a href="#/ingles" class="link">← Inglés</a><p>No encontré esa lección.</p>`);
    titulo = l.data.titulo;
    ejercicios = e.data;
  }
  if (!ejercicios.length) return pintar(`
    <a href="#/ingles" class="link">← Inglés</a>
    <div class="card flash" style="margin-top:16px"><div class="big">✅ Nada pendiente</div>
    <p class="muted">No tienes errores por repasar. ¡Bien!</p></div>`);

  const total = ejercicios.length;
  const cola = [...ejercicios];
  const primerIntento = {};            // id → true/false
  const yaRepetido = new Set();
  let xp = 0, combo = 0, hechos = 0;
  let actual, estado, comprobado;

  const sig = () => {
    if (!cola.length) return final();
    actual = cola.shift();
    estado = {}; comprobado = false;
    pintarEjercicio();
  };

  function cabecera() {
    const pct = Math.round((hechos / total) * 100);
    return `
      <div class="lec-top">
        <a href="#/ingles" class="link" title="Salir">✕</a>
        <div class="barra" style="flex:1"><i style="width:${pct}%"></i></div>
        <span class="muted">${combo >= 3 ? `🔥${combo} · ` : ""}${xp} XP</span>
      </div>
      <div class="sec" style="margin-top:8px">${esc(titulo)}</div>`;
  }

  function pintarEjercicio() {
    const d = actual.datos, t = actual.tipo;
    const etiquetas = { elegir: "Elige la correcta", escuchar: "Escucha y elige", ordenar: "Ordena la frase",
      escribir: "Escríbelo en inglés", emparejar: "Une cada pareja" };
    let cuerpo = "";
    if (t === "elegir") {
      cuerpo = `<div class="lec-frase">${esc(d.frase)} ${d.pista ? `<span class="muted">${esc(d.pista)}</span>` : ""}</div>
        ${d.es ? `<div class="muted">${esc(d.es)}</div>` : ""}
        <div class="opciones">${d.opciones.map((o, i) => `<button class="opcion" data-op="${i}">${esc(o)}</button>`).join("")}</div>`;
    } else if (t === "escuchar") {
      cuerpo = `<button class="btn alt" id="b-oir">🔊 Escuchar otra vez</button>
        <div class="opciones">${d.opciones.map((o, i) => `<button class="opcion" data-op="${i}">${esc(o)}</button>`).join("")}</div>`;
    } else if (t === "ordenar") {
      const palabras = d.frase.split(" ");
      let fichas = mezclar(palabras);
      for (let k = 0; k < 5 && fichas.join(" ") === d.frase; k++) fichas = mezclar(palabras);
      estado.elegidas = [];
      cuerpo = `<div class="lec-frase">${esc(d.es)}</div>
        <div class="linea" id="linea"></div>
        <div id="banco">${fichas.map((w, i) => `<button class="ficha" data-f="${i}">${esc(w)}</button>`).join("")}</div>`;
      estado.fichas = fichas;
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
        <div class="muted lec-tipo">${etiquetas[t]}</div>
        ${cuerpo}
        <p class="error" id="lec-err"></p>
        <div id="lec-fb"></div>
        <div class="row" style="justify-content:flex-end">
          <button class="btn" id="b-go" ${t === "emparejar" ? "hidden" : ""}>Comprobar</button>
        </div>
      </div>`);
    conectar();
  }

  function conectar() {
    const d = actual.datos, t = actual.tipo;
    const err = (m) => (document.getElementById("lec-err").textContent = m);
    const go = document.getElementById("b-go");
    go.onclick = () => (comprobado ? sig() : comprobar());

    if (t === "elegir" || t === "escuchar") {
      app.querySelectorAll("[data-op]").forEach((b) => (b.onclick = () => {
        if (comprobado) return;
        app.querySelectorAll("[data-op]").forEach((x) => x.classList.remove("sel"));
        b.classList.add("sel"); estado.sel = Number(b.dataset.op); err("");
      }));
      if (t === "escuchar") {
        document.getElementById("b-oir").onclick = () => decir(d.audio);
        setTimeout(() => decir(d.audio), 300);
      }
    } else if (t === "ordenar") {
      const linea = document.getElementById("linea");
      app.querySelectorAll("[data-f]").forEach((b) => (b.onclick = () => {
        if (comprobado || b.classList.contains("usada")) return;
        b.classList.add("usada");
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

  function comprobar() {
    const d = actual.datos, t = actual.tipo;
    const err = (m) => (document.getElementById("lec-err").textContent = m);
    let ok, correcta, ortografia = false, ingles = "";
    if (t === "elegir" || t === "escuchar") {
      if (estado.sel === undefined) return err("Elige una opción primero.");
      ok = estado.sel === d.correcta;
      correcta = d.opciones[d.correcta];
      app.querySelectorAll("[data-op]").forEach((b) => {
        const i = Number(b.dataset.op);
        b.classList.remove("sel");
        if (i === d.correcta) b.classList.add("bien");
        else if (i === estado.sel) b.classList.add("mal");
      });
      ingles = t === "escuchar" ? d.audio : (d.frase.startsWith("¿") ? "" : d.frase.replace("___", correcta));
    } else if (t === "ordenar") {
      if (!estado.elegidas.length) return err("Toca las palabras para armar la frase.");
      ok = estado.elegidas.join(" ") === d.frase;
      correcta = ingles = d.frase.replace(/ ([?.!,])/g, "$1");
    } else if (t === "escribir") {
      const v = normalizar(document.getElementById("resp").value);
      if (!v) return err("Escribe tu respuesta primero.");
      const opciones = d.respuestas.map(normalizar);
      ok = opciones.includes(v);
      if (!ok && v.length > 8 && opciones.some((r) => distancia(v, r) <= 1)) { ok = true; ortografia = true; }
      correcta = ingles = d.mostrar;
    } else if (t === "emparejar") {
      ok = estado.fallos === 0;
      correcta = d.pares.map((p) => `${p[0]} = ${p[1]}`).join(" · ");
    }
    comprobado = true;
    const primera = !(actual.id in primerIntento);
    if (primera) primerIntento[actual.id] = ok;
    if (ok) {
      combo++; hechos++;
      xp += primera ? XP_PRIMERA : XP_SEGUNDA;
    } else {
      combo = 0;
      if (!yaRepetido.has(actual.id)) { yaRepetido.add(actual.id); cola.push(actual); } else hechos++;
    }
    if (ingles) decir(ingles);
    document.getElementById("lec-fb").innerHTML = `
      <div class="fb ${ok ? "fb-ok" : "fb-mal"}">
        <b>${ok ? (ortografia ? "¡Bien! Ojo con la ortografía." : "¡Correcto!") : "Casi. La respuesta es:"}</b>
        ${!ok || ortografia ? `<div class="fb-resp">${esc(correcta)}</div>` : ""}
        ${ingles ? `<div>${btnVoz(ingles)} <span>${esc(ingles)}</span></div>` : ""}
        ${d.es && t !== "escribir" && t !== "ordenar" ? `<div class="muted">🇪🇸 ${esc(d.es)}</div>` : ""}
        <div class="fb-ex">💡 ${esc(d.explicacion)}</div>
        ${!ok && cola.includes(actual) ? `<div class="muted">Este ejercicio volverá al final de la lección.</div>` : ""}
      </div>`;
    const go = document.getElementById("b-go");
    go.hidden = false; go.textContent = "Continuar"; go.focus();
  }

  async function final() {
    const ids = Object.keys(primerIntento);
    const bien = ids.filter((id) => primerIntento[id]).length;
    const precision = Math.round((bien / total) * 100);
    const fallados = ids.filter((id) => !primerIntento[id]);
    pintar(`<p class="muted">Guardando…</p>`);
    try {
      await guardarResultado({ user, leccionId, xp, precision, fallados, acertados: ids.filter((id) => primerIntento[id]), modoErrores });
    } catch (e) { /* si falla el guardado, igual mostramos el resultado */ }
    let est = { xpHoy: xp, racha: 1 };
    try { est = await resumenEstudio(); } catch {}
    const metaOk = est.xpHoy >= META_XP;
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
          ${!modoErrores ? `<a class="btn alt" href="#/ingles/leccion/${leccionId}" onclick="setTimeout(router,0)">Repetir</a>` : ""}
          <a class="btn" href="#/ingles">Seguir</a>
        </div>
      </div>`);
  }

  sig();
}
