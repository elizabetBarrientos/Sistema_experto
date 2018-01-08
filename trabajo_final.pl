:-use_module(library(pce)).
:-use_module(library(pce_style_item)).

main:-
 new(Menu, dialog('SISTEMA EXPERTO DE DIAGNOSTICO', size(500,500))),
 new(L,label(nombre,'BIENVENIDO A SU DIAGNOSTICO')),
 new(@texto,label(nombre,'SEGÚN SU RESPUESTA SE TENDRÁ UN RESULTADO')),
 new(@respl,label(nombre,'')),
 new(Salir,button('SALIR',
        and(message(Menu, destroy),message(Menu,free)))),
 new(@boton,button('realizar test',message(@prolog,botones))),

 send(Menu,append(L)),new(@btncarrera,button('Diagnostico?')),
 send(Menu,display,L,point(125,20)),
 send(Menu,display,@boton,point(100,150)),
 send(Menu,display,@texto,point(20,100)),
 send(Menu,display,Salir,point(20,400)),
 send(Menu,display,@respl,point(20,130)),
 send(Menu,open_centered).
enfermedades(hidrocefalia_pn):-hidrocefalia_pn,!.
enfermedades(parkinson):-parkinson,!.
enfermedades(alzheimer):-alzheimer,!.
enfermedades('sin resultado').

hidrocefalia_pn:- tiene_hidrocefalia_pn,
 pregunta('¿Ud. tiene perdida de memoria?, Ud. no recuerda donde pone las cosas'),
 pregunta('¿Ud. tiene alteracion en la marcha?, Ud. pierde el equilibrio al andar'),
 pregunta('¿Ud. tiene incontinencia urinaria?'),
 pregunta('¿En su prueba de Neruo Imagen el indice de Evans mayor a 0.30?'),
 pregunta('¿En su prueba de Expectroscopia sea ha encontrado Lactato?'),
 pregunta('¿Ud. ha notado cambios de memoria que dificultan su vida cotidiana?').

parkinson:- tiene_parkinson,
 pregunta('Ha notado temblor en sus dedos, manos, mentón o labios?'),
 pregunta('¿Ha notado que la forma en que Ud. escribe las palabras ha cambiado'),
 pregunta('Ha notado que ya no puede oler ciertos alimentos igual que antes'),
 pregunta('¿Ha notado que Ud. que ha empezado a caerse de la cama, movimientos repentinos durante el sueño?'),
 pregunta('¿Siente rigidez es su cuerpo, brazos o piernas'),
 pregunta('¿le han comentado que Ud. se ve enojado, serio o deprimido, aun cuando Ud. no está de mal humor?'),
 pregunta('Siente Ud. que se marea cuando se levanta de una silla o de su cama?').

alzheimer:- tiene_alzheimer,
 pregunta('¿Ud. ha notado cambios de memoria que dificultan su vida cotidiana?'),
 pregunta('¿Ud. ha notado dificultad para planificar o resolver problemas?'),
 pregunta('¿Ha notado dificultad para desempeñar tareas habituales en la casa en el trabajo o en su tiempo libre?'),
 pregunta('¿Ha notado desorientacion de tiempo o lugar?'),
 pregunta('¿Ha notado dificultad para comprender imágenes visuales y cómo objetos se relacionan uno al otro en el ambiente?'),
 pregunta('¿Ha notado nuevos problemas con el uso de palabras en el habla o lo escrito?'),
 pregunta('¿Ha notado que coloca los objetos fuera de lugar y la falta de habilidad para retrazar sus pasos?').

desconocido:- se_deconoce_enfermedad.

tiene_hidrocefalia_pn:-pregunta('tiene perdida de memoria'),!.
tiene_parkinson:-pregunta('tiene alguna alteracion en la marcha'),!.
tiene_alzheimer:-pregunta('tiene dificultadad para planificar o resolver problemas'),!.

:-dynamic si/1,no/1.
preguntar(Problema):- new(Di,dialog('exa')),
     new(L2,label(texto,'Responde las siguientes preguntas')),
     new(La,label(prob,Problema)),
     new(B1,button(si,and(message(Di,return,si)))),
     new(B2,button(no,and(message(Di,return,no)))),
         send(Di,append(L2)),
  send(Di,append(La)),
  send(Di,append(B1)),
  send(Di,append(B2)),

  send(Di,default_button,si),
  send(Di,open_centered),get(Di,confirm,Answer),
  write(Answer),send(Di,destroy),
  (   (Answer==si)->assert(si(Problema));
  assert(no(Problema)),fail).

limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.
pregunta(S):-(si(S)->fail;preguntar(S)).
botones :- lim,
 send(@boton,free),
 send(@btncarrera,free),
 enfermedades(Enfer),
 send(@texto,selection('su diagnostico es: ')),

 send(@respl,selection(Enfer)),
 new(@boton,button('inicia',message(@prolog,botones))),
        send(Menu,display,@boton,point(40,50)),
        send(Menu,display,@btncarrera,point(20,50)),
limpiar.
   lim :- send(@respl,selection('')).

