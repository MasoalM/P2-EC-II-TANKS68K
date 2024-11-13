*-----------------------------------------------------------
*   VARIABLES DEL JUEGO
*-----------------------------------------------------------

; --- VARIABLES RELACIONADAS CON LA BALA DEL TANQUE --------

BULPOSX     DS.W    1       ; COORDENADA X DE LA BALA
BULPOSY     DS.W    1       ; COORDENADA Y DE LA BALA
BULVELX     DS.W    1       ; VELOCIDAD X DE LA BALA
BULVELY     DS.W    1       ; VELOCIDAD Y DE LA BALA

; --- VARIABLES RELACIONADAS CON EL TANQUE -----------------

TANPOSX     DS.W    1       ; COORDENADA X DEL TANQUE
TANPOSY     DS.W    1       ; COORDENADA Y DEL TANQUE

; --- VARIABLES RELACIONADAS CON EL MARCADOR ---------------

SCORE       DS.W    1       ; NÚMERO DE TANQUES DESTRUIDOS // (cuidado con si llega a superar 255) // podríamos hacer que se multiplique cada puntuación de tanque destruido con una cte relacionada con el tanque (diferentes tipos de tanque?)

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
