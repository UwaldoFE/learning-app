-- =====================================================================
-- 025 · Episodio 16 completo (Unidades 33 y 34 del Libro 3)
--   - 8 temas nuevos en pensum_temas (orden 1-8 del Episodio 16):
--     Unidad 33 (Expressing Sympathy): expresar simpatía, conjunciones
--       subordinantes, linking words, describir animales.
--     Unidad 34 (A Conversation): voz pasiva (formación), voz pasiva (cuándo
--       usarla), pasiva con modales/infinitivos/gerundios, preguntas sobre animales.
--   - 8 lecciones tipo 'tema' (8 ejercicios cada una)
--   - banco-ep16 +8·8 = 64 ejercicios de práctica
--   - examen-ep16 +8·3 = 24 ejercicios reservados
--   - 8×19 = 152 ejercicios en total
--   - 'escuchar' de lección y examen va pata 'input'.
-- Requiere 006, 007, 008 y 011. Se puede correr varias veces sin dañar nada.
-- Pega TODO este archivo en Supabase → SQL Editor → Run.
-- =====================================================================

insert into unidades (materia_id, numero, episodio, objetivo) values
  ('ingles', 33, 'Episodio 16', 'Expressing sympathy, subordinating conjunctions, linking words and describing animals'),
  ('ingles', 34, 'Episodio 16', 'Passive voice and questions about animals')
on conflict (materia_id, numero) do update set
  episodio = excluded.episodio,
  objetivo = coalesce(nullif(unidades.objetivo, ''), excluded.objetivo);

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('banco-ep16', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 33), 16, 90, 'banco', 'Banco de ejercicios Episodio 16', 'Ejercicios de refuerzo - Episodio 16'),
  ('examen-ep16', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 33), 16, 91, 'examen', 'Examen Episodio 16', 'Evaluación - Episodio 16')
on conflict (id) do update set
  materia_id = excluded.materia_id, unidad_id = excluded.unidad_id, episodio = excluded.episodio,
  orden = excluded.orden, tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;

insert into pensum_temas (id, episodio, orden, nombre_es, nombre_en, descripcion) values
  ('ep16-expresiones-simpatia', 16, 1, $t$Expresar simpatía$t$, $t$Expressing sympathy$t$, $t$I'm sorry to hear that. Take your time. Do you need any help? Thanks for offering.$t$),
  ('ep16-conjunciones-subordinantes', 16, 2, $t$Conjunciones subordinantes$t$, $t$Subordinating conjunctions$t$, $t$because, although, while, unless: unen una idea principal con una cláusula. Ej.: Although it was cold, she went out.$t$),
  ('ep16-linking-words', 16, 3, $t$Linking words (conectores)$t$, $t$Linking words$t$, $t$For example, however, as a result, in addition: conectan ideas al hablar y al escribir.$t$),
  ('ep16-animales-descripcion', 16, 4, $t$Describir animales$t$, $t$Describing animals$t$, $t$Vocabulario de animales y frases para describirlos: has four legs, lives in the sea, eats meat.$t$),
  ('ep16-pasiva-formacion', 16, 5, $t$Voz pasiva: formación$t$, $t$Passive voice: form$t$, $t$be (am/is/are/was/were) + participio: The house was built in 1899.$t$),
  ('ep16-pasiva-usos', 16, 6, $t$Voz pasiva: cuándo usarla$t$, $t$Passive voice: when to use it$t$, $t$Se usa cuando nos interesa quien recibe la acción o no sabemos quién la hizo: A window had been left open.$t$),
  ('ep16-pasiva-infinitivos', 16, 7, $t$Voz pasiva con modales, infinitivos y gerundios$t$, $t$Passive with modals, infinitives and gerunds$t$, $t$You have to be tested. I remember being taught to drive. I was born in 1976.$t$),
  ('ep16-animales-preguntas', 16, 8, $t$Preguntas sobre animales$t$, $t$Questions about animals$t$, $t$Does it...? Can it...? Is it...? How many...? Adivina el animal haciendo preguntas.$t$)
on conflict (id) do update set episodio = excluded.episodio, orden = excluded.orden,
  nombre_es = excluded.nombre_es, nombre_en = excluded.nombre_en, descripcion = excluded.descripcion;

insert into lecciones (id, materia_id, unidad_id, episodio, orden, tipo, titulo, descripcion) values
  ('ep16-expresiones-simpatia', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 33), 16, 1, 'tema', $t$Expressing sympathy$t$, $t$I'm sorry to hear that. Take your time. Do you need any help? Thanks for offering.$t$),
  ('ep16-conjunciones-subordinantes', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 33), 16, 2, 'tema', $t$Subordinating conjunctions$t$, $t$because, although, while, unless: unen una idea principal con una cláusula. Ej.: Although it was cold, she went out.$t$),
  ('ep16-linking-words', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 33), 16, 3, 'tema', $t$Linking words$t$, $t$For example, however, as a result, in addition: conectan ideas al hablar y al escribir.$t$),
  ('ep16-animales-descripcion', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 33), 16, 4, 'tema', $t$Describing animals$t$, $t$Vocabulario de animales y frases para describirlos: has four legs, lives in the sea, eats meat.$t$),
  ('ep16-pasiva-formacion', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 34), 16, 5, 'tema', $t$Passive voice: form$t$, $t$be (am/is/are/was/were) + participio: The house was built in 1899.$t$),
  ('ep16-pasiva-usos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 34), 16, 6, 'tema', $t$Passive voice: when to use it$t$, $t$Se usa cuando nos interesa quien recibe la acción o no sabemos quién la hizo: A window had been left open.$t$),
  ('ep16-pasiva-infinitivos', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 34), 16, 7, 'tema', $t$Passive with modals, infinitives and gerunds$t$, $t$You have to be tested. I remember being taught to drive. I was born in 1976.$t$),
  ('ep16-animales-preguntas', 'ingles', (select id from unidades where materia_id = 'ingles' and numero = 34), 16, 8, 'tema', $t$Questions about animals$t$, $t$Does it...? Can it...? Is it...? How many...? Adivina el animal haciendo preguntas.$t$)
on conflict (id) do update set unidad_id = excluded.unidad_id, episodio = excluded.episodio, orden = excluded.orden,
  tipo = excluded.tipo, titulo = excluded.titulo, descripcion = excluded.descripcion;


-- EJERCICIOS — TEMA 1: ep16-expresiones-simpatia
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-simp-01', 'ep16-expresiones-simpatia', 1, 'elegir',
 $j${"frase": "I'm sorry ___ hear about your accident.", "opciones": ["to", "for", "at", "on"], "correcta": 0, "es": "Lamento escuchar sobre tu accidente.", "explicacion": "sorry to hear = lo siento al saber."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-02', 'ep16-expresiones-simpatia', 2, 'elegir',
 $j${"frase": "Take ___. There's no hurry.", "opciones": ["your time", "your job", "your car", "your place"], "correcta": 0, "es": "Tómate tu tiempo. No hay prisa.", "explicacion": "Take your time = tómate tu tiempo."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-03', 'ep16-expresiones-simpatia', 3, 'elegir',
 $j${"frase": "___ you need any help?", "opciones": ["Do", "Are", "Is", "Did"], "correcta": 0, "es": "¿Necesitas alguna ayuda?", "explicacion": "Do you need...? (need es verbo de acción)."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-04', 'ep16-expresiones-simpatia', 4, 'elegir',
 $j${"frase": "Thanks for ___, but I'm fine.", "opciones": ["offering", "offer", "to offer", "offered"], "correcta": 0, "es": "Gracias por ofrecerlo, pero estoy bien.", "explicacion": "Thanks for + verbo con -ing."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-05', 'ep16-expresiones-simpatia', 5, 'escribir',
 $j${"respuestas": ["i'm sorry to hear that", "im sorry to hear that", "i am sorry to hear that"], "mostrar": "I'm sorry to hear that.", "es": "Lo siento al saber eso.", "explicacion": "sorry to hear that = expresión fija de simpatía."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-06', 'ep16-expresiones-simpatia', 6, 'ordenar',
 $j${"frase": "I'm really sorry about your uncle.", "es": "Lo siento mucho por tu tío.", "explicacion": "sorry about = lo siento por (algo que pasó)."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-07', 'ep16-expresiones-simpatia', 7, 'emparejar',
 $j${"pares": [["I'm sorry to hear that", "lo siento al saber eso"], ["Take your time", "tómate tu tiempo"], ["Do you need any help?", "¿necesitas ayuda?"], ["Thanks for offering", "gracias por ofrecerlo"]], "es": "", "explicacion": "Frases básicas de simpatía."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', false),
('ep16-simp-08', 'ep16-expresiones-simpatia', 8, 'escuchar',
 $j${"opciones": ["Take your time.", "Take your car.", "Make your time.", "Take your seat."], "correcta": 0, "audio": "Take your time.", "es": "Tómate tu tiempo.", "explicacion": "Take your time = tómate tu tiempo."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-simp-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Leonard, I heard about your uncle's accident.", "es": "Leonard, escuché sobre el accidente de tu tío."}, {"en": "I'm sorry to hear that. Is he okay?", "es": "Lo siento al saber eso. ¿Está bien?"}], "pregunta": "What is the speaker doing?", "pregunta_es": "¿Qué hace el hablante?", "opciones": ["Expressing sympathy", "Making a reservation", "Asking for directions", "Ordering food"], "correcta": 0, "explicacion": "'I'm sorry to hear that' = expresar simpatía."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'input', false),
('banco-ep16-simp-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I'm sorry about your dog. Take your time to rest.", "es": "Lamento lo de tu perro. Tómate tu tiempo para descansar."}, {"en": "Thanks. I appreciate it.", "es": "Gracias. Lo aprecio."}], "pregunta": "What does the first speaker suggest?", "pregunta_es": "¿Qué sugiere el primer hablante?", "opciones": ["To take time to rest", "To buy a new dog", "To travel tomorrow", "To call the doctor"], "correcta": 0, "explicacion": "'Take your time to rest.'"}$j$::jsonb,
 'ep16-expresiones-simpatia', 'input', false),
('banco-ep16-simp-03', 'banco-ep16', 3, 'decir',
 $j${"es": "Lo siento al saber eso.", "respuestas": ["i'm sorry to hear that", "im sorry to hear that", "i am sorry to hear that"], "mostrar": "I'm sorry to hear that.", "explicacion": "sorry to hear that = lo siento al saber eso."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'output', false),
('banco-ep16-simp-04', 'banco-ep16', 4, 'decir',
 $j${"es": "Tómate tu tiempo.", "respuestas": ["take your time"], "mostrar": "Take your time.", "explicacion": "Take your time = tómate tu tiempo."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'output', false),
('banco-ep16-simp-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "How would you comfort a friend whose father is sick? Write two sentences with sympathy expressions.", "pregunta_es": "¿Cómo consolarías a un amigo cuyo padre está enfermo? Escribe dos frases con expresiones de simpatía.", "ejemplo": "I'm sorry to hear that. Do you need any help?", "criterio": "sorry to hear / Do you need / Take your time.", "explicacion": "Usa expresiones de simpatía y una oferta de ayuda."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'output', false),
('banco-ep16-simp-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "I'm sorry ___ hear that.", "opciones": ["to", "for", "at"], "correcta": 0, "es": "Lo siento al saber eso.", "explicacion": "sorry to hear.", "segundos": 5}$j$::jsonb,
 'ep16-expresiones-simpatia', 'fluidez', false),
('banco-ep16-simp-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "Thanks ___ calling me.", "opciones": ["for", "to", "at"], "correcta": 0, "es": "Gracias por llamarme.", "explicacion": "Thanks for + -ing.", "segundos": 5}$j$::jsonb,
 'ep16-expresiones-simpatia', 'fluidez', false),
('banco-ep16-simp-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "___ your time. There's no hurry.", "opciones": ["Take", "Make", "Do"], "correcta": 0, "es": "Tómate tu tiempo. No hay prisa.", "explicacion": "Take your time.", "segundos": 5}$j$::jsonb,
 'ep16-expresiones-simpatia', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-simp-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "___ you need any help with your homework?", "opciones": ["Do", "Does", "Are", "Is"], "correcta": 0, "es": "¿Necesitas ayuda con tu tarea?", "explicacion": "Do you need...?"}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', true),
('examen-ep16-simp-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["i'm sorry to hear that", "im sorry to hear that", "i am sorry to hear that"], "mostrar": "I'm sorry to hear that.", "es": "Lo siento al saber eso.", "explicacion": "sorry to hear that."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'estudio', true),
('examen-ep16-simp-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["Thanks for offering, but I'm fine.", "Thanks for offer, but I am fine.", "Thanks for to offer, I'm fine.", "Thanks offer for, I'm fine."], "correcta": 0, "audio": "Thanks for offering, but I'm fine.", "es": "Gracias por ofrecerlo, pero estoy bien.", "explicacion": "Thanks for + -ing."}$j$::jsonb,
 'ep16-expresiones-simpatia', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 2: ep16-conjunciones-subordinantes
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-conj-01', 'ep16-conjunciones-subordinantes', 1, 'elegir',
 $j${"frase": "___ it was raining, we stayed home.", "opciones": ["Because", "Because of", "Although", "Despite"], "correcta": 0, "es": "Como llovía, nos quedamos en casa.", "explicacion": "because + cláusula (sujeto + verbo)."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-02', 'ep16-conjunciones-subordinantes', 2, 'elegir',
 $j${"frase": "She went out ___ it was cold.", "opciones": ["although", "despite", "because of", "due to"], "correcta": 0, "es": "Salió aunque hacía frío.", "explicacion": "although + cláusula; despite/because of + sustantivo."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-03', 'ep16-conjunciones-subordinantes', 3, 'elegir',
 $j${"frase": "I won't go out ___ it stops raining.", "opciones": ["unless", "although", "because", "while"], "correcta": 0, "es": "No saldré a menos que deje de llover.", "explicacion": "unless = a menos que."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-04', 'ep16-conjunciones-subordinantes', 4, 'elegir',
 $j${"frase": "___ I was cooking, the phone rang.", "opciones": ["While", "Despite", "Unless", "Because of"], "correcta": 0, "es": "Mientras cocinaba, sonó el teléfono.", "explicacion": "while + cláusula con verbo."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-05', 'ep16-conjunciones-subordinantes', 5, 'escribir',
 $j${"respuestas": ["because it was raining"], "mostrar": "We stayed home because it was raining.", "es": "Nos quedamos en casa porque llovía.", "explicacion": "because + sujeto + verbo."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-06', 'ep16-conjunciones-subordinantes', 6, 'ordenar',
 $j${"frase": "Although she was tired, she helped me.", "es": "Aunque estaba cansada, me ayudó.", "explicacion": "Although + cláusula, coma, cláusula principal."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-07', 'ep16-conjunciones-subordinantes', 7, 'emparejar',
 $j${"pares": [["because", "porque"], ["although", "aunque"], ["while", "mientras"], ["unless", "a menos que"]], "es": "", "explicacion": "Conjunciones subordinantes básicas."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', false),
('ep16-conj-08', 'ep16-conjunciones-subordinantes', 8, 'escuchar',
 $j${"opciones": ["I'll help you unless I'm busy.", "I'll help you because I'm busy.", "I'll help you although I'm busy.", "I'll help you despite I'm busy."], "correcta": 0, "audio": "I'll help you unless I'm busy.", "es": "Te ayudaré a menos que esté ocupado.", "explicacion": "unless = if not."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-conj-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Although it rained all day, we went to the beach.", "es": "Aunque llovió todo el día, fuimos a la playa."}, {"en": "We got wet, but we had fun.", "es": "Nos mojamos, pero nos divertimos."}], "pregunta": "Did they go to the beach?", "pregunta_es": "¿Fueron a la playa?", "opciones": ["Yes, although it rained", "No, because it rained", "No, it was sunny", "Yes, but it was cold"], "correcta": 0, "explicacion": "'Although it rained all day, we went...'"}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'input', false),
('banco-ep16-conj-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "I'm staying home while my wife works.", "es": "Me quedo en casa mientras mi esposa trabaja."}, {"en": "I'll cook dinner unless she is late.", "es": "Cocinaré la cena a menos que ella llegue tarde."}], "pregunta": "When does the speaker cook dinner?", "pregunta_es": "¿Cuándo cocina la cena el hablante?", "opciones": ["Unless his wife is late", "While his wife sleeps", "Because it is cold", "Despite the rain"], "correcta": 0, "explicacion": "'I'll cook dinner unless she is late.'"}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'input', false),
('banco-ep16-conj-03', 'banco-ep16', 3, 'decir',
 $j${"es": "Aunque estoy cansado, voy al gimnasio.", "respuestas": ["although i am tired i go to the gym", "although im tired i go to the gym"], "mostrar": "Although I'm tired, I go to the gym.", "explicacion": "Although + cláusula."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'output', false),
('banco-ep16-conj-04', 'banco-ep16', 4, 'decir',
 $j${"es": "No saldré a menos que deje de llover.", "respuestas": ["i will not go out unless it stops raining", "i won't go out unless it stops raining", "i wont go out unless it stops raining"], "mostrar": "I won't go out unless it stops raining.", "explicacion": "unless = a menos que."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'output', false),
('banco-ep16-conj-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Write two sentences using because and although about your day.", "pregunta_es": "Escribe dos frases con because y although sobre tu día.", "ejemplo": "I'm tired because I worked late. Although I'm tired, I'll go to the gym.", "criterio": "because + cláusula; although + cláusula.", "explicacion": "Cada conjunción va seguida de sujeto + verbo."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'output', false),
('banco-ep16-conj-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "I stayed home ___ it was raining.", "opciones": ["because", "because of", "despite"], "correcta": 0, "es": "Me quedé en casa porque llovía.", "explicacion": "because + cláusula.", "segundos": 5}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'fluidez', false),
('banco-ep16-conj-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "___ it was late, we kept talking.", "opciones": ["Although", "Despite", "Because of"], "correcta": 0, "es": "Aunque era tarde, seguimos hablando.", "explicacion": "although + cláusula.", "segundos": 5}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'fluidez', false),
('banco-ep16-conj-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "I'll call you ___ I finish work.", "opciones": ["when", "unless"], "correcta": 0, "es": "Te llamaré cuando termine el trabajo.", "explicacion": "when = cuando.", "segundos": 5}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-conj-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "___ she is tired, she is still working.", "opciones": ["Although", "Because", "Unless"], "correcta": 0, "es": "Aunque está cansada, sigue trabajando.", "explicacion": "Although + cláusula."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', true),
('examen-ep16-conj-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["because it was late"], "mostrar": "We went home because it was late.", "es": "Nos fuimos a casa porque era tarde.", "explicacion": "because + cláusula."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'estudio', true),
('examen-ep16-conj-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["I won't go unless you come with me.", "I won't go because you come with me.", "I will go although you come with me.", "I won't go while you come with me."], "correcta": 0, "audio": "I won't go unless you come with me.", "es": "No iré a menos que vengas conmigo.", "explicacion": "unless = a menos que."}$j$::jsonb,
 'ep16-conjunciones-subordinantes', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 3: ep16-linking-words
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-link-01', 'ep16-linking-words', 1, 'elegir',
 $j${"frase": "I like sports. ___, I play tennis every weekend.", "opciones": ["For example", "However", "Namely", "Consequently"], "correcta": 0, "es": "Me gustan los deportes. Por ejemplo, juego tenis cada fin de semana.", "explicacion": "For example = por ejemplo."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-02', 'ep16-linking-words', 2, 'elegir',
 $j${"frase": "The price is high. ___, the quality is excellent.", "opciones": ["However", "Also", "Besides", "Finally"], "correcta": 0, "es": "El precio es alto. Sin embargo, la calidad es excelente.", "explicacion": "However = sin embargo (contraste)."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-03', 'ep16-linking-words', 3, 'elegir',
 $j${"frase": "The company is growing. ___, they are hiring more staff.", "opciones": ["As a result", "In spite of", "Although", "Unless"], "correcta": 0, "es": "La empresa está creciendo. Como resultado, están contratando más personal.", "explicacion": "As a result = como resultado."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-04', 'ep16-linking-words', 4, 'elegir',
 $j${"frase": "___ the rain, we went for a walk.", "opciones": ["In spite of", "Because", "However", "Namely"], "correcta": 0, "es": "A pesar de la lluvia, salimos a caminar.", "explicacion": "In spite of + sustantivo."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-05', 'ep16-linking-words', 5, 'escribir',
 $j${"respuestas": ["for example", "for instance"], "mostrar": "For example, I like apples.", "es": "Por ejemplo, me gustan las manzanas.", "explicacion": "For example / For instance = por ejemplo."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-06', 'ep16-linking-words', 6, 'ordenar',
 $j${"frase": "In addition, we need more time.", "es": "Además, necesitamos más tiempo.", "explicacion": "In addition = además."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-07', 'ep16-linking-words', 7, 'emparejar',
 $j${"pares": [["however", "sin embargo"], ["as a result", "como resultado"], ["in addition", "además"], ["in conclusion", "en conclusión"]], "es": "", "explicacion": "Conectores comunes."}$j$::jsonb,
 'ep16-linking-words', 'estudio', false),
('ep16-link-08', 'ep16-linking-words', 8, 'escuchar',
 $j${"opciones": ["In conclusion, we agree.", "In addition, we agree.", "However, we agree.", "For example, we agree."], "correcta": 0, "audio": "In conclusion, we agree.", "es": "En conclusión, estamos de acuerdo.", "explicacion": "In conclusion = en conclusión."}$j$::jsonb,
 'ep16-linking-words', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-link-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "The food was cheap. However, it was not very good.", "es": "La comida era barata. Sin embargo, no era muy buena."}, {"en": "Also, the service was slow.", "es": "Además, el servicio fue lento."}], "pregunta": "Was the food good?", "pregunta_es": "¿La comida era buena?", "opciones": ["No, it was cheap but not very good", "Yes, it was excellent", "No, it was expensive", "Yes, but the service was fast"], "correcta": 0, "explicacion": "'However' marca el contraste."}$j$::jsonb,
 'ep16-linking-words', 'input', false),
('banco-ep16-link-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Due to the rain, the match was postponed.", "es": "Debido a la lluvia, el partido se aplazó."}, {"en": "As a result, we stayed at home.", "es": "Como resultado, nos quedamos en casa."}], "pregunta": "Why did they stay at home?", "pregunta_es": "¿Por qué se quedaron en casa?", "opciones": ["Because the match was postponed", "Because it was sunny", "Because they were tired", "Because of the food"], "correcta": 0, "explicacion": "'As a result' = como resultado."}$j$::jsonb,
 'ep16-linking-words', 'input', false),
('banco-ep16-link-03', 'banco-ep16', 3, 'decir',
 $j${"es": "Por ejemplo, me gusta leer.", "respuestas": ["for example i like reading", "for example i like to read", "for instance i like reading"], "mostrar": "For example, I like reading.", "explicacion": "For example = por ejemplo."}$j$::jsonb,
 'ep16-linking-words', 'output', false),
('banco-ep16-link-04', 'banco-ep16', 4, 'decir',
 $j${"es": "Sin embargo, es muy caro.", "respuestas": ["however it is very expensive", "however its very expensive", "however it's very expensive"], "mostrar": "However, it's very expensive.", "explicacion": "However + coma."}$j$::jsonb,
 'ep16-linking-words', 'output', false),
('banco-ep16-link-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Write two sentences about a city you like. Use however and for example.", "pregunta_es": "Escribe dos frases sobre una ciudad que te guste. Usa however y for example.", "ejemplo": "Cúcuta is hot. However, I love its food. For example, the arepas are delicious.", "criterio": "however para contraste; for example para ejemplo.", "explicacion": "Cada conector va al inicio de una frase, seguido de coma."}$j$::jsonb,
 'ep16-linking-words', 'output', false),
('banco-ep16-link-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "The price is high. ___, it is worth it.", "opciones": ["However", "Namely"], "correcta": 0, "es": "El precio es alto. Sin embargo, vale la pena.", "explicacion": "However = contraste.", "segundos": 5}$j$::jsonb,
 'ep16-linking-words', 'fluidez', false),
('banco-ep16-link-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "___ the food, the service was great.", "opciones": ["Apart from", "Unless"], "correcta": 0, "es": "Aparte de la comida, el servicio fue genial.", "explicacion": "apart from = aparte de.", "segundos": 5}$j$::jsonb,
 'ep16-linking-words', 'fluidez', false),
('banco-ep16-link-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "We need more money. ___, we need time.", "opciones": ["Also", "However"], "correcta": 0, "es": "Necesitamos más dinero. Además, necesitamos tiempo.", "explicacion": "Also = además.", "segundos": 5}$j$::jsonb,
 'ep16-linking-words', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-link-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "I love music. ___, I play the guitar.", "opciones": ["For example", "However", "Unless"], "correcta": 0, "es": "Me encanta la música. Por ejemplo, toco la guitarra.", "explicacion": "For example = por ejemplo."}$j$::jsonb,
 'ep16-linking-words', 'estudio', true),
('examen-ep16-link-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["in conclusion"], "mostrar": "In conclusion, we agree.", "es": "En conclusión, estamos de acuerdo.", "explicacion": "In conclusion = en conclusión."}$j$::jsonb,
 'ep16-linking-words', 'estudio', true),
('examen-ep16-link-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["As a result, we left early.", "As a result, we stayed late.", "However, we left early.", "In addition, we left early."], "correcta": 0, "audio": "As a result, we left early.", "es": "Como resultado, salimos temprano.", "explicacion": "As a result = como resultado."}$j$::jsonb,
 'ep16-linking-words', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 4: ep16-animales-descripcion
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-anim-01', 'ep16-animales-descripcion', 1, 'elegir',
 $j${"frase": "A dog ___ four legs.", "opciones": ["has", "have", "is", "are"], "correcta": 0, "es": "Un perro tiene cuatro patas.", "explicacion": "has = tercera persona singular."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-02', 'ep16-animales-descripcion', 2, 'elegir',
 $j${"frase": "A dolphin ___ in the sea.", "opciones": ["lives", "live", "living", "is live"], "correcta": 0, "es": "Un delfín vive en el mar.", "explicacion": "lives = tercera persona singular."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-03', 'ep16-animales-descripcion', 3, 'elegir',
 $j${"frase": "A lion ___ meat.", "opciones": ["eats", "eat", "eating", "is eat"], "correcta": 0, "es": "Un león come carne.", "explicacion": "eats = tercera persona singular."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-04', 'ep16-animales-descripcion', 4, 'elegir',
 $j${"frase": "A bird can ___, but a fish can't.", "opciones": ["fly", "swim", "run", "climb"], "correcta": 0, "es": "Un pájaro puede volar, pero un pez no.", "explicacion": "can + verbo base."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-05', 'ep16-animales-descripcion', 5, 'escribir',
 $j${"respuestas": ["a horse has four legs", "a horse has 4 legs"], "mostrar": "A horse has four legs.", "es": "Un caballo tiene cuatro patas.", "explicacion": "has + número de patas."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-06', 'ep16-animales-descripcion', 6, 'ordenar',
 $j${"frase": "The elephant is very big.", "es": "El elefante es muy grande.", "explicacion": "very big = muy grande."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-07', 'ep16-animales-descripcion', 7, 'emparejar',
 $j${"pares": [["dog", "perro"], ["dolphin", "delfín"], ["lion", "león"], ["bird", "pájaro"]], "es": "", "explicacion": "Animales básicos."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', false),
('ep16-anim-08', 'ep16-animales-descripcion', 8, 'escuchar',
 $j${"opciones": ["The cat has a long tail.", "The cat has a long nose.", "The cat lives in the sea.", "The cat flies."], "correcta": 0, "audio": "The cat has a long tail.", "es": "El gato tiene una cola larga.", "explicacion": "has + parte del cuerpo."}$j$::jsonb,
 'ep16-animales-descripcion', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-anim-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "It lives in the sea. It has fins and it eats fish.", "es": "Vive en el mar. Tiene aletas y come pescado."}, {"en": "It is not a fish. It is a mammal.", "es": "No es un pez. Es un mamífero."}], "pregunta": "What is the animal?", "pregunta_es": "¿Qué animal es?", "opciones": ["A dolphin", "A lion", "A dog", "A bird"], "correcta": 0, "explicacion": "Vive en el mar y es mamífero: delfín."}$j$::jsonb,
 'ep16-animales-descripcion', 'input', false),
('banco-ep16-anim-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "This animal has a long neck and four legs.", "es": "Este animal tiene un cuello largo y cuatro patas."}, {"en": "It eats leaves from the trees.", "es": "Come hojas de los árboles."}], "pregunta": "What does this animal eat?", "pregunta_es": "¿Qué come este animal?", "opciones": ["Leaves", "Meat", "Fish", "Seeds"], "correcta": 0, "explicacion": "'It eats leaves from the trees.'"}$j$::jsonb,
 'ep16-animales-descripcion', 'input', false),
('banco-ep16-anim-03', 'banco-ep16', 3, 'decir',
 $j${"es": "El perro tiene cuatro patas.", "respuestas": ["the dog has four legs", "a dog has four legs"], "mostrar": "The dog has four legs.", "explicacion": "has + número de patas."}$j$::jsonb,
 'ep16-animales-descripcion', 'output', false),
('banco-ep16-anim-04', 'banco-ep16', 4, 'decir',
 $j${"es": "El delfín vive en el mar.", "respuestas": ["the dolphin lives in the sea", "a dolphin lives in the sea"], "mostrar": "The dolphin lives in the sea.", "explicacion": "lives = tercera persona."}$j$::jsonb,
 'ep16-animales-descripcion', 'output', false),
('banco-ep16-anim-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Describe an animal you like: where it lives, what it eats, and one physical feature.", "pregunta_es": "Describe un animal que te guste: dónde vive, qué come y una característica física.", "ejemplo": "My cat lives in my house. It eats fish. It has a long tail.", "criterio": "lives / eats / has + sustantivo.", "explicacion": "Usa la tercera persona: lives, eats, has."}$j$::jsonb,
 'ep16-animales-descripcion', 'output', false),
('banco-ep16-anim-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "A cow ___ grass.", "opciones": ["eats", "eat"], "correcta": 0, "es": "Una vaca come pasto.", "explicacion": "eats.", "segundos": 5}$j$::jsonb,
 'ep16-animales-descripcion', 'fluidez', false),
('banco-ep16-anim-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "A bird ___ in a tree.", "opciones": ["lives", "live"], "correcta": 0, "es": "Un pájaro vive en un árbol.", "explicacion": "lives.", "segundos": 5}$j$::jsonb,
 'ep16-animales-descripcion', 'fluidez', false),
('banco-ep16-anim-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "A tiger ___ strong legs.", "opciones": ["has", "have"], "correcta": 0, "es": "Un tigre tiene patas fuertes.", "explicacion": "has.", "segundos": 5}$j$::jsonb,
 'ep16-animales-descripcion', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-anim-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "A penguin ___ in the cold.", "opciones": ["lives", "live", "living"], "correcta": 0, "es": "Un pingüino vive en el frío.", "explicacion": "lives = tercera persona."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', true),
('examen-ep16-anim-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["a cat has a tail", "the cat has a tail"], "mostrar": "A cat has a tail.", "es": "Un gato tiene cola.", "explicacion": "has + parte del cuerpo."}$j$::jsonb,
 'ep16-animales-descripcion', 'estudio', true),
('examen-ep16-anim-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["The monkey eats bananas.", "The monkey eats fish.", "The monkey has wings.", "The monkey lives in the sea."], "correcta": 0, "audio": "The monkey eats bananas.", "es": "El mono come bananas.", "explicacion": "eats = come."}$j$::jsonb,
 'ep16-animales-descripcion', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 5: ep16-pasiva-formacion
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-pfor-01', 'ep16-pasiva-formacion', 1, 'elegir',
 $j${"frase": "The house ___ in 1899.", "opciones": ["was built", "built", "is build", "was build"], "correcta": 0, "es": "La casa fue construida en 1899.", "explicacion": "was + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-02', 'ep16-pasiva-formacion', 2, 'elegir',
 $j${"frase": "The road ___ repaired right now.", "opciones": ["is being", "is", "has being", "being"], "correcta": 0, "es": "La carretera está siendo reparada ahora.", "explicacion": "is being + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-03', 'ep16-pasiva-formacion', 3, 'elegir',
 $j${"frase": "___ these houses built in 1899?", "opciones": ["Were", "Was", "Are", "Did"], "correcta": 0, "es": "¿Fueron construidas estas casas en 1899?", "explicacion": "Were + sujeto plural + participio?"}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-04', 'ep16-pasiva-formacion', 4, 'elegir',
 $j${"frase": "The letter ___ sent yesterday.", "opciones": ["was", "did", "is"], "correcta": 0, "es": "La carta fue enviada ayer.", "explicacion": "was + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-05', 'ep16-pasiva-formacion', 5, 'escribir',
 $j${"respuestas": ["the house wasnt built in 1899", "the house was not built in 1899", "the house wasn't built in 1899"], "mostrar": "The house wasn't built in 1899.", "es": "La casa no fue construida en 1899.", "explicacion": "wasn't = was not."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-06', 'ep16-pasiva-formacion', 6, 'ordenar',
 $j${"frase": "Was the house built in 1899?", "es": "¿Fue construida la casa en 1899?", "explicacion": "Was + sujeto + participio?"}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-07', 'ep16-pasiva-formacion', 7, 'emparejar',
 $j${"pares": [["was built", "fue construida"], ["is repaired", "es reparada"], ["were eaten", "fueron comidas"], ["has been stolen", "ha sido robado"]], "es": "", "explicacion": "Pasiva con be + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', false),
('ep16-pfor-08', 'ep16-pasiva-formacion', 8, 'escuchar',
 $j${"opciones": ["My car has been stolen.", "My car has stolen.", "My car was steal.", "My car is stealing."], "correcta": 0, "audio": "My car has been stolen.", "es": "Me robaron el carro.", "explicacion": "has been + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-pfor-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "The bridge was painted last year.", "es": "El puente fue pintado el año pasado."}, {"en": "It is being repaired now.", "es": "Ahora lo están reparando."}], "pregunta": "Is the bridge being repaired now?", "pregunta_es": "¿Están reparando el puente ahora?", "opciones": ["Yes", "No, it was sold", "No, it was built", "No, it was stolen"], "correcta": 0, "explicacion": "'It is being repaired now.'"}$j$::jsonb,
 'ep16-pasiva-formacion', 'input', false),
('banco-ep16-pfor-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "My bike was stolen yesterday.", "es": "Mi bicicleta fue robada ayer."}, {"en": "Was it found?", "es": "¿La encontraron?"}], "pregunta": "What happened to the bike?", "pregunta_es": "¿Qué pasó con la bicicleta?", "opciones": ["It was stolen", "It was painted", "It was repaired", "It was sold"], "correcta": 0, "explicacion": "'My bike was stolen yesterday.'"}$j$::jsonb,
 'ep16-pasiva-formacion', 'input', false),
('banco-ep16-pfor-03', 'banco-ep16', 3, 'decir',
 $j${"es": "La casa fue construida en 1899.", "respuestas": ["the house was built in 1899"], "mostrar": "The house was built in 1899.", "explicacion": "was built = fue construida."}$j$::jsonb,
 'ep16-pasiva-formacion', 'output', false),
('banco-ep16-pfor-04', 'banco-ep16', 4, 'decir',
 $j${"es": "¿Fue reparada la carretera?", "respuestas": ["was the road repaired"], "mostrar": "Was the road repaired?", "explicacion": "Was + sujeto + participio?"}$j$::jsonb,
 'ep16-pasiva-formacion', 'output', false),
('banco-ep16-pfor-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Write two sentences in passive voice about something that was done or is being done in your city.", "pregunta_es": "Escribe dos frases en voz pasiva sobre algo que se hizo o se está haciendo en tu ciudad.", "ejemplo": "The park was cleaned last week. A new bridge is being built.", "criterio": "was/were/is/are/being + participio.", "explicacion": "Usa be + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'output', false),
('banco-ep16-pfor-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "The letter ___ sent yesterday.", "opciones": ["was", "did"], "correcta": 0, "es": "La carta fue enviada ayer.", "explicacion": "was + participio.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-formacion', 'fluidez', false),
('banco-ep16-pfor-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "The car ___ repaired now.", "opciones": ["is being", "has"], "correcta": 0, "es": "El carro está siendo reparado ahora.", "explicacion": "is being + participio.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-formacion', 'fluidez', false),
('banco-ep16-pfor-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "The books ___ written in 1990.", "opciones": ["were", "was"], "correcta": 0, "es": "Los libros fueron escritos en 1990.", "explicacion": "plural = were.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-formacion', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-pfor-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "The windows ___ cleaned every week.", "opciones": ["are", "is", "were"], "correcta": 0, "es": "Las ventanas se limpian cada semana.", "explicacion": "plural presente: are + participio."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', true),
('examen-ep16-pfor-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["it was built in 2000"], "mostrar": "It was built in 2000.", "es": "Fue construido en 2000.", "explicacion": "was built = fue construido."}$j$::jsonb,
 'ep16-pasiva-formacion', 'estudio', true),
('examen-ep16-pfor-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["The cake was eaten by the children.", "The cake eats the children.", "The children were eat the cake.", "The cake is eating children."], "correcta": 0, "audio": "The cake was eaten by the children.", "es": "El pastel fue comido por los niños.", "explicacion": "was eaten = fue comido."}$j$::jsonb,
 'ep16-pasiva-formacion', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 6: ep16-pasiva-usos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-puso-01', 'ep16-pasiva-usos', 1, 'elegir',
 $j${"frase": "I noticed that a window ___ left open.", "opciones": ["had been", "has been", "was been", "is"], "correcta": 0, "es": "Noté que una ventana había quedado abierta.", "explicacion": "had been + participio (pasado perfecto pasivo)."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-02', 'ep16-pasiva-usos', 2, 'elegir',
 $j${"frase": "Thousands of people are ___ on our roads every year.", "opciones": ["killed", "kill", "killing", "killer"], "correcta": 0, "es": "Cada año miles de personas mueren en nuestras carreteras.", "explicacion": "are killed = forma pasiva."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-03', 'ep16-pasiva-usos', 3, 'elegir',
 $j${"frase": "All the cookies ___ eaten.", "opciones": ["have been", "are been", "have be", "was been"], "correcta": 0, "es": "Todas las galletas han sido comidas.", "explicacion": "have been + participio."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-04', 'ep16-pasiva-usos', 4, 'elegir',
 $j${"frase": "The passive is used ___ in English.", "opciones": ["frequently", "frequency", "frequent"], "correcta": 0, "es": "La voz pasiva se usa con frecuencia en inglés.", "explicacion": "frequently = con frecuencia (adverbio)."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-05', 'ep16-pasiva-usos', 5, 'escribir',
 $j${"respuestas": ["my car has been stolen"], "mostrar": "My car has been stolen!", "es": "¡Me robaron el carro!", "explicacion": "has been stolen: no decimos quién."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-06', 'ep16-pasiva-usos', 6, 'ordenar',
 $j${"frase": "The road is being repaired.", "es": "La carretera está siendo reparada.", "explicacion": "is being + participio: nos interesa la carretera."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-07', 'ep16-pasiva-usos', 7, 'emparejar',
 $j${"pares": [["has been eaten", "ha sido comido"], ["had been left", "había sido dejado"], ["is being repaired", "está siendo reparado"], ["was built", "fue construido"]], "es": "", "explicacion": "Pasiva en distintos tiempos."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', false),
('ep16-puso-08', 'ep16-pasiva-usos', 8, 'escuchar',
 $j${"opciones": ["A window had been left open.", "A window had left open.", "A window has leave open.", "A window was leaving open."], "correcta": 0, "audio": "A window had been left open.", "es": "Una ventana había quedado abierta.", "explicacion": "had been + participio."}$j$::jsonb,
 'ep16-pasiva-usos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-puso-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Every year thousands of trees are cut down.", "es": "Cada año se talan miles de árboles."}, {"en": "We do not know who cuts them.", "es": "No sabemos quién los corta."}], "pregunta": "Does the speaker know who cuts the trees?", "pregunta_es": "¿El hablante sabe quién corta los árboles?", "opciones": ["No", "Yes, the farmers", "Yes, the children", "Yes, the government"], "correcta": 0, "explicacion": "'We do not know who cuts them.'"}$j$::jsonb,
 'ep16-pasiva-usos', 'input', false),
('banco-ep16-puso-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "The door was left open last night.", "es": "La puerta quedó abierta anoche."}, {"en": "Nobody knows who opened it.", "es": "Nadie sabe quién la abrió."}], "pregunta": "Why does the speaker use the passive?", "pregunta_es": "¿Por qué usa el hablante la pasiva?", "opciones": ["Because nobody knows who did it", "Because it is a question", "Because the door is new", "Because it happened long ago"], "correcta": 0, "explicacion": "Nadie sabe quién lo hizo."}$j$::jsonb,
 'ep16-pasiva-usos', 'input', false),
('banco-ep16-puso-03', 'banco-ep16', 3, 'decir',
 $j${"es": "Me robaron el carro.", "respuestas": ["my car has been stolen", "my car was stolen"], "mostrar": "My car has been stolen.", "explicacion": "has been stolen = fue robado (no nos interesa quién)."}$j$::jsonb,
 'ep16-pasiva-usos', 'output', false),
('banco-ep16-puso-04', 'banco-ep16', 4, 'decir',
 $j${"es": "Todas las galletas han sido comidas.", "respuestas": ["all the cookies have been eaten"], "mostrar": "All the cookies have been eaten.", "explicacion": "have been + participio."}$j$::jsonb,
 'ep16-pasiva-usos', 'output', false),
('banco-ep16-puso-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Write two sentences in passive voice: one where you know who did the action and one where you don't.", "pregunta_es": "Escribe dos frases en pasiva: una donde sabes quién hizo la acción y otra donde no lo sabes.", "ejemplo": "The bread was baked by my mom. My bike has been stolen.", "criterio": "usa by si se sabe quién; sin by si no se sabe.", "explicacion": "by + quien hace la acción, solo si lo sabemos o es importante."}$j$::jsonb,
 'ep16-pasiva-usos', 'output', false),
('banco-ep16-puso-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "Many cars ___ sold every month.", "opciones": ["are", "is"], "correcta": 0, "es": "Muchos carros se venden cada mes.", "explicacion": "plural: are.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-usos', 'fluidez', false),
('banco-ep16-puso-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "The phone ___ stolen yesterday.", "opciones": ["was", "did"], "correcta": 0, "es": "El teléfono fue robado ayer.", "explicacion": "was + participio.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-usos', 'fluidez', false),
('banco-ep16-puso-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "The room ___ cleaned already.", "opciones": ["has been", "is being"], "correcta": 0, "es": "El cuarto ya fue limpiado.", "explicacion": "has been cleaned = ya fue.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-usos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-puso-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "My bag ___ yesterday.", "opciones": ["was stolen", "stole", "was steal"], "correcta": 0, "es": "Mi bolso fue robado ayer.", "explicacion": "was + participio."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', true),
('examen-ep16-puso-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["the window was left open"], "mostrar": "The window was left open.", "es": "La ventana quedó abierta.", "explicacion": "was left open."}$j$::jsonb,
 'ep16-pasiva-usos', 'estudio', true),
('examen-ep16-puso-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["Every year, thousands of people are killed on the roads.", "Every year, thousands of people kill the roads.", "Every year, thousands of roads are killed.", "Every year, people are killing thousands."], "correcta": 0, "audio": "Every year, thousands of people are killed on the roads.", "es": "Cada año, miles de personas mueren en las carreteras.", "explicacion": "are killed = forma pasiva."}$j$::jsonb,
 'ep16-pasiva-usos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 7: ep16-pasiva-infinitivos
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-pinf-01', 'ep16-pasiva-infinitivos', 1, 'elegir',
 $j${"frase": "You have to ___ tested on your English grammar.", "opciones": ["be", "been", "being", "is"], "correcta": 0, "es": "Tienes que ser evaluado en tu gramática de inglés.", "explicacion": "modal + be + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-02', 'ep16-pasiva-infinitivos', 2, 'elegir',
 $j${"frase": "John might ___ promoted next year.", "opciones": ["be", "is", "been", "being"], "correcta": 0, "es": "John podría ser ascendido el próximo año.", "explicacion": "might be promoted."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-03', 'ep16-pasiva-infinitivos', 3, 'elegir',
 $j${"frase": "I remember ___ taught to drive.", "opciones": ["being", "be", "been", "to be"], "correcta": 0, "es": "Recuerdo que me enseñaron a conducir.", "explicacion": "remember + being + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-04', 'ep16-pasiva-infinitivos', 4, 'elegir',
 $j${"frase": "I was ___ in 1976.", "opciones": ["born", "bear", "borne", "birth"], "correcta": 0, "es": "Nací en 1976.", "explicacion": "to be born = nacer (forma pasiva)."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-05', 'ep16-pasiva-infinitivos', 5, 'escribir',
 $j${"respuestas": ["i was born in 1976"], "mostrar": "I was born in 1976.", "es": "Nací en 1976.", "explicacion": "was born = nací."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-06', 'ep16-pasiva-infinitivos', 6, 'ordenar',
 $j${"frase": "She wants to be invited to the party.", "es": "Ella quiere ser invitada a la fiesta.", "explicacion": "want + to be + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-07', 'ep16-pasiva-infinitivos', 7, 'emparejar',
 $j${"pares": [["might be promoted", "podría ser ascendido"], ["being taught", "siendo enseñado"], ["to be invited", "ser invitado"], ["was born", "nací"]], "es": "", "explicacion": "Pasiva con modales, infinitivos y gerundios."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', false),
('ep16-pinf-08', 'ep16-pasiva-infinitivos', 8, 'escuchar',
 $j${"opciones": ["Poodles like to be pampered.", "Poodles like to pamper.", "Poodles like pampering to be.", "Poodles are pamper like."], "correcta": 0, "audio": "Poodles like to be pampered.", "es": "A los caniches les gusta que los consientan.", "explicacion": "like to be + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-pinf-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Most film stars hate being interviewed.", "es": "A la mayoría de estrellas de cine no les gusta que les hagan entrevistas."}, {"en": "They prefer to be left alone.", "es": "Prefieren que los dejen en paz."}], "pregunta": "What do film stars prefer?", "pregunta_es": "¿Qué prefieren las estrellas de cine?", "opciones": ["To be left alone", "To be interviewed", "To be photographed", "To be promoted"], "correcta": 0, "explicacion": "'They prefer to be left alone.'"}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'input', false),
('banco-ep16-pinf-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Around 100 babies are born in this hospital every week.", "es": "Cerca de 100 bebés nacen en este hospital cada semana."}, {"en": "We expect to be busy this month.", "es": "Esperamos estar ocupados este mes."}], "pregunta": "How many babies are born in this hospital each week?", "pregunta_es": "¿Cuántos bebés nacen en este hospital cada semana?", "opciones": ["Around 100", "Around 10", "Around 1000", "None"], "correcta": 0, "explicacion": "'Around 100 babies are born...'"}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'input', false),
('banco-ep16-pinf-03', 'banco-ep16', 3, 'decir',
 $j${"es": "Tienes que ser evaluado.", "respuestas": ["you have to be tested"], "mostrar": "You have to be tested.", "explicacion": "have to be + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'output', false),
('banco-ep16-pinf-04', 'banco-ep16', 4, 'decir',
 $j${"es": "Me gusta que me consientan.", "respuestas": ["i like being pampered", "i like to be pampered"], "mostrar": "I like being pampered.", "explicacion": "like + being / to be + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'output', false),
('banco-ep16-pinf-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Write two sentences: one with a modal (might, must) and passive, one with a gerund (being + participle).", "pregunta_es": "Escribe dos frases: una con un modal (might, must) y pasiva, otra con gerundio (being + participio).", "ejemplo": "You must be paid on time. I hate being interrupted.", "criterio": "modal + be + participio; being + participio.", "explicacion": "Usa be + participio después de modales y being después de verbos."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'output', false),
('banco-ep16-pinf-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "You may ___ disappointed.", "opciones": ["be", "been"], "correcta": 0, "es": "Puede que te decepciones.", "explicacion": "may be disappointed.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'fluidez', false),
('banco-ep16-pinf-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "I hate ___ interrupted.", "opciones": ["being", "been"], "correcta": 0, "es": "Odio que me interrumpan.", "explicacion": "hate + being.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'fluidez', false),
('banco-ep16-pinf-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "He was ___ in Cúcuta.", "opciones": ["born", "bear"], "correcta": 0, "es": "Él nació en Cúcuta.", "explicacion": "was born.", "segundos": 5}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-pinf-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "The children are excited about ___ taken to the zoo.", "opciones": ["being", "be", "been"], "correcta": 0, "es": "Los niños están emocionados de que los lleven al zoológico.", "explicacion": "about + being + participio."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', true),
('examen-ep16-pinf-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["i was born in 1990"], "mostrar": "I was born in 1990.", "es": "Nací en 1990.", "explicacion": "was born = nací."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'estudio', true),
('examen-ep16-pinf-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["You might be surprised on your birthday.", "You might be surprise on your birthday.", "You might surprised be on your birthday.", "You might surprise be on your birthday."], "correcta": 0, "audio": "You might be surprised on your birthday.", "es": "Puede que te sorprendas en tu cumpleaños.", "explicacion": "might be surprised."}$j$::jsonb,
 'ep16-pasiva-infinitivos', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;

-- EJERCICIOS — TEMA 8: ep16-animales-preguntas
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('ep16-apre-01', 'ep16-animales-preguntas', 1, 'elegir',
 $j${"frase": "___ it eat meat?", "opciones": ["Does", "Is", "Can", "Do"], "correcta": 0, "es": "¿Come carne?", "explicacion": "Does + sujeto + verbo base?"}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-02', 'ep16-animales-preguntas', 2, 'elegir',
 $j${"frase": "___ it fly?", "opciones": ["Can", "Does", "Is", "Has"], "correcta": 0, "es": "¿Puede volar?", "explicacion": "Can + sujeto + verbo base?"}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-03', 'ep16-animales-preguntas', 3, 'elegir',
 $j${"frase": "Is it ___ or small?", "opciones": ["big", "bigs", "bigger than", "biggest"], "correcta": 0, "es": "¿Es grande o pequeño?", "explicacion": "Is it + adjetivo?"}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-04', 'ep16-animales-preguntas', 4, 'elegir',
 $j${"frase": "How ___ legs does it have?", "opciones": ["many", "much", "old", "long"], "correcta": 0, "es": "¿Cuántas patas tiene?", "explicacion": "How many + plural."}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-05', 'ep16-animales-preguntas', 5, 'escribir',
 $j${"respuestas": ["does it eat fish"], "mostrar": "Does it eat fish?", "es": "¿Come pescado?", "explicacion": "Does + sujeto + verbo base."}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-06', 'ep16-animales-preguntas', 6, 'ordenar',
 $j${"frase": "Can it swim in the sea?", "es": "¿Puede nadar en el mar?", "explicacion": "Can + sujeto + verbo?"}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-07', 'ep16-animales-preguntas', 7, 'emparejar',
 $j${"pares": [["Can it fly?", "¿Puede volar?"], ["Is it big?", "¿Es grande?"], ["How many legs?", "¿Cuántas patas?"], ["Does it eat meat?", "¿Come carne?"]], "es": "", "explicacion": "Preguntas básicas para adivinar."}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', false),
('ep16-apre-08', 'ep16-animales-preguntas', 8, 'escuchar',
 $j${"opciones": ["Does it live on land?", "Does it lives on land?", "Is it live on land?", "Can it lives on land?"], "correcta": 0, "audio": "Does it live on land?", "es": "¿Vive en tierra?", "explicacion": "Does + verbo base (sin -s)."}$j$::jsonb,
 'ep16-animales-preguntas', 'input', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('banco-ep16-apre-01', 'banco-ep16', 1, 'comprension',
 $j${"modo": "escuchar", "lineas": [{"en": "Is it bigger than a dog?", "es": "¿Es más grande que un perro?"}, {"en": "Yes, it is. And it has a long tail.", "es": "Sí, lo es. Y tiene una cola larga."}], "pregunta": "Is the animal bigger than a dog?", "pregunta_es": "¿El animal es más grande que un perro?", "opciones": ["Yes", "No", "It has no tail", "It is a bird"], "correcta": 0, "explicacion": "'Yes, it is.'"}$j$::jsonb,
 'ep16-animales-preguntas', 'input', false),
('banco-ep16-apre-02', 'banco-ep16', 2, 'comprension',
 $j${"modo": "leer", "lineas": [{"en": "Can it fly? No, it can't.", "es": "¿Puede volar? No, no puede."}, {"en": "Does it eat grass? Yes, it does.", "es": "¿Come pasto? Sí, come."}], "pregunta": "What can we say about the animal?", "pregunta_es": "¿Qué podemos decir del animal?", "opciones": ["It eats grass and can't fly", "It flies and eats meat", "It lives in the sea", "It has no legs"], "correcta": 0, "explicacion": "No vuela y come pasto."}$j$::jsonb,
 'ep16-animales-preguntas', 'input', false),
('banco-ep16-apre-03', 'banco-ep16', 3, 'decir',
 $j${"es": "¿Puede volar?", "respuestas": ["can it fly"], "mostrar": "Can it fly?", "explicacion": "Can + sujeto + verbo."}$j$::jsonb,
 'ep16-animales-preguntas', 'output', false),
('banco-ep16-apre-04', 'banco-ep16', 4, 'decir',
 $j${"es": "¿Cuántas patas tiene?", "respuestas": ["how many legs does it have"], "mostrar": "How many legs does it have?", "explicacion": "How many + plural + does it have?"}$j$::jsonb,
 'ep16-animales-preguntas', 'output', false),
('banco-ep16-apre-05', 'banco-ep16', 5, 'libre',
 $j${"pregunta": "Ask three questions to guess a mystery animal. Use can, does and is.", "pregunta_es": "Haz tres preguntas para adivinar un animal misterioso. Usa can, does e is.", "ejemplo": "Is it big? Does it eat meat? Can it fly?", "criterio": "is/can/does + sujeto + verbo base.", "explicacion": "Las preguntas empiezan con el auxiliar."}$j$::jsonb,
 'ep16-animales-preguntas', 'output', false),
('banco-ep16-apre-06', 'banco-ep16', 6, 'rapido',
 $j${"frase": "___ it eat meat?", "opciones": ["Does", "Do"], "correcta": 0, "es": "¿Come carne?", "explicacion": "it → does.", "segundos": 5}$j$::jsonb,
 'ep16-animales-preguntas', 'fluidez', false),
('banco-ep16-apre-07', 'banco-ep16', 7, 'rapido',
 $j${"frase": "Is it ___ or small?", "opciones": ["big", "bigs"], "correcta": 0, "es": "¿Es grande o pequeño?", "explicacion": "big.", "segundos": 5}$j$::jsonb,
 'ep16-animales-preguntas', 'fluidez', false),
('banco-ep16-apre-08', 'banco-ep16', 8, 'rapido',
 $j${"frase": "How ___ legs does it have?", "opciones": ["many", "much"], "correcta": 0, "es": "¿Cuántas patas tiene?", "explicacion": "How many.", "segundos": 5}$j$::jsonb,
 'ep16-animales-preguntas', 'fluidez', false)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;
insert into ejercicios (id, leccion_id, orden, tipo, datos, tema_id, pata, reservado) values
('examen-ep16-apre-01', 'examen-ep16', 1, 'elegir',
 $j${"frase": "___ it swim?", "opciones": ["Can", "Does", "Is"], "correcta": 0, "es": "¿Puede nadar?", "explicacion": "Can + sujeto + verbo base."}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', true),
('examen-ep16-apre-02', 'examen-ep16', 2, 'escribir',
 $j${"respuestas": ["does it eat grass"], "mostrar": "Does it eat grass?", "es": "¿Come pasto?", "explicacion": "Does + sujeto + verbo base."}$j$::jsonb,
 'ep16-animales-preguntas', 'estudio', true),
('examen-ep16-apre-03', 'examen-ep16', 3, 'escuchar',
 $j${"opciones": ["Can it live in the sea?", "Can it lives in the sea?", "Does it can live in the sea?", "Is it live in the sea?"], "correcta": 0, "audio": "Can it live in the sea?", "es": "¿Puede vivir en el mar?", "explicacion": "Can + verbo base."}$j$::jsonb,
 'ep16-animales-preguntas', 'input', true)
on conflict (id) do update set
  leccion_id = excluded.leccion_id, orden = excluded.orden, tipo = excluded.tipo,
  datos = excluded.datos, tema_id = excluded.tema_id, pata = excluded.pata, reservado = excluded.reservado;