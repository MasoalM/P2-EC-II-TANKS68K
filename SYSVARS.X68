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

FILEDATA    DS.L    200000  ; IMAGEN DE LA INTRO
WINDATA     DS.L    10000   ; IMAGEN DE VICTORIA

DATPLXE     DS.L    512     ; IMÁGENES JUGADOR
DATPLXN     DS.L    512    
DATPLXNE    DS.L    512    
DATPLXNW    DS.L    512    
DATPLXS     DS.L    512    
DATPLXSE    DS.L    512    
DATPLXSW    DS.L    512    
DATPLXW     DS.L    512    
DATPLYE     DS.L    512    
DATPLYN     DS.L    512    
DATPLYNE    DS.L    512    
DATPLYNW    DS.L    512    
DATPLYS     DS.L    512    
DATPLYSE    DS.L    512    
DATPLYSW    DS.L    512    
DATPLYW     DS.L    512    

DATENXE     DS.L    512     ; IMÁGENES ENEMIGO
DATENXN     DS.L    512    
DATENXNE    DS.L    512    
DATENXNW    DS.L    512    
DATENXS     DS.L    512    
DATENXSE    DS.L    512    
DATENXSW    DS.L    512    
DATENXW     DS.L    512    
DATENYE     DS.L    512    
DATENYN     DS.L    512    
DATENYNE    DS.L    512    
DATENYNW    DS.L    512    
DATENYS     DS.L    512    
DATENYSE    DS.L    512    
DATENYSW    DS.L    512    
DATENYW     DS.L    512    


*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
