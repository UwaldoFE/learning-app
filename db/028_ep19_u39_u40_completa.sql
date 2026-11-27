-- =====================================================================
-- 028 · Episodio 19 completo (Unidades 39 y 40 del Libro 3) — ÚLTIMO EPISODIO
--   - 8 temas nuevos en pensum_temas (orden 1-8 del Episodio 19):
--     Unidad 39 (Expressing Wishes): deseos sobre el presente, arrepentimientos,
--       would y if only, más homófonos.
--     Unidad 40 (Modals Review): should have, suposiciones en pasado,
--       repaso de modales, brindis y vocabulario de la conversación.
--   - 8 lecciones tipo 'tema' (8 ejercicios cada una)
--   - banco-ep19 +8·8 = 64 ejercicios de práctica
--   - examen-ep19 +8·3 = 24 ejercicios reservados
--   - 8×19 = 152 ejercicios en total
-- Requiere 006, 007, 008 y 011. Se puede correr varias veces sin dañar nada.
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================

insert into unidades (materia_id, numero, episodio, objetivo) values
  ('ingles', 39, 'Episodio 19', 'Expressing wishes, if only, past regrets, more homophones'),
  ('ingles', 40, 'Episodio 19', 'Should have, past modals, modals review, toasts and conversation vocabulary')
on conflict (materia_id, numero) do update set
  episodio = excluded.episodio,
  objetivo = coalesce(nullif(unidades.objetivo, ''), excluded.objetivo);

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('banco-ep19', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 39), 19, 90, 'banco', 'Banco de ejercicios Episodio 19', 'Ejercicios de refuerzo - Episodio 19'),
  ('examen-ep19', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 39), 19, 91, 'examen', 'Examen Episodio 19', 'Evaluación - Episodio 19')
on conflict (id) do update set
  materia_id = excluded.materia_id, unidad_id = excluded.unidad_id, episodio = excluded.episodio,
  orden = excluded.orden, tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;

insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep19-deseos-presente', 19, 1, $t$Deseos sobre el presente (wish + pasado simple)$t$, $t$Wishes about the present$t$, $t$I wish I had more free time: wish + pasado simple para algo que no es real ahora.$t$),
  ('ep19-deseos-pasado', 19, 2, $t$Arrepentimientos (wish + past perfect)$t$, $t$Regrets about the past$t$, $t$I wish I had discovered it earlier: wish + had + participio para algo que ya no se puede cambiar.$t$),
  ('ep19-would-if-only', 19, 3, $t$Deseos con would y if only$t$, $t$Wishes with would and if only$t$, $t$I wish you would call me. If only I had more money: would para cambiar a otros y if only para lamentos fuertes.$t$),
  ('ep19-homofonos-2', 19, 4, $t$Más homófonos$t$, $t$More homophones$t$, $t$sail/sale, flour/flower, piece/peace, plane/plain, pair/pear, hour/our: suenan igual y se escriben distinto.$t$),
  ('ep19-deberia-haber', 19, 5, $t$Should have y shouldn't have$t$, $t$Should have and shouldn't have$t$, $t$You should have called me: lo que habría sido mejor hacer (o no hacer) en el pasado.$t$),
  ('ep19-posibilidad-pasado', 19, 6, $t$Suposiciones sobre el pasado (might, must, can't have)$t$, $t$Past speculation with modals$t$, $t$She might have forgotten / He must have been tired / It can't have been him: suposiciones sobre lo que pasó.$t$),
  ('ep19-modales-repaso', 19, 7, $t$Repaso de modales$t$, $t$Modal verbs review$t$, $t$can, could, may, must, have to y don't have to: habilidad, permiso, obligación y necesidad.$t$),
  ('ep19-brindis-vocabulario', 19, 8, $t$Brindis y vocabulario de la conversación$t$, $t$Toasts and conversation vocabulary$t$, $t$regrets, drink to, get away from it all, champagne, celebration, crossword puzzles, reunion.$t$)
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden,
  nombre_es = excluded.nombre_es, nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('ep19-deseos-presente', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 39), 19, 1, 'tema', $t$Wishes about the present$t$, $t$I wish I had more free time: wish + pasado simple para algo que no es real ahora.$t$),
  ('ep19-deseos-pasado', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 39), 19, 2, 'tema', $t$Regrets about the past$t$, $t$I wish I had discovered it earlier: wish + had + participio para algo que ya no se puede cambiar.$t$),
  ('ep19-would-if-only', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 39), 19, 3, 'tema', $t$Wishes with would and if only$t$, $t$I wish you would call me. If only I had more money: would para cambiar a otros y if only para lamentos fuertes.$t$),
  ('ep19-homofonos-2', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 39), 19, 4, 'tema', $t$More homophones$t$, $t$sail/sale, flour/flower, piece/peace, plane/plain, pair/pear, hour/our: suenan igual y se escriben distinto.$t$),
  ('ep19-deberia-haber', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 40), 19, 5, 'tema', $t$Should have and shouldn't have$t$, $t$You should have called me: lo que habría sido mejor hacer (o no hacer) en el pasado.$t$),
  ('ep19-posibilidad-pasado', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 40), 19, 6, 'tema', $t$Past speculation with modals$t$, $t$She might have forgotten / He must have been tired / It can't have been him: suposiciones sobre lo que pasó.$t$),
  ('ep19-modales-repaso', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 40), 19, 7, 'tema', $t$Modal verbs review$t$, $t$can, could, may, must, have to y don't have to: habilidad, permiso, obligación y necesidad.$t$),
  ('ep19-brindis-vocabulario', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 40), 19, 8, 'tema', $t$Toasts and conversation vocabulary$t$, $t$regrets, drink to, get away from it all, champagne, celebration, crossword puzzles, reunion.$t$)
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;


-- EJERCICIOS — TEMA 1: ep19-deseos-presente
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-dpre-01', 'ep19-deseos-presente', 1, 'elegir',
 $j${"frase": "I wish I ___ more free time.", "opciones": ["had", "have", "will have", "having"], "correcta": 0, "es": "Ojalá tuviera más tiempo libre.", "explicacion": "wish + pasado simple (had)."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-02', 'ep19-deseos-presente', 2, 'elegir',
 $j${"frase": "I wish I ___ here right now.", "opciones": ["were", "am", "will be", "be"], "correcta": 0, "es": "Ojalá estuviera aquí ahora.", "explicacion": "wish + were (también con I)."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-03', 'ep19-deseos-presente', 3, 'elegir',
 $j${"frase": "She wishes she ___ closer to her family.", "opciones": ["lived", "lives", "will live", "living"], "correcta": 0, "es": "Ella desearía vivir más cerca de su familia.", "explicacion": "wish + pasado simple (lived)."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-04', 'ep19-deseos-presente', 4, 'elegir',
 $j${"frase": "We wish we ___ speak French.", "opciones": ["could", "can", "will", "must"], "correcta": 0, "es": "Ojalá pudiéramos hablar francés.", "explicacion": "could = poder (habilidad en deseos)."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-05', 'ep19-deseos-presente', 5, 'escribir',
 $j${"respuestas": ["i wish i had more time", "i wish i had more free time"], "mostrar": "I wish I had more time.", "es": "Ojalá tuviera más tiempo.", "explicacion": "wish + had."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-06', 'ep19-deseos-presente', 6, 'ordenar',
 $j${"frase": "I wish I lived closer to my family.", "es": "Ojalá viviera más cerca de mi familia.", "explicacion": "wish + sujeto + pasado simple."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-07', 'ep19-deseos-presente', 7, 'emparejar',
 $j${"pares": [["I wish I had time", "Ojalá tuviera tiempo"], ["I wish I were rich", "Ojalá fuera rico"], ["I wish I could fly", "Ojalá pudiera volar"], ["I wish I knew", "Ojalá supiera"]], "es": "", "explicacion": "Deseos sobre el presente."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', false),
('ep19-dpre-08', 'ep19-deseos-presente', 8, 'escuchar',
 $j${"opciones": ["I wish I had more free time.", "I wish I have more free time.", "I wish I will have more free time.", "I hope I had more free time."], "correcta": 0, "audio": "I wish I had more free time.", "es": "Ojalá tuviera más tiempo libre.", "explicacion": "wish + pasado simple."}$j$::jsonb,
 'ep19-deseos-presente', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-dpre-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Frances: Sometimes I wish I had more free time.", "es": "Frances: A veces ojalá tuviera más tiempo libre."}, {"en": "She enjoys her job, but she wishes she could relax more.", "es": "Disfruta su trabajo, pero ojalá pudiera relajarse más."}], "pregunta": "What does Frances wish?", "pregunta_es": "¿Qué desea Frances?", "opciones": ["She had more free time", "She had less work", "She lived abroad", "She was younger"], "correcta": 0, "explicacion": "'I wish I had more free time.'"}$j$::jsonb,
 'ep19-deseos-presente', 'input', false),
('banco-ep19-dpre-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Lyle: I wish I lived closer to you guys.", "es": "Lyle: Ojalá viviera más cerca de ustedes."}, {"en": "Frances: Me too. We would see each other more often.", "es": "Frances: A mí también. Nos veríamos más seguido."}], "pregunta": "Where does Lyle live?", "pregunta_es": "¿Dónde vive Lyle?", "opciones": ["Far from his friends", "Next to his friends", "With his parents", "In Bogotá"], "correcta": 0, "explicacion": "Desea vivir más cerca: vive lejos."}$j$::jsonb,
 'ep19-deseos-presente', 'input', false),
('banco-ep19-dpre-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Ojalá tuviera más dinero.", "respuestas": ["i wish i had more money"], "mostrar": "I wish I had more money.", "explicacion": "wish + had."}$j$::jsonb,
 'ep19-deseos-presente', 'output', false),
('banco-ep19-dpre-04', 'banco-ep19', 4, 'decir',
 $j${"es": "Ojalá supiera hablar inglés perfecto.", "respuestas": ["i wish i could speak perfect english", "i wish i could speak english perfectly"], "mostrar": "I wish I could speak perfect English.", "explicacion": "wish + could."}$j$::jsonb,
 'ep19-deseos-presente', 'output', false),
('banco-ep19-dpre-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write two sentences about something you wish were different now. Use wish + past simple.", "pregunta_es": "Escribe dos frases sobre algo que ojalá fuera distinto ahora. Usa wish + pasado simple.", "ejemplo": "I wish I had a bigger house. I wish I could travel more.", "criterio": "wish + pasado simple.", "explicacion": "Deseos sobre el presente usan pasado simple."}$j$::jsonb,
 'ep19-deseos-presente', 'output', false),
('banco-ep19-dpre-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "I wish I ___ a car.", "opciones": ["had", "have"], "correcta": 0, "es": "Ojalá tuviera un carro.", "explicacion": "had.", "segundos": 5}$j$::jsonb,
 'ep19-deseos-presente', 'fluidez', false),
('banco-ep19-dpre-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "I wish I ___ there now.", "opciones": ["were", "am"], "correcta": 0, "es": "Ojalá estuviera allí ahora.", "explicacion": "were.", "segundos": 5}$j$::jsonb,
 'ep19-deseos-presente', 'fluidez', false),
('banco-ep19-dpre-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "She wishes she ___ more time.", "opciones": ["had", "has"], "correcta": 0, "es": "Ella desearía tener más tiempo.", "explicacion": "had.", "segundos": 5}$j$::jsonb,
 'ep19-deseos-presente', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-dpre-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "We wish we ___ the answer.", "opciones": ["knew", "know", "will know"], "correcta": 0, "es": "Ojalá supiéramos la respuesta.", "explicacion": "wish + pasado simple (knew)."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', true),
('examen-ep19-dpre-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["i wish i were taller"], "mostrar": "I wish I were taller.", "es": "Ojalá fuera más alto.", "explicacion": "wish + were."}$j$::jsonb,
 'ep19-deseos-presente', 'estudio', true),
('examen-ep19-dpre-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["I wish I knew the answer.", "I wish I know the answer.", "I wish I will know the answer.", "I hope I knew the answer."], "correcta": 0, "audio": "I wish I knew the answer.", "es": "Ojalá supiera la respuesta.", "explicacion": "wish + pasado simple."}$j$::jsonb,
 'ep19-deseos-presente', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 2: ep19-deseos-pasado
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-dpas-01', 'ep19-deseos-pasado', 1, 'elegir',
 $j${"frase": "I wish I ___ it earlier.", "opciones": ["had discovered", "discovered", "have discovered", "discover"], "correcta": 0, "es": "Ojalá lo hubiera descubierto antes.", "explicacion": "wish + had + participio."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-02', 'ep19-deseos-pasado', 2, 'elegir',
 $j${"frase": "She wishes she ___ to the party.", "opciones": ["had gone", "went", "has gone", "go"], "correcta": 0, "es": "Ella desearía haber ido a la fiesta.", "explicacion": "had gone (participio de go)."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-03', 'ep19-deseos-pasado', 3, 'elegir',
 $j${"frase": "We wish we ___ more money last year.", "opciones": ["had saved", "saved", "have saved", "save"], "correcta": 0, "es": "Ojalá hubiéramos ahorrado más dinero el año pasado.", "explicacion": "had + participio."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-04', 'ep19-deseos-pasado', 4, 'elegir',
 $j${"frase": "He wishes he ___ her years ago.", "opciones": ["had married", "married", "has married", "marries"], "correcta": 0, "es": "Ojalá se hubiera casado con ella hace años.", "explicacion": "had + participio (married)."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-05', 'ep19-deseos-pasado', 5, 'escribir',
 $j${"respuestas": ["i wish i had studied harder", "i wish i had studied more"], "mostrar": "I wish I had studied harder.", "es": "Ojalá hubiera estudiado más duro.", "explicacion": "wish + had studied."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-06', 'ep19-deseos-pasado', 6, 'ordenar',
 $j${"frase": "I wish I had known about it sooner.", "es": "Ojalá lo hubiera sabido antes.", "explicacion": "wish + had + known."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-07', 'ep19-deseos-pasado', 7, 'emparejar',
 $j${"pares": [["I wish I had gone", "Ojalá hubiera ido"], ["I wish I had known", "Ojalá hubiera sabido"], ["I wish I had called", "Ojalá hubiera llamado"], ["I wish I had listened", "Ojalá hubiera escuchado"]], "es": "", "explicacion": "Deseos sobre el pasado."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', false),
('ep19-dpas-08', 'ep19-deseos-pasado', 8, 'escuchar',
 $j${"opciones": ["I wish I had listened to my mother.", "I wish I listened to my mother.", "I wish I have listened to my mother.", "I wish I had listen to my mother."], "correcta": 0, "audio": "I wish I had listened to my mother.", "es": "Ojalá hubiera escuchado a mi madre.", "explicacion": "had + participio."}$j$::jsonb,
 'ep19-deseos-pasado', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-dpas-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Leonard: Do you have any regrets about the past?", "es": "Leonard: ¿Tienes algún arrepentimiento del pasado?"}, {"en": "Kathryn: None. I have all that I ever hoped for.", "es": "Kathryn: Ninguno. Tengo todo lo que alguna vez esperé."}], "pregunta": "What does Kathryn say about her regrets?", "pregunta_es": "¿Qué dice Kathryn de sus arrepentimientos?", "opciones": ["She has none", "She has many", "She regrets her job", "She wants to move"], "correcta": 0, "explicacion": "'None. I have all that I ever hoped for.'"}$j$::jsonb,
 'ep19-deseos-pasado', 'input', false),
('banco-ep19-dpas-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Lyle: I wish I had discovered earlier that Kath is better at crossword puzzles.", "es": "Lyle: Ojalá hubiera descubierto antes que Kath es mejor en los crucigramas."}, {"en": "Lyle: I would have married her years ago.", "es": "Lyle: Me habría casado con ella hace años."}], "pregunta": "What does Lyle regret?", "pregunta_es": "¿De qué se arrepiente Lyle?", "opciones": ["Not marrying Kath earlier", "Buying a car", "Missing a flight", "Losing a job"], "correcta": 0, "explicacion": "Lamenta no haberse casado antes con Kath."}$j$::jsonb,
 'ep19-deseos-pasado', 'input', false),
('banco-ep19-dpas-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Ojalá hubiera llegado a tiempo.", "respuestas": ["i wish i had arrived on time", "i wish i had come on time"], "mostrar": "I wish I had arrived on time.", "explicacion": "wish + had + participio."}$j$::jsonb,
 'ep19-deseos-pasado', 'output', false),
('banco-ep19-dpas-04', 'banco-ep19', 4, 'decir',
 $j${"es": "Ojalá lo hubiera sabido.", "respuestas": ["i wish i had known", "i wish i had known it"], "mostrar": "I wish I had known.", "explicacion": "wish + had known."}$j$::jsonb,
 'ep19-deseos-pasado', 'output', false),
('banco-ep19-dpas-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write two regrets about last year. Use I wish I had + past participle.", "pregunta_es": "Escribe dos arrepentimientos del año pasado. Usa I wish I had + participio.", "ejemplo": "I wish I had saved more money. I wish I had visited my grandmother.", "criterio": "wish + had + participio.", "explicacion": "Arrepentimientos sobre el pasado."}$j$::jsonb,
 'ep19-deseos-pasado', 'output', false),
('banco-ep19-dpas-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "I wish I ___ earlier.", "opciones": ["had come", "came"], "correcta": 0, "es": "Ojalá hubiera llegado antes.", "explicacion": "had come.", "segundos": 5}$j$::jsonb,
 'ep19-deseos-pasado', 'fluidez', false),
('banco-ep19-dpas-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "She wishes she ___ the truth.", "opciones": ["had told", "told"], "correcta": 0, "es": "Ella desearía haber dicho la verdad.", "explicacion": "had told.", "segundos": 5}$j$::jsonb,
 'ep19-deseos-pasado', 'fluidez', false),
('banco-ep19-dpas-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "We wish we ___ that film.", "opciones": ["had seen", "saw"], "correcta": 0, "es": "Ojalá hubiéramos visto esa película.", "explicacion": "had seen.", "segundos": 5}$j$::jsonb,
 'ep19-deseos-pasado', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-dpas-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "They wish they ___ harder for the test.", "opciones": ["had studied", "studied", "study"], "correcta": 0, "es": "Ojalá hubieran estudiado más duro para el examen.", "explicacion": "had + participio."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', true),
('examen-ep19-dpas-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["i wish i had known the answer"], "mostrar": "I wish I had known the answer.", "es": "Ojalá hubiera sabido la respuesta.", "explicacion": "wish + had known."}$j$::jsonb,
 'ep19-deseos-pasado', 'estudio', true),
('examen-ep19-dpas-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["I wish I had known the answer.", "I wish I had know the answer.", "I wish I have known the answer.", "I hope I had known the answer."], "correcta": 0, "audio": "I wish I had known the answer.", "es": "Ojalá hubiera sabido la respuesta.", "explicacion": "had + participio."}$j$::jsonb,
 'ep19-deseos-pasado', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 3: ep19-would-if-only
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-wuld-01', 'ep19-would-if-only', 1, 'elegir',
 $j${"frase": "I wish you ___ talk less in class.", "opciones": ["would", "will", "could", "did"], "correcta": 0, "es": "Ojalá hablaras menos en clase.", "explicacion": "wish + would + verbo: deseo de que alguien cambie."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-02', 'ep19-would-if-only', 2, 'elegir',
 $j${"frase": "If only I ___ more money!", "opciones": ["had", "have", "would have", "will have"], "correcta": 0, "es": "¡Si tan solo tuviera más dinero!", "explicacion": "if only + pasado simple."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-03', 'ep19-would-if-only', 3, 'elegir',
 $j${"frase": "If only we ___ earlier!", "opciones": ["had left", "left", "leave", "would leave"], "correcta": 0, "es": "¡Si tan solo hubiéramos salido antes!", "explicacion": "if only + had + participio para el pasado."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-04', 'ep19-would-if-only', 4, 'elegir',
 $j${"frase": "It's raining. I wish it ___ stop.", "opciones": ["would", "will", "can", "did"], "correcta": 0, "es": "Está lloviendo. Ojalá parara.", "explicacion": "I wish it would stop."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-05', 'ep19-would-if-only', 5, 'escribir',
 $j${"respuestas": ["i wish you would call me", "i wish you would call me more"], "mostrar": "I wish you would call me.", "es": "Ojalá me llamaras.", "explicacion": "wish + would."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-06', 'ep19-would-if-only', 6, 'ordenar',
 $j${"frase": "If only I could speak German!", "es": "¡Si tan solo pudiera hablar alemán!", "explicacion": "if only + could."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-07', 'ep19-would-if-only', 7, 'emparejar',
 $j${"pares": [["I wish you would listen", "Ojalá escucharas"], ["If only I had time", "Si tan solo tuviera tiempo"], ["I wish it would stop", "Ojalá parara"], ["If only I had known", "Si tan solo hubiera sabido"]], "es": "", "explicacion": "would y if only."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', false),
('ep19-wuld-08', 'ep19-would-if-only', 8, 'escuchar',
 $j${"opciones": ["If only I had more time!", "If only I have more time!", "If only I would have more time!", "If only I had more times!"], "correcta": 0, "audio": "If only I had more time!", "es": "¡Si tan solo tuviera más tiempo!", "explicacion": "if only + pasado simple."}$j$::jsonb,
 'ep19-would-if-only', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-wuld-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Walter: I wish the weather would get better.", "es": "Walter: Ojalá el clima mejorara."}, {"en": "Lyle: If only we had a boat today!", "es": "Lyle: ¡Si tan solo tuviéramos un bote hoy!"}], "pregunta": "What does Walter wish?", "pregunta_es": "¿Qué desea Walter?", "opciones": ["The weather would improve", "He had a boat", "He could fly", "The party would end"], "correcta": 0, "explicacion": "'I wish the weather would get better.'"}$j$::jsonb,
 'ep19-would-if-only', 'input', false),
('banco-ep19-wuld-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Frances: I wish my sister would visit more often.", "es": "Frances: Ojalá mi hermana viniera más seguido."}, {"en": "She lives far away, so it's hard for her.", "es": "Vive lejos, así que le es difícil."}], "pregunta": "Why is it hard for the sister to visit?", "pregunta_es": "¿Por qué le es difícil a la hermana visitarla?", "opciones": ["She lives far away", "She has no money", "She doesn't like Frances", "She is sick"], "correcta": 0, "explicacion": "'She lives far away.'"}$j$::jsonb,
 'ep19-would-if-only', 'input', false),
('banco-ep19-wuld-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Ojalá me escribieras más.", "respuestas": ["i wish you would write me more", "i wish you would write to me more", "i wish you would write more"], "mostrar": "I wish you would write me more.", "explicacion": "wish + would."}$j$::jsonb,
 'ep19-would-if-only', 'output', false),
('banco-ep19-wuld-04', 'banco-ep19', 4, 'decir',
 $j${"es": "¡Si tan solo tuviera un carro!", "respuestas": ["if only i had a car", "if only i had a car!"], "mostrar": "If only I had a car!", "explicacion": "if only + pasado simple."}$j$::jsonb,
 'ep19-would-if-only', 'output', false),
('banco-ep19-wuld-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write one wish about someone you know (I wish you would...) and one with If only.", "pregunta_es": "Escribe un deseo sobre alguien que conoces (I wish you would...) y uno con If only.", "ejemplo": "I wish my brother would call more. If only I had a bigger kitchen.", "criterio": "would para otros; if only + pasado simple.", "explicacion": "Usa would para pedir cambios a otros."}$j$::jsonb,
 'ep19-would-if-only', 'output', false),
('banco-ep19-wuld-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "I wish you ___ harder.", "opciones": ["would try", "try"], "correcta": 0, "es": "Ojalá te esforzaras más.", "explicacion": "would try.", "segundos": 5}$j$::jsonb,
 'ep19-would-if-only', 'fluidez', false),
('banco-ep19-wuld-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "If only I ___ taller.", "opciones": ["were", "am"], "correcta": 0, "es": "Si tan solo fuera más alto.", "explicacion": "were.", "segundos": 5}$j$::jsonb,
 'ep19-would-if-only', 'fluidez', false),
('banco-ep19-wuld-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "I wish it ___ stop.", "opciones": ["would", "will"], "correcta": 0, "es": "Ojalá parara.", "explicacion": "would.", "segundos": 5}$j$::jsonb,
 'ep19-would-if-only', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-wuld-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "I wish he ___ more careful.", "opciones": ["would be", "will be", "is"], "correcta": 0, "es": "Ojalá fuera más cuidadoso.", "explicacion": "wish + would be."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', true),
('examen-ep19-wuld-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["if only i had more time", "if only i had more time!"], "mostrar": "If only I had more time!", "es": "¡Si tan solo tuviera más tiempo!", "explicacion": "if only + pasado simple."}$j$::jsonb,
 'ep19-would-if-only', 'estudio', true),
('examen-ep19-wuld-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["I wish you would listen to me.", "I wish you will listen to me.", "I wish you would listens to me.", "I wish you would listening to me."], "correcta": 0, "audio": "I wish you would listen to me.", "es": "Ojalá me escucharas.", "explicacion": "wish + would + verbo base."}$j$::jsonb,
 'ep19-would-if-only', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 4: ep19-homofonos-2
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-homo2-01', 'ep19-homofonos-2', 1, 'elegir',
 $j${"frase": "The shop has a big ___ this week.", "opciones": ["sale", "sail", "sell"], "correcta": 0, "es": "La tienda tiene una gran rebaja esta semana.", "explicacion": "sale = rebaja; sail = navegar."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-02', 'ep19-homofonos-2', 2, 'elegir',
 $j${"frase": "We will ___ on the lake on Sunday.", "opciones": ["sail", "sale", "sell"], "correcta": 0, "es": "Navegaremos en el lago el domingo.", "explicacion": "sail = navegar."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-03', 'ep19-homofonos-2', 3, 'elegir',
 $j${"frase": "I'd like a ___ of cake, please.", "opciones": ["piece", "peace", "peas"], "correcta": 0, "es": "Quisiera un pedazo de torta, por favor.", "explicacion": "piece = pedazo."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-04', 'ep19-homofonos-2', 4, 'elegir',
 $j${"frase": "Let's hope for ___ in the world.", "opciones": ["peace", "piece", "peas"], "correcta": 0, "es": "Esperemos paz en el mundo.", "explicacion": "peace = paz."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-05', 'ep19-homofonos-2', 5, 'escribir',
 $j${"respuestas": ["the flour is in the kitchen"], "mostrar": "The flour is in the kitchen.", "es": "La harina está en la cocina.", "explicacion": "flour = harina; flower = flor."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-06', 'ep19-homofonos-2', 6, 'ordenar',
 $j${"frase": "The flower is very beautiful.", "es": "La flor es muy hermosa.", "explicacion": "flower = flor."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-07', 'ep19-homofonos-2', 7, 'emparejar',
 $j${"pares": [["flour", "harina"], ["flower", "flor"], ["hour", "hora"], ["our", "nuestro"]], "es": "", "explicacion": "Homófonos básicos de esta unidad."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', false),
('ep19-homo2-08', 'ep19-homofonos-2', 8, 'escuchar',
 $j${"opciones": ["Meet us in an hour.", "Meet us in a flower.", "Meet us in our flour.", "Meet us in our hour."], "correcta": 0, "audio": "Meet us in an hour.", "es": "Encuéntranos en una hora.", "explicacion": "hour = hora (la h no se pronuncia)."}$j$::jsonb,
 'ep19-homofonos-2', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-homo2-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Our plane lands at noon.", "es": "Nuestro avión aterriza al mediodía."}, {"en": "Then we will take a taxi to the hotel.", "es": "Luego tomaremos un taxi al hotel."}], "pregunta": "What did the speaker's group take?", "pregunta_es": "¿Qué tomó el grupo del hablante?", "opciones": ["A plane", "A train", "A bus", "A boat"], "correcta": 0, "explicacion": "'Our plane lands at noon.'"}$j$::jsonb,
 'ep19-homofonos-2', 'input', false),
('banco-ep19-homo2-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I bought a pair of shoes at the sale.", "es": "Compré un par de zapatos en la rebaja."}, {"en": "I also bought a pear for lunch.", "es": "También compré una pera para el almuerzo."}], "pregunta": "What fruit did the speaker buy?", "pregunta_es": "¿Qué fruta compró el hablante?", "opciones": ["A pear", "An apple", "A banana", "A peach"], "correcta": 0, "explicacion": "'I also bought a pear for lunch.'"}$j$::jsonb,
 'ep19-homofonos-2', 'input', false),
('banco-ep19-homo2-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Compré una pera.", "respuestas": ["i bought a pear", "i bought a pear."], "mostrar": "I bought a pear.", "explicacion": "pear = pera; pair = par."}$j$::jsonb,
 'ep19-homofonos-2', 'output', false),
('banco-ep19-homo2-04', 'banco-ep19', 4, 'decir',
 $j${"es": "Ella come un pedazo de pan.", "respuestas": ["she eats a piece of bread"], "mostrar": "She eats a piece of bread.", "explicacion": "piece = pedazo."}$j$::jsonb,
 'ep19-homofonos-2', 'output', false),
('banco-ep19-homo2-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write two sentences with two homophones from this lesson.", "pregunta_es": "Escribe dos frases con dos homófonos de esta lección.", "ejemplo": "Our plane lands in an hour. I need a piece of cake.", "criterio": "cada homófono con su significado correcto.", "explicacion": "Revisa que cada palabra tenga el sentido correcto."}$j$::jsonb,
 'ep19-homofonos-2', 'output', false),
('banco-ep19-homo2-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "I need a ___ of paper.", "opciones": ["piece", "peace"], "correcta": 0, "es": "Necesito un pedazo de papel.", "explicacion": "piece.", "segundos": 5}$j$::jsonb,
 'ep19-homofonos-2', 'fluidez', false),
('banco-ep19-homo2-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "We'll ___ in the bay.", "opciones": ["sail", "sale"], "correcta": 0, "es": "Navegaremos en la bahía.", "explicacion": "sail.", "segundos": 5}$j$::jsonb,
 'ep19-homofonos-2', 'fluidez', false),
('banco-ep19-homo2-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "Please wait one ___.", "opciones": ["hour", "our"], "correcta": 0, "es": "Por favor espera una hora.", "explicacion": "hour.", "segundos": 5}$j$::jsonb,
 'ep19-homofonos-2', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-homo2-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "We ___ on the sea every Sunday.", "opciones": ["sail", "sale", "sell"], "correcta": 0, "es": "Navegamos en el mar cada domingo.", "explicacion": "sail = navegar."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', true),
('examen-ep19-homo2-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["the flower is red"], "mostrar": "The flower is red.", "es": "La flor es roja.", "explicacion": "flower = flor."}$j$::jsonb,
 'ep19-homofonos-2', 'estudio', true),
('examen-ep19-homo2-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["The shop has a sale today.", "The shop has a sail today.", "The shop has a seal today.", "The shop has a sell today."], "correcta": 0, "audio": "The shop has a sale today.", "es": "La tienda tiene una rebaja hoy.", "explicacion": "sale = rebaja."}$j$::jsonb,
 'ep19-homofonos-2', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 5: ep19-deberia-haber
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-shav-01', 'ep19-deberia-haber', 1, 'elegir',
 $j${"frase": "You ___ called me earlier.", "opciones": ["should have", "should has", "should had"], "correcta": 0, "es": "Deberías haberme llamado antes.", "explicacion": "should have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-02', 'ep19-deberia-haber', 2, 'elegir',
 $j${"frase": "I shouldn't ___ so much last night.", "opciones": ["have eaten", "eat", "eating", "ate"], "correcta": 0, "es": "No debí haber comido tanto anoche.", "explicacion": "shouldn't have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-03', 'ep19-deberia-haber', 3, 'elegir',
 $j${"frase": "She ___ the bus; she would have been on time.", "opciones": ["should have taken", "should taken", "should take"], "correcta": 0, "es": "Debió haber tomado el bus; habría llegado a tiempo.", "explicacion": "should have taken."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-04', 'ep19-deberia-haber', 4, 'elegir',
 $j${"frase": "We ___ earlier.", "opciones": ["should have left", "should leave", "have should left", "should left"], "correcta": 0, "es": "Deberíamos haber salido antes.", "explicacion": "should have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-05', 'ep19-deberia-haber', 5, 'escribir',
 $j${"respuestas": ["you should have called me", "you should have called me earlier"], "mostrar": "You should have called me.", "es": "Deberías haberme llamado.", "explicacion": "should have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-06', 'ep19-deberia-haber', 6, 'ordenar',
 $j${"frase": "I shouldn't have said that.", "es": "No debí haber dicho eso.", "explicacion": "shouldn't have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-07', 'ep19-deberia-haber', 7, 'emparejar',
 $j${"pares": [["should have called", "debería haber llamado"], ["shouldn't have spent", "no debí haber gastado"], ["should have studied", "debí haber estudiado"], ["shouldn't have gone", "no debí haber ido"]], "es": "", "explicacion": "Críticas y arrepentimientos."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', false),
('ep19-shav-08', 'ep19-deberia-haber', 8, 'escuchar',
 $j${"opciones": ["You should have told me.", "You should has told me.", "You should had told me.", "You should to have told me."], "correcta": 0, "audio": "You should have told me.", "es": "Deberías habérmelo dicho.", "explicacion": "should have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-shav-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Kathryn: You should have seen the wedding photos.", "es": "Kathryn: Deberías haber visto las fotos de la boda."}, {"en": "Leonard: I wish I had been there!", "es": "Leonard: ¡Ojalá hubiera estado ahí!"}], "pregunta": "What does Leonard regret?", "pregunta_es": "¿De qué se arrepiente Leonard?", "opciones": ["Missing the wedding", "Losing a bet", "Forgetting a book", "Buying a car"], "correcta": 0, "explicacion": "'I wish I had been there!'"}$j$::jsonb,
 'ep19-deberia-haber', 'input', false),
('banco-ep19-shav-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I shouldn't have bought so many shoes.", "es": "No debí haber comprado tantos zapatos."}, {"en": "Now I have no room in my closet.", "es": "Ahora no tengo espacio en el closet."}], "pregunta": "What is the speaker's problem?", "pregunta_es": "¿Cuál es el problema del hablante?", "opciones": ["No room in the closet", "Too little money", "No shoes", "A broken car"], "correcta": 0, "explicacion": "'Now I have no room in my closet.'"}$j$::jsonb,
 'ep19-deberia-haber', 'input', false),
('banco-ep19-shav-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Deberías haber llamado.", "respuestas": ["you should have called", "you should have called me"], "mostrar": "You should have called.", "explicacion": "should have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'output', false),
('banco-ep19-shav-04', 'banco-ep19', 4, 'decir',
 $j${"es": "No debí haber comido tanto.", "respuestas": ["i shouldn't have eaten so much", "i should not have eaten so much"], "mostrar": "I shouldn't have eaten so much.", "explicacion": "shouldn't have eaten."}$j$::jsonb,
 'ep19-deberia-haber', 'output', false),
('banco-ep19-shav-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write two sentences about something you should or shouldn't have done.", "pregunta_es": "Escribe dos frases sobre algo que debiste o no debiste haber hecho.", "ejemplo": "I should have studied more. I shouldn't have bought that expensive phone.", "criterio": "should/shouldn't have + participio.", "explicacion": "Críticas sobre el pasado."}$j$::jsonb,
 'ep19-deberia-haber', 'output', false),
('banco-ep19-shav-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "You ___ called me.", "opciones": ["should have", "should of"], "correcta": 0, "es": "Deberías haberme llamado.", "explicacion": "should have.", "segundos": 5}$j$::jsonb,
 'ep19-deberia-haber', 'fluidez', false),
('banco-ep19-shav-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "I ___ so late.", "opciones": ["shouldn't have stayed", "stayed"], "correcta": 0, "es": "No debí haberme quedado tan tarde.", "explicacion": "shouldn't have stayed.", "segundos": 5}$j$::jsonb,
 'ep19-deberia-haber', 'fluidez', false),
('banco-ep19-shav-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "She ___ an umbrella.", "opciones": ["should have brought", "should bring"], "correcta": 0, "es": "Debió haber traído un paraguas.", "explicacion": "should have brought.", "segundos": 5}$j$::jsonb,
 'ep19-deberia-haber', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-shav-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "They ___ the train; now they are late.", "opciones": ["should have taken", "should take", "took"], "correcta": 0, "es": "Debieron haber tomado el tren; ahora llegan tarde.", "explicacion": "should have taken."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', true),
('examen-ep19-shav-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["i shouldn't have said that"], "mostrar": "I shouldn't have said that.", "es": "No debí haber dicho eso.", "explicacion": "shouldn't have said."}$j$::jsonb,
 'ep19-deberia-haber', 'estudio', true),
('examen-ep19-shav-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["I shouldn't have said that.", "I shouldn't have say that.", "I should have said not that.", "I shouldn't said that."], "correcta": 0, "audio": "I shouldn't have said that.", "es": "No debí haber dicho eso.", "explicacion": "shouldn't have + participio."}$j$::jsonb,
 'ep19-deberia-haber', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 6: ep19-posibilidad-pasado
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-posp-01', 'ep19-posibilidad-pasado', 1, 'elegir',
 $j${"frase": "He ___ the train; he left late.", "opciones": ["might have missed", "might missed", "might have miss"], "correcta": 0, "es": "Quizá perdió el tren.", "explicacion": "might have + participio."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-02', 'ep19-posibilidad-pasado', 2, 'elegir',
 $j${"frase": "She ___ tired after the trip.", "opciones": ["must have been", "must be", "must been"], "correcta": 0, "es": "Debió haber estado cansada después del viaje.", "explicacion": "must have been: deducción fuerte sobre el pasado."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-03', 'ep19-posibilidad-pasado', 3, 'elegir',
 $j${"frase": "It ___ Peter; he is in Bogotá.", "opciones": ["can't have been", "can't be been", "couldn't has been"], "correcta": 0, "es": "No puede haber sido Peter; él está en Bogotá.", "explicacion": "can't have been: imposibilidad en el pasado."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-04', 'ep19-posibilidad-pasado', 4, 'elegir',
 $j${"frase": "They ___ the bus, but they walked.", "opciones": ["could have taken", "could took", "could taken"], "correcta": 0, "es": "Podrían haber tomado el bus, pero caminaron.", "explicacion": "could have + participio."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-05', 'ep19-posibilidad-pasado', 5, 'escribir',
 $j${"respuestas": ["he must have been tired", "he must have been very tired"], "mostrar": "He must have been tired.", "es": "Debió haber estado cansado.", "explicacion": "must have been."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-06', 'ep19-posibilidad-pasado', 6, 'ordenar',
 $j${"frase": "She might have forgotten her keys.", "es": "Quizá olvidó sus llaves.", "explicacion": "might have + participio."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-07', 'ep19-posibilidad-pasado', 7, 'emparejar',
 $j${"pares": [["might have missed", "quizá perdió"], ["must have been", "debió haber sido"], ["can't have been", "no puede haber sido"], ["could have taken", "podría haber tomado"]], "es": "", "explicacion": "Suposiciones sobre el pasado."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', false),
('ep19-posp-08', 'ep19-posibilidad-pasado', 8, 'escuchar',
 $j${"opciones": ["They might have been at home.", "They might has been at home.", "They might have be at home.", "They might have being at home."], "correcta": 0, "audio": "They might have been at home.", "es": "Quizá estuvieron en casa.", "explicacion": "might have been."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-posp-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Frances: Where's Lyle? He must have forgotten the time.", "es": "Frances: ¿Dónde está Lyle? Debió haber olvidado la hora."}, {"en": "Kathryn: He might have gone to buy champagne.", "es": "Kathryn: Quizá fue a comprar champán."}], "pregunta": "Where might Lyle be?", "pregunta_es": "¿Dónde podría estar Lyle?", "opciones": ["Buying champagne", "At home asleep", "At the airport", "At the wedding"], "correcta": 0, "explicacion": "'He might have gone to buy champagne.'"}$j$::jsonb,
 'ep19-posibilidad-pasado', 'input', false),
('banco-ep19-posp-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "The lights are off. They can't have arrived yet.", "es": "Las luces están apagadas. No pueden haber llegado todavía."}, {"en": "They must have left early.", "es": "Debieron haber salido temprano."}], "pregunta": "What do they think about the guests?", "pregunta_es": "¿Qué piensan de los invitados?", "opciones": ["They left early", "They arrived late", "They stayed at home", "They are still in traffic"], "correcta": 0, "explicacion": "'They must have left early.'"}$j$::jsonb,
 'ep19-posibilidad-pasado', 'input', false),
('banco-ep19-posp-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Debió haber sido difícil.", "respuestas": ["it must have been difficult", "it must have been hard"], "mostrar": "It must have been difficult.", "explicacion": "must have been."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'output', false),
('banco-ep19-posp-04', 'banco-ep19', 4, 'decir',
 $j${"es": "Quizá no lo oyó.", "respuestas": ["he might not have heard it", "he might not have heard"], "mostrar": "He might not have heard it.", "explicacion": "might not have + participio."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'output', false),
('banco-ep19-posp-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Make two guesses about what happened yesterday. Use might have, must have or can't have.", "pregunta_es": "Haz dos suposiciones sobre lo que pasó ayer. Usa might have, must have o can't have.", "ejemplo": "He must have been tired. She might have forgotten the meeting.", "criterio": "modal + have + participio.", "explicacion": "Suposiciones sobre el pasado."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'output', false),
('banco-ep19-posp-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "She ___ at home.", "opciones": ["must have been", "must be"], "correcta": 0, "es": "Debió haber estado en casa.", "explicacion": "must have been (pasado).", "segundos": 5}$j$::jsonb,
 'ep19-posibilidad-pasado', 'fluidez', false),
('banco-ep19-posp-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "They ___ the news.", "opciones": ["might have heard", "might heard"], "correcta": 0, "es": "Quizá oyeron la noticia.", "explicacion": "might have heard.", "segundos": 5}$j$::jsonb,
 'ep19-posibilidad-pasado', 'fluidez', false),
('banco-ep19-posp-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "It ___ him.", "opciones": ["can't have been", "can't be"], "correcta": 0, "es": "No puede haber sido él.", "explicacion": "can't have been.", "segundos": 5}$j$::jsonb,
 'ep19-posibilidad-pasado', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-posp-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "He ___ very hungry after the game.", "opciones": ["must have been", "must been", "must be been"], "correcta": 0, "es": "Debió haber tenido mucha hambre después del partido.", "explicacion": "must have been."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', true),
('examen-ep19-posp-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["they might have forgotten"], "mostrar": "They might have forgotten.", "es": "Quizá lo olvidaron.", "explicacion": "might have + participio."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'estudio', true),
('examen-ep19-posp-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["She could have called you.", "She could have call you.", "She could has called you.", "She could have calls you."], "correcta": 0, "audio": "She could have called you.", "es": "Ella podría haberte llamado.", "explicacion": "could have + participio."}$j$::jsonb,
 'ep19-posibilidad-pasado', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 7: ep19-modales-repaso
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-modr-01', 'ep19-modales-repaso', 1, 'elegir',
 $j${"frase": "You ___ wear a seatbelt. It's the law.", "opciones": ["must", "might", "can"], "correcta": 0, "es": "Debes usar el cinturón. Es la ley.", "explicacion": "must = obligación fuerte."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-02', 'ep19-modales-repaso', 2, 'elegir',
 $j${"frase": "___ I use your phone, please?", "opciones": ["May", "Must", "Might"], "correcta": 0, "es": "¿Puedo usar tu teléfono, por favor?", "explicacion": "May = permiso formal."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-03', 'ep19-modales-repaso', 3, 'elegir',
 $j${"frase": "She ___ speak three languages.", "opciones": ["can", "must", "might"], "correcta": 0, "es": "Ella sabe hablar tres idiomas.", "explicacion": "can = habilidad."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-04', 'ep19-modales-repaso', 4, 'elegir',
 $j${"frase": "We ___ leave now; the train is about to go.", "opciones": ["have to", "might", "could have"], "correcta": 0, "es": "Tenemos que salir ya; el tren está por partir.", "explicacion": "have to = obligación."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-05', 'ep19-modales-repaso', 5, 'escribir',
 $j${"respuestas": ["we must leave now", "we have to leave now"], "mostrar": "We have to leave now.", "es": "Tenemos que salir ahora.", "explicacion": "must o have to = obligación."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-06', 'ep19-modales-repaso', 6, 'ordenar',
 $j${"frase": "You don't have to pay for the entrance.", "es": "No tienes que pagar la entrada.", "explicacion": "don't have to = no es necesario."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-07', 'ep19-modales-repaso', 7, 'emparejar',
 $j${"pares": [["must", "deber (obligación)"], ["might", "quizá"], ["can", "poder / saber"], ["don't have to", "no es necesario"]], "es": "", "explicacion": "Significados de los modales."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', false),
('ep19-modr-08', 'ep19-modales-repaso', 8, 'escuchar',
 $j${"opciones": ["You must wear a helmet.", "You must to wear a helmet.", "You musts wear a helmet.", "You must wears a helmet."], "correcta": 0, "audio": "You must wear a helmet.", "es": "Debes usar casco.", "explicacion": "must + verbo base."}$j$::jsonb,
 'ep19-modales-repaso', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-modr-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Lyle: Can you play the piano?", "es": "Lyle: ¿Sabes tocar el piano?"}, {"en": "Frances: No, but I could learn if I had a teacher.", "es": "Frances: No, pero podría aprender si tuviera un profesor."}], "pregunta": "Can Frances play the piano now?", "pregunta_es": "¿Puede Frances tocar el piano ahora?", "opciones": ["No", "Yes", "She is learning", "She has a teacher"], "correcta": 0, "explicacion": "'No, but I could learn if I had a teacher.'"}$j$::jsonb,
 'ep19-modales-repaso', 'input', false),
('banco-ep19-modr-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "You may leave the room if you finish early.", "es": "Puedes salir del salón si terminas temprano."}, {"en": "You must return the book on time.", "es": "Debes devolver el libro a tiempo."}], "pregunta": "What must you do with the book?", "pregunta_es": "¿Qué debes hacer con el libro?", "opciones": ["Return it on time", "Keep it for a year", "Give it to a friend", "Sell it"], "correcta": 0, "explicacion": "'You must return the book on time.'"}$j$::jsonb,
 'ep19-modales-repaso', 'input', false),
('banco-ep19-modr-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Puedo nadar muy bien.", "respuestas": ["i can swim very well", "i can swim really well"], "mostrar": "I can swim very well.", "explicacion": "can = habilidad."}$j$::jsonb,
 'ep19-modales-repaso', 'output', false),
('banco-ep19-modr-04', 'banco-ep19', 4, 'decir',
 $j${"es": "No es necesario que vengas.", "respuestas": ["you don't have to come", "you do not have to come"], "mostrar": "You don't have to come.", "explicacion": "don't have to = no es necesario."}$j$::jsonb,
 'ep19-modales-repaso', 'output', false),
('banco-ep19-modr-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write two sentences: one with must (a rule) and one with might (a possibility).", "pregunta_es": "Escribe dos frases: una con must (una regla) y otra con might (una posibilidad).", "ejemplo": "You must bring your ID. I might be late tomorrow.", "criterio": "must = regla; might = posibilidad.", "explicacion": "Cada modal con su significado."}$j$::jsonb,
 'ep19-modales-repaso', 'output', false),
('banco-ep19-modr-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "You ___ wear a seatbelt.", "opciones": ["must", "musts"], "correcta": 0, "es": "Debes usar el cinturón.", "explicacion": "must.", "segundos": 5}$j$::jsonb,
 'ep19-modales-repaso', 'fluidez', false),
('banco-ep19-modr-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "I ___ go tomorrow.", "opciones": ["might", "mights"], "correcta": 0, "es": "Quizá vaya mañana.", "explicacion": "might.", "segundos": 5}$j$::jsonb,
 'ep19-modales-repaso', 'fluidez', false),
('banco-ep19-modr-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "He ___ drive.", "opciones": ["can", "cans"], "correcta": 0, "es": "Él sabe conducir.", "explicacion": "can.", "segundos": 5}$j$::jsonb,
 'ep19-modales-repaso', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-modr-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "___ you help me with this, please?", "opciones": ["Could", "Must", "Might"], "correcta": 0, "es": "¿Podrías ayudarme con esto, por favor?", "explicacion": "could = petición cortés."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', true),
('examen-ep19-modr-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["i might be late"], "mostrar": "I might be late.", "es": "Quizá llegue tarde.", "explicacion": "might + verbo base."}$j$::jsonb,
 'ep19-modales-repaso', 'estudio', true),
('examen-ep19-modr-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["You must finish the report.", "You musts finish the report.", "You must finishing the report.", "You must to finish the report."], "correcta": 0, "audio": "You must finish the report.", "es": "Debes terminar el informe.", "explicacion": "must + verbo base."}$j$::jsonb,
 'ep19-modales-repaso', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 8: ep19-brindis-vocabulario
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep19-vdes-01', 'ep19-brindis-vocabulario', 1, 'elegir',
 $j${"frase": "I have no ___ about my decision.", "opciones": ["regrets", "regretted", "regretful"], "correcta": 0, "es": "No me arrepiento de mi decisión.", "explicacion": "regret = arrepentimiento (sustantivo, en plural)."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-02', 'ep19-brindis-vocabulario', 2, 'elegir',
 $j${"frase": "Let's ___ to our success!", "opciones": ["drink", "drank", "drinking"], "correcta": 0, "es": "¡Brindemos por nuestro éxito!", "explicacion": "drink to = brindar por."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-03', 'ep19-brindis-vocabulario', 3, 'elegir',
 $j${"frase": "We need some time to ___ from work.", "opciones": ["get away", "get along", "get up"], "correcta": 0, "es": "Necesitamos tiempo para escaparnos del trabajo.", "explicacion": "get away = escaparse."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-04', 'ep19-brindis-vocabulario', 4, 'elegir',
 $j${"frase": "She is better at ___ puzzles than I am.", "opciones": ["crossword", "crossed", "crosswise"], "correcta": 0, "es": "Ella es mejor que yo en los crucigramas.", "explicacion": "crossword puzzle = crucigrama."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-05', 'ep19-brindis-vocabulario', 5, 'escribir',
 $j${"respuestas": ["i have no regrets", "i have no regret"], "mostrar": "I have no regrets.", "es": "No tengo arrepentimientos.", "explicacion": "no regrets = sin arrepentimientos."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-06', 'ep19-brindis-vocabulario', 6, 'ordenar',
 $j${"frase": "Let's drink to our future.", "es": "Brindemos por nuestro futuro.", "explicacion": "drink to + sustantivo."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-07', 'ep19-brindis-vocabulario', 7, 'emparejar',
 $j${"pares": [["regret", "arrepentimiento"], ["to hope", "esperar / desear"], ["to get away", "escaparse"], ["champagne", "champán"]], "es": "", "explicacion": "Vocabulario de la conversación."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', false),
('ep19-vdes-08', 'ep19-brindis-vocabulario', 8, 'escuchar',
 $j${"opciones": ["Let's drink champagne to celebrate.", "Let's drink champagne to sell.", "Let's drink champagne to sleep.", "Let's drink champagne to sail."], "correcta": 0, "audio": "Let's drink champagne to celebrate.", "es": "Brindemos con champán para celebrar.", "explicacion": "to celebrate = para celebrar."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep19-vdes-01', 'banco-ep19', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Walter: Would you like anything else?", "es": "Walter: ¿Desean algo más?"}, {"en": "Lyle: You can bring us your best bottle of champagne. This calls for a celebration!", "es": "Lyle: Traiga su mejor botella de champán. ¡Esto merece una celebración!"}], "pregunta": "Why do they want champagne?", "pregunta_es": "¿Por qué quieren champán?", "opciones": ["To celebrate", "To cook", "To clean", "To leave"], "correcta": 0, "explicacion": "'This calls for a celebration!'"}$j$::jsonb,
 'ep19-brindis-vocabulario', 'input', false),
('banco-ep19-vdes-02', 'banco-ep19', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Seeing you guys again is about as good as life gets.", "es": "Volver a verlos es lo mejor que la vida puede ofrecer."}, {"en": "I wish I lived closer, though.", "es": "Aunque ojalá viviera más cerca."}], "pregunta": "How does the speaker feel about seeing his friends?", "pregunta_es": "¿Cómo se siente el hablante al ver a sus amigos?", "opciones": ["Very happy", "Very angry", "Bored", "Worried"], "correcta": 0, "explicacion": "'Seeing you guys again is about as good as life gets.'"}$j$::jsonb,
 'ep19-brindis-vocabulario', 'input', false),
('banco-ep19-vdes-03', 'banco-ep19', 3, 'decir',
 $j${"es": "Brindemos por eso.", "respuestas": ["let's drink to that", "let us drink to that"], "mostrar": "Let's drink to that.", "explicacion": "drink to that = brindemos por eso."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'output', false),
('banco-ep19-vdes-04', 'banco-ep19', 4, 'decir',
 $j${"es": "Quiero escaparme del trabajo.", "respuestas": ["i want to get away from work", "i want to get away from it all"], "mostrar": "I want to get away from work.", "explicacion": "get away from = escaparse de."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'output', false),
('banco-ep19-vdes-05', 'banco-ep19', 5, 'libre',
 $j${"pregunta": "Write a short toast (brindis) for a friend. Use Let's drink to...", "pregunta_es": "Escribe un brindis corto para un amigo. Usa Let's drink to...", "ejemplo": "Let's drink to your new job! Let's drink to our friendship.", "criterio": "Let's drink to + sustantivo.", "explicacion": "Brindis con drink to."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'output', false),
('banco-ep19-vdes-06', 'banco-ep19', 6, 'rapido',
 $j${"frase": "Let's ___ to our friends!", "opciones": ["drink", "drank"], "correcta": 0, "es": "¡Brindemos por nuestros amigos!", "explicacion": "drink.", "segundos": 5}$j$::jsonb,
 'ep19-brindis-vocabulario', 'fluidez', false),
('banco-ep19-vdes-07', 'banco-ep19', 7, 'rapido',
 $j${"frase": "I have no ___.", "opciones": ["regrets", "regretted"], "correcta": 0, "es": "No tengo arrepentimientos.", "explicacion": "regrets.", "segundos": 5}$j$::jsonb,
 'ep19-brindis-vocabulario', 'fluidez', false),
('banco-ep19-vdes-08', 'banco-ep19', 8, 'rapido',
 $j${"frase": "She is good at crossword ___.", "opciones": ["puzzles", "puzzled"], "correcta": 0, "es": "Ella es buena en los crucigramas.", "explicacion": "puzzles.", "segundos": 5}$j$::jsonb,
 'ep19-brindis-vocabulario', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep19-vdes-01', 'examen-ep19', 1, 'elegir',
 $j${"frase": "I'd like a bottle of ___, please.", "opciones": ["champagne", "champion", "chandelier"], "correcta": 0, "es": "Quisiera una botella de champán, por favor.", "explicacion": "champagne = champán."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', true),
('examen-ep19-vdes-02', 'examen-ep19', 2, 'escribir',
 $j${"respuestas": ["let's drink to that"], "mostrar": "Let's drink to that!", "es": "¡Brindemos por eso!", "explicacion": "drink to that."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'estudio', true),
('examen-ep19-vdes-03', 'examen-ep19', 3, 'escuchar',
 $j${"opciones": ["Let's drink to our health.", "Let's drink to our hell.", "Let's drink to our help.", "Let's drink too our health."], "correcta": 0, "audio": "Let's drink to our health.", "es": "Brindemos por nuestra salud.", "explicacion": "drink to our health."}$j$::jsonb,
 'ep19-brindis-vocabulario', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;