# The Hidden Thief

## Documento de concepto -- Actividad 7

### 1. Concepto general

**The Hidden Thief** es un videojuego 2D de sigilo con perspectiva
top-down, desarrollado en Godot. El jugador controla a un ladrón que
aprovecha apagones para infiltrarse en distintos edificios, evitar a los
guardias, conseguir llaves y robar un objeto de gran valor.

El movimiento se realiza en ocho direcciones. La jugabilidad se basa
principalmente en administrar la velocidad y el ruido generado, observar
los conos de visión de los guardias y aprovechar el escenario para
mantenerse fuera de su campo visual.

Cada nivel posee un objetivo principal. Una vez robado el objeto, se
activa una alarma y comienza una fase de escape contrarreloj.

### 2. Historia y contexto

El protagonista es un ladrón que aprovecha una serie de apagones para
realizar robos cada vez más ambiciosos.

Su primer objetivo será infiltrarse en un museo para robar una
estatuilla antigua. Luego ingresará a una mansión privada para conseguir
una joya de gran valor. Finalmente intentará su golpe más difícil:
entrar a un banco y robar un gran diamante.

Al superar los tres robos, el jugador habrá completado la progresión del
ladrón y se mostrará un mensaje final indicando que se ha convertido en
un ladrón legendario.

### 3. Objetivo del juego

El objetivo de cada nivel consiste en infiltrarse sin ser atrapado,
explorar el escenario, conseguir las llaves necesarias para acceder a
las zonas restringidas y alcanzar el tesoro.

Después de robar el objetivo comienza una segunda etapa: escapar del
edificio antes de que llegue la policía.

### 4. Mecánicas principales

El jugador contará con las siguientes mecánicas principales:

-   Movimiento top-down en ocho direcciones.
-   Tres modos de desplazamiento: sigilo, normal y carrera.
-   Generación de diferentes niveles de ruido según el modo de
    movimiento.
-   Interacción contextual con llaves, puertas y tesoros.
-   Posibilidad de robar llaves que llevan determinados guardias.
-   Ocultamiento detrás de paredes, muebles y otros elementos del
    escenario para evitar el campo visual de los guardias.
-   Exploración de distintas zonas del nivel mediante puertas y llaves.
-   Fase de escape contrarreloj después de conseguir el tesoro.
-   Pausa y guardado manual de la partida.

### 5. Movimiento y controles

El personaje puede desplazarse en ocho direcciones utilizando **WASD** o
las **flechas del teclado**.

Los controles previstos son:

  Acción                         Control
  ------------------------------ -------------------
  Movimiento                     WASD / Flechas
  Interactuar, recoger o robar   E
  Modo sigilo                    Barra espaciadora
  Correr                         Shift
  Pausa                          P

El modo sigilo se activa manteniendo presionada la barra espaciadora. El
personaje continúa utilizando su animación de caminar, pero se desplaza
lentamente y no genera ruido.

Al desplazarse normalmente genera un nivel de ruido intermedio. Al
mantener Shift corre a mayor velocidad, pero genera más ruido y puede
ser detectado desde una distancia mayor.

### 6. Sistema de sigilo y ruido

El ruido será una de las mecánicas centrales.

-   **Modo sigilo:** movimiento lento y sin ruido.
-   **Movimiento normal:** velocidad media y ruido normal.
-   **Carrera:** movimiento rápido y mayor nivel de ruido.

Los guardias tendrán un área de audición. Si el jugador genera ruido
dentro de esa zona, el guardia reaccionará, orientándose hacia el origen
del sonido e investigando el lugar.

La distancia desde la cual puede detectarse al jugador dependerá del
ruido producido. De esta manera, correr permite desplazarse rápidamente
pero aumenta el riesgo, mientras que el modo sigilo permite acercarse a
los guardias sin ser escuchado.

### 7. Guardias e inteligencia artificial

Los guardias patrullarán el escenario siguiendo rutas formadas por
puntos predefinidos.

Cada guardia llevará una linterna cuyo haz representará visualmente su
campo de visión. Si el jugador entra en ese campo y no existe un
obstáculo que bloquee la visión, el guardia lo detectará e iniciará una
persecución.

Los guardias podrán pasar por diferentes comportamientos:

-   **Patrulla:** recorre su ruta normalmente.
-   **Investigación:** se dirige hacia una zona donde escuchó ruido.
-   **Alerta:** permanece atento durante un período después de perder al
    jugador o investigar un evento.
-   **Persecución:** corre detrás del jugador después de detectarlo.

Si el jugador logra alejarse lo suficiente, el guardia dejará la
persecución pero permanecerá en alerta durante un tiempo antes de
regresar a su patrulla.

Si durante una huida el jugador genera ruido o entra en el campo visual
de otros guardias, estos también pueden reaccionar, aumentando la
dificultad de la situación.

Si un guardia alcanza al jugador mientras lo tiene detectado, la partida
se pierde.

### 8. Interacción, llaves y puertas

El botón **E** funcionará como acción contextual para interactuar con
diferentes elementos.

Habrá puertas comunes, que podrán abrirse directamente, y puertas
restringidas que necesitarán una llave determinada.

Cada nivel tendrá aproximadamente dos o tres llaves obligatorias.
Algunas estarán ubicadas en habitaciones y otras serán transportadas por
guardias.

Para robar una llave a un guardia, el jugador deberá aproximarse por
detrás utilizando el modo sigilo e interactuar con ella sin ser
detectado.

El jugador podrá transportar varias llaves simultáneamente y estas
aparecerán en el HUD. Al utilizar la llave correspondiente, esta se
consumirá y la puerta quedará desbloqueada permanentemente, facilitando
también la ruta de escape posterior.

### 9. Niveles y progresión

El juego estará compuesto inicialmente por tres niveles:

#### Nivel 1 -- Museo

El jugador deberá infiltrarse en un museo y robar una **estatuilla
antigua**.

Será el escenario más permisivo y permitirá aprender las mecánicas de
visión, ruido, llaves, puertas y robo a guardias.

#### Nivel 2 -- Mansión privada

El objetivo será robar una **joya de gran valor**.

Los guardias tendrán una detección auditiva mayor, las patrullas serán
más complejas y el escenario ofrecerá menos oportunidades seguras que el
museo.

#### Nivel 3 -- Banco

El objetivo final será robar un **gran diamante**.

Será el nivel más exigente. Los guardias serán más sensibles al ruido,
permanecerán más tiempo en alerta, existirán recorridos de patrulla más
difíciles de anticipar y el tiempo disponible para escapar será menor.

La dificultad no se basará principalmente en aumentar la cantidad de
guardias, sino en mejorar su capacidad de detección, prolongar los
estados de alerta, diseñar patrullas más complejas y reducir
progresivamente el margen de error del jugador.

### 10. Inicio de los niveles

Cada nivel comenzará con una breve presentación del escenario mientras
todavía se encuentra iluminado.

Luego se producirá el apagón. Los guardias reaccionarán mostrando un
símbolo de alerta sobre ellos y encenderán sus linternas. Ese mismo
símbolo podrá utilizarse durante la partida para indicar que un guardia
ha escuchado un ruido.

Finalmente, el ladrón ingresará al escenario a través de una ventana y
comenzará la infiltración.

La electricidad permanecerá apagada durante todo el nivel, incluso
después de activar la alarma.

### 11. Fase de escape

Al robar el tesoro se activará la alarma y comenzará la fase de escape.

Los guardias pasarán a un estado de mayor vigilancia: se desplazarán más
rápido y tendrán una mayor capacidad para detectar el ruido generado por
el jugador.

En ese momento aparecerá un contador indicando cuánto falta para que
llegue la policía.

El jugador deberá regresar a la salida antes de que el contador llegue a
cero. Las puertas desbloqueadas durante la infiltración permanecerán
abiertas, por lo que conocer y preparar la ruta de regreso será
importante.

### 12. HUD

El HUD mostrará únicamente información relevante para el sigilo y la
progresión:

-   Llaves que lleva actualmente el jugador.
-   Indicador de alarma durante la fase de escape.
-   Mensaje de búsqueda cuando uno o más guardias se encuentran en
    alerta.
-   Temporizador con el mensaje **"La policía llegará en..."** después
    de robar el tesoro.

No se utilizará una barra de vida: ser atrapado por un guardia provoca
directamente la derrota.

### 13. Cámara y estilo visual

El juego utilizará una **Camera2D** que seguirá al ladrón y mostrará
solamente una parte del escenario. La cámara tendrá límites para evitar
mostrar zonas exteriores al mapa.

El estilo gráfico será **pixel art**, utilizando personajes de **32 × 32
píxeles por frame** y una cuadrícula gráfica base de 32 × 32 píxeles.

Durante el apagón el escenario permanecerá oscurecido, pero los
elementos necesarios para desplazarse ---paredes, puertas, muebles y
objetos--- seguirán siendo distinguibles.

Las linternas de los guardias destacarán sobre la oscuridad y permitirán
visualizar claramente sus campos de visión.

### 14. Sonido y música

Durante la infiltración se utilizará música orientada a generar tensión
y acompañar el sigilo.

Después de robar el tesoro, la música cambiará a una versión más intensa
para acompañar la huida y la cuenta regresiva.

También se utilizarán efectos de sonido para puertas, llaves, tesoros,
alarma y detección de los guardias.

Los pasos estarán relacionados con la mecánica de ruido: el modo sigilo
no generará ruido detectable, caminar producirá ruido normal y correr
producirá un nivel de ruido mayor.

### 15. Victoria, derrota y progresión entre niveles

El nivel se completa cuando el jugador consigue el tesoro y logra
escapar antes de la llegada de la policía.

Después de completar un nivel se mostrará una pantalla de felicitación
indicando el objeto conseguido. Luego se presentará el próximo objetivo
antes de comenzar el siguiente escenario.

El jugador pierde si:

-   Un guardia lo alcanza mientras está detectado.
-   El contador llega a cero y llega la policía.

En caso de derrota podrá reintentar el nivel actual o volver al menú
principal.

Al completar los tres niveles se mostrará una pantalla final indicando
que el jugador se ha convertido en un ladrón legendario y se ofrecerá la
opción de volver al menú.

### 16. Pausa y guardado

Al presionar **P** se abrirá un menú de pausa con las opciones:

-   Volver al juego.
-   Guardar partida.
-   Volver al menú.

El juego tendrá un único slot de guardado manual.

El menú principal contará con **Nueva partida**, **Continuar** y
**Salir**. La opción Continuar permitirá recuperar el progreso guardado.

El sistema de guardado conservará el estado persistente necesario para
continuar el nivel, como la posición del jugador, llaves obtenidas,
puertas desbloqueadas, estado del tesoro, alarma, temporizador y
posiciones relevantes de los guardias. Al cargar, los guardias podrán
reanudar desde un estado estable.

### 17. Tecnología y plataforma

El proyecto será desarrollado como videojuego 2D utilizando:

-   **Godot 4** como motor de desarrollo.
-   **GDScript** para la programación.
-   **Pixel art** para personajes, tiles y objetos.
-   **Git y GitHub** para control de versiones y alojamiento del
    repositorio.
-   **PC** como plataforma objetivo inicial.

### 18. Relación con los contenidos de la materia

La propuesta permite integrar diferentes sistemas y conceptos trabajados
durante el curso:

-   Manejo de entradas de teclado.
-   Movimiento en ocho direcciones.
-   Animaciones 2D.
-   Colisiones y áreas de detección.
-   Interacción entre entidades.
-   Señales y comunicación entre nodos.
-   Inteligencia artificial mediante estados.
-   Patrullaje, investigación y persecución.
-   Navegación de agentes.
-   Interfaces y HUD.
-   Manejo de escenas y niveles.
-   Audio.
-   Persistencia y guardado de datos.

El diseño está pensado para permitir la reutilización de los sistemas
principales entre los tres escenarios. El ladrón, los guardias, las
puertas, las llaves, el sistema de ruido, la detección y la alarma
funcionarán como sistemas comunes, mientras que cada nivel modificará su
distribución, objetivo y dificultad.
