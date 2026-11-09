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
      { tema: "ep1-profesiones", q: "What is Laura's job?", es: "¿Cuál es el trabajo de Laura?", opciones: ["She is a nurse.", "She is an engineer.", "She is a teacher."], correcta: 0, ex: "\"She is a nurse\" = Ella es enfermera." },
      { tema: "ep1-a-an", q: "Tom is ___ engineer.", es: "Tom es ingeniero.", opciones: ["a", "an", "the"], correcta: 1, ex: "\"an\" va antes de sonido de vocal: an engineer, an umbrella." },
      { tema: "ep1-pronombres", q: "What color is Tom's car?", es: "¿De qué color es el carro de Tom?", opciones: ["Blue", "Black", "Red"], correcta: 2, ex: "\"His car is red\" = Su carro es rojo. His = de él." },
      { tema: "ep1-comparativos", q: "Who is taller?", es: "¿Quién es más alto?", opciones: ["Laura", "Tom"], correcta: 1, ex: "\"Tom is taller\" = Tom es más alto. Tall → taller." }
    ]
  },
  {
    id: "ep1-two-brothers", episodio: 1, titulo: "Two Brothers", es: "Dos hermanos",
    tema: "profesiones, describir personas, comparativos y superlativos",
    lineas: [
      { en: "This is Mark. He is a lawyer.", es: "Este es Mark. Es abogado." },
      { en: "His brother is Sam. Sam is a taxi driver.", es: "Su hermano es Sam. Sam es taxista." },
      { en: "Mark is tall and thin. He has short black hair.", es: "Mark es alto y delgado. Tiene el pelo corto y negro." },
      { en: "Sam is shorter than Mark, but he is stronger.", es: "Sam es más bajo que Mark, pero es más fuerte." },
      { en: "Sam has big brown eyes and a big smile.", es: "Sam tiene ojos grandes y cafés y una gran sonrisa." },
      { en: "Mark is older than Sam. Mark is forty, and Sam is thirty-five.", es: "Mark es mayor que Sam. Mark tiene cuarenta y Sam treinta y cinco." },
      { en: "Today it is cold and cloudy.", es: "Hoy está frío y nublado." },
      { en: "Sam is the happiest man in the city!", es: "¡Sam es el hombre más feliz de la ciudad!" }
    ],
    preguntas: [
      { tema: "ep1-profesiones", q: "What is Mark's job?", es: "¿Cuál es el trabajo de Mark?", opciones: ["He is a lawyer.", "He is a taxi driver.", "He is a nurse."], correcta: 0, ex: "\"He is a lawyer\" = Es abogado. La profesión lleva a/an." },
      { tema: "ep1-comparativos", q: "Who is taller?", es: "¿Quién es más alto?", opciones: ["Mark", "Sam"], correcta: 0, ex: "\"Sam is shorter than Mark\" = Sam es más bajo que Mark, así que Mark es más alto." },
      { tema: "ep1-cuerpo", q: "What color are Sam's eyes?", es: "¿De qué color son los ojos de Sam?", opciones: ["Brown", "Black", "Blue"], correcta: 0, ex: "\"big brown eyes\" = ojos grandes y cafés. El adjetivo va antes de eyes." },
      { tema: "ep1-comparativos", q: "Who is older?", es: "¿Quién es mayor?", opciones: ["Sam", "Mark"], correcta: 1, ex: "\"Mark is older than Sam\": old → older than." }
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
      { tema: "ep2-hora", q: "What time does Tom wake up?", es: "¿A qué hora se despierta Tom?", opciones: ["At six o'clock.", "At seven o'clock.", "At twelve o'clock."], correcta: 0, ex: "\"Tom wakes up at six\": con he/she el verbo lleva -s (wakes)." },
      { tema: "ep2-presente-s", q: "How does Tom go to work?", es: "¿Cómo va Tom al trabajo?", opciones: ["By car.", "By bus.", "By taxi."], correcta: 1, ex: "\"He goes to work by bus\" = Va en bus. go → goes con he." },
      { tema: "ep2-presente-s", q: "Where does Laura work?", es: "¿Dónde trabaja Laura?", opciones: ["In an office.", "In a school.", "In a hospital."], correcta: 2, ex: "\"She works in a hospital.\" Pregunta con does, respuesta con -s." },
      { tema: "ep2-do-does", q: "Does Tom like his job?", es: "¿A Tom le gusta su trabajo?", opciones: ["Yes, he do.", "Yes, he does.", "Yes, he likes."], correcta: 1, ex: "Respuesta corta con he/she: \"Yes, he does\" / \"No, he doesn't\"." }
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
      { tema: "ep3-would-like", q: "What would Laura like to do?", es: "¿Qué le gustaría hacer a Laura?", opciones: ["Go to the cinema.", "Go to the airport.", "Have lunch."], correcta: 0, ex: "\"Would you like to go…?\" = ¿Te gustaría ir…? Sirve para invitar." },
      { tema: "ep3-can-could", q: "Can Tom meet at seven?", es: "¿Tom puede verse a las siete?", opciones: ["Yes, he can.", "No, he can't."], correcta: 1, ex: "\"Sorry, I can't\" = Lo siento, no puedo. can't = can not." },
      { tema: "ep3-can-could", q: "Why can't Tom meet at seven?", es: "¿Por qué Tom no puede a las siete?", opciones: ["He is tired.", "He works until seven.", "He has a class."], correcta: 1, ex: "\"I work until seven\" = Trabajo hasta las siete." },
      { tema: "ep3-would-like", q: "\"I'd like that\" means…", es: "\"I'd like that\" significa…", opciones: ["Me gusta eso.", "Me gustaría (eso).", "No me gusta."], correcta: 1, ex: "I'd like = I would like = me gustaría. Es más cortés que \"I want\"." }
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
      { tema: "ep3-conectores", q: "Why can't Anna visit the museum on Sunday?", es: "¿Por qué Anna no puede visitar el museo el domingo?", opciones: ["It is closed.", "It is far.", "It is expensive."], correcta: 0, ex: "\"…but it is closed on Sunday\". But = pero (contraste)." },
      { tema: "ep3-may-might", q: "Why does Anna take an umbrella?", es: "¿Por qué Anna lleva un paraguas?", opciones: ["It is sunny.", "It may rain.", "She likes it."], correcta: 1, ex: "\"It may rain\" = Puede que llueva. May/might = posibilidad." },
      { tema: "ep3-conectores", q: "Why is Tom tired?", es: "¿Por qué Tom está cansado?", opciones: ["Because he works a lot.", "Because he watches TV.", "Because he is sick."], correcta: 0, ex: "Because = porque (da la razón). So = así que (da la consecuencia)." },
      { tema: "ep3-may-might", q: "\"He might stay home\" means…", es: "\"He might stay home\" significa…", opciones: ["Debe quedarse en casa.", "Tal vez se quede en casa.", "Se quedó en casa."], correcta: 1, ex: "might + verbo = tal vez / puede que. No cambia: he might stay (sin -s)." }
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
      { tema: "ep3-can-could", q: "Where does Laura want to go?", es: "¿A dónde quiere ir Laura?", opciones: ["To the hospital.", "To the airport.", "To the museum."], correcta: 1, ex: "\"Could you take me to the airport?\" = ¿Me podría llevar al aeropuerto? Could = forma cortés de pedir." },
      { tema: "ep3-question-words", q: "How long does it take?", es: "¿Cuánto se demora?", opciones: ["Ten minutes.", "Thirty minutes.", "One hour."], correcta: 1, ex: "How long = cuánto tiempo. \"About thirty minutes\" = unos treinta minutos." },
      { tema: "ep2-presente-s", q: "Who lives in Miami?", es: "¿Quién vive en Miami?", opciones: ["Her sister.", "Her brother.", "The driver."], correcta: 1, ex: "\"My brother lives there\": brother = hermano; lives con -s (he)." },
      { tema: "ep3-question-words", q: "How much is the taxi?", es: "¿Cuánto cuesta el taxi?", opciones: ["$15", "$25", "$35"], correcta: 1, ex: "How much = cuánto (precio). Twenty-five = 25." }
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
      { tema: "ep1-adjetivos", q: "What color is the bag?", es: "¿De qué color es el bolso?", opciones: ["Blue", "Black", "Red"], correcta: 1, ex: "\"a black bag\": en inglés el color va antes de la cosa." },
      { tema: "ep3-whose", q: "Whose bag is it?", es: "¿De quién es el bolso?", opciones: ["The man's bag.", "The woman's bag.", "The boy's bag."], correcta: 2, ex: "Whose = de quién. Se responde con 's: the boy's bag = el bolso del niño." },
      { tema: "ep3-whose", q: "Complete: \"___ phone is this?\"", es: "¿De quién es este teléfono?", opciones: ["Who", "Whose", "Where"], correcta: 1, ex: "Para preguntar el dueño: Whose + cosa + is this?" },
      { tema: "ep2-hora", q: "\"A quarter to ten\" is…", es: "\"A quarter to ten\" es…", opciones: ["10:15", "9:45", "10:45"], correcta: 1, ex: "\"to\" = para / menos: un cuarto para las diez = 9:45. \"past\" = y: a quarter past ten = 10:15." }
    ]
  },
  {
    id: "ep4-a-night-at-the-hotel", episodio: 4, titulo: "A Night at the Hotel", es: "Una noche en el hotel",
    tema: "pasado regular e irregular, was/were, pasado progresivo y used to",
    lineas: [
      { en: "Last Friday, Uwaldo and Maria traveled to Bogotá for a shoe fair.", es: "El viernes pasado, Uwaldo y María viajaron a Bogotá a una feria de calzado." },
      { en: "They arrived at the hotel at ten o'clock at night.", es: "Llegaron al hotel a las diez de la noche." },
      { en: "The receptionist was very kind, but their room wasn't ready.", es: "La recepcionista fue muy amable, pero su habitación no estaba lista." },
      { en: "While they were waiting, they had a coffee in the lobby.", es: "Mientras esperaban, se tomaron un café en el lobby." },
      { en: "The room was small, but it was clean and quiet.", es: "La habitación era pequeña, pero estaba limpia y tranquila." },
      { en: "Maria didn't sleep well. She isn't used to the cold weather of Bogotá.", es: "María no durmió bien. No está acostumbrada al clima frío de Bogotá." },
      { en: "Uwaldo used to live in Bogotá, so he slept like a baby.", es: "Uwaldo antes vivía en Bogotá, así que durmió como un bebé." },
      { en: "In the morning, they went to the fair and bought new models for Alzati.", es: "En la mañana fueron a la feria y compraron modelos nuevos para Alzati." }
    ],
    preguntas: [
      { tema: "ep4-dias", q: "When did they travel to Bogotá?", es: "¿Cuándo viajaron a Bogotá?", opciones: ["Last Sunday.", "Two weeks ago.", "Last Friday."], correcta: 2, ex: "\"Last Friday\" = el viernes pasado." },
      { tema: "ep4-pasado-progresivo", q: "What did they do while they were waiting?", es: "¿Qué hicieron mientras esperaban?", opciones: ["They had a coffee.", "They slept.", "They went to the fair."], correcta: 0, ex: "While they were waiting, they had a coffee." },
      { tema: "ep4-used-to", q: "Why did Uwaldo sleep well?", es: "¿Por qué Uwaldo durmió bien?", opciones: ["He drank a coffee.", "The room was big.", "He used to live in Bogotá."], correcta: 2, ex: "used to live = antes vivía." },
      { tema: "ep4-pasado-irregular", q: "What did they buy?", es: "¿Qué compraron?", opciones: ["New models for Alzati.", "A new hotel room.", "Coffee for the store."], correcta: 0, ex: "bought = compraron (buy → bought)." }
    ]
  },
  {
    id: "ep5-monday-at-the-office", episodio: 5, titulo: "Monday at the Office", es: "Lunes en la oficina",
    tema: "both/either/neither, palabras negativas, there is/are, how much/many y have got",
    lineas: [
      { en: "On Monday morning, there are many messages on Uwaldo's laptop.", es: "El lunes en la mañana hay muchos mensajes en el portátil de Uwaldo." },
      { en: "Two suppliers want to sell him sneakers. Both of them have got good prices.", es: "Dos proveedores le quieren vender tenis. Los dos tienen buenos precios." },
      { en: "\"How many pairs can you send?\" he asks. \"And how long does the shipping take?\"", es: "\"¿Cuántos pares pueden enviar?\", pregunta. \"¿Y cuánto se demora el envío?\"" },
      { en: "The first supplier doesn't answer. Nobody answers the phone at his office.", es: "El primer proveedor no responde. Nadie contesta el teléfono en su oficina." },
      { en: "The second one says: \"You can pay either by transfer or in cash.\"", es: "El segundo dice: \"Puede pagar o por transferencia o en efectivo.\"" },
      { en: "Maria looks at the photos. \"I like neither the red ones nor the green ones,\" she says.", es: "María mira las fotos. \"No me gustan ni los rojos ni los verdes\", dice." },
      { en: "\"Me neither,\" says Uwaldo. \"But the black ones are great.\"", es: "\"A mí tampoco\", dice Uwaldo. \"Pero los negros están geniales.\"" },
      { en: "In the end, they order fifty pairs of black sneakers.", es: "Al final, piden cincuenta pares de tenis negros." }
    ],
    preguntas: [
      { tema: "ep5-both-either-neither", q: "What have both suppliers got?", es: "¿Qué tienen los dos proveedores?", opciones: ["A big office.", "Good prices.", "Black sneakers."], correcta: 1, ex: "Both of them have got good prices." },
      { tema: "ep5-negativas", q: "Who answers the phone at the first supplier's office?", es: "¿Quién contesta en la oficina del primer proveedor?", opciones: ["The supplier.", "Nobody.", "Maria."], correcta: 1, ex: "Nobody answers the phone." },
      { tema: "ep5-neither-nor", q: "Does Maria like the red sneakers?", es: "¿A María le gustan los tenis rojos?", opciones: ["Yes, she likes both.", "Yes, but not the black ones.", "No, she likes neither the red nor the green ones."], correcta: 2, ex: "neither… nor = ni… ni." },
      { tema: "ep5-how", q: "How many pairs do they order?", es: "¿Cuántos pares piden?", opciones: ["Fifty.", "Fifteen.", "Five."], correcta: 0, ex: "fifty pairs = cincuenta pares." }
    ]
  },
  {
    id: "ep6-a-table-for-four", episodio: 6, titulo: "A Table for Four", es: "Una mesa para cuatro",
    tema: "reservas, some/any, cuantificadores, too/enough, fechas y adverbios de frecuencia",
    lineas: [
      { en: "On March 14th, Uwaldo calls a restaurant. It's Maria's birthday.", es: "El 14 de marzo, Uwaldo llama a un restaurante. Es el cumpleaños de María." },
      { en: "\"I'd like to book a table for four at eight o'clock, please.\"", es: "\"Quisiera reservar una mesa para cuatro a las ocho, por favor.\"" },
      { en: "\"Sorry, we don't have any tables at eight. We have some at nine.\"", es: "\"Lo siento, no tenemos mesas a las ocho. Tenemos algunas a las nueve.\"" },
      { en: "Nine is too late for their daughter, so they choose another restaurant.", es: "Las nueve es demasiado tarde para su hija, así que eligen otro restaurante." },
      { en: "They usually go to a small Italian place, and they always order pasta.", es: "Normalmente van a un lugar italiano pequeño y siempre piden pasta." },
      { en: "This time the pasta isn't hot enough, and there's too much salt in the salad.", es: "Esta vez la pasta no está lo suficientemente caliente y la ensalada tiene demasiada sal." },
      { en: "The waiter brings them something new: a little chocolate cake with a candle.", es: "El mesero les trae algo nuevo: un pequeño pastel de chocolate con una vela." },
      { en: "Maria is very happy. It's her best birthday in many years.", es: "María está muy feliz. Es su mejor cumpleaños en muchos años." }
    ],
    preguntas: [
      { tema: "ep6-meses-fechas", q: "When is Maria's birthday?", es: "¿Cuándo es el cumpleaños de María?", opciones: ["On March 14th.", "On May 14th.", "On March 4th."], correcta: 0, ex: "March 14th = 14 de marzo." },
      { tema: "ep6-too-enough", q: "Why don't they go at nine?", es: "¿Por qué no van a las nueve?", opciones: ["It's too expensive.", "There aren't any tables.", "It's too late for their daughter."], correcta: 2, ex: "too late = demasiado tarde." },
      { tema: "ep6-frecuencia", q: "What do they always order?", es: "¿Qué piden siempre?", opciones: ["Pasta.", "Chocolate cake.", "Salad."], correcta: 0, ex: "they always order pasta." },
      { tema: "ep6-cuantificadores", q: "What was wrong with the salad?", es: "¿Qué tenía de malo la ensalada?", opciones: ["It wasn't hot enough.", "There was too much salt.", "There wasn't any salad."], correcta: 1, ex: "too much salt = demasiada sal." }
    ]
  },
  {
    id: "ep7-at-the-bar", episodio: 7, titulo: "Friday at the Bar", es: "Viernes en el bar",
    tema: "preposiciones, 's, posesivos, adverbios, tag questions y preguntas negativas",
    lineas: [
      { en: "On Friday night, Uwaldo meets his old friend Andrés at a bar on Fifth Avenue.", es: "El viernes en la noche, Uwaldo se encuentra con su viejo amigo Andrés en un bar de la Quinta Avenida." },
      { en: "\"You're still in the police, aren't you?\" asks Uwaldo.", es: "\"Sigues en la policía, ¿cierto?\", pregunta Uwaldo." },
      { en: "\"Yes, I am. And you sell shoes now, don't you?\"", es: "\"Sí. Y tú ahora vendes zapatos, ¿verdad?\"" },
      { en: "Uwaldo shows him a photo of his wife's store. \"It isn't mine,\" he laughs. \"It's ours.\"", es: "Uwaldo le muestra una foto de la tienda de su esposa. \"No es mía\", se ríe. \"Es nuestra.\"" },
      { en: "Andrés orders a beer and Uwaldo has a lemonade. He drives carefully at night.", es: "Andrés pide una cerveza y Uwaldo una limonada. Él maneja con cuidado de noche." },
      { en: "\"Don't you miss the old job?\" asks Andrés.", es: "\"¿No extrañas el trabajo de antes?\", pregunta Andrés." },
      { en: "\"Sometimes. But now I work hard for my family, and I'm learning English quickly.\"", es: "\"A veces. Pero ahora trabajo duro por mi familia y estoy aprendiendo inglés rápido.\"" },
      { en: "They talk happily until eleven, and then Uwaldo goes home by car.", es: "Hablan felices hasta las once y luego Uwaldo se va a casa en carro." }
    ],
    preguntas: [
      { tema: "ep7-preposiciones", q: "Where is the bar?", es: "¿Dónde queda el bar?", opciones: ["At the police station.", "In the store.", "On Fifth Avenue."], correcta: 2, ex: "on Fifth Avenue." },
      { tema: "ep7-pronombres-posesivos", q: "Whose store is it?", es: "¿De quién es la tienda?", opciones: ["It's only Uwaldo's.", "It's Andrés's.", "It's theirs: Uwaldo's and his wife's."], correcta: 2, ex: "\"It isn't mine. It's ours.\"" },
      { tema: "ep7-adverbios", q: "How does Uwaldo drive at night?", es: "¿Cómo maneja Uwaldo de noche?", opciones: ["Badly.", "Fast.", "Carefully."], correcta: 2, ex: "He drives carefully." },
      { tema: "ep7-tag-questions", q: "\"You sell shoes now, ___?\"", es: "\"Ahora vendes zapatos, ¿verdad?\"", opciones: ["don't you", "do you", "aren't you"], correcta: 0, ex: "Presente afirmativo → don't you?" }
    ]
  },
  {
    id: "ep8-memories", episodio: 8, titulo: "Old Memories", es: "Viejos recuerdos",
    tema: "presente perfecto, just/already/yet, futuro con will y going to, ropa y carros",
    lineas: [
      { en: "Uwaldo has just found an old photo album in a box.", es: "Uwaldo acaba de encontrar un viejo álbum de fotos en una caja." },
      { en: "In one photo he is wearing his police uniform and a black hat.", es: "En una foto lleva su uniforme de policía y una gorra negra." },
      { en: "\"I've had many jobs, but I've never had my own business before,\" he says.", es: "\"He tenido muchos trabajos, pero nunca antes había tenido mi propio negocio\", dice." },
      { en: "Maria has already looked at the album. She laughs at his old jeans.", es: "María ya miró el álbum. Se ríe de sus jeans viejos." },
      { en: "\"Have you shown it to our daughter yet?\" she asks. \"Not yet,\" he says.", es: "\"¿Ya se lo mostraste a nuestra hija?\", pregunta. \"Todavía no\", dice él." },
      { en: "Next month they are going to rent a car and drive to his hometown.", es: "El próximo mes van a alquilar un carro e ir a su pueblo natal." },
      { en: "\"I'll show you the house where I grew up,\" Uwaldo promises.", es: "\"Te mostraré la casa donde crecí\", promete Uwaldo." },
      { en: "\"Shall we take the album with us?\" asks Maria. \"Great idea!\"", es: "\"¿Llevamos el álbum?\", pregunta María. \"¡Gran idea!\"" }
    ],
    preguntas: [
      { tema: "ep8-just-already-yet", q: "Has their daughter seen the album?", es: "¿Su hija ya vio el álbum?", opciones: ["Yes, already.", "Not yet.", "She has just seen it."], correcta: 1, ex: "\"Not yet\" = todavía no." },
      { tema: "ep8-ropa", q: "What is Uwaldo wearing in the photo?", es: "¿Qué lleva Uwaldo en la foto?", opciones: ["A suit and a tie.", "His police uniform and a black hat.", "A raincoat."], correcta: 1, ex: "he is wearing his police uniform and a black hat." },
      { tema: "ep8-going-to", q: "What are they going to do next month?", es: "¿Qué van a hacer el próximo mes?", opciones: ["Rent a car and drive to his hometown.", "Sell the album.", "Buy a new house."], correcta: 0, ex: "they are going to rent a car." },
      { tema: "ep8-presente-perfecto", q: "What has Uwaldo never had before?", es: "¿Qué nunca había tenido Uwaldo?", opciones: ["His own business.", "A job.", "A photo album."], correcta: 0, ex: "I've never had my own business before." }
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
  const lento = rate === VEL.lenta;
  lineas.forEach((l, i) => {
    const partes = encolarVoz(l.en, lento); // lento: trozo por trozo, con pausas
    if (!partes.length) return;
    partes[0].onstart = () => alMarcar(i);
    if (i === lineas.length - 1) partes[partes.length - 1].onend = () => alMarcar(-1);
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
    ${eps.map((ep) => `<h2 style="margin-top:20px">Nivel ${ep} <span class="muted" style="font-size:.85rem">· Ep. ${ep} del instituto</span></h2>${htmlLecturasDe(ep).replace(/<div class="sec"[^>]*>.*?<\/div>/, "")}`).join("")}`);
}

async function vistaLectura(id) {
  await cargarHechas();
  const L = LECTURAS.find((x) => x.id === id);
  if (!L) return pintar(`<a href="#/ingles/lecturas" class="link">← Leer y escuchar</a><p>No encontré esa historia.</p>`);
  const total = L.preguntas.length;
  ponerContexto(`Lectura «${L.titulo}» (Episodio ${L.episodio})`, `Tema: ${L.tema}\nTexto:\n${L.lineas.map((x) => `${x.en} = ${x.es}`).join("\n")}\nPreguntas:\n${L.preguntas.map((x) => `${x.q} → ${x.opciones[x.correcta]}`).join("\n")}`);

  pintar(`
    <a href="#/ingles/lecturas" class="link">← Leer y escuchar</a>
    <h1>${esc(L.titulo)}</h1>
    <p class="muted">Nivel ${L.episodio} · ${esc(L.tema)}</p>

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
        <div class="muted pista-palabra">👆 Toca una palabra para oírla y ver qué significa · 🇪🇸 para ver la traducción de una línea</div>
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
      if (p.tema) registrarDominio(p.tema, "input", ok); // leer y escuchar = pata de input
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
    if (typeof energiaSumarMinutos === "function") energiaSumarMinutos(5); // práctica libre: 10 min = ½ raya
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
