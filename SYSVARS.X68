*-----------------------------------------------------------
*   VARIABLES DEL SISTEMA
*-----------------------------------------------------------


; --- KEYBOARD RELATED VARIABLES ---------------------------

KBDVAL      DS.B    1       ; KEY STATE (1 BYTE -> 8 TECLAS MAX)
KBDEDGE     DS.B    1       ; KEY EDGE

; --- MOUSE RELATED VARIABLES ---------------------------

MOUEDGE     DS.B    1       ; MOUSE EDGE
MOUBUT      DS.B    1       ; MOUSE LEFT BUTTON
MOUPOS      DS.B    1       ; MOUSE POSITION
            DS.W    0       ; si no agregamos más, se podrán eliminar los dos DS.W

; --- TIMED INTERRUPT RELATED VARIABLES --------------------

SCRINTCT    DS.B    1       ; INTERRUPT COUNTER
            DS.W    0


*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
