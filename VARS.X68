*-----------------------------------------------------------
*   VARIABLES DEL JUEGO
*-----------------------------------------------------------

; --- VARIABLES RELACIONADAS CON EL MARCADOR ---------------

SCORE       DS.W    1       ; NÚMERO DE TANQUES DESTRUIDOS // (cuidado con si llega a superar 255) // podríamos hacer que se multiplique cada puntuación de tanque destruido con una cte relacionada con el tanque (diferentes tipos de tanque?)

; --- VARIABLES RELACIONADAS CON EL MAPA -------------------

LVLNUM      DS.W    1       ; NÚMERO DEL NIVEL

; --- VARIABLES RELACIONADAS CON EL TANQUE -----------------

TANID       DS.W    1

; -- VARIABLES RELACIONADAS CON EL ESTADO DE INTRODUCCIÓN --

ISCTIMER    DS.W    1       ; INTRO TIMER

; --- INSTRUCTIONS STATE RELATED VARIABLES -----------------

INSTIMER    DS.W    1       ; INSTRUCTIONS TIMER

; --- VARIABLES RELACIONADAS CON LOS ESTADOS ---------------

STACUR      DS.W    1       ; ESTADO ACTUAL
STANEXT     DS.W    1       ; SIGUIENTE ESTADO

; --- VARIABLES RELACIONADAS CON LA DERROTA ----------------

PLYRDEAD    DS.W    1       ; PLAYER MUERTO

; --- VARIABLES RELACIONADAS CON EL PLOT -------------------

DOPLOT      DS.W    1






*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
