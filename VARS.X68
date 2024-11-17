*-----------------------------------------------------------
*   VARIABLES DEL JUEGO
*-----------------------------------------------------------

; --- VARIABLES RELACIONADAS CON EL TANQUE -----------------

TANPOSX     DS.W    1           ; COORDENADA X DEL TANQUE
TANPOSY     DS.W    1           ; COORDENADA Y DEL TANQUE
TANPCOL     DS.L    1           ; COLOR DE CONTORNO DEL TANQUE   
TANFCOL     DS.L    1           ; COLOR DE RELLENO DEL TANQUE

; --- VARIABLES RELACIONADAS CON EL MARCADOR ---------------

SCORE       DS.W    1       ; NÚMERO DE TANQUES DESTRUIDOS // (cuidado con si llega a superar 255) // podríamos hacer que se multiplique cada puntuación de tanque destruido con una cte relacionada con el tanque (diferentes tipos de tanque?)

; --- VARIABLES RELACIONADAS CON EL MAPA -------------------

NUMENELIV   DS.W    1       ; NÚMERO DE ENEMIGOS VIVOS EN EL NIVEL

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
