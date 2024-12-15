*-----------------------------------------------------------
*   VARIABLES DEL SISTEMA
*-----------------------------------------------------------


; --- KEYBOARD RELATED VARIABLES ---------------------------

KBDVAL      DS.B    1       ; KEY STATE (1 BYTE -> 8 TECLAS MAX)
KBDEDGE     DS.B    1       ; KEY EDGE

; --- MOUSE RELATED VARIABLES ------------------------------

MOUEDGE     DS.L    1       ; MOUSE EDGE
MOUBUT      DS.L    1       ; MOUSE LEFT BUTTON
MOUPOS      DS.L    1       ; MOUSE POSITION

; --- TIMED INTERRUPT RELATED VARIABLES --------------------

SCRINTCT    DS.B    1       ; INTERRUPT COUNTER
SCRCYCCT    DS.B    1       ; CYCLE COUNTER
            DS.W    0

; --- TIME RELATED VARIABLES -------------------------------

TIEMPO      DS.L    1       ; CONTADOR DE TIEMPO


; --- FPS RELATED VARIABLES --------------------------------

ACTFPS      DS.W    1       ; FPS ACTUALES
SHWFPS      DS.W    1       ; FPS PARA MOSTRAR
            
            
; --- FILE RELATED VARIABLES -------------------------------

FILEDATA    DS.L    400000








*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
