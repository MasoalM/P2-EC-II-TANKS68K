; ==============================================================================
; PANTALLA DE GAME OVER
; ==============================================================================

; ------------------------------------------------------------------------------
GOVINIT
; INICIALIZACIÓN DE LA PANTALLA DE GAME OVER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : DOPLOT
; ------------------------------------------------------------------------------

            MOVE.W  #0,(DOPLOT)             ; NO SOBREESCRIBIR EL DIBUJADO DEL 
                                            ; MENÚ DE GAME OVER
            MOVEM.L D0-D1/A0,-(A7)
            
            ; COLOR ROJO OSCURO DE FONDO
            MOVE.L  #$00101060,D1           
            MOVE.B  #81,D0
            TRAP    #15
            
            ; PINTAR RECTÁNGULO QUE REPRESENTARÁ EL FONDO
            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH,D3
            MOVE.L  #SCRHEIGH,D4
            MOVE.B  #87,D0                  
            TRAP    #15

            ; TEXTO 1 GAME OVER
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            ; TEXTO 2 GAME OVER
            LEA     .TXT2,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT
            
            MOVEM.L (A7)+,D0-D1/A0
            ; ACTUALIZAR PANTALLA
            TRAP    #SCRUPTN
            RTS
            
.TXT1       DC.B    'GAME OVER :(',0
.TXT2       DC.B    '¡PRESIONA LA BARRA ESPACIADORA PARA CONTINUAR!',0
            DS.W    0

; ------------------------------------------------------------------------------
GOVUPD
; ACTUALIZACIÓN DE LA PANTALLA DE GAME OVER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ; REPRODUCIR CANCIÓN DE GAME OVER
            MOVE.B  #SNDGVR1,D7
            TRAP    #SNDPLTN
            ; SI SE PRESIONA EL ESPACIO, VOLVER AL MENÚ PRINCIPAL
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
.CONT            
            RTS










*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
