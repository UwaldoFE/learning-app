// ============================================================
// Dibujos propios (SVG) para las tarjetas "Mira el dibujo y dilo en inglés".
// Hechos a mano para esta app: formas simples, contorno morado oscuro y colores de la app.
// Se pueden reutilizar en el perfil para niños.
// Cada dibujo: lienzo de 100×100. dibujoSVG("shoes") devuelve el <svg> listo.
// ============================================================
const D_O = "#2b2366";      // contorno
const D_PIEL = "#f6c7a4";
const D_PIEL2 = "#e9a882";

// Carro reutilizable (taxi y car)
const dCarro = (color, extra = "") => `
  <path d="M10 68 V56 C10 51 14 49 19 48 L31 35 C33 33 36 32 40 32 H61 C65 32 68 33 70 36 L80 48 C86 49 90 52 90 57 V68 Z" fill="${color}"/>
  <path d="M34 47 L41 38 H50 V47 Z M55 47 V38 H62 C64 38 65 39 66 40 L72 47 Z" fill="#bfe6ff"/>
  ${extra}
  <circle cx="30" cy="69" r="9" fill="#3b3550"/><circle cx="30" cy="69" r="3.5" fill="#d9d6e8"/>
  <circle cx="71" cy="69" r="9" fill="#3b3550"/><circle cx="71" cy="69" r="3.5" fill="#d9d6e8"/>
  <path d="M84 56 h5 M11 58 h5" stroke="#ffc93c"/>`;
// Taza reutilizable (coffee y tea)
const dTaza = (liquido, extra = "") => `
  <path d="M22 40 H70 V66 C70 76 62 82 52 82 H40 C30 82 22 76 22 66 Z" fill="#ffffff"/>
  <path d="M70 46 C82 46 84 64 70 66" fill="none" stroke-width="5"/>
  <ellipse cx="46" cy="42" rx="22" ry="4" fill="${liquido}"/>
  <path d="M16 84 H76" stroke-width="4"/>
  ${extra}`;

const DIBUJOS = {
  // ---------- el clima ----------
  sun: `<circle cx="50" cy="50" r="17" fill="#ffc93c"/>
    <g stroke="#ff9a1f" stroke-width="5">${[0, 45, 90, 135, 180, 225, 270, 315].map((a) => {
      const r = (a * Math.PI) / 180, c = Math.cos(r), s = Math.sin(r);
      return `<path d="M${(50 + 25 * c).toFixed(1)} ${(50 + 25 * s).toFixed(1)} L${(50 + 36 * c).toFixed(1)} ${(50 + 36 * s).toFixed(1)}"/>`;
    }).join("")}</g>`,
  cloud: `<path d="M26 72 H72 A14 14 0 0 0 74 44 A19 19 0 0 0 39 36 A15 15 0 0 0 26 72 Z" fill="#ffffff"/>`,
  rain: `<path d="M26 56 H72 A14 14 0 0 0 74 28 A19 19 0 0 0 39 20 A15 15 0 0 0 26 56 Z" fill="#dfe7f5"/>
    <g fill="#38bdf8">${[[34, 64], [50, 70], [66, 64], [42, 82], [58, 84]].map(([x, y]) => `<path d="M${x} ${y} q-5 8 0 10 q5 -2 0 -10z"/>`).join("")}</g>`,
  snow: `<g stroke="#38bdf8" stroke-width="5">
      <path d="M50 16 V84 M20.6 33 L79.4 67 M20.6 67 L79.4 33"/>
      <path d="M42 22 L50 30 L58 22 M42 78 L50 70 L58 78 M24 42 L31 46 L25 54 M76 58 L69 54 L75 46 M24 58 L31 54 L25 46 M76 42 L69 46 L75 54" fill="none"/></g>`,
  umbrella: `<path d="M14 50 A36 32 0 0 1 86 50 Q77 44 68 50 Q59 44 50 50 Q41 44 32 50 Q23 44 14 50 Z" fill="#ff5fa2"/>
    <path d="M50 18 V12 M50 50 V78 Q50 86 42 86 Q36 86 36 80" fill="none" stroke-width="4"/>`,

  // ---------- el cuerpo ----------
  eye: `<path d="M12 50 Q50 16 88 50 Q50 84 12 50 Z" fill="#ffffff"/>
    <circle cx="50" cy="50" r="15" fill="#5b8def"/><circle cx="50" cy="50" r="7" fill="${D_O}"/>
    <circle cx="45" cy="45" r="3" fill="#ffffff" stroke="none"/>`,
  nose: `<path d="M50 18 C47 36 37 52 34 62 C32 72 42 76 50 71 C58 76 68 72 66 62 C63 52 53 36 50 18 Z" fill="${D_PIEL}"/>
    <ellipse cx="43" cy="64" rx="4" ry="2.5" fill="${D_O}"/><ellipse cx="57" cy="64" rx="4" ry="2.5" fill="${D_O}"/>`,
  mouth: `<path d="M14 50 Q32 30 50 42 Q68 30 86 50 Q50 56 14 50 Z" fill="#f0475c"/>
    <path d="M14 50 Q50 56 86 50 Q68 78 50 76 Q32 78 14 50 Z" fill="#ff7d8e"/>`,
  ear: `<path d="M40 18 C70 12 84 40 70 60 C63 70 62 82 49 84 C38 86 34 76 40 70 C46 64 40 60 36 54 C30 44 28 22 40 18 Z" fill="${D_PIEL}"/>
    <path d="M48 32 C62 30 66 44 58 52 C54 56 52 60 54 66" fill="none" stroke="${D_PIEL2}" stroke-width="4"/>`,
  hand: `<g fill="${D_PIEL}">
      <rect x="29" y="22" width="10" height="36" rx="5"/><rect x="40" y="13" width="10" height="44" rx="5"/>
      <rect x="51" y="15" width="10" height="42" rx="5"/><rect x="62" y="24" width="10" height="34" rx="5"/>
      <rect x="14" y="50" width="10" height="28" rx="5" transform="rotate(-42 19 64)"/>
      <path d="M28 48 H73 V72 C73 82 66 88 56 88 H44 C34 88 28 82 28 72 Z"/></g>`,
  foot: `<path d="M28 14 H50 V60 C64 62 84 66 84 78 C84 85 78 87 70 87 H34 C27 87 24 83 24 76 Z" fill="${D_PIEL}"/>
    <g fill="${D_PIEL}"><circle cx="78" cy="70" r="0"/></g>`,
  tooth: `<path d="M28 28 C28 16 42 14 50 21 C58 14 72 16 72 28 C72 46 67 58 63 79 C61 86 54 85 53 78 L51 62 C50.5 57 49.5 57 49 62 L47 78 C46 85 39 86 37 79 C33 58 28 46 28 28 Z" fill="#ffffff"/>
    <path d="M38 26 Q42 22 46 25" fill="none" stroke="#c9c3ea"/>`,

  // ---------- la casa y la rutina ----------
  bed: `<rect x="12" y="30" width="10" height="52" rx="3" fill="#a0673b"/>
    <rect x="20" y="54" width="70" height="16" rx="3" fill="#ffffff"/>
    <rect x="42" y="49" width="48" height="21" rx="4" fill="#5b8def"/>
    <ellipse cx="33" cy="50" rx="10" ry="6" fill="#ffffff"/>
    <path d="M24 70 V82 M86 70 V82" stroke-width="5"/>`,
  shower: `<path d="M24 90 V22 Q24 16 30 16 H58 V28" fill="none" stroke="#9aa3b8" stroke-width="6"/>
    <path d="M46 28 H70 L66 38 H50 Z" fill="#c4cad8"/>
    <g stroke="#38bdf8" stroke-width="3.5"><path d="M52 46 L48 56 M58 46 V58 M64 46 L68 56 M50 64 L46 74 M58 64 V78 M66 64 L70 74"/></g>`,
  toothbrush: `<g transform="rotate(-35 50 50)">
      <rect x="6" y="50" width="66" height="10" rx="5" fill="#38bdf8"/>
      <rect x="64" y="38" width="26" height="12" rx="3" fill="#ffffff"/>
      <path d="M68 38 V50 M74 38 V50 M80 38 V50 M86 38 V50" stroke="#c9c3ea" stroke-width="2"/>
      <path d="M64 50 H90 V54 C90 56 88 58 86 58 H64 Z" fill="#38bdf8"/>
      <path d="M66 38 C66 30 76 28 78 33 C82 26 92 30 88 38 Z" fill="#7ee0c3"/></g>`,
  clock: `<circle cx="50" cy="50" r="35" fill="#ffffff" stroke="#ff9a1f" stroke-width="7"/>
    <path d="M50 22 V27 M78 50 H73 M50 78 V73 M22 50 H27" stroke-width="3"/>
    <path d="M50 50 V32 M50 50 L64 58" stroke-width="5"/><circle cx="50" cy="50" r="4" fill="${D_O}"/>`,
  airplane: `<g transform="rotate(40 50 50)">
      <rect x="44" y="10" width="12" height="80" rx="6" fill="#e8ecf7"/>
      <path d="M50 38 L12 58 V65 L50 56 L88 65 V58 Z" fill="#6c4cf5"/>
      <path d="M50 76 L35 86 V90 L50 86 L65 90 V86 Z" fill="#6c4cf5"/>
      <path d="M47 16 Q50 12 53 16 V22 H47 Z" fill="#bfe6ff"/></g>`,
  suitcase: `<path d="M38 34 V24 Q38 20 42 20 H58 Q62 20 62 24 V34" fill="none" stroke-width="5"/>
    <rect x="16" y="34" width="68" height="48" rx="8" fill="#ff9a1f"/>
    <path d="M34 34 V82 M66 34 V82" stroke="#c2620a" stroke-width="4"/>
    <circle cx="28" cy="86" r="4" fill="${D_O}"/><circle cx="72" cy="86" r="4" fill="${D_O}"/>`,
  passport: `<rect x="25" y="12" width="50" height="76" rx="6" fill="#2f5bd3"/>
    <circle cx="50" cy="44" r="12" fill="none" stroke="#ffc93c" stroke-width="3"/>
    <path d="M38 44 H62 M50 32 C44 38 44 50 50 56 C56 50 56 38 50 32" fill="none" stroke="#ffc93c" stroke-width="2"/>
    <rect x="36" y="66" width="28" height="4" rx="2" fill="#ffc93c" stroke="none"/>
    <rect x="40" y="74" width="20" height="3" rx="1.5" fill="#ffc93c" stroke="none"/>`,

  // ---------- la calle y el teléfono ----------
  taxi: dCarro("#ffc93c", `<rect x="42" y="23" width="18" height="9" rx="2" fill="#ffffff"/>
    <path d="M14 58 H86" stroke="none"/>
    <g stroke="none" fill="${D_O}">${[16, 28, 40, 52, 64, 76].map((x) => `<rect x="${x}" y="55" width="6" height="5"/>`).join("")}</g>`),
  car: dCarro("#f0475c"),
  tire: `<circle cx="50" cy="50" r="36" fill="#3b3550"/>
    <circle cx="50" cy="50" r="20" fill="#d9d6e8"/><circle cx="50" cy="50" r="6" fill="#9aa3b8"/>
    <path d="M50 30 V44 M50 56 V70 M30 50 H44 M56 50 H70" stroke="#9aa3b8" stroke-width="4"/>
    <g stroke="#5c5574" stroke-width="3">${[0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330].map((a) => {
      const r = (a * Math.PI) / 180;
      return `<path d="M${(50 + 29 * Math.cos(r)).toFixed(1)} ${(50 + 29 * Math.sin(r)).toFixed(1)} L${(50 + 34 * Math.cos(r)).toFixed(1)} ${(50 + 34 * Math.sin(r)).toFixed(1)}"/>`;
    }).join("")}</g>`,
  phone: `<rect x="29" y="10" width="42" height="80" rx="9" fill="${D_O}"/>
    <rect x="34" y="19" width="32" height="58" rx="3" fill="#8fd3ff" stroke="none"/>
    <circle cx="50" cy="83" r="3" fill="#ffffff" stroke="none"/>
    <path d="M44 14 H56" stroke="#ffffff" stroke-width="2"/>`,

  // ---------- la oficina ----------
  computer: `<rect x="12" y="14" width="76" height="52" rx="5" fill="${D_O}"/>
    <rect x="17" y="19" width="66" height="42" rx="2" fill="#8fd3ff" stroke="none"/>
    <path d="M44 66 L40 80 H60 L56 66" fill="#c4cad8"/><rect x="30" y="80" width="40" height="6" rx="3" fill="#c4cad8"/>`,
  keyboard: `<rect x="8" y="32" width="84" height="38" rx="6" fill="#c4cad8"/>
    <g fill="#ffffff" stroke-width="1.5">${[0, 1, 2].map((f) => [0, 1, 2, 3, 4, 5, 6, 7, 8].map((c) => `<rect x="${14 + c * 8.3}" y="${37 + f * 8}" width="6" height="6" rx="1"/>`).join("")).join("")}
    <rect x="28" y="61" width="44" height="5" rx="1.5"/></g>`,
  printer: `<rect x="30" y="16" width="40" height="26" fill="#ffffff"/>
    <rect x="14" y="38" width="72" height="32" rx="6" fill="#9aa3b8"/>
    <rect x="28" y="62" width="44" height="24" fill="#ffffff"/>
    <path d="M34 70 H66 M34 77 H58" stroke="#c9c3ea" stroke-width="3"/>
    <circle cx="76" cy="46" r="3" fill="#22c55e" stroke="none"/>`,
  chair: `<rect x="28" y="12" width="44" height="38" rx="6" fill="#ff9a1f"/>
    <rect x="22" y="48" width="56" height="11" rx="4" fill="#ffb24d"/>
    <path d="M30 59 V88 M70 59 V88 M38 59 V80 M62 59 V80" stroke-width="5"/>`,
  pen: `<g transform="rotate(-45 50 50)">
      <rect x="44" y="6" width="12" height="70" rx="5" fill="#2f5bd3"/>
      <path d="M44 76 H56 L52 90 H48 Z" fill="#e8ecf7"/><path d="M49 88 L50 94 L51 88" fill="${D_O}"/>
      <path d="M56 12 H60 V40" fill="none" stroke-width="3"/></g>`,
  pencil: `<g transform="rotate(-45 50 50)">
      <rect x="43" y="16" width="14" height="58" fill="#ffc93c"/>
      <rect x="43" y="6" width="14" height="12" rx="3" fill="#ff7d8e"/>
      <rect x="43" y="16" width="14" height="5" fill="#c4cad8"/>
      <path d="M43 74 H57 L50 92 Z" fill="#f6d7b0"/><path d="M47.5 86 L50 92 L52.5 86 Z" fill="${D_O}"/>
      <path d="M50 21 V74" stroke="#e0a800" stroke-width="2"/></g>`,
  book: `<rect x="24" y="12" width="56" height="74" rx="4" fill="#22c55e"/>
    <rect x="24" y="12" width="11" height="74" rx="3" fill="#15924a"/>
    <rect x="34" y="78" width="46" height="8" fill="#ffffff"/>
    <rect x="44" y="26" width="26" height="14" rx="3" fill="#ffffff"/>`,
  backpack: `<path d="M40 22 Q40 12 50 12 Q60 12 60 22" fill="none" stroke-width="5"/>
    <path d="M22 40 Q22 22 50 22 Q78 22 78 40 V80 Q78 88 70 88 H30 Q22 88 22 80 Z" fill="#6c4cf5"/>
    <rect x="32" y="56" width="36" height="22" rx="6" fill="#8b72ff"/>
    <path d="M32 64 H68" stroke-width="2.5"/><circle cx="50" cy="40" r="3" fill="#ffc93c"/>`,

  // ---------- comida ----------
  apple: `<path d="M50 32 C38 22 16 26 18 52 C20 74 36 90 50 82 C64 90 80 74 82 52 C84 26 62 22 50 32 Z" fill="#f0475c"/>
    <path d="M50 32 C50 24 52 18 56 14" fill="none" stroke-width="4"/>
    <path d="M55 22 C62 12 74 14 76 18 C70 26 60 26 55 22 Z" fill="#22c55e"/>
    <path d="M30 46 Q32 38 38 36" fill="none" stroke="#ffffff" stroke-width="4"/>`,
  banana: `<path d="M20 30 C18 62 44 84 80 74 C84 73 84 68 80 68 C52 70 34 56 30 30 C29 24 21 24 20 30 Z" fill="#ffd84d"/>
    <path d="M19 30 L17 22 L24 21 L25 28" fill="#8a6b2e"/><path d="M80 68 L86 72" stroke-width="5"/>`,
  bread: `<path d="M14 60 C10 36 30 26 50 26 C70 26 90 36 86 60 L82 78 H18 Z" fill="#e7a35b"/>
    <path d="M34 36 L42 52 M50 33 L56 50 M66 36 L70 52" stroke="#b9732f" stroke-width="4"/>`,
  egg: `<path d="M50 12 C32 12 20 40 20 58 C20 76 33 88 50 88 C67 88 80 76 80 58 C80 40 68 12 50 12 Z" fill="#fff6e3"/>
    <path d="M34 40 Q36 30 42 26" fill="none" stroke="#ffffff" stroke-width="5"/>`,
  cheese: `<path d="M12 72 L22 38 L88 50 V72 Z" fill="#ffc93c"/><path d="M22 38 L88 50 L84 46 L28 34 Z" fill="#ffe28a"/>
    <g fill="#f0b400" stroke="none"><circle cx="36" cy="58" r="5"/><circle cx="58" cy="64" r="4"/><circle cx="72" cy="58" r="3"/><circle cx="48" cy="48" r="3"/></g>`,
  chicken: `<path d="M56 18 C78 14 92 36 80 54 C72 66 58 64 52 58 L40 70 Z" fill="#c7752b"/>
    <path d="M50 54 L34 70" stroke="#fff6e3" stroke-width="10"/>
    <circle cx="26" cy="72" r="7" fill="#fff6e3"/><circle cx="33" cy="80" r="7" fill="#fff6e3"/>
    <path d="M66 28 Q74 30 76 38" fill="none" stroke="#e59a52" stroke-width="4"/>`,
  fish: `<path d="M14 50 C28 26 62 26 74 50 C62 74 28 74 14 50 Z" fill="#38bdf8"/>
    <path d="M72 50 L90 34 V66 Z" fill="#38bdf8"/><circle cx="30" cy="46" r="4" fill="${D_O}"/>
    <path d="M44 38 Q50 50 44 62" fill="none" stroke="#1e8fc4" stroke-width="3"/>`,
  cake: `<rect x="20" y="52" width="60" height="30" rx="4" fill="#ff8fbd"/>
    <path d="M20 52 Q30 60 40 52 Q50 60 60 52 Q70 60 80 52 V48 H20 Z" fill="#ffffff"/>
    <rect x="47" y="30" width="6" height="18" fill="#38bdf8"/><path d="M50 22 Q55 27 50 30 Q45 27 50 22 Z" fill="#ffc93c"/>
    <path d="M14 84 H86" stroke-width="4"/>`,
  carrot: `<path d="M60 30 C70 34 74 44 66 52 L24 88 L38 40 C42 30 52 26 60 30 Z" fill="#ff9a1f"/>
    <path d="M40 54 L48 56 M34 70 L42 72" stroke="#c2620a" stroke-width="3"/>
    <path d="M60 30 C58 18 62 10 66 8 C66 18 64 24 62 30 M62 31 C70 20 80 18 86 20 C80 28 70 32 63 32" fill="#22c55e"/>`,
  tomato: `<circle cx="50" cy="56" r="32" fill="#f0475c"/>
    <path d="M50 28 L42 22 L46 32 L36 32 L46 36 L50 30 L54 36 L64 32 L54 32 L58 22 Z" fill="#22c55e"/>
    <path d="M30 50 Q32 42 38 40" fill="none" stroke="#ffffff" stroke-width="4"/>`,
  pizza: `<path d="M50 88 L16 22 Q50 8 84 22 Z" fill="#ffd27a"/>
    <path d="M16 22 Q50 8 84 22 L80 30 Q50 18 20 30 Z" fill="#e7a35b"/>
    <g fill="#f0475c"><circle cx="40" cy="38" r="6"/><circle cx="60" cy="42" r="6"/><circle cx="50" cy="62" r="5"/></g>`,
  fork: `<path d="M38 12 V34 Q38 44 50 44 Q62 44 62 34 V12 M46 12 V34 M54 12 V34" fill="none" stroke="#9aa3b8" stroke-width="5"/>
    <rect x="46" y="42" width="8" height="46" rx="4" fill="#c4cad8"/>`,
  knife: `<path d="M44 12 C58 18 58 42 56 54 H44 Z" fill="#e8ecf7"/>
    <rect x="43" y="52" width="14" height="36" rx="5" fill="#a0673b"/>`,
  spoon: `<ellipse cx="50" cy="28" rx="15" ry="19" fill="#c4cad8"/>
    <rect x="46" y="44" width="8" height="44" rx="4" fill="#c4cad8"/>
    <path d="M44 22 Q46 16 52 14" fill="none" stroke="#ffffff" stroke-width="3"/>`,
  plate: `<ellipse cx="50" cy="56" rx="40" ry="26" fill="#ffffff"/><ellipse cx="50" cy="54" rx="24" ry="14" fill="#f1effa"/>`,

  // ---------- bebidas ----------
  coffee: dTaza("#7a4a24", `<path d="M38 32 Q34 26 38 20 Q42 14 38 8 M52 32 Q48 26 52 20 Q56 14 52 8" fill="none" stroke="#9aa3b8" stroke-width="3"/>`),
  tea: dTaza("#e0a800", `<path d="M46 42 Q48 20 60 18" fill="none" stroke="#9aa3b8" stroke-width="2"/>
    <rect x="58" y="14" width="10" height="12" rx="1" fill="#22c55e"/>`),
  juice: `<path d="M26 26 H74 L68 86 H32 Z" fill="#ffffff"/>
    <path d="M28.5 40 H71.5 L68 86 H32 Z" fill="#ff9a1f"/>
    <path d="M58 40 L66 10 H74" fill="none" stroke="#ff5fa2" stroke-width="4"/>
    <circle cx="36" cy="30" r="9" fill="#ffc93c"/>`,
  milk: `<path d="M28 34 L36 18 H64 L72 34 V88 H28 Z" fill="#ffffff"/>
    <path d="M36 18 L44 34 H72 M28 34 H44 V88" fill="none"/>
    <path d="M44 52 Q58 46 72 52 V72 Q58 66 44 72 Z" fill="#5b8def"/>`,
  water: `<path d="M42 8 H58 V18 Q70 22 70 36 V84 Q70 90 64 90 H36 Q30 90 30 84 V36 Q30 22 42 18 Z" fill="#cdeeff"/>
    <rect x="40" y="6" width="20" height="8" rx="2" fill="#2f5bd3"/>
    <rect x="30" y="46" width="40" height="18" fill="#38bdf8"/>
    <path d="M44 52 Q46 58 50 58" fill="none" stroke="#ffffff" stroke-width="3"/>`,
  beer: `<rect x="22" y="30" width="44" height="56" rx="6" fill="#ffc93c"/>
    <path d="M66 42 H76 Q82 42 82 50 V64 Q82 72 76 72 H66" fill="none" stroke-width="5"/>
    <path d="M20 34 Q20 18 34 22 Q42 12 52 20 Q66 16 68 32 Q60 38 44 36 Q30 40 20 34 Z" fill="#ffffff"/>
    <path d="M34 50 V76 M46 50 V76" stroke="#e0a800" stroke-width="3"/>`,
  wine: `<path d="M30 12 H70 Q72 44 50 52 Q28 44 30 12 Z" fill="#ffffff"/>
    <path d="M31 28 H69 Q66 46 50 50 Q34 46 31 28 Z" fill="#a3164b"/>
    <path d="M50 52 V82" stroke-width="5"/><path d="M34 86 Q50 78 66 86 Z" fill="#ffffff"/>`,
  lemon: `<path d="M14 50 C14 30 34 20 50 20 C66 20 86 30 86 50 C86 70 66 80 50 80 C34 80 14 70 14 50 Z" fill="#ffe14d"/>
    <path d="M14 50 L8 48 M86 50 L92 52" stroke-width="5"/>
    <path d="M30 40 Q34 32 44 30" fill="none" stroke="#ffffff" stroke-width="4"/>`,
  icecream: `<path d="M30 50 L50 92 L70 50 Z" fill="#e7a35b"/>
    <path d="M36 56 L60 74 M64 56 L42 74 M46 52 L66 62 M54 52 L36 64" stroke="#b9732f" stroke-width="2"/>
    <circle cx="40" cy="42" r="14" fill="#ff8fbd"/><circle cx="60" cy="42" r="14" fill="#fff6e3"/><circle cx="50" cy="26" r="14" fill="#7a4a24"/>`,
  hamburger: `<path d="M16 46 Q16 18 50 18 Q84 18 84 46 Z" fill="#e7a35b"/>
    <g fill="#fff6e3" stroke="none"><ellipse cx="38" cy="30" rx="2.5" ry="1.5"/><ellipse cx="54" cy="26" rx="2.5" ry="1.5"/><ellipse cx="64" cy="34" rx="2.5" ry="1.5"/></g>
    <path d="M14 50 Q22 44 30 50 Q38 44 46 50 Q54 44 62 50 Q70 44 78 50 Q84 46 88 50 V54 H14 Z" fill="#22c55e"/>
    <rect x="16" y="54" width="68" height="12" rx="6" fill="#7a4a24"/>
    <path d="M16 70 H84 Q84 84 70 84 H30 Q16 84 16 70 Z" fill="#e7a35b"/>`,

  // ---------- la ropa ----------
  shirt: `<path d="M34 16 L50 24 L66 16 L88 30 L80 46 L72 42 V86 H28 V42 L20 46 L12 30 Z" fill="#ffffff"/>
    <path d="M34 16 L42 30 L50 24 L58 30 L66 16" fill="#e8ecf7"/>
    <path d="M50 24 V86" stroke-width="2.5"/>
    <g fill="${D_O}" stroke="none"><circle cx="54" cy="40" r="2"/><circle cx="54" cy="54" r="2"/><circle cx="54" cy="68" r="2"/></g>`,
  tshirt: `<path d="M36 16 Q50 26 64 16 L88 30 L80 46 L72 42 V86 H28 V42 L20 46 L12 30 Z" fill="#22c55e"/>
    <path d="M36 16 Q50 26 64 16" fill="none" stroke-width="4"/>`,
  pants: `<path d="M26 14 H74 L80 88 H56 L50 40 L44 88 H20 Z" fill="#2f5bd3"/>
    <path d="M26 22 H74" stroke-width="2.5"/><path d="M38 22 Q40 34 32 36 M62 22 Q60 34 68 36" fill="none" stroke-width="2"/>`,
  dress: `<path d="M38 12 V24 Q50 30 62 24 V12 L68 14 L64 40 L84 88 H16 L36 40 L32 14 Z" fill="#ff5fa2"/>
    <path d="M36 40 H64" stroke-width="3"/><circle cx="50" cy="40" r="3" fill="#ffc93c"/>`,
  skirt: `<path d="M30 22 H70 L86 80 H14 Z" fill="#a64cf5"/>
    <rect x="28" y="18" width="44" height="9" rx="2" fill="#7c34c9"/>
    <path d="M42 27 L36 80 M58 27 L64 80 M50 27 V80" stroke="#7c34c9" stroke-width="2.5"/>`,
  jacket: `<path d="M36 14 L50 20 L64 14 L84 26 L88 84 H70 V50 H30 V84 H12 L16 26 Z" fill="#f0475c"/>
    <path d="M30 50 V86 H70 V50" fill="#f0475c"/>
    <path d="M50 20 V86" stroke-width="3"/><path d="M36 14 L44 32 L50 20 L56 32 L64 14" fill="#c42b40"/>
    <rect x="30" y="58" width="12" height="4" rx="2" fill="${D_O}" stroke="none"/><rect x="58" y="58" width="12" height="4" rx="2" fill="${D_O}" stroke="none"/>`,
  hat: `<ellipse cx="50" cy="68" rx="42" ry="12" fill="#a0673b"/>
    <path d="M28 66 V40 Q28 26 50 26 Q72 26 72 40 V66 Q50 74 28 66 Z" fill="#a0673b"/>
    <path d="M28 56 Q50 64 72 56 V62 Q50 70 28 62 Z" fill="${D_O}"/>`,
  cap: `<path d="M20 60 Q18 26 50 24 Q80 26 80 60 Z" fill="#2f5bd3"/>
    <path d="M60 60 H94 Q94 70 80 70 H58 Z" fill="#1f3f9e"/>
    <path d="M50 24 V60 M34 30 Q30 44 32 60" fill="none" stroke-width="2.5"/><circle cx="50" cy="23" r="3" fill="#2f5bd3"/>`,
  shoes: `<path d="M34 50 Q34 36 46 36 L56 37 Q60 46 70 48 L84 51 Q94 53 94 61 V64 H34 Z" fill="#7a4a24"/>
    <path d="M32 64 H96" stroke-width="5"/>
    <path d="M6 70 Q6 54 18 54 L30 55 Q34 64 46 66 L62 69 Q72 71 72 79 V82 H6 Z" fill="#c47f45"/>
    <path d="M4 82 H74" stroke-width="5"/>
    <path d="M32 60 L38 57 M36 64 L42 61" stroke="#fff6e3" stroke-width="2.5"/>`,
  socks: `<path d="M18 14 H38 V54 L50 66 Q56 74 48 80 Q42 84 34 78 L20 64 Q18 62 18 58 Z" fill="#ffffff"/>
    <rect x="18" y="14" width="20" height="10" fill="#f0475c"/>
    <path d="M56 18 H76 V58 L88 70 Q94 78 86 84 Q80 88 72 82 L58 68 Q56 66 56 62 Z" fill="#ffffff"/>
    <rect x="56" y="18" width="20" height="10" fill="#f0475c"/>`,
  tie: `<path d="M42 12 H58 L54 24 H46 Z" fill="#6c4cf5"/>
    <path d="M46 24 H54 L64 72 L50 88 L36 72 Z" fill="#6c4cf5"/>
    <path d="M44 40 L58 34 M41 54 L60 46 M38 68 L62 58" stroke="#ffc93c" stroke-width="3"/>`,
  scarf: `<path d="M22 22 Q50 34 78 22 L80 36 Q50 50 20 36 Z" fill="#f0475c"/>
    <path d="M58 40 L66 86 H50 L46 42 Z" fill="#f0475c"/>
    <path d="M50 86 V92 M55 86 V92 M60 86 V92 M65 86 V92" stroke-width="2.5"/>
    <path d="M30 28 L32 40 M70 28 L68 40" stroke="#ffffff" stroke-width="3"/>`,
  boots: `<path d="M16 14 H40 V60 L56 66 Q62 68 62 76 V82 H16 Z" fill="#7a4a24"/>
    <path d="M16 82 H64" stroke-width="5"/>
    <path d="M48 14 H70 V58 L84 64 Q90 66 90 74 V80 H62" fill="#a0673b"/>
    <path d="M62 80 H92" stroke-width="5"/><path d="M16 22 H40 M48 22 H70" stroke-width="2.5"/>`,
  glasses: `<rect x="12" y="38" width="32" height="24" rx="10" fill="#bfe6ff"/>
    <rect x="56" y="38" width="32" height="24" rx="10" fill="#bfe6ff"/>
    <path d="M44 46 Q50 40 56 46 M12 44 L6 38 M88 44 L94 38" fill="none" stroke-width="4"/>`
};

// Devuelve el dibujo como <svg>, sobre un círculo suave
function dibujoSVG(clave, clase = "dibujo") {
  const cuerpo = DIBUJOS[clave];
  if (!cuerpo) return "";
  return `<svg class="${clase}" viewBox="0 0 100 100" role="img" aria-label="dibujo">
    <circle cx="50" cy="50" r="49" fill="var(--accent-soft)"/>
    <g stroke="${D_O}" stroke-width="3" stroke-linejoin="round" stroke-linecap="round">${cuerpo}</g></svg>`;
}
