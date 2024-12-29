*-----------------------------------------------------------
*   VARIABLES DEL SISTEMA
*-----------------------------------------------------------


; --- VARIABLES RELACIONADAS CON EL TECLADO ----------------

KBDVAL      DS.B    1       ; ESTADO DEL TECLADO (1 BYTE -> 8 TECLAS MAX)
KBDEDGE     DS.B    1       ; TECLADO PULSADO

; --- VARIABLES RELACIONADAS CON EL RATÓN ------------------

MOUEDGE     DS.L    1       ; RATÓN PULSADO
MOUBUT      DS.L    1       ; BOTÓN IZQUIERDO DEL RATÓN PULSADO
MOUPOS      DS.L    1       ; POSICIÓN DEL RATÓN

; - VARIABLES RELACIONADAS CON LAS INTERRUPCIONES TEMPORALES -

SCRINTCT    DS.B    1       ; CONTADOR DE INTERRUPCIONES
SCRCYCCT    DS.B    1       ; CONTADOR DE CICLOS
            DS.W    0

; --- VARIABLES RELACIONADAS CON EL TIEMPO -----------------

TIEMPO      DS.L    2       ; CONTADOR DE TIEMPO

; --- VARIABLES RELACIONADAS CON LOS FPS--------------------

ACTFPS      DS.W    1       ; FPS ACTUALES
SHWFPS      DS.W    1       ; FPS PARA MOSTRAR
            
            
; --- VARIABLES RELACIONADAS CON LAS IMÁGENES --------------

FILEDATA    DS.L    400000 ; IMAGEN DE LA INTRO
WINDATA     DS.L    40000  ; IMAGEN DE VICTORIA

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
