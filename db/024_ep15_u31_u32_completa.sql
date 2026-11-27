-- =====================================================================
-- 024 · Episodio 15 completo (Unidades 31 y 32 del Libro 2)
--   - 8 temas nuevos en pensum_temas (orden 1-6 del Episodio 15):
--     Unidad 31 (An Advertising Campaign): phrasal verbs, pronombres indefinidos,
--       pronombres recíprocos, modismos y refranes.
--     Unidad 32 (A Television Talk Show): pronombres interrogativos,
--       opinión y desacuerdo.
--   - 8 lecciones tipo 'tema' (8 ejercicios cada una)
--   - banco-ep15 +6·8 = 48 ejercicios de práctica
--   - examen-ep15 +6·3 = 18 ejercicios reservados
--   - 6×19 = 114 ejercicios en total
--   - 'escuchar' de lección va pata 'input'; el examen incluye 'escuchar' (input).
-- Requiere 006, 007, 008 y 011. Se puede correr varias veces sin dañar nada.
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================

insert into unidades (materia_id, numero, episodio, objetivo) values
  ('ingles', 31, 'Episodio 15', 'Phrasal verbs, indefinite pronouns, reciprocal pronouns and idioms'),
  ('ingles', 32, 'Episodio 15', 'Interrogative pronouns and expressing opinions and disagreement')
on conflict (materia_id, numero) do update set
  episodio = excluded.episodio,
  objetivo = coalesce(nullif(unidades.objetivo, ''), excluded.objetivo);

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('banco-ep15', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 90, 'banco', 'Banco de ejercicios Episodio 15', 'Ejercicios de refuerzo - Episodio 15'),
  ('examen-ep15', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 91, 'examen', 'Examen Episodio 15', 'Evaluación - Episodio 15')
on conflict (id) do update set
  materia_id = excluded.materia_id, unidad_id = excluded.unidad_id, episodio = excluded.episodio,
  orden = excluded.orden, tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;

insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep15-phrasal-verbs', 15, 1, $t$Phrasal verbs (verbos compuestos)$t$, $t$Phrasal verbs$t$, $t$Verbo + partícula cambian el significado: give up = rendirse, look for = buscar, turn off = apagar.$t$),
  ('ep15-indefinidos', 15, 2, $t$Pronombres indefinidos (singular y plural)$t$, $t$Indefinite pronouns (singular and plural)$t$, $t$each, every, everybody, somebody, nobody, anyone, either, neither llevan verbo en singular. both, several, many llevan plural.$t$),
  ('ep15-reciprocos', 15, 3, $t$Pronombres recíprocos$t$, $t$Reciprocal pronouns$t$, $t$each other y one another expresan una acción mutua entre dos o más personas: They love each other.$t$),
  ('ep15-idioms', 15, 4, $t$Modismos (idioms) con refranes$t$, $t$Idioms and proverbs$t$, $t$Birds of a feather flock together, Better late than never, An eye for an eye, Charity begins at home...$t$),
  ('ep15-pronombres-interrogativos', 15, 5, $t$Pronombres interrogativos$t$, $t$Interrogative pronouns$t$, $t$who, whom, whose, what, which: ¿quién?, ¿qué?, ¿cuál?, ¿de quién? Se usan en preguntas directas e indirectas.$t$),
  ('ep15-opiniones-desacuerdo', 15, 6, $t$Expresar opinión y desacuerdo$t$, $t$Expressing opinions and disagreement$t$, $t$I completely disagree, I'm afraid I disagree, I see your point, but... Frases del talk show para debatir con cortesía.$t$),
  ('ep15-homofonos', 15, 7, $t$Homófonos: palabras que suenan igual$t$, $t$Homophones$t$, $t$Palabras que se escriben distinto, suenan igual y tienen significados diferentes: air/heir, isle/aisle, eight/ate.$t$),
  ('ep15-significado-homofonos', 15, 8, $t$Significado de palabras homófonas$t$, $t$Meanings of homophones$t$, $t$Alter (cambiar), altar (altar), bawl (llorar a gritos), ball (pelota), bare (desnudo), heir (heredero), isle (isla).$t$)
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden,
  nombre_es = excluded.nombre_es, nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('ep15-phrasal-verbs', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 1, 'tema', $t$Phrasal verbs$t$, $t$Verbo + partícula cambian el significado: give up = rendirse, look for = buscar, turn off = apagar.$t$),
  ('ep15-indefinidos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 2, 'tema', $t$Indefinite pronouns (singular and plural)$t$, $t$each, every, everybody, somebody, nobody, anyone, either, neither llevan verbo en singular. both, several, many llevan plural.$t$),
  ('ep15-reciprocos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 3, 'tema', $t$Reciprocal pronouns$t$, $t$each other y one another expresan una acción mutua entre dos o más personas: They love each other.$t$),
  ('ep15-idioms', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 4, 'tema', $t$Idioms and proverbs$t$, $t$Birds of a feather flock together, Better late than never, An eye for an eye, Charity begins at home...$t$),
  ('ep15-pronombres-interrogativos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 32), 15, 5, 'tema', $t$Interrogative pronouns$t$, $t$who, whom, whose, what, which: ¿quién?, ¿qué?, ¿cuál?, ¿de quién? Se usan en preguntas directas e indirectas.$t$),
  ('ep15-opiniones-desacuerdo', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 32), 15, 6, 'tema', $t$Expressing opinions and disagreement$t$, $t$I completely disagree, I'm afraid I disagree, I see your point, but... Frases del talk show para debatir con cortesía.$t$),
  ('ep15-homofonos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 7, 'tema', $t$Homophones$t$, $t$Palabras que se escriben distinto, suenan igual y tienen significados diferentes: air/heir, isle/aisle, eight/ate.$t$),
  ('ep15-significado-homofonos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 31), 15, 8, 'tema', $t$Meanings of homophones$t$, $t$Alter (cambiar), altar (altar), bawl (llorar a gritos), ball (pelota), bare (desnudo), heir (heredero), isle (isla).$t$)
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;


-- EJERCICIOS — TEMA 1: ep15-phrasal-verbs
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-phra-01', 'ep15-phrasal-verbs', 1, 'elegir',
 $j${"frase": "Don't ___ on your dreams.", "opciones": ["give up", "give in", "give out", "give off"], "correcta": 0, "es": "No te rindas con tus sueños.", "explicacion": "give up = rendirse."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-02', 'ep15-phrasal-verbs', 2, 'elegir',
 $j${"frase": "Please ___ the light before you leave.", "opciones": ["turn off", "turn on", "turn up", "turn down"], "correcta": 0, "es": "Por favor apaga la luz antes de salir.", "explicacion": "turn off = apagar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-03', 'ep15-phrasal-verbs', 3, 'elegir',
 $j${"frase": "I'm ___ my keys. Have you seen them?", "opciones": ["looking for", "looking at", "looking after", "looking into"], "correcta": 0, "es": "Estoy buscando mis llaves. ¿Las has visto?", "explicacion": "look for = buscar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-04', 'ep15-phrasal-verbs', 4, 'elegir',
 $j${"frase": "Can you ___ this word in the dictionary?", "opciones": ["look up", "look out", "look over", "look after"], "correcta": 0, "es": "¿Puedes buscar esta palabra en el diccionario?", "explicacion": "look up = consultar/buscar información."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-05', 'ep15-phrasal-verbs', 5, 'escribir',
 $j${"respuestas": ["put off"], "mostrar": "Don't put off your homework until tomorrow.", "es": "No dejes tu tarea para mañana.", "explicacion": "put off = aplazar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-06', 'ep15-phrasal-verbs', 6, 'ordenar',
 $j${"frase": "We have to turn down the music .", "es": "Tenemos que bajar la música.", "explicacion": "turn down = bajar el volumen / rechazar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-07', 'ep15-phrasal-verbs', 7, 'emparejar',
 $j${"pares": [["give up", "rendirse"], ["turn off", "apagar"], ["look for", "buscar"], ["put off", "aplazar"]], "es": "", "explicacion": "Phrasal verbs básicos."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', false),
('ep15-phra-08', 'ep15-phrasal-verbs', 8, 'escuchar',
 $j${"opciones": ["Please turn off the TV.", "Please turn on the TV.", "Please turn up the TV.", "Please turn down the TV."], "correcta": 0, "audio": "Please turn off the TV.", "es": "Por favor apaga la tele.", "explicacion": "turn off = apagar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-phra-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I can't find my glasses. I'm looking for them everywhere.", "es": "No encuentro mis gafas. Las busco por todas partes."}, {"en": "Did you look under the sofa?", "es": "¿Miraste debajo del sofá?"}], "pregunta": "What is the speaker doing?", "pregunta_es": "¿Qué está haciendo el hablante?", "opciones": ["Looking for glasses", "Giving up", "Turning off the TV", "Putting off a meeting"], "correcta": 0, "explicacion": "'I'm looking for them everywhere.'"}$j$::jsonb,
 'ep15-phrasal-verbs', 'input', false),
('banco-ep15-phra-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Don't give up. Try again tomorrow.", "es": "No te rindas. Inténtalo de nuevo mañana."}, {"en": "Okay, I'll keep trying.", "es": "Bueno, seguiré intentando."}], "pregunta": "What does the friend advise?", "pregunta_es": "¿Qué aconseja el amigo?", "opciones": ["Not to give up", "To stop trying", "To turn off the phone", "To put off the test"], "correcta": 0, "explicacion": "'Don't give up.'"}$j$::jsonb,
 'ep15-phrasal-verbs', 'input', false),
('banco-ep15-phra-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Apaga la luz, por favor.", "respuestas": ["Please turn off the light."], "mostrar": "Please turn off the light.", "explicacion": "turn off = apagar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'output', false),
('banco-ep15-phra-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: No voy a aplazar la reunión.", "respuestas": ["I won't put off the meeting."], "mostrar": "I won't put off the meeting.", "explicacion": "put off = aplazar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'output', false),
('banco-ep15-phra-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Tell about something you looked for, gave up, or put off. Use at least two phrasal verbs.", "pregunta_es": "Cuenta algo que buscaste, en lo que te rendiste o que aplazaste. Usa al menos dos phrasal verbs.", "ejemplo": "Last week I put off my dentist appointment, and I looked for a new one."}$j$::jsonb,
 'ep15-phrasal-verbs', 'output', false),
('banco-ep15-phra-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "Don't ___ on your goals.", "opciones": ["give up", "turn off", "look up"], "correcta": 0, "es": "No te rindas con tus metas.", "explicacion": "give up = rendirse.", "segundos": 5}$j$::jsonb,
 'ep15-phrasal-verbs', 'fluidez', false),
('banco-ep15-phra-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "I'm ___ my phone.", "opciones": ["looking for", "turning off", "giving up"], "correcta": 0, "es": "Estoy buscando mi teléfono.", "explicacion": "look for = buscar.", "segundos": 5}$j$::jsonb,
 'ep15-phrasal-verbs', 'fluidez', false),
('banco-ep15-phra-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "Please ___ the radio.", "opciones": ["turn down", "give up", "put off"], "correcta": 0, "es": "Por favor baja la radio.", "explicacion": "turn down = bajar volumen.", "segundos": 5}$j$::jsonb,
 'ep15-phrasal-verbs', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-phra-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "Let's ___ the meeting until next week.", "opciones": ["put off", "put on", "put up"], "correcta": 0, "es": "Aplacemos la reunión hasta la próxima semana.", "explicacion": "put off = aplazar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', true),
('examen-ep15-phra-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["looked up"], "mostrar": "I looked up the word online.", "es": "Busqué la palabra en internet.", "explicacion": "look up = consultar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'estudio', true),
('examen-ep15-phra-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["Turn off the lights when you leave.", "Turn on the lights when you leave.", "Turn up the lights when you leave.", "Turn down the lights when you leave."], "correcta": 0, "audio": "Turn off the lights when you leave.", "es": "Apaga las luces cuando salgas.", "explicacion": "turn off = apagar."}$j$::jsonb,
 'ep15-phrasal-verbs', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 2: ep15-indefinidos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-inde-01', 'ep15-indefinidos', 1, 'elegir',
 $j${"frase": "Everybody ___ ready for the test.", "opciones": ["is", "are", "were", "have"], "correcta": 0, "es": "Todos están listos para el examen.", "explicacion": "everybody es singular: is."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-02', 'ep15-indefinidos', 2, 'elegir',
 $j${"frase": "Each of the students ___ a book.", "opciones": ["has", "have", "are", "were"], "correcta": 0, "es": "Cada uno de los estudiantes tiene un libro.", "explicacion": "each es singular: has."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-03', 'ep15-indefinidos', 3, 'elegir',
 $j${"frase": "Both of my sisters ___ teachers.", "opciones": ["are", "is", "was", "has"], "correcta": 0, "es": "Mis dos hermanas son profesoras.", "explicacion": "both es plural: are."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-04', 'ep15-indefinidos', 4, 'elegir',
 $j${"frase": "Nobody ___ here on Sundays.", "opciones": ["works", "work", "are working", "were"], "correcta": 0, "es": "Nadie trabaja aquí los domingos.", "explicacion": "nobody es singular: works."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-05', 'ep15-indefinidos', 5, 'escribir',
 $j${"respuestas": ["is"], "mostrar": "Somebody is knocking at the door.", "es": "Alguien está tocando la puerta.", "explicacion": "somebody es singular: is."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-06', 'ep15-indefinidos', 6, 'ordenar',
 $j${"frase": "Everyone in the office likes coffee .", "es": "A todos en la oficina les gusta el café.", "explicacion": "everyone = singular, verbo en -s."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-07', 'ep15-indefinidos', 7, 'emparejar',
 $j${"pares": [["everybody is", "todos están"], ["each has", "cada uno tiene"], ["both are", "ambos son"], ["nobody works", "nadie trabaja"]], "es": "", "explicacion": "Indefinidos con su verbo correcto."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', false),
('ep15-inde-08', 'ep15-indefinidos', 8, 'escuchar',
 $j${"opciones": ["Everybody is happy today.", "Everybody are happy today.", "Everybody were happy today.", "Everybody have happy today."], "correcta": 0, "audio": "Everybody is happy today.", "es": "Todos están felices hoy.", "explicacion": "everybody + is."}$j$::jsonb,
 'ep15-indefinidos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-inde-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Is anyone home?", "es": "¿Hay alguien en casa?"}, {"en": "Nobody is here. Everybody left early.", "es": "No hay nadie. Todos se fueron temprano."}], "pregunta": "What happened?", "pregunta_es": "¿Qué pasó?", "opciones": ["Everybody left early", "Everybody stayed late", "Somebody is home", "Both are at work"], "correcta": 0, "explicacion": "'Everybody left early.'"}$j$::jsonb,
 'ep15-indefinidos', 'input', false),
('banco-ep15-inde-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Both of the ads are very creative.", "es": "Ambos anuncios son muy creativos."}, {"en": "Yes, and each one has a strong message.", "es": "Sí, y cada uno tiene un mensaje fuerte."}], "pregunta": "How are the ads described?", "pregunta_es": "¿Cómo se describen los anuncios?", "opciones": ["Creative, with strong messages", "Boring and long", "Expensive and short", "Late and unclear"], "correcta": 0, "explicacion": "'Both of the ads are very creative.'"}$j$::jsonb,
 'ep15-indefinidos', 'input', false),
('banco-ep15-inde-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Cada uno tiene su propio color.", "respuestas": ["Each one has its own color."], "mostrar": "Each one has its own color.", "explicacion": "each one + has (singular)."}$j$::jsonb,
 'ep15-indefinidos', 'output', false),
('banco-ep15-inde-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: Ninguno de ellos llegó a tiempo.", "respuestas": ["None of them arrived on time."], "mostrar": "None of them arrived on time.", "explicacion": "none puede usarse con verbo en pasado."}$j$::jsonb,
 'ep15-indefinidos', 'output', false),
('banco-ep15-inde-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Describe your team or family using 'everybody', 'each', 'both' and 'nobody' correctly.", "pregunta_es": "Describe tu equipo o familia usando 'everybody', 'each', 'both' y 'nobody' correctamente.", "ejemplo": "Everybody in my family works hard. Both of my brothers are engineers."}$j$::jsonb,
 'ep15-indefinidos', 'output', false),
('banco-ep15-inde-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "Everybody ___ happy.", "opciones": ["is", "are", "were"], "correcta": 0, "es": "Todos están felices.", "explicacion": "everybody + is.", "segundos": 5}$j$::jsonb,
 'ep15-indefinidos', 'fluidez', false),
('banco-ep15-inde-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "Both of them ___ here.", "opciones": ["are", "is", "was"], "correcta": 0, "es": "Ambos están aquí.", "explicacion": "both + are.", "segundos": 5}$j$::jsonb,
 'ep15-indefinidos', 'fluidez', false),
('banco-ep15-inde-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "Nobody ___ late today.", "opciones": ["is", "are", "were"], "correcta": 0, "es": "Nadie llegó tarde hoy.", "explicacion": "nobody + is/verbo singular.", "segundos": 5}$j$::jsonb,
 'ep15-indefinidos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-inde-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "Somebody ___ my bag.", "opciones": ["has taken", "have taken", "are taking"], "correcta": 0, "es": "Alguien se llevó mi bolso.", "explicacion": "somebody es singular: has."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', true),
('examen-ep15-inde-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["are"], "mostrar": "Both of the managers are here.", "es": "Ambos gerentes están aquí.", "explicacion": "both es plural: are."}$j$::jsonb,
 'ep15-indefinidos', 'estudio', true),
('examen-ep15-inde-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["Nobody knows the answer.", "Nobody know the answer.", "Nobody are knowing the answer.", "Nobody have the answer."], "correcta": 0, "audio": "Nobody knows the answer.", "es": "Nadie sabe la respuesta.", "explicacion": "nobody + knows."}$j$::jsonb,
 'ep15-indefinidos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 3: ep15-reciprocos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-reci-01', 'ep15-reciprocos', 1, 'elegir',
 $j${"frase": "Lyle and Frances love ___.", "opciones": ["each other", "themselves", "one another's", "them"], "correcta": 0, "es": "Lyle y Frances se aman el uno al otro.", "explicacion": "each other = el uno al otro (dos personas)."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-02', 'ep15-reciprocos', 2, 'elegir',
 $j${"frase": "The team helps ___ every day.", "opciones": ["one another", "each", "themselves"], "correcta": 0, "es": "El equipo se ayuda mutuamente todos los días.", "explicacion": "one another = el uno al otro (grupo)."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-03', 'ep15-reciprocos', 3, 'elegir',
 $j${"frase": "My sister and I talk to ___ every night.", "opciones": ["each other", "ourselves", "one another's"], "correcta": 0, "es": "Mi hermana y yo hablamos todas las noches.", "explicacion": "each other con dos personas."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-04', 'ep15-reciprocos', 4, 'elegir',
 $j${"frase": "They write to ___ every week.", "opciones": ["each other", "themselves", "theirs"], "correcta": 0, "es": "Se escriben cada semana.", "explicacion": "each other = mutuamente."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-05', 'ep15-reciprocos', 5, 'escribir',
 $j${"respuestas": ["one another"], "mostrar": "The students respect one another.", "es": "Los estudiantes se respetan mutuamente.", "explicacion": "one another con grupos de más de dos."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-06', 'ep15-reciprocos', 6, 'ordenar',
 $j${"frase": "We should listen to each other .", "es": "Deberíamos escucharnos el uno al otro.", "explicacion": "listen to each other."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-07', 'ep15-reciprocos', 7, 'emparejar',
 $j${"pares": [["each other", "el uno al otro (dos)"], ["one another", "el uno al otro (grupo)"], ["love each other", "se aman"], ["help one another", "se ayudan mutuamente"]], "es": "", "explicacion": "Recíprocos con dos o con grupos."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', false),
('ep15-reci-08', 'ep15-reciprocos', 8, 'escuchar',
 $j${"opciones": ["They always help each other.", "They always help themselves.", "They always help theirs.", "They always help ourselves."], "correcta": 0, "audio": "They always help each other.", "es": "Siempre se ayudan mutuamente.", "explicacion": "each other = mutuo."}$j$::jsonb,
 'ep15-reciprocos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-reci-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Frances and Lyle always talk to each other.", "es": "Frances y Lyle siempre se hablan."}, {"en": "They are very close friends.", "es": "Son muy buenos amigos."}], "pregunta": "What do Frances and Lyle do?", "pregunta_es": "¿Qué hacen Frances y Lyle?", "opciones": ["They talk to each other", "They avoid each other", "They fight with one another's friends", "They forget each other"], "correcta": 0, "explicacion": "'They always talk to each other.'"}$j$::jsonb,
 'ep15-reciprocos', 'input', false),
('banco-ep15-reci-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Our team members support one another.", "es": "Los miembros de nuestro equipo se apoyan mutuamente."}, {"en": "That's why we succeed.", "es": "Por eso tenemos éxito."}], "pregunta": "Why does the team succeed?", "pregunta_es": "¿Por qué tiene éxito el equipo?", "opciones": ["They support one another", "They work alone", "They ignore each other", "They argue all day"], "correcta": 0, "explicacion": "'Our team members support one another.'"}$j$::jsonb,
 'ep15-reciprocos', 'input', false),
('banco-ep15-reci-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Nos queremos mucho.", "respuestas": ["We love each other."], "mostrar": "We love each other.", "explicacion": "each other con dos personas."}$j$::jsonb,
 'ep15-reciprocos', 'output', false),
('banco-ep15-reci-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: Los vecinos se ayudan mutuamente.", "respuestas": ["The neighbors help one another."], "mostrar": "The neighbors help one another.", "explicacion": "one another con grupos."}$j$::jsonb,
 'ep15-reciprocos', 'output', false),
('banco-ep15-reci-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Describe how two people you know help or respect each other. Use 'each other' or 'one another'.", "pregunta_es": "Describe cómo dos personas que conoces se ayudan o respetan. Usa 'each other' o 'one another'.", "ejemplo": "My parents always support each other, and my friends help one another with homework."}$j$::jsonb,
 'ep15-reciprocos', 'output', false),
('banco-ep15-reci-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "They love ___.", "opciones": ["each other", "themselves", "theirs"], "correcta": 0, "es": "Se aman.", "explicacion": "each other = mutuo.", "segundos": 5}$j$::jsonb,
 'ep15-reciprocos', 'fluidez', false),
('banco-ep15-reci-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "We trust ___.", "opciones": ["one another", "ourselves", "ours"], "correcta": 0, "es": "Confiamos el uno en el otro.", "explicacion": "one another en grupo.", "segundos": 5}$j$::jsonb,
 'ep15-reciprocos', 'fluidez', false),
('banco-ep15-reci-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "Kids, help ___!", "opciones": ["each other", "yourselves", "ours"], "correcta": 0, "es": "¡Niños, ayúdense!", "explicacion": "each other con dos o más.", "segundos": 5}$j$::jsonb,
 'ep15-reciprocos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-reci-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "The two sisters look like ___.", "opciones": ["each other", "themselves", "theirs"], "correcta": 0, "es": "Las dos hermanas se parecen.", "explicacion": "each other = mutuamente."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', true),
('examen-ep15-reci-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["one another"], "mostrar": "The players congratulate one another.", "es": "Los jugadores se felicitan mutuamente.", "explicacion": "one another con grupos."}$j$::jsonb,
 'ep15-reciprocos', 'estudio', true),
('examen-ep15-reci-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["They trust each other completely.", "They trust themselves completely.", "They trust theirs completely.", "They trust ourselves completely."], "correcta": 0, "audio": "They trust each other completely.", "es": "Confían completamente el uno en el otro.", "explicacion": "each other."}$j$::jsonb,
 'ep15-reciprocos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 4: ep15-idioms
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-idio-01', 'ep15-idioms', 1, 'elegir',
 $j${"frase": "Better late than ___.", "opciones": ["never", "always", "tomorrow", "ever"], "correcta": 0, "es": "Mejor tarde que nunca.", "explicacion": "Better late than never = mejor tarde que nunca."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-02', 'ep15-idioms', 2, 'elegir',
 $j${"frase": "Birds of a feather ___ together.", "opciones": ["flock", "fly", "sing", "build"], "correcta": 0, "es": "Dios los cría y ellos se juntan.", "explicacion": "Birds of a feather flock together = los iguales se juntan."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-03', 'ep15-idioms', 3, 'elegir',
 $j${"frase": "An eye for an eye and a tooth for a ___.", "opciones": ["tooth", "bite", "smile", "word"], "correcta": 0, "es": "Ojo por ojo y diente por diente.", "explicacion": "Castigo del mismo tipo que el daño."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-04', 'ep15-idioms', 4, 'elegir',
 $j${"frase": "Charity begins at ___.", "opciones": ["home", "work", "school", "night"], "correcta": 0, "es": "La caridad empieza por casa.", "explicacion": "Ayuda primero a los tuyos."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-05', 'ep15-idioms', 5, 'escribir',
 $j${"respuestas": ["prevention"], "mostrar": "An ounce of prevention is worth a pound of cure.", "es": "Más vale prevenir que lamentar.", "explicacion": "prevention = prevención."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-06', 'ep15-idioms', 6, 'ordenar',
 $j${"frase": "I'll sleep on it .", "es": "Lo voy a pensar con calma (lo consultaré a la almohada).", "explicacion": "sleep on it = pensar algo antes de decidir."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-07', 'ep15-idioms', 7, 'emparejar',
 $j${"pares": [["Better late than never", "Mejor tarde que nunca"], ["His bark is worse than his bite", "Ladra más de lo que muerde"], ["I'll sleep on it", "Lo pensaré con calma"], ["Charity begins at home", "La caridad empieza en casa"]], "es": "", "explicacion": "Refranes y modismos del nivel."}$j$::jsonb,
 'ep15-idioms', 'estudio', false),
('ep15-idio-08', 'ep15-idioms', 8, 'escuchar',
 $j${"opciones": ["Better late than never, my friend.", "Better early than never, my friend.", "Better late than ever, my friend.", "Better soon than never, my friend."], "correcta": 0, "audio": "Better late than never, my friend.", "es": "Mejor tarde que nunca, amigo.", "explicacion": "Better late than never."}$j$::jsonb,
 'ep15-idioms', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-idio-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I'm sorry I forgot your birthday. Here's your gift now.", "es": "Lo siento, olvidé tu cumpleaños. Aquí está tu regalo ahora."}, {"en": "Oh well, better late than never!", "es": "¡Bueno, mejor tarde que nunca!"}], "pregunta": "What does the friend think about the late gift?", "pregunta_es": "¿Qué piensa el amigo del regalo tardío?", "opciones": ["It's still worth it", "He is angry", "He doesn't want it", "He will return it"], "correcta": 0, "explicacion": "'Better late than never!'"}$j$::jsonb,
 'ep15-idioms', 'input', false),
('banco-ep15-idio-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Let's think about it. I'll sleep on it.", "es": "Pensémoslo. Lo voy a pensar con calma."}, {"en": "Fine, let me know tomorrow.", "es": "Bien, avísame mañana."}], "pregunta": "What does the speaker plan to do?", "pregunta_es": "¿Qué planea hacer el hablante?", "opciones": ["Think about it overnight", "Decide right away", "Say no immediately", "Ask someone else now"], "correcta": 0, "explicacion": "'I'll sleep on it.'"}$j$::jsonb,
 'ep15-idioms', 'input', false),
('banco-ep15-idio-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Más vale prevenir que lamentar.", "respuestas": ["An ounce of prevention is worth a pound of cure."], "mostrar": "An ounce of prevention is worth a pound of cure.", "explicacion": "Refrán completo."}$j$::jsonb,
 'ep15-idioms', 'output', false),
('banco-ep15-idio-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: Ladra más de lo que muerde.", "respuestas": ["His bark is worse than his bite."], "mostrar": "His bark is worse than his bite.", "explicacion": "Modismo: parece peor de lo que es."}$j$::jsonb,
 'ep15-idioms', 'output', false),
('banco-ep15-idio-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Which proverb from this unit do you agree with most? Explain why in two sentences.", "pregunta_es": "¿Con cuál refrán de esta unidad estás más de acuerdo? Explica por qué en dos frases.", "ejemplo": "I agree with 'Better late than never' because it's never too late to learn English."}$j$::jsonb,
 'ep15-idioms', 'output', false),
('banco-ep15-idio-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "Charity begins at ___.", "opciones": ["home", "work", "dinner"], "correcta": 0, "es": "La caridad empieza en casa.", "explicacion": "home = casa.", "segundos": 5}$j$::jsonb,
 'ep15-idioms', 'fluidez', false),
('banco-ep15-idio-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "Birds of a feather flock ___.", "opciones": ["together", "apart", "alone"], "correcta": 0, "es": "Los iguales se juntan.", "explicacion": "together = juntos.", "segundos": 5}$j$::jsonb,
 'ep15-idioms', 'fluidez', false),
('banco-ep15-idio-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "An eye for an ___.", "opciones": ["eye", "tooth", "bite"], "correcta": 0, "es": "Ojo por ojo.", "explicacion": "eye for an eye.", "segundos": 5}$j$::jsonb,
 'ep15-idioms', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-idio-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "___ than never!", "opciones": ["Better late", "Better early", "Late better"], "correcta": 0, "es": "¡Mejor tarde que nunca!", "explicacion": "Better late than never."}$j$::jsonb,
 'ep15-idioms', 'estudio', true),
('examen-ep15-idio-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["sleep on it"], "mostrar": "I need time. I'll sleep on it.", "es": "Necesito tiempo. Lo pensaré con calma.", "explicacion": "sleep on it = consultarlo con la almohada."}$j$::jsonb,
 'ep15-idioms', 'estudio', true),
('examen-ep15-idio-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["Charity begins at home.", "Charity begins at school.", "Charity begins at work.", "Charity begins at night."], "correcta": 0, "audio": "Charity begins at home.", "es": "La caridad empieza en casa.", "explicacion": "home."}$j$::jsonb,
 'ep15-idioms', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 5: ep15-pronombres-interrogativos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-pron-01', 'ep15-pronombres-interrogativos', 1, 'elegir',
 $j${"frase": "___ is the host of the show?", "opciones": ["Who", "Whose", "Which", "Whom"], "correcta": 0, "es": "¿Quién es el presentador del programa?", "explicacion": "who = quién (sujeto)."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-02', 'ep15-pronombres-interrogativos', 2, 'elegir',
 $j${"frase": "___ book is this?", "opciones": ["Whose", "Who", "What", "Whom"], "correcta": 0, "es": "¿De quién es este libro?", "explicacion": "whose = de quién."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-03', 'ep15-pronombres-interrogativos', 3, 'elegir',
 $j${"frase": "___ do you want: the red one or the blue one?", "opciones": ["Which", "Who", "Whose", "What"], "correcta": 0, "es": "¿Cuál quieres: el rojo o el azul?", "explicacion": "which = cuál (entre opciones)."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-04', 'ep15-pronombres-interrogativos', 4, 'elegir',
 $j${"frase": "___ did you invite to the party?", "opciones": ["Whom", "Who", "Whose", "Which"], "correcta": 0, "es": "¿A quién invitaste a la fiesta?", "explicacion": "whom = a quién (objeto); en el habla diaria también se usa 'who'."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-05', 'ep15-pronombres-interrogativos', 5, 'escribir',
 $j${"respuestas": ["what"], "mostrar": "What is your opinion about the ad?", "es": "¿Cuál es tu opinión sobre el anuncio?", "explicacion": "what = qué."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-06', 'ep15-pronombres-interrogativos', 6, 'ordenar',
 $j${"frase": "Whose car is parked outside ?", "es": "¿De quién es el carro estacionado afuera?", "explicacion": "whose + sustantivo."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-07', 'ep15-pronombres-interrogativos', 7, 'emparejar',
 $j${"pares": [["who", "quién (sujeto)"], ["whose", "de quién"], ["which", "cuál (entre opciones)"], ["what", "qué"]], "es": "", "explicacion": "Pronombres interrogativos básicos."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', false),
('ep15-pron-08', 'ep15-pronombres-interrogativos', 8, 'escuchar',
 $j${"opciones": ["Whose idea was this?", "Who idea was this?", "Which idea was this?", "What idea was this?"], "correcta": 0, "audio": "Whose idea was this?", "es": "¿De quién fue esta idea?", "explicacion": "whose + sustantivo."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-pron-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Who is your guest today?", "es": "¿Quién es tu invitado hoy?"}, {"en": "It's Dr. Carter, a famous plastic surgeon.", "es": "Es el Dr. Carter, un cirujano plástico famoso."}], "pregunta": "Who is the guest?", "pregunta_es": "¿Quién es el invitado?", "opciones": ["Dr. Carter", "A famous singer", "A teacher", "A host's friend"], "correcta": 0, "explicacion": "'It's Dr. Carter, a famous plastic surgeon.'"}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'input', false),
('banco-ep15-pron-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Which topic should we discuss first?", "es": "¿Qué tema debemos discutir primero?"}, {"en": "Let's start with cosmetic surgery.", "es": "Empecemos con la cirugía estética."}], "pregunta": "What topic will they discuss first?", "pregunta_es": "¿Qué tema discutirán primero?", "opciones": ["Cosmetic surgery", "Advertising", "Weather", "Travel"], "correcta": 0, "explicacion": "'Let's start with cosmetic surgery.'"}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'input', false),
('banco-ep15-pron-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: ¿De quién es este carro?", "respuestas": ["Whose car is this?"], "mostrar": "Whose car is this?", "explicacion": "whose = de quién."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'output', false),
('banco-ep15-pron-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: ¿Qué piensas de eso?", "respuestas": ["What do you think about that?"], "mostrar": "What do you think about that?", "explicacion": "what = qué."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'output', false),
('banco-ep15-pron-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Write three questions to interview a famous person. Use who, whose, which and what.", "pregunta_es": "Escribe tres preguntas para entrevistar a una persona famosa. Usa who, whose, which y what.", "ejemplo": "Who inspired you most? Whose advice do you follow? Which project are you proudest of?"}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'output', false),
('banco-ep15-pron-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "___ is your favorite color?", "opciones": ["What", "Whose", "Who"], "correcta": 0, "es": "¿Cuál es tu color favorito?", "explicacion": "what para preguntar por algo.", "segundos": 5}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'fluidez', false),
('banco-ep15-pron-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "___ pen is this?", "opciones": ["Whose", "Who", "Which"], "correcta": 0, "es": "¿De quién es este lapicero?", "explicacion": "whose + sustantivo.", "segundos": 5}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'fluidez', false),
('banco-ep15-pron-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "___ is calling you?", "opciones": ["Who", "Whose", "Which"], "correcta": 0, "es": "¿Quién te llama?", "explicacion": "who = quién.", "segundos": 5}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-pron-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "___ do you prefer, tea or coffee?", "opciones": ["Which", "Who", "Whose"], "correcta": 0, "es": "¿Cuál prefieres, té o café?", "explicacion": "which entre opciones."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', true),
('examen-ep15-pron-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["whose"], "mostrar": "Whose turn is it to speak?", "es": "¿De quién es el turno de hablar?", "explicacion": "whose = de quién."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'estudio', true),
('examen-ep15-pron-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["Who is going to speak first?", "Whose is going to speak first?", "Which is going to speak first?", "What is going to speak first?"], "correcta": 0, "audio": "Who is going to speak first?", "es": "¿Quién va a hablar primero?", "explicacion": "who = quién."}$j$::jsonb,
 'ep15-pronombres-interrogativos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 6: ep15-opiniones-desacuerdo
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-opin-01', 'ep15-opiniones-desacuerdo', 1, 'elegir',
 $j${"frase": "I'm afraid I ___ with you.", "opciones": ["disagree", "agree with", "agreeing", "disagreed"], "correcta": 0, "es": "Me temo que no estoy de acuerdo contigo.", "explicacion": "I'm afraid I disagree = desacuerdo cortés."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-02', 'ep15-opiniones-desacuerdo', 2, 'elegir',
 $j${"frase": "I ___ your point, but I think otherwise.", "opciones": ["see", "look", "hear", "say"], "correcta": 0, "es": "Entiendo tu punto, pero pienso lo contrario.", "explicacion": "I see your point = entiendo tu punto."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-03', 'ep15-opiniones-desacuerdo', 3, 'elegir',
 $j${"frase": "I completely ___ with that idea.", "opciones": ["agree", "agrees", "agreed", "agreeing"], "correcta": 0, "es": "Estoy totalmente de acuerdo con esa idea.", "explicacion": "I agree con verbo base."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-04', 'ep15-opiniones-desacuerdo', 4, 'elegir',
 $j${"frase": "Are you ___ that cosmetic surgery is necessary?", "opciones": ["saying", "say", "said", "says"], "correcta": 0, "es": "¿Estás diciendo que la cirugía estética es necesaria?", "explicacion": "Are you saying that...? = ¿estás diciendo que...?"}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-05', 'ep15-opiniones-desacuerdo', 5, 'escribir',
 $j${"respuestas": ["disagree"], "mostrar": "I'm afraid I disagree with the ad.", "es": "Me temo que no estoy de acuerdo con el anuncio.", "explicacion": "disagree = no estar de acuerdo."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-06', 'ep15-opiniones-desacuerdo', 6, 'ordenar',
 $j${"frase": "I see your point, but I think differently .", "es": "Entiendo tu punto, pero pienso diferente.", "explicacion": "I see your point, but... = desacuerdo cortés."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-07', 'ep15-opiniones-desacuerdo', 7, 'emparejar',
 $j${"pares": [["I completely disagree", "No estoy de acuerdo para nada"], ["I see your point", "Entiendo tu punto"], ["I'm afraid I disagree", "Me temo que no estoy de acuerdo"], ["I totally agree", "Estoy totalmente de acuerdo"]], "es": "", "explicacion": "Frases para debatir."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', false),
('ep15-opin-08', 'ep15-opiniones-desacuerdo', 8, 'escuchar',
 $j${"opciones": ["I'm afraid I disagree with you.", "I'm afraid I agree with you.", "I'm sure I agree with you.", "I'm happy I disagree with you."], "correcta": 0, "audio": "I'm afraid I disagree with you.", "es": "Me temo que no estoy de acuerdo contigo.", "explicacion": "disagree = no estar de acuerdo."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-opin-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Cosmetic surgery makes people feel better about themselves.", "es": "La cirugía estética hace que la gente se sienta mejor consigo misma."}, {"en": "I see your point, but I completely disagree.", "es": "Entiendo tu punto, pero no estoy de acuerdo para nada."}], "pregunta": "Does the speaker agree?", "pregunta_es": "¿Está de acuerdo el hablante?", "opciones": ["No, they disagree", "Yes, completely", "Partly, they agree", "They don't say"], "correcta": 0, "explicacion": "'I completely disagree.'"}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'input', false),
('banco-ep15-opin-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Are you saying that everyone should change their look?", "es": "¿Estás diciendo que todos deberían cambiar su apariencia?"}, {"en": "I'm afraid I disagree.", "es": "Me temo que no estoy de acuerdo."}], "pregunta": "What is the speaker's position?", "pregunta_es": "¿Cuál es la postura del hablante?", "opciones": ["Disagrees", "Agrees", "Is undecided", "Is happy"], "correcta": 0, "explicacion": "'I'm afraid I disagree.'"}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'input', false),
('banco-ep15-opin-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Entiendo tu punto, pero...", "respuestas": ["I see your point, but..."], "mostrar": "I see your point, but...", "explicacion": "Desacuerdo cortés."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'output', false),
('banco-ep15-opin-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: Estoy totalmente de acuerdo contigo.", "respuestas": ["I totally agree with you."], "mostrar": "I totally agree with you.", "explicacion": "totally agree = estar totalmente de acuerdo."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'output', false),
('banco-ep15-opin-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Give your opinion on a topic you care about. Then express one disagreement politely.", "pregunta_es": "Da tu opinión sobre un tema que te importe. Luego expresa un desacuerdo con cortesía.", "ejemplo": "I think social media is useful. I see your point, but I'm afraid I disagree that it's always harmful."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'output', false),
('banco-ep15-opin-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "I ___ with that.", "opciones": ["disagree", "disagrees", "disagreeing"], "correcta": 0, "es": "No estoy de acuerdo con eso.", "explicacion": "I disagree.", "segundos": 5}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'fluidez', false),
('banco-ep15-opin-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "I see your ___.", "opciones": ["point", "say", "look"], "correcta": 0, "es": "Entiendo tu punto.", "explicacion": "I see your point.", "segundos": 5}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'fluidez', false),
('banco-ep15-opin-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "I totally ___.", "opciones": ["agree", "agrees", "agreed"], "correcta": 0, "es": "Estoy totalmente de acuerdo.", "explicacion": "I agree.", "segundos": 5}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-opin-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "I completely ___ with the plan.", "opciones": ["agree", "agrees", "agreed"], "correcta": 0, "es": "Estoy totalmente de acuerdo con el plan.", "explicacion": "I agree."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', true),
('examen-ep15-opin-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["point"], "mostrar": "I see your point, but I disagree.", "es": "Entiendo tu punto, pero no estoy de acuerdo.", "explicacion": "see your point."}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'estudio', true),
('examen-ep15-opin-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["Are you saying that it is cheap?", "Are you saying that it is safe?", "Are you saying that it is new?", "Are you saying that it is easy?"], "correcta": 0, "audio": "Are you saying that it is cheap?", "es": "¿Estás diciendo que es barato?", "explicacion": "Are you saying that...?"}$j$::jsonb,
 'ep15-opiniones-desacuerdo', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 7: ep15-homofonos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-homo-01', 'ep15-homofonos', 1, 'elegir',
 $j${"frase": "I can't believe it's the same ___ as yesterday.", "opciones": ["air", "heir", "hair", "hare"], "correcta": 0, "es": "No puedo creer que sea el mismo aire que ayer.", "explicacion": "air (aire) suena igual que heir (heredero) pero significan distinto."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-02', 'ep15-homofonos', 2, 'elegir',
 $j${"frase": "We ___ dinner at seven.", "opciones": ["ate", "eight", "at", "it"], "correcta": 0, "es": "Cenamos a las siete.", "explicacion": "ate = pasado de eat; eight = ocho."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-03', 'ep15-homofonos', 3, 'elegir',
 $j${"frase": "The boat sailed to a small ___ in the sea.", "opciones": ["isle", "aisle", "idle", "aide"], "correcta": 0, "es": "El barco navegó hacia una pequeña isla en el mar.", "explicacion": "isle = isla; aisle = pasillo."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-04', 'ep15-homofonos', 4, 'elegir',
 $j${"frase": "Walk down the ___ to find the rice.", "opciones": ["aisle", "isle", "idle", "I'll"], "correcta": 0, "es": "Camina por el pasillo para encontrar el arroz.", "explicacion": "aisle = pasillo (de una tienda)."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-05', 'ep15-homofonos', 5, 'escribir',
 $j${"respuestas": ["bear"], "mostrar": "We saw a bear in the forest.", "es": "Vimos un oso en el bosque.", "explicacion": "bear (oso) suena igual que bare (desnudo)."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-06', 'ep15-homofonos', 6, 'ordenar',
 $j${"frase": "The bride walked toward the altar .", "es": "La novia caminó hacia el altar.", "explicacion": "altar (altar) suena igual que alter (cambiar)."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-07', 'ep15-homofonos', 7, 'emparejar',
 $j${"pares": [["air / heir", "aire / heredero"], ["ate / eight", "comió / ocho"], ["isle / aisle", "isla / pasillo"], ["bear / bare", "oso / desnudo"]], "es": "", "explicacion": "Pares de homófonos: misma pronunciación, distinta escritura y significado."}$j$::jsonb,
 'ep15-homofonos', 'estudio', false),
('ep15-homo-08', 'ep15-homofonos', 8, 'escuchar',
 $j${"opciones": ["We ate at eight o'clock.", "We eight at eight o'clock.", "We ate at ate o'clock.", "We eat at eight o'clock."], "correcta": 0, "audio": "We ate at eight o'clock.", "es": "Comimos a las ocho.", "explicacion": "ate (pasado) y eight (ocho) suenan igual."}$j$::jsonb,
 'ep15-homofonos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-homo-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Do you know where the cereal is?", "es": "¿Sabes dónde está el cereal?"}, {"en": "It's in aisle five, next to the rice.", "es": "Está en el pasillo cinco, al lado del arroz."}], "pregunta": "Where is the cereal?", "pregunta_es": "¿Dónde está el cereal?", "opciones": ["In aisle five", "On the isle", "In the air", "In the altar"], "correcta": 0, "explicacion": "'It's in aisle five' = pasillo cinco."}$j$::jsonb,
 'ep15-homofonos', 'input', false),
('banco-ep15-homo-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "I ate dinner at eight last night.", "es": "Cené a las ocho anoche."}, {"en": "Oh, that's late for you!", "es": "¡Oh, eso es tarde para ti!"}], "pregunta": "What time did the speaker eat dinner?", "pregunta_es": "¿A qué hora cenó el hablante?", "opciones": ["At eight", "At seven", "At nine", "At ten"], "correcta": 0, "explicacion": "'I ate dinner at eight last night.'"}$j$::jsonb,
 'ep15-homofonos', 'input', false),
('banco-ep15-homo-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Comí a las ocho.", "respuestas": ["I ate at eight."], "mostrar": "I ate at eight.", "explicacion": "ate = comí (pasado), eight = ocho."}$j$::jsonb,
 'ep15-homofonos', 'output', false),
('banco-ep15-homo-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: El oso está en el bosque.", "respuestas": ["The bear is in the forest."], "mostrar": "The bear is in the forest.", "explicacion": "bear = oso."}$j$::jsonb,
 'ep15-homofonos', 'output', false),
('banco-ep15-homo-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Make two sentences, one with 'ate' and one with 'eight'. Say them out loud.", "pregunta_es": "Haz dos frases, una con 'ate' y otra con 'eight'. Dilas en voz alta.", "ejemplo": "I ate pizza yesterday. My team has eight players."}$j$::jsonb,
 'ep15-homofonos', 'output', false),
('banco-ep15-homo-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "We ___ lunch at noon. (pasado)", "opciones": ["ate", "eight", "at"], "correcta": 0, "es": "Almorzamos al mediodía.", "explicacion": "ate = pasado de eat.", "segundos": 5}$j$::jsonb,
 'ep15-homofonos', 'fluidez', false),
('banco-ep15-homo-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "There are ___ cookies.", "opciones": ["eight", "ate", "aisle"], "correcta": 0, "es": "Hay ocho galletas.", "explicacion": "eight = ocho.", "segundos": 5}$j$::jsonb,
 'ep15-homofonos', 'fluidez', false),
('banco-ep15-homo-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "Find it in ___ three.", "opciones": ["aisle", "isle", "idle"], "correcta": 0, "es": "Búscalo en el pasillo tres.", "explicacion": "aisle = pasillo.", "segundos": 5}$j$::jsonb,
 'ep15-homofonos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-homo-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "The ___ of the family will get the house.", "opciones": ["heir", "air", "hair"], "correcta": 0, "es": "El heredero de la familia recibirá la casa.", "explicacion": "heir = heredero."}$j$::jsonb,
 'ep15-homofonos', 'estudio', true),
('examen-ep15-homo-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["ate"], "mostrar": "She ate the cake yesterday.", "es": "Ella se comió el pastel ayer.", "explicacion": "ate = pasado de eat."}$j$::jsonb,
 'ep15-homofonos', 'estudio', true),
('examen-ep15-homo-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["The boat is near the isle.", "The boat is near the aisle.", "The boat is near the idle.", "The boat is near the aide."], "correcta": 0, "audio": "The boat is near the isle.", "es": "El barco está cerca de la isla.", "explicacion": "isle = isla."}$j$::jsonb,
 'ep15-homofonos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 8: ep15-significado-homofonos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep15-sign-01', 'ep15-significado-homofonos', 1, 'elegir',
 $j${"frase": "Please don't ___ the plan without asking me.", "opciones": ["alter", "altar", "altered", "alters"], "correcta": 0, "es": "Por favor no cambies el plan sin preguntarme.", "explicacion": "alter = cambiar o modificar."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-02', 'ep15-significado-homofonos', 2, 'elegir',
 $j${"frase": "The wedding ceremony took place at the ___.", "opciones": ["altar", "alter", "altered", "alters"], "correcta": 0, "es": "La ceremonia de boda tuvo lugar en el altar.", "explicacion": "altar = lugar elevado para ceremonias religiosas."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-03', 'ep15-significado-homofonos', 3, 'elegir',
 $j${"frase": "The baby began to ___ loudly.", "opciones": ["bawl", "ball", "bail", "bale"], "correcta": 0, "es": "El bebé empezó a llorar a gritos.", "explicacion": "bawl = llorar a gritos."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-04', 'ep15-significado-homofonos', 4, 'elegir',
 $j${"frase": "Kids kicked the ___ across the field.", "opciones": ["ball", "bawl", "bale", "bail"], "correcta": 0, "es": "Los niños patearon la pelota por el campo.", "explicacion": "ball = pelota."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-05', 'ep15-significado-homofonos', 5, 'escribir',
 $j${"respuestas": ["bare"], "mostrar": "The tree was bare in winter.", "es": "El árbol estaba sin hojas en invierno.", "explicacion": "bare = desnudo, sin cubierta."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-06', 'ep15-significado-homofonos', 6, 'ordenar',
 $j${"frase": "The heir will inherit the castle .", "es": "El heredero heredará el castillo.", "explicacion": "heir = persona con derecho a heredar."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-07', 'ep15-significado-homofonos', 7, 'emparejar',
 $j${"pares": [["alter", "cambiar"], ["altar", "altar"], ["bawl", "llorar a gritos"], ["isle", "isla pequeña"]], "es": "", "explicacion": "Significados de homófonos del nivel."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', false),
('ep15-sign-08', 'ep15-significado-homofonos', 8, 'escuchar',
 $j${"opciones": ["The baby began to bawl.", "The baby began to ball.", "The baby began to bail.", "The baby began to bale."], "correcta": 0, "audio": "The baby began to bawl.", "es": "El bebé empezó a llorar a gritos.", "explicacion": "bawl = llorar a gritos."}$j$::jsonb,
 'ep15-significado-homofonos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep15-sign-01', 'banco-ep15', 1, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Can you alter this dress? It's too long.", "es": "¿Puedes modificar este vestido? Está muy largo."}, {"en": "Sure, I can make it shorter.", "es": "Claro, puedo hacerlo más corto."}], "pregunta": "What does the speaker want?", "pregunta_es": "¿Qué quiere el hablante?", "opciones": ["To change the dress", "To buy a new dress", "To find the altar", "To sell the dress"], "correcta": 0, "explicacion": "'Can you alter this dress?' = ¿puedes modificarlo?"}$j$::jsonb,
 'ep15-significado-homofonos', 'input', false),
('banco-ep15-sign-02', 'banco-ep15', 2, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "The kids are playing with a ball in the park.", "es": "Los niños juegan con una pelota en el parque."}, {"en": "Careful, don't let the baby bawl!", "es": "¡Cuidado, no dejen que el bebé llore a gritos!"}], "pregunta": "What is the object the kids use?", "pregunta_es": "¿Qué objeto usan los niños?", "opciones": ["A ball", "An altar", "An isle", "A bear"], "correcta": 0, "explicacion": "'The kids are playing with a ball.'"}$j$::jsonb,
 'ep15-significado-homofonos', 'input', false),
('banco-ep15-sign-03', 'banco-ep15', 3, 'decir',
 $j${"es": "Di: Quiero cambiar el plan.", "respuestas": ["I want to alter the plan."], "mostrar": "I want to alter the plan.", "explicacion": "alter = cambiar."}$j$::jsonb,
 'ep15-significado-homofonos', 'output', false),
('banco-ep15-sign-04', 'banco-ep15', 4, 'decir',
 $j${"es": "Di: Mi hermano es el heredero.", "respuestas": ["My brother is the heir."], "mostrar": "My brother is the heir.", "explicacion": "heir = heredero."}$j$::jsonb,
 'ep15-significado-homofonos', 'output', false),
('banco-ep15-sign-05', 'banco-ep15', 5, 'libre',
 $j${"pregunta": "Explain in your own words the difference between 'alter' and 'altar', and give one example for each.", "pregunta_es": "Explica con tus palabras la diferencia entre 'alter' y 'altar', y da un ejemplo de cada una.", "ejemplo": "I want to alter my shirt. The priest stood at the altar."}$j$::jsonb,
 'ep15-significado-homofonos', 'output', false),
('banco-ep15-sign-06', 'banco-ep15', 6, 'rapido',
 $j${"frase": "Please don't ___ the rules.", "opciones": ["alter", "altar", "bawl"], "correcta": 0, "es": "Por favor no cambies las reglas.", "explicacion": "alter = cambiar.", "segundos": 5}$j$::jsonb,
 'ep15-significado-homofonos', 'fluidez', false),
('banco-ep15-sign-07', 'banco-ep15', 7, 'rapido',
 $j${"frase": "The ___ was decorated with flowers.", "opciones": ["altar", "alter", "ball"], "correcta": 0, "es": "El altar estaba decorado con flores.", "explicacion": "altar = altar.", "segundos": 5}$j$::jsonb,
 'ep15-significado-homofonos', 'fluidez', false),
('banco-ep15-sign-08', 'banco-ep15', 8, 'rapido',
 $j${"frase": "The ___ is a small island.", "opciones": ["isle", "aisle", "bare"], "correcta": 0, "es": "La isla es una pequeña isla.", "explicacion": "isle = isla.", "segundos": 5}$j$::jsonb,
 'ep15-significado-homofonos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep15-sign-01', 'examen-ep15', 1, 'elegir',
 $j${"frase": "The church has a beautiful ___.", "opciones": ["altar", "alter", "altered"], "correcta": 0, "es": "La iglesia tiene un altar hermoso.", "explicacion": "altar."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', true),
('examen-ep15-sign-02', 'examen-ep15', 2, 'escribir',
 $j${"respuestas": ["bawl"], "mostrar": "The child started to bawl.", "es": "El niño empezó a llorar a gritos.", "explicacion": "bawl = llorar a gritos."}$j$::jsonb,
 'ep15-significado-homofonos', 'estudio', true),
('examen-ep15-sign-03', 'examen-ep15', 3, 'escuchar',
 $j${"opciones": ["Don't alter the schedule.", "Don't altar the schedule.", "Don't alter the scheduled.", "Don't altar the scheduled."], "correcta": 0, "audio": "Don't alter the schedule.", "es": "No cambies el horario.", "explicacion": "alter = cambiar."}$j$::jsonb,
 'ep15-significado-homofonos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;