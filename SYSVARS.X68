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
WINDATA     DS.L    40000

DATPLXE     DS.L    1000    ; IMÁGENES JUGADOR
DATPLXN     DS.L    1000
DATPLXNE    DS.L    1000
DATPLXNW    DS.L    1000
DATPLXS     DS.L    1000
DATPLXSE    DS.L    1000
DATPLXSW    DS.L    1000
DATPLXW     DS.L    1000
DATPLYE     DS.L    1000
DATPLYN     DS.L    1000
DATPLYNE    DS.L    1000
DATPLYNW    DS.L    1000
DATPLYS     DS.L    1000
DATPLYSE    DS.L    1000
DATPLYSW    DS.L    1000
DATPLYW     DS.L    1000

DATENXE     DS.L    1000    ; IMÁGENES ENEMIGO
DATENXN     DS.L    1000
DATENXNE    DS.L    1000
DATENXNW    DS.L    1000
DATENXS     DS.L    1000
DATENXSE    DS.L    1000
DATENXSW    DS.L    1000
DATENXW     DS.L    1000
DATENYE     DS.L    1000
DATENYN     DS.L    1000
DATENYNE    DS.L    1000
DATENYNW    DS.L    1000
DATENYS     DS.L    1000
DATENYSE    DS.L    1000
DATENYSW    DS.L    1000
DATENYW     DS.L    1000












*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
