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

; --- TIMED INTERRUPT RELATED VARIABLES --------------------

SCRINTCT    DS.B    1       ; INTERRUPT COUNTER
SCRCYCCT    DS.B    1       ; CYCLE COUNTER
            DS.W    0
            
; --- FILE RELATED VARIABLES -------------------------------

FILEDATA    DS.B    1024




*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
