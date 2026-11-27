-- =====================================================================
-- 026 · Episodio 17 completo (Unidades 35 y 36 del Libro 3)
--   - 8 temas nuevos en pensum_temas (orden 1-8 del Episodio 17):
--     Unidad 35 (Gerunds and Infinitives / Review): verbos + gerundio,
--       verbos + infinitivo, go/have + -ing, stop/remember/try (cambio de significado).
--     Unidad 36 (Leisure: Literature & Movies): libros y películas, gustos
--       y preferencias, verbos de percepción, objetos directos e indirectos.
--   - 8 lecciones tipo 'tema' (8 ejercicios cada una)
--   - banco-ep17 +8·8 = 64 ejercicios de práctica
--   - examen-ep17 +8·3 = 24 ejercicios reservados
--   - 8×19 = 152 ejercicios en total
--   - 'escuchar' de lección y examen va pata 'input'.
-- Requiere 006, 007, 008 y 011. Se puede correr varias veces sin dañar nada.
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================

insert into unidades (materia_id, numero, episodio, objetivo) values
  ('ingles', 35, 'Episodio 17', 'Gerunds and infinitives: verbs followed by -ing or to, go/have + -ing, stop/remember/try'),
  ('ingles', 36, 'Episodio 17', 'Books and movies, likes and preferences, perception verbs, direct and indirect objects')
on conflict (materia_id, numero) do update set
  episodio = excluded.episodio,
  objetivo = coalesce(nullif(unidades.objetivo, ''), excluded.objetivo);

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('banco-ep17', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 35), 17, 90, 'banco', 'Banco de ejercicios Episodio 17', 'Ejercicios de refuerzo - Episodio 17'),
  ('examen-ep17', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 35), 17, 91, 'examen', 'Examen Episodio 17', 'Evaluación - Episodio 17')
on conflict (id) do update set
  materia_id = excluded.materia_id, unidad_id = excluded.unidad_id, episodio = excluded.episodio,
  orden = excluded.orden, tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;

insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep17-gerundios-verbos', 17, 1, $t$Verbos seguidos de gerundio$t$, $t$Verbs followed by gerund$t$, $t$enjoy, avoid, finish, mind, suggest: después van con -ing. Ej.: I enjoy swimming.$t$),
  ('ep17-infinitivos-verbos', 17, 2, $t$Verbos seguidos de infinitivo$t$, $t$Verbs followed by infinitive$t$, $t$want, decide, hope, promise, agree, offer, refuse: van con to + verbo. Ej.: I want to swim.$t$),
  ('ep17-go-have-ing', 17, 3, $t$Go y have + -ing$t$, $t$Go and have + -ing$t$, $t$go shopping, go hiking, have fun, have trouble: actividades y expresiones con go/have + -ing.$t$),
  ('ep17-stop-remember', 17, 4, $t$Gerundio o infinitivo: cambia el significado$t$, $t$Gerund or infinitive: meaning changes$t$, $t$stop, remember, forget, try: stop smoking (dejar de fumar) vs stop to smoke (parar para fumar).$t$),
  ('ep17-cine-literatura', 17, 5, $t$Libros y películas$t$, $t$Books and movies$t$, $t$novel, thriller, horror film, action film, foreign film, tear-jerker, plot: vocabulario de literatura y cine.$t$),
  ('ep17-gustos-preferencias', 17, 6, $t$Expresar gustos y preferencias$t$, $t$Expressing likes and preferences$t$, $t$I'm crazy about, I adore, I can't stand, I don't mind, I'd love to: expresiones de gusto.$t$),
  ('ep17-percepcion', 17, 7, $t$Verbos de percepción: see, hear, watch$t$, $t$Perception verbs: see, hear, watch$t$, $t$I saw them running (los vi en plena acción) / I saw them run (vi toda la acción).$t$),
  ('ep17-objetos-directos-indirectos', 17, 8, $t$Objetos directos e indirectos$t$, $t$Direct and indirect objects$t$, $t$Directo = qué (I read the article). Indirecto = a quién (I read Peter the article / I read the article to Peter).$t$)
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden,
  nombre_es = excluded.nombre_es, nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('ep17-gerundios-verbos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 35), 17, 1, 'tema', $t$Verbs followed by gerund$t$, $t$enjoy, avoid, finish, mind, suggest: después van con -ing. Ej.: I enjoy swimming.$t$),
  ('ep17-infinitivos-verbos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 35), 17, 2, 'tema', $t$Verbs followed by infinitive$t$, $t$want, decide, hope, promise, agree, offer, refuse: van con to + verbo. Ej.: I want to swim.$t$),
  ('ep17-go-have-ing', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 35), 17, 3, 'tema', $t$Go and have + -ing$t$, $t$go shopping, go hiking, have fun, have trouble: actividades y expresiones con go/have + -ing.$t$),
  ('ep17-stop-remember', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 35), 17, 4, 'tema', $t$Gerund or infinitive: meaning changes$t$, $t$stop, remember, forget, try: stop smoking (dejar de fumar) vs stop to smoke (parar para fumar).$t$),
  ('ep17-cine-literatura', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 36), 17, 5, 'tema', $t$Books and movies$t$, $t$novel, thriller, horror film, action film, foreign film, tear-jerker, plot: vocabulario de literatura y cine.$t$),
  ('ep17-gustos-preferencias', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 36), 17, 6, 'tema', $t$Expressing likes and preferences$t$, $t$I'm crazy about, I adore, I can't stand, I don't mind, I'd love to: expresiones de gusto.$t$),
  ('ep17-percepcion', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 36), 17, 7, 'tema', $t$Perception verbs: see, hear, watch$t$, $t$I saw them running (los vi en plena acción) / I saw them run (vi toda la acción).$t$),
  ('ep17-objetos-directos-indirectos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 36), 17, 8, 'tema', $t$Direct and indirect objects$t$, $t$Directo = qué (I read the article). Indirecto = a quién (I read Peter the article / I read the article to Peter).$t$)
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;


-- EJERCICIOS — TEMA 1: ep17-gerundios-verbos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-gerv-01', 'ep17-gerundios-verbos', 1, 'elegir',
 $j${"frase": "I enjoy ___ in the morning.", "opciones": ["swimming", "to swim", "swim", "swam"], "correcta": 0, "es": "Me gusta nadar por la mañana.", "explicacion": "enjoy + gerundio (-ing)."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-02', 'ep17-gerundios-verbos', 2, 'elegir',
 $j${"frase": "She avoids ___ fast food.", "opciones": ["eating", "to eat", "eat", "ate"], "correcta": 0, "es": "Ella evita comer comida rápida.", "explicacion": "avoid + gerundio."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-03', 'ep17-gerundios-verbos', 3, 'elegir',
 $j${"frase": "We finished ___ the report.", "opciones": ["writing", "to write", "write", "written"], "correcta": 0, "es": "Terminamos de escribir el informe.", "explicacion": "finish + gerundio."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-04', 'ep17-gerundios-verbos', 4, 'elegir',
 $j${"frase": "Do you mind ___ the window?", "opciones": ["opening", "to open", "open", "opened"], "correcta": 0, "es": "¿Te importa abrir la ventana?", "explicacion": "mind + gerundio."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-05', 'ep17-gerundios-verbos', 5, 'escribir',
 $j${"respuestas": ["i enjoy reading"], "mostrar": "I enjoy reading.", "es": "Me gusta leer.", "explicacion": "enjoy + -ing."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-06', 'ep17-gerundios-verbos', 6, 'ordenar',
 $j${"frase": "He suggested visiting the museum.", "es": "Él sugirió visitar el museo.", "explicacion": "suggest + gerundio."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-07', 'ep17-gerundios-verbos', 7, 'emparejar',
 $j${"pares": [["enjoy", "disfrutar"], ["avoid", "evitar"], ["finish", "terminar"], ["mind", "importarle a alguien"]], "es": "", "explicacion": "Verbos + gerundio básicos."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', false),
('ep17-gerv-08', 'ep17-gerundios-verbos', 8, 'escuchar',
 $j${"opciones": ["I can't stop laughing.", "I can't to laugh.", "I can't laughing to.", "I can't laughs."], "correcta": 0, "audio": "I can't stop laughing.", "es": "No puedo dejar de reír.", "explicacion": "stop + gerundio (dejar de)."}$j$::jsonb,
 'ep17-gerundios-verbos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-gerv-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "I suggest taking a taxi. It's raining a lot.", "es": "Sugiero tomar un taxi. Está lloviendo mucho."}, {"en": "Great idea. I don't mind paying for it.", "es": "Buena idea. No me importa pagarlo."}], "pregunta": "What does the speaker suggest?", "pregunta_es": "¿Qué sugiere el hablante?", "opciones": ["Taking a taxi", "Walking home", "Staying at home", "Buying a car"], "correcta": 0, "explicacion": "'I suggest taking a taxi.'"}$j$::jsonb,
 'ep17-gerundios-verbos', 'input', false),
('banco-ep17-gerv-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "My brother avoids eating sugar.", "es": "Mi hermano evita comer azúcar."}, {"en": "He finished doing his exercises.", "es": "Terminó de hacer sus ejercicios."}], "pregunta": "What did the brother finish?", "pregunta_es": "¿Qué terminó el hermano?", "opciones": ["Doing his exercises", "Eating sugar", "Buying a car", "Taking a taxi"], "correcta": 0, "explicacion": "'He finished doing his exercises.'"}$j$::jsonb,
 'ep17-gerundios-verbos', 'input', false),
('banco-ep17-gerv-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Me gusta cocinar.", "respuestas": ["i enjoy cooking"], "mostrar": "I enjoy cooking.", "explicacion": "enjoy + -ing."}$j$::jsonb,
 'ep17-gerundios-verbos', 'output', false),
('banco-ep17-gerv-04', 'banco-ep17', 4, 'decir',
 $j${"es": "Sugiero comprar un libro.", "respuestas": ["i suggest buying a book"], "mostrar": "I suggest buying a book.", "explicacion": "suggest + gerundio."}$j$::jsonb,
 'ep17-gerundios-verbos', 'output', false),
('banco-ep17-gerv-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Write two sentences about things you enjoy, avoid or finish doing.", "pregunta_es": "Escribe dos frases sobre cosas que disfrutas, evitas o terminas de hacer.", "ejemplo": "I enjoy cooking. I avoid eating late at night.", "criterio": "verbo + -ing.", "explicacion": "Cada verbo de esta lista va seguido de -ing."}$j$::jsonb,
 'ep17-gerundios-verbos', 'output', false),
('banco-ep17-gerv-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "I enjoy ___ music.", "opciones": ["listening to", "to listen to"], "correcta": 0, "es": "Me gusta escuchar música.", "explicacion": "enjoy + gerundio.", "segundos": 5}$j$::jsonb,
 'ep17-gerundios-verbos', 'fluidez', false),
('banco-ep17-gerv-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "She finished ___ her homework.", "opciones": ["doing", "to do"], "correcta": 0, "es": "Ella terminó de hacer su tarea.", "explicacion": "finish + gerundio.", "segundos": 5}$j$::jsonb,
 'ep17-gerundios-verbos', 'fluidez', false),
('banco-ep17-gerv-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "Do you mind ___ the door?", "opciones": ["closing", "to close"], "correcta": 0, "es": "¿Te importa cerrar la puerta?", "explicacion": "mind + gerundio.", "segundos": 5}$j$::jsonb,
 'ep17-gerundios-verbos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-gerv-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "We avoid ___ late at night.", "opciones": ["driving", "to drive", "drive"], "correcta": 0, "es": "Evitamos conducir de noche.", "explicacion": "avoid + gerundio."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', true),
('examen-ep17-gerv-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i finished reading"], "mostrar": "I finished reading the book.", "es": "Terminé de leer el libro.", "explicacion": "finish + -ing."}$j$::jsonb,
 'ep17-gerundios-verbos', 'estudio', true),
('examen-ep17-gerv-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["We enjoy swimming in the sea.", "We enjoy swim in the sea.", "We enjoy to swim in the sea.", "We enjoys swimming in the sea."], "correcta": 0, "audio": "We enjoy swimming in the sea.", "es": "Disfrutamos nadar en el mar.", "explicacion": "enjoy + -ing."}$j$::jsonb,
 'ep17-gerundios-verbos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 2: ep17-infinitivos-verbos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-infv-01', 'ep17-infinitivos-verbos', 1, 'elegir',
 $j${"frase": "I want ___ a new car.", "opciones": ["to buy", "buying", "buy", "bought"], "correcta": 0, "es": "Quiero comprar un carro nuevo.", "explicacion": "want + to + verbo."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-02', 'ep17-infinitivos-verbos', 2, 'elegir',
 $j${"frase": "They decided ___ home early.", "opciones": ["to go", "going", "go", "went"], "correcta": 0, "es": "Decidieron irse a casa temprano.", "explicacion": "decide + to + verbo."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-03', 'ep17-infinitivos-verbos', 3, 'elegir',
 $j${"frase": "She promised ___ on time.", "opciones": ["to be", "being", "be", "been"], "correcta": 0, "es": "Ella prometió estar a tiempo.", "explicacion": "promise + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-04', 'ep17-infinitivos-verbos', 4, 'elegir',
 $j${"frase": "I hope ___ you soon.", "opciones": ["to see", "seeing", "see", "saw"], "correcta": 0, "es": "Espero verte pronto.", "explicacion": "hope + to + verbo."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-05', 'ep17-infinitivos-verbos', 5, 'escribir',
 $j${"respuestas": ["i want to learn english"], "mostrar": "I want to learn English.", "es": "Quiero aprender inglés.", "explicacion": "want + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-06', 'ep17-infinitivos-verbos', 6, 'ordenar',
 $j${"frase": "They agreed to meet tomorrow.", "es": "Acordaron reunirse mañana.", "explicacion": "agree + to + verbo."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-07', 'ep17-infinitivos-verbos', 7, 'emparejar',
 $j${"pares": [["want to", "querer"], ["decide to", "decidir"], ["hope to", "esperar"], ["promise to", "prometer"]], "es": "", "explicacion": "Verbos + to + verbo."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', false),
('ep17-infv-08', 'ep17-infinitivos-verbos', 8, 'escuchar',
 $j${"opciones": ["He refused to answer.", "He refused answering.", "He refuse to answers.", "He refused answer to."], "correcta": 0, "audio": "He refused to answer.", "es": "Se negó a responder.", "explicacion": "refuse + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-infv-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "I need to finish this project by Friday.", "es": "Necesito terminar este proyecto antes del viernes."}, {"en": "I hope to finish it early.", "es": "Espero terminarlo temprano."}], "pregunta": "When does the speaker need to finish the project?", "pregunta_es": "¿Cuándo necesita terminar el proyecto el hablante?", "opciones": ["By Friday", "On Monday", "Next year", "Never"], "correcta": 0, "explicacion": "'I need to finish this project by Friday.'"}$j$::jsonb,
 'ep17-infinitivos-verbos', 'input', false),
('banco-ep17-infv-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "We planned to visit Cartagena in May.", "es": "Planeamos visitar Cartagena en mayo."}, {"en": "We decided to stay in a hotel near the beach.", "es": "Decidimos quedarnos en un hotel cerca de la playa."}], "pregunta": "Where did they decide to stay?", "pregunta_es": "¿Dónde decidieron quedarse?", "opciones": ["In a hotel near the beach", "In a friend's house", "In Bogotá", "In a hostel in the mountains"], "correcta": 0, "explicacion": "'We decided to stay in a hotel near the beach.'"}$j$::jsonb,
 'ep17-infinitivos-verbos', 'input', false),
('banco-ep17-infv-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Quiero aprender inglés.", "respuestas": ["i want to learn english"], "mostrar": "I want to learn English.", "explicacion": "want + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'output', false),
('banco-ep17-infv-04', 'banco-ep17', 4, 'decir',
 $j${"es": "Decidimos viajar mañana.", "respuestas": ["we decided to travel tomorrow"], "mostrar": "We decided to travel tomorrow.", "explicacion": "decide + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'output', false),
('banco-ep17-infv-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Write two sentences with want to, decide to or hope to about your plans.", "pregunta_es": "Escribe dos frases con want to, decide to u hope to sobre tus planes.", "ejemplo": "I want to learn more English. I hope to travel next year.", "criterio": "verbo + to + verbo base.", "explicacion": "Usa to + verbo base después de estos verbos."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'output', false),
('banco-ep17-infv-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "I want ___ a doctor.", "opciones": ["to be", "being"], "correcta": 0, "es": "Quiero ser doctor.", "explicacion": "want + to.", "segundos": 5}$j$::jsonb,
 'ep17-infinitivos-verbos', 'fluidez', false),
('banco-ep17-infv-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "She agreed ___ the meeting.", "opciones": ["to join", "joining"], "correcta": 0, "es": "Ella aceptó unirse a la reunión.", "explicacion": "agree + to.", "segundos": 5}$j$::jsonb,
 'ep17-infinitivos-verbos', 'fluidez', false),
('banco-ep17-infv-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "They refused ___ the money.", "opciones": ["to take", "taking"], "correcta": 0, "es": "Se negaron a tomar el dinero.", "explicacion": "refuse + to.", "segundos": 5}$j$::jsonb,
 'ep17-infinitivos-verbos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-infv-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "I plan ___ a house next year.", "opciones": ["to buy", "buying", "buy"], "correcta": 0, "es": "Planeo comprar una casa el próximo año.", "explicacion": "plan + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', true),
('examen-ep17-infv-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i hope to see you soon"], "mostrar": "I hope to see you soon.", "es": "Espero verte pronto.", "explicacion": "hope + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'estudio', true),
('examen-ep17-infv-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["She offered to help us.", "She offered helping us.", "She offer to help us.", "She offers helped us."], "correcta": 0, "audio": "She offered to help us.", "es": "Ella se ofreció a ayudarnos.", "explicacion": "offer + to."}$j$::jsonb,
 'ep17-infinitivos-verbos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 3: ep17-go-have-ing
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-goha-01', 'ep17-go-have-ing', 1, 'elegir',
 $j${"frase": "We like to go ___ on weekends.", "opciones": ["hiking", "hike", "to hike", "hiked"], "correcta": 0, "es": "Nos gusta ir de excursión los fines de semana.", "explicacion": "go + -ing para actividades."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-02', 'ep17-go-have-ing', 2, 'elegir',
 $j${"frase": "I'm going ___ this afternoon.", "opciones": ["shopping", "shop", "shops", "to shop"], "correcta": 0, "es": "Voy de compras esta tarde.", "explicacion": "go shopping = ir de compras."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-03', 'ep17-go-have-ing', 3, 'elegir',
 $j${"frase": "Did you have ___ at the party?", "opciones": ["fun", "funny", "funs", "funned"], "correcta": 0, "es": "¿Te divertiste en la fiesta?", "explicacion": "have fun = divertirse."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-04', 'ep17-go-have-ing', 4, 'elegir',
 $j${"frase": "They go ___ every summer.", "opciones": ["swimming", "swim", "swam", "to swimming"], "correcta": 0, "es": "Ellos van a nadar cada verano.", "explicacion": "go swimming."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-05', 'ep17-go-have-ing', 5, 'escribir',
 $j${"respuestas": ["we went fishing"], "mostrar": "We went fishing.", "es": "Fuimos a pescar.", "explicacion": "go fishing (pasado: went)."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-06', 'ep17-go-have-ing', 6, 'ordenar',
 $j${"frase": "We had a great time at the beach.", "es": "Lo pasamos muy bien en la playa.", "explicacion": "have a great time = pasarla bien."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-07', 'ep17-go-have-ing', 7, 'emparejar',
 $j${"pares": [["go shopping", "ir de compras"], ["go hiking", "ir de excursión"], ["have fun", "divertirse"], ["have trouble", "tener problemas"]], "es": "", "explicacion": "Expresiones con go y have."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', false),
('ep17-goha-08', 'ep17-go-have-ing', 8, 'escuchar',
 $j${"opciones": ["I had trouble finding the house.", "I had troubles to find house.", "I had trouble to find the house.", "I have troubles finding house."], "correcta": 0, "audio": "I had trouble finding the house.", "es": "Me costó trabajo encontrar la casa.", "explicacion": "have trouble + -ing."}$j$::jsonb,
 'ep17-go-have-ing', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-goha-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "On Sundays we go hiking in the mountains.", "es": "Los domingos vamos de excursión a las montañas."}, {"en": "We always have a great time together.", "es": "Siempre la pasamos muy bien juntos."}], "pregunta": "What do they do on Sundays?", "pregunta_es": "¿Qué hacen los domingos?", "opciones": ["They go hiking", "They go shopping", "They go swimming", "They stay at home"], "correcta": 0, "explicacion": "'On Sundays we go hiking.'"}$j$::jsonb,
 'ep17-go-have-ing', 'input', false),
('banco-ep17-goha-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "My sister goes jogging every morning.", "es": "Mi hermana trota todas las mañanas."}, {"en": "She says she has no trouble waking up early.", "es": "Dice que no le cuesta trabajo levantarse temprano."}], "pregunta": "What does the sister do every morning?", "pregunta_es": "¿Qué hace la hermana cada mañana?", "opciones": ["She goes jogging", "She goes shopping", "She goes fishing", "She sleeps"], "correcta": 0, "explicacion": "'She goes jogging' en la primera frase."}$j$::jsonb,
 'ep17-go-have-ing', 'input', false),
('banco-ep17-goha-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Vamos de compras los sábados.", "respuestas": ["we go shopping on saturdays"], "mostrar": "We go shopping on Saturdays.", "explicacion": "go shopping."}$j$::jsonb,
 'ep17-go-have-ing', 'output', false),
('banco-ep17-goha-04', 'banco-ep17', 4, 'decir',
 $j${"es": "Me divertí mucho.", "respuestas": ["i had a lot of fun", "i had lots of fun"], "mostrar": "I had a lot of fun.", "explicacion": "have fun."}$j$::jsonb,
 'ep17-go-have-ing', 'output', false),
('banco-ep17-goha-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Write two sentences about activities you go or went doing. Use go + -ing.", "pregunta_es": "Escribe dos frases sobre actividades que haces o hiciste. Usa go + -ing.", "ejemplo": "I go swimming every week. Last month we went camping.", "criterio": "go + -ing.", "explicacion": "go + -ing para actividades."}$j$::jsonb,
 'ep17-go-have-ing', 'output', false),
('banco-ep17-goha-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "We go ___ on Fridays.", "opciones": ["dancing", "dance"], "correcta": 0, "es": "Vamos a bailar los viernes.", "explicacion": "go dancing.", "segundos": 5}$j$::jsonb,
 'ep17-go-have-ing', 'fluidez', false),
('banco-ep17-goha-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "Did you have ___?", "opciones": ["fun", "funny"], "correcta": 0, "es": "¿Te divertiste?", "explicacion": "have fun.", "segundos": 5}$j$::jsonb,
 'ep17-go-have-ing', 'fluidez', false),
('banco-ep17-goha-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "I have ___ with my car.", "opciones": ["trouble", "troubles"], "correcta": 0, "es": "Tengo problemas con mi carro.", "explicacion": "have trouble (sin s).", "segundos": 5}$j$::jsonb,
 'ep17-go-have-ing', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-goha-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "She goes ___ every Saturday.", "opciones": ["shopping", "shop", "shops"], "correcta": 0, "es": "Ella va de compras cada sábado.", "explicacion": "go shopping."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', true),
('examen-ep17-goha-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i had fun at the party"], "mostrar": "I had fun at the party.", "es": "Me divertí en la fiesta.", "explicacion": "have fun."}$j$::jsonb,
 'ep17-go-have-ing', 'estudio', true),
('examen-ep17-goha-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["They go camping in the summer.", "They go to camp in the summer.", "They goes camping in the summer.", "They go camp in the summer."], "correcta": 0, "audio": "They go camping in the summer.", "es": "Ellos van de camping en verano.", "explicacion": "go camping."}$j$::jsonb,
 'ep17-go-have-ing', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 4: ep17-stop-remember
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-stop-01', 'ep17-stop-remember', 1, 'elegir',
 $j${"frase": "I remember ___ the door.", "opciones": ["locking", "to lock", "lock", "locked"], "correcta": 0, "es": "Recuerdo haber cerrado la puerta.", "explicacion": "remember + -ing = recordar algo que ya pasó."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-02', 'ep17-stop-remember', 2, 'elegir',
 $j${"frase": "Please remember ___ the lights.", "opciones": ["to turn off", "turning off", "turn off", "turned off"], "correcta": 0, "es": "Por favor recuerda apagar las luces.", "explicacion": "remember + to = acordarse de hacer algo."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-03', 'ep17-stop-remember', 3, 'elegir',
 $j${"frase": "She stopped ___ coffee.", "opciones": ["drinking", "to drink", "drink", "drank"], "correcta": 0, "es": "Ella dejó de tomar café.", "explicacion": "stop + -ing = dejar de hacer algo."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-04', 'ep17-stop-remember', 4, 'elegir',
 $j${"frase": "I tried ___ the problem, but I couldn't.", "opciones": ["to solve", "solving", "solve", "solved"], "correcta": 0, "es": "Intenté resolver el problema, pero no pude.", "explicacion": "try + to = intentar."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-05', 'ep17-stop-remember', 5, 'escribir',
 $j${"respuestas": ["she stopped smoking"], "mostrar": "She stopped smoking.", "es": "Ella dejó de fumar.", "explicacion": "stop + -ing."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-06', 'ep17-stop-remember', 6, 'ordenar',
 $j${"frase": "I stopped to buy some bread.", "es": "Me detuve a comprar pan.", "explicacion": "stop + to = parar para hacer algo."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-07', 'ep17-stop-remember', 7, 'emparejar',
 $j${"pares": [["stop smoking", "dejar de fumar"], ["stop to smoke", "parar para fumar"], ["remember to call", "acordarse de llamar"], ["try to help", "intentar ayudar"]], "es": "", "explicacion": "Gerundio o infinitivo según el significado."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', false),
('ep17-stop-08', 'ep17-stop-remember', 8, 'escuchar',
 $j${"opciones": ["I forgot to call my mom.", "I forgot calling my mom.", "I forget to calls my mom.", "I forgot call my mom."], "correcta": 0, "audio": "I forgot to call my mom.", "es": "Olvidé llamar a mi mamá.", "explicacion": "forget + to = olvidar hacer algo (no lo hice)."}$j$::jsonb,
 'ep17-stop-remember', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-stop-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "I stopped to take a photo of the mountain.", "es": "Me detuve para tomar una foto de la montaña."}, {"en": "I remember taking many photos there.", "es": "Recuerdo haber tomado muchas fotos allí."}], "pregunta": "Why did the speaker stop?", "pregunta_es": "¿Por qué se detuvo el hablante?", "opciones": ["To take a photo", "To smoke", "To eat lunch", "To call a friend"], "correcta": 0, "explicacion": "'I stopped to take a photo.'"}$j$::jsonb,
 'ep17-stop-remember', 'input', false),
('banco-ep17-stop-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "He stopped smoking last year.", "es": "Dejó de fumar el año pasado."}, {"en": "Now he tries to exercise every day.", "es": "Ahora intenta hacer ejercicio todos los días."}], "pregunta": "What did he stop doing?", "pregunta_es": "¿Qué dejó de hacer?", "opciones": ["Smoking", "Exercising", "Eating", "Running"], "correcta": 0, "explicacion": "'He stopped smoking last year.'"}$j$::jsonb,
 'ep17-stop-remember', 'input', false),
('banco-ep17-stop-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Dejé de comer carne.", "respuestas": ["i stopped eating meat"], "mostrar": "I stopped eating meat.", "explicacion": "stop + -ing."}$j$::jsonb,
 'ep17-stop-remember', 'output', false),
('banco-ep17-stop-04', 'banco-ep17', 4, 'decir',
 $j${"es": "No olvides llamarme.", "respuestas": ["don't forget to call me", "do not forget to call me"], "mostrar": "Don't forget to call me.", "explicacion": "forget + to."}$j$::jsonb,
 'ep17-stop-remember', 'output', false),
('banco-ep17-stop-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Write two sentences: one with remember or stop + -ing and one with remember or try + to.", "pregunta_es": "Escribe dos frases: una con remember o stop + -ing y otra con remember o try + to.", "ejemplo": "I remember locking the door. I'll try to finish today.", "criterio": "verbo + -ing o + to según el significado.", "explicacion": "-ing = ya pasó o se dejó de hacer; to = futuro o intento."}$j$::jsonb,
 'ep17-stop-remember', 'output', false),
('banco-ep17-stop-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "I'll try ___ earlier tomorrow.", "opciones": ["to arrive", "arriving"], "correcta": 0, "es": "Intentaré llegar más temprano mañana.", "explicacion": "try + to.", "segundos": 5}$j$::jsonb,
 'ep17-stop-remember', 'fluidez', false),
('banco-ep17-stop-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "She stopped ___ fast food.", "opciones": ["eating", "to eat"], "correcta": 0, "es": "Ella dejó de comer comida rápida.", "explicacion": "stop + -ing.", "segundos": 5}$j$::jsonb,
 'ep17-stop-remember', 'fluidez', false),
('banco-ep17-stop-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "Remember ___ the email.", "opciones": ["to send", "sending"], "correcta": 0, "es": "Acuérdate de enviar el correo.", "explicacion": "remember + to.", "segundos": 5}$j$::jsonb,
 'ep17-stop-remember', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-stop-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "I'll never forget ___ you for the first time.", "opciones": ["meeting", "to meet", "meet"], "correcta": 0, "es": "Nunca olvidaré conocerte por primera vez.", "explicacion": "forget + -ing = olvidar algo que pasó."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', true),
('examen-ep17-stop-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i remember meeting him"], "mostrar": "I remember meeting him.", "es": "Recuerdo haberlo conocido.", "explicacion": "remember + -ing."}$j$::jsonb,
 'ep17-stop-remember', 'estudio', true),
('examen-ep17-stop-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["Don't stop working now.", "Don't stop to work now.", "Don't stops working now.", "Don't stop work now."], "correcta": 0, "audio": "Don't stop working now.", "es": "No pares de trabajar ahora.", "explicacion": "stop + -ing."}$j$::jsonb,
 'ep17-stop-remember', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 5: ep17-cine-literatura
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-cine-01', 'ep17-cine-literatura', 1, 'elegir',
 $j${"frase": "I love ___ films. They are very scary.", "opciones": ["horror", "horrible", "horrify", "horrors"], "correcta": 0, "es": "Me encantan las películas de terror. Dan mucho miedo.", "explicacion": "horror film = película de terror."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-02', 'ep17-cine-literatura', 2, 'elegir',
 $j${"frase": "This book is a ___. I can't stop reading it!", "opciones": ["thriller", "thrill", "thrilled", "thrilling"], "correcta": 0, "es": "Este libro es de suspenso. ¡No puedo dejar de leerlo!", "explicacion": "thriller = novela o película de suspenso."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-03', 'ep17-cine-literatura', 3, 'elegir',
 $j${"frase": "I cried during the movie. It's a real ___.", "opciones": ["tear-jerker", "tear-jerk", "tearful", "tearing"], "correcta": 0, "es": "Lloré en la película. Es muy triste.", "explicacion": "tear-jerker = película que hace llorar."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-04', 'ep17-cine-literatura', 4, 'elegir',
 $j${"frase": "I read a ___ about a family in the desert.", "opciones": ["novel", "novels", "novelist", "nove"], "correcta": 0, "es": "Leí una novela sobre una familia en el desierto.", "explicacion": "novel = novela."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-05', 'ep17-cine-literatura', 5, 'escribir',
 $j${"respuestas": ["i love action films"], "mostrar": "I love action films.", "es": "Me encantan las películas de acción.", "explicacion": "action film = película de acción."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-06', 'ep17-cine-literatura', 6, 'ordenar',
 $j${"frase": "The plot of the book is very interesting.", "es": "La trama del libro es muy interesante.", "explicacion": "plot = trama."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-07', 'ep17-cine-literatura', 7, 'emparejar',
 $j${"pares": [["novel", "novela"], ["thriller", "suspenso"], ["horror film", "película de terror"], ["foreign film", "película extranjera"]], "es": "", "explicacion": "Vocabulario de literatura y cine."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', false),
('ep17-cine-08', 'ep17-cine-literatura', 8, 'escuchar',
 $j${"opciones": ["I watched a foreign film last night.", "I watched a foreign phone last night.", "I watched a fair film last night.", "I watched a funny film last night."], "correcta": 0, "audio": "I watched a foreign film last night.", "es": "Anoche vi una película extranjera.", "explicacion": "foreign film = película extranjera."}$j$::jsonb,
 'ep17-cine-literatura', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-cine-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "I'm crazy about foreign films, but I can't stand horror films.", "es": "Me encantan las películas extranjeras, pero no soporto las de terror."}, {"en": "I'd love to see that new thriller.", "es": "Me encantaría ver ese nuevo thriller."}], "pregunta": "What kind of films doesn't the speaker like?", "pregunta_es": "¿Qué tipo de películas no le gustan al hablante?", "opciones": ["Horror films", "Foreign films", "Thrillers", "Novels"], "correcta": 0, "explicacion": "'I can't stand horror films.'"}$j$::jsonb,
 'ep17-cine-literatura', 'input', false),
('banco-ep17-cine-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "The novel is about a girl who lives in the mountains.", "es": "La novela trata de una niña que vive en las montañas."}, {"en": "I found the plot really exciting.", "es": "Me pareció que la trama era muy emocionante."}], "pregunta": "What does the speaker think of the plot?", "pregunta_es": "¿Qué piensa el hablante de la trama?", "opciones": ["It is exciting", "It is boring", "It is confusing", "It is too short"], "correcta": 0, "explicacion": "'I found the plot really exciting.'"}$j$::jsonb,
 'ep17-cine-literatura', 'input', false),
('banco-ep17-cine-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Me encantan las películas de terror.", "respuestas": ["i love horror films", "i adore horror films", "i love horror movies"], "mostrar": "I love horror films.", "explicacion": "horror film = película de terror."}$j$::jsonb,
 'ep17-cine-literatura', 'output', false),
('banco-ep17-cine-04', 'banco-ep17', 4, 'decir',
 $j${"es": "Leí una novela muy buena.", "respuestas": ["i read a very good novel", "i read a really good novel"], "mostrar": "I read a very good novel.", "explicacion": "novel = novela."}$j$::jsonb,
 'ep17-cine-literatura', 'output', false),
('banco-ep17-cine-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Describe a book or movie you liked: what kind it is and why you liked it.", "pregunta_es": "Describe un libro o película que te gustó: qué tipo es y por qué te gustó.", "ejemplo": "I watched a thriller last week. The plot was amazing.", "criterio": "tipo de libro/película + opinión.", "explicacion": "Usa el vocabulario de la unidad."}$j$::jsonb,
 'ep17-cine-literatura', 'output', false),
('banco-ep17-cine-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "I like ___ films with lots of fights.", "opciones": ["action", "actions"], "correcta": 0, "es": "Me gustan las películas de acción con muchas peleas.", "explicacion": "action film (action no toma s).", "segundos": 5}$j$::jsonb,
 'ep17-cine-literatura', 'fluidez', false),
('banco-ep17-cine-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "This is a ___ film. I cried a lot.", "opciones": ["tear-jerker", "horror"], "correcta": 0, "es": "Esta es una película que hace llorar. Lloré mucho.", "explicacion": "tear-jerker.", "segundos": 5}$j$::jsonb,
 'ep17-cine-literatura', 'fluidez', false),
('banco-ep17-cine-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "I'm reading a ___ about a detective.", "opciones": ["thriller", "thrilling"], "correcta": 0, "es": "Estoy leyendo una novela de suspenso sobre un detective.", "explicacion": "thriller = suspenso.", "segundos": 5}$j$::jsonb,
 'ep17-cine-literatura', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-cine-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "The ___ of the film was very confusing.", "opciones": ["plot", "plan", "plant"], "correcta": 0, "es": "La trama de la película fue muy confusa.", "explicacion": "plot = trama."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', true),
('examen-ep17-cine-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i like foreign films"], "mostrar": "I like foreign films.", "es": "Me gustan las películas extranjeras.", "explicacion": "foreign film."}$j$::jsonb,
 'ep17-cine-literatura', 'estudio', true),
('examen-ep17-cine-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["This novel is my favorite book.", "This novel is my favorite boat.", "This novel was my favorite nose.", "This novel is my favorite bike."], "correcta": 0, "audio": "This novel is my favorite book.", "es": "Esta novela es mi libro favorito.", "explicacion": "novel = novela."}$j$::jsonb,
 'ep17-cine-literatura', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 6: ep17-gustos-preferencias
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-gust-01', 'ep17-gustos-preferencias', 1, 'elegir',
 $j${"frase": "I'm crazy ___ science fiction.", "opciones": ["about", "for", "at", "in"], "correcta": 0, "es": "Me encanta la ciencia ficción.", "explicacion": "crazy about = me encanta."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-02', 'ep17-gustos-preferencias', 2, 'elegir',
 $j${"frase": "I can't ___ horror films.", "opciones": ["stand", "stop", "stay", "stick"], "correcta": 0, "es": "No soporto las películas de terror.", "explicacion": "can't stand = no soportar."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-03', 'ep17-gustos-preferencias', 3, 'elegir',
 $j${"frase": "I don't ___ watching comedies.", "opciones": ["mind", "mine", "minded", "minding"], "correcta": 0, "es": "No me importa ver comedias.", "explicacion": "don't mind + -ing."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-04', 'ep17-gustos-preferencias', 4, 'elegir',
 $j${"frase": "I'm ___ into mystery novels.", "opciones": ["really", "real", "reality", "realize"], "correcta": 0, "es": "Me gustan mucho las novelas de misterio.", "explicacion": "be really into = gustar mucho."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-05', 'ep17-gustos-preferencias', 5, 'escribir',
 $j${"respuestas": ["i am crazy about comedies", "im crazy about comedies", "i'm crazy about comedies"], "mostrar": "I'm crazy about comedies.", "es": "Me encantan las comedias.", "explicacion": "crazy about."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-06', 'ep17-gustos-preferencias', 6, 'ordenar',
 $j${"frase": "I'd love to see that new film.", "es": "Me encantaría ver esa película nueva.", "explicacion": "I'd love to + verbo."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-07', 'ep17-gustos-preferencias', 7, 'emparejar',
 $j${"pares": [["I'm crazy about", "me encanta"], ["I can't stand", "no soporto"], ["I don't mind", "no me importa"], ["I'd love to", "me encantaría"]], "es": "", "explicacion": "Expresiones de gusto."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', false),
('ep17-gust-08', 'ep17-gustos-preferencias', 8, 'escuchar',
 $j${"opciones": ["I can't stand loud music.", "I can stand loud music.", "I can't stand loud music?", "I can't standing loud music."], "correcta": 0, "audio": "I can't stand loud music.", "es": "No soporto la música alta.", "explicacion": "can't stand + sustantivo."}$j$::jsonb,
 'ep17-gustos-preferencias', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-gust-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Do you like comedies?", "es": "¿Te gustan las comedias?"}, {"en": "Not really. I can't stand them, but I don't mind watching thrillers.", "es": "No mucho. No las soporto, pero no me importa ver thrillers."}], "pregunta": "What does the speaker think of comedies?", "pregunta_es": "¿Qué piensa el hablante de las comedias?", "opciones": ["He can't stand them", "He is crazy about them", "He doesn't mind them", "He adores them"], "correcta": 0, "explicacion": "'I can't stand them.'"}$j$::jsonb,
 'ep17-gustos-preferencias', 'input', false),
('banco-ep17-gust-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "My wife is really into romantic novels.", "es": "A mi esposa le gustan mucho las novelas románticas."}, {"en": "She'd love to read the new one by that author.", "es": "Le encantaría leer la nueva de ese autor."}], "pregunta": "What would the wife love to do?", "pregunta_es": "¿Qué le encantaría hacer a la esposa?", "opciones": ["Read the new novel", "Watch a horror film", "Go to the cinema", "Buy a car"], "correcta": 0, "explicacion": "'She'd love to read the new one.'"}$j$::jsonb,
 'ep17-gustos-preferencias', 'input', false),
('banco-ep17-gust-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Me encanta el cine.", "respuestas": ["i am crazy about movies", "i'm crazy about movies", "im crazy about movies", "i am crazy about films"], "mostrar": "I'm crazy about movies.", "explicacion": "crazy about."}$j$::jsonb,
 'ep17-gustos-preferencias', 'output', false),
('banco-ep17-gust-04', 'banco-ep17', 4, 'decir',
 $j${"es": "No soporto los finales tristes.", "respuestas": ["i can't stand sad endings", "i cant stand sad endings"], "mostrar": "I can't stand sad endings.", "explicacion": "can't stand."}$j$::jsonb,
 'ep17-gustos-preferencias', 'output', false),
('banco-ep17-gust-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Write two sentences about your tastes using I'm crazy about, I don't mind or I can't stand.", "pregunta_es": "Escribe dos frases sobre tus gustos usando I'm crazy about, I don't mind o I can't stand.", "ejemplo": "I'm crazy about thrillers. I can't stand horror films.", "criterio": "expresión + sustantivo o -ing.", "explicacion": "Cada expresión tiene su construcción."}$j$::jsonb,
 'ep17-gustos-preferencias', 'output', false),
('banco-ep17-gust-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "I'm crazy ___ foreign films.", "opciones": ["about", "for"], "correcta": 0, "es": "Me encantan las películas extranjeras.", "explicacion": "crazy about.", "segundos": 5}$j$::jsonb,
 'ep17-gustos-preferencias', 'fluidez', false),
('banco-ep17-gust-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "I don't ___ waiting for the bus.", "opciones": ["mind", "mine"], "correcta": 0, "es": "No me importa esperar el bus.", "explicacion": "don't mind + -ing.", "segundos": 5}$j$::jsonb,
 'ep17-gustos-preferencias', 'fluidez', false),
('banco-ep17-gust-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "I'd ___ to visit Medellín.", "opciones": ["love", "lovely"], "correcta": 0, "es": "Me encantaría visitar Medellín.", "explicacion": "I'd love to.", "segundos": 5}$j$::jsonb,
 'ep17-gustos-preferencias', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-gust-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "I can't ___ waiting in line.", "opciones": ["stand", "stop", "stay"], "correcta": 0, "es": "No soporto hacer fila.", "explicacion": "can't stand + -ing."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', true),
('examen-ep17-gust-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i don't mind waiting"], "mostrar": "I don't mind waiting.", "es": "No me importa esperar.", "explicacion": "don't mind + -ing."}$j$::jsonb,
 'ep17-gustos-preferencias', 'estudio', true),
('examen-ep17-gust-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["I'm really into science fiction.", "I'm really into science diction.", "I'm really into sciences fiction.", "I'm really in science fiction."], "correcta": 0, "audio": "I'm really into science fiction.", "es": "Me gusta mucho la ciencia ficción.", "explicacion": "be really into."}$j$::jsonb,
 'ep17-gustos-preferencias', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 7: ep17-percepcion
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-perc-01', 'ep17-percepcion', 1, 'elegir',
 $j${"frase": "I saw them ___ across the lawn.", "opciones": ["running", "run", "to run", "ran"], "correcta": 0, "es": "Los vi correr por el jardín.", "explicacion": "see + -ing = acción en progreso."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-02', 'ep17-percepcion', 2, 'elegir',
 $j${"frase": "She felt something ___ her hair.", "opciones": ["touching", "to touch", "touched"], "correcta": 0, "es": "Sintió que algo le tocaba el pelo.", "explicacion": "feel + -ing."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-03', 'ep17-percepcion', 3, 'elegir',
 $j${"frase": "We watched the kids ___ in the pool.", "opciones": ["playing", "to play", "played"], "correcta": 0, "es": "Vimos a los niños jugando en la piscina.", "explicacion": "watch + -ing."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-04', 'ep17-percepcion', 4, 'elegir',
 $j${"frase": "Can you smell the food ___?", "opciones": ["burning", "to burn", "burned"], "correcta": 0, "es": "¿Hueles la comida quemándose?", "explicacion": "smell + -ing."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-05', 'ep17-percepcion', 5, 'escribir',
 $j${"respuestas": ["i saw them running"], "mostrar": "I saw them running.", "es": "Los vi corriendo.", "explicacion": "see + -ing."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-06', 'ep17-percepcion', 6, 'ordenar',
 $j${"frase": "I watched him play the guitar.", "es": "Lo vi tocar la guitarra.", "explicacion": "watch + objeto + verbo base (acción completa)."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-07', 'ep17-percepcion', 7, 'emparejar',
 $j${"pares": [["saw them running", "los vi corriendo"], ["heard them scream", "los oí gritar"], ["watched him play", "lo vi tocar"], ["smelled the food burning", "olí la comida quemándose"]], "es": "", "explicacion": "Verbos de percepción + objeto + forma verbal."}$j$::jsonb,
 'ep17-percepcion', 'estudio', false),
('ep17-perc-08', 'ep17-percepcion', 8, 'escuchar',
 $j${"opciones": ["I heard the baby crying.", "I heard the baby to cry.", "I hear the baby cries.", "I heard the baby cry to."], "correcta": 0, "audio": "I heard the baby crying.", "es": "Oí al bebé llorando.", "explicacion": "hear + -ing."}$j$::jsonb,
 'ep17-percepcion', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-perc-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "I watched them fighting in the street.", "es": "Los vi peleando en la calle."}, {"en": "I heard them screaming, so I called the police.", "es": "Los oí gritar, así que llamé a la policía."}], "pregunta": "Why did the speaker call the police?", "pregunta_es": "¿Por qué llamó el hablante a la policía?", "opciones": ["Because he heard them screaming", "Because he saw a film", "Because he lost his keys", "Because he was hungry"], "correcta": 0, "explicacion": "'I heard them screaming, so I called the police.'"}$j$::jsonb,
 'ep17-percepcion', 'input', false),
('banco-ep17-perc-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "She felt the wind blowing on her face.", "es": "Sintió el viento soplándole en la cara."}, {"en": "She saw a bird fly over the lake.", "es": "Vio un pájaro volar sobre el lago."}], "pregunta": "What did she see?", "pregunta_es": "¿Qué vio ella?", "opciones": ["A bird flying over the lake", "A boat on the river", "A car in the street", "A dog in the garden"], "correcta": 0, "explicacion": "'She saw a bird fly over the lake.'"}$j$::jsonb,
 'ep17-percepcion', 'input', false),
('banco-ep17-perc-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Los vi jugando fútbol.", "respuestas": ["i saw them playing football", "i saw them playing soccer"], "mostrar": "I saw them playing football.", "explicacion": "see + -ing."}$j$::jsonb,
 'ep17-percepcion', 'output', false),
('banco-ep17-perc-04', 'banco-ep17', 4, 'decir',
 $j${"es": "Lo oí cantar.", "respuestas": ["i heard him sing", "i heard him singing"], "mostrar": "I heard him singing.", "explicacion": "hear + -ing o base."}$j$::jsonb,
 'ep17-percepcion', 'output', false),
('banco-ep17-perc-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Describe something you saw or heard someone doing. Use see or hear + -ing.", "pregunta_es": "Describe algo que viste u oíste que alguien hacía. Usa see o hear + -ing.", "ejemplo": "Yesterday I heard my neighbor singing loudly.", "criterio": "see/hear + objeto + -ing.", "explicacion": "Usa el objeto y luego la forma -ing."}$j$::jsonb,
 'ep17-percepcion', 'output', false),
('banco-ep17-perc-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "I saw her ___ the bus.", "opciones": ["catching", "to catch"], "correcta": 0, "es": "La vi tomando el bus.", "explicacion": "see + -ing.", "segundos": 5}$j$::jsonb,
 'ep17-percepcion', 'fluidez', false),
('banco-ep17-perc-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "We heard the dog ___.", "opciones": ["barking", "to bark"], "correcta": 0, "es": "Oímos al perro ladrar.", "explicacion": "hear + -ing.", "segundos": 5}$j$::jsonb,
 'ep17-percepcion', 'fluidez', false),
('banco-ep17-perc-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "Can you smell the coffee ___?", "opciones": ["brewing", "to brew"], "correcta": 0, "es": "¿Hueles el café preparándose?", "explicacion": "smell + -ing.", "segundos": 5}$j$::jsonb,
 'ep17-percepcion', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-perc-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "I felt the ground ___.", "opciones": ["shaking", "to shaking", "to shake"], "correcta": 0, "es": "Sentí el suelo temblar.", "explicacion": "feel + -ing."}$j$::jsonb,
 'ep17-percepcion', 'estudio', true),
('examen-ep17-perc-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i heard the children laughing"], "mostrar": "I heard the children laughing.", "es": "Oí a los niños reír.", "explicacion": "hear + -ing."}$j$::jsonb,
 'ep17-percepcion', 'estudio', true),
('examen-ep17-perc-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["We saw the sun rising over the hills.", "We saw the sun to rise over the hills.", "We see the sun rises over the hills.", "We saw the sun rose over the hills."], "correcta": 0, "audio": "We saw the sun rising over the hills.", "es": "Vimos el sol salir sobre las colinas.", "explicacion": "see + -ing."}$j$::jsonb,
 'ep17-percepcion', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 8: ep17-objetos-directos-indirectos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep17-obj-01', 'ep17-objetos-directos-indirectos', 1, 'elegir',
 $j${"frase": "Lester gave ___ a book.", "opciones": ["Danny", "Danny's", "Dannie"], "correcta": 0, "es": "Lester le dio un libro a Danny.", "explicacion": "objeto indirecto (Danny) va antes del directo (a book)."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-02', 'ep17-objetos-directos-indirectos', 2, 'elegir',
 $j${"frase": "I read ___ the article.", "opciones": ["Peter", "Peter's", "the Peter"], "correcta": 0, "es": "Le leí el artículo a Peter.", "explicacion": "I read Peter the article = I read the article to Peter."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-03', 'ep17-objetos-directos-indirectos', 3, 'elegir',
 $j${"frase": "She asked ___ a favor.", "opciones": ["me", "I", "my"], "correcta": 0, "es": "Ella me pidió un favor.", "explicacion": "objeto indirecto: me."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-04', 'ep17-objetos-directos-indirectos', 4, 'elegir',
 $j${"frase": "I hate ___.", "opciones": ["fishing", "fish", "fishes"], "correcta": 0, "es": "Odio la pesca.", "explicacion": "fishing = objeto directo (¿qué odio?)."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-05', 'ep17-objetos-directos-indirectos', 5, 'escribir',
 $j${"respuestas": ["she gave me a gift"], "mostrar": "She gave me a gift.", "es": "Ella me dio un regalo.", "explicacion": "me = indirecto, a gift = directo."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-06', 'ep17-objetos-directos-indirectos', 6, 'ordenar',
 $j${"frase": "He bought his wife a new car.", "es": "Él le compró a su esposa un carro nuevo.", "explicacion": "bought + indirecto + directo."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-07', 'ep17-objetos-directos-indirectos', 7, 'emparejar',
 $j${"pares": [["gave Danny a book", "le dio a Danny un libro"], ["read Peter the article", "le leí a Peter el artículo"], ["asked me a favor", "me pidió un favor"], ["bought his wife a car", "le compró a su esposa un carro"]], "es": "", "explicacion": "Objeto indirecto + directo."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', false),
('ep17-obj-08', 'ep17-objetos-directos-indirectos', 8, 'escuchar',
 $j${"opciones": ["Lester gave Danny a book.", "Lester gave a book Danny.", "Lester gave book a Danny.", "Lester gave Danny book a."], "correcta": 0, "audio": "Lester gave Danny a book.", "es": "Lester le dio un libro a Danny.", "explicacion": "give + indirecto + directo."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep17-obj-01', 'banco-ep17', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "My mom bought me a new bike for my birthday.", "es": "Mi mamá me compró una bicicleta nueva para mi cumpleaños."}, {"en": "I gave her a big hug in return.", "es": "Yo le di un gran abrazo a cambio."}], "pregunta": "What did the mom buy?", "pregunta_es": "¿Qué compró la mamá?", "opciones": ["A new bike", "A new car", "A book", "A hat"], "correcta": 0, "explicacion": "'My mom bought me a new bike.'"}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'input', false),
('banco-ep17-obj-02', 'banco-ep17', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Can you tell me the time?", "es": "¿Me dices la hora?"}, {"en": "Sure, I'll show you my watch.", "es": "Claro, te enseño mi reloj."}], "pregunta": "What does the speaker offer to show?", "pregunta_es": "¿Qué ofrece enseñar el hablante?", "opciones": ["His watch", "His phone", "His car", "His bag"], "correcta": 0, "explicacion": "'I'll show you my watch.'"}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'input', false),
('banco-ep17-obj-03', 'banco-ep17', 3, 'decir',
 $j${"es": "Le di un libro a Peter.", "respuestas": ["i gave peter a book", "i gave a book to peter"], "mostrar": "I gave Peter a book.", "explicacion": "indirecto antes del directo, o con to."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'output', false),
('banco-ep17-obj-04', 'banco-ep17', 4, 'decir',
 $j${"es": "Me compró un regalo.", "respuestas": ["he bought me a gift", "he bought a gift for me"], "mostrar": "He bought me a gift.", "explicacion": "me = indirecto."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'output', false),
('banco-ep17-obj-05', 'banco-ep17', 5, 'libre',
 $j${"pregunta": "Write two sentences: one with an indirect object (me, him, her) and one with to.", "pregunta_es": "Escribe dos frases: una con objeto indirecto (me, him, her) y otra con to.", "ejemplo": "My friend gave me a book. I sent the letter to my teacher.", "criterio": "verbo + indirecto + directo; verbo + directo + to + indirecto.", "explicacion": "Las dos formas son válidas."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'output', false),
('banco-ep17-obj-06', 'banco-ep17', 6, 'rapido',
 $j${"frase": "She gave ___ a gift.", "opciones": ["me", "I"], "correcta": 0, "es": "Ella me dio un regalo.", "explicacion": "me = objeto indirecto.", "segundos": 5}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'fluidez', false),
('banco-ep17-obj-07', 'banco-ep17', 7, 'rapido',
 $j${"frase": "I read ___ the story.", "opciones": ["him", "he"], "correcta": 0, "es": "Le leí el cuento.", "explicacion": "him = objeto indirecto.", "segundos": 5}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'fluidez', false),
('banco-ep17-obj-08', 'banco-ep17', 8, 'rapido',
 $j${"frase": "Can you lend ___ your pen?", "opciones": ["me", "I"], "correcta": 0, "es": "¿Me prestas tu lapicero?", "explicacion": "me = objeto indirecto.", "segundos": 5}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep17-obj-01', 'examen-ep17', 1, 'elegir',
 $j${"frase": "He told ___ the truth.", "opciones": ["us", "we", "our"], "correcta": 0, "es": "Nos dijo la verdad.", "explicacion": "us = objeto indirecto."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', true),
('examen-ep17-obj-02', 'examen-ep17', 2, 'escribir',
 $j${"respuestas": ["i bought her flowers"], "mostrar": "I bought her flowers.", "es": "Le compré flores.", "explicacion": "her = indirecto, flowers = directo."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'estudio', true),
('examen-ep17-obj-03', 'examen-ep17', 3, 'escuchar',
 $j${"opciones": ["She sent me a message.", "She sent a message me.", "She sent I a message.", "She send me a message."], "correcta": 0, "audio": "She sent me a message.", "es": "Ella me envió un mensaje.", "explicacion": "send + indirecto + directo."}$j$::jsonb,
 'ep17-objetos-directos-indirectos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;