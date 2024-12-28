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

; --- VARIABLES RELACIONADAS CON LOS ESTADOS ---------------

STACUR      DS.W    1       ; ESTADO ACTUAL
STANEXT     DS.W    1       ; SIGUIENTE ESTADO

; --- VARIABLES RELACIONADAS CON LA DERROTA ----------------

PLYRDEAD    DS.W    1       ; PLAYER MUERTO

; --- VARIABLES RELACIONADAS CON EL PLOT -------------------

DOPLOT      DS.W    1

; --- VARIABLES RELACIONADAS CON LA BALA -------------------

BULVELY     DS.W    1
BULVELX     DS.W    1
BULORGY  DS.W    1
BULORGX  DS.W    1

; --- VARIABLES RELACIONADAS CON POSICIONES DE TANQUES -----

PLAYPOSX    DS.W    1
PLAYPOSY    DS.W    1
ENEMPOSX    DS.W    1
ENEMPOSY    DS.W    1
POSXTEMP    DS.W    1       ; POSICIÓN TEMPORAL DE UN TANQUE
POSYTEMP    DS.W    1
MOVXTEMP    DS.W    1
MOVYTEMP    DS.W    1
COLTANKP    DS.W    1

; --- VARIABLES RELACIONADAS CON EL DIBUJADO DEL TANQUE ----

PLCANPOS    DS.W    1       ; TANK AND CANNON POSITION OF PLAYER
ENCANPOS    DS.W    1       ; TANK AND CANNON POSITION OF ENEMY

; --- VARIABLES RELACIONADAS CON LA DEMO -------------------

DEMO        DS.W    1       ; SI VALE 1, ESTAMOS EN LA DEMO, SI VALE 0 NO
















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
