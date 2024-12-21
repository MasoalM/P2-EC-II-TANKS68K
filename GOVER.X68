; ==============================================================================
; GAME OVER SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
GOVINIT
; GAME OVER SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ;MOVE.B  #SNDGVR1,D7
            ;TRAP    #SNDPLTN
            MOVE.W  #0,(DOPLOT)
            MOVEM.L D0-D1/A0,-(A7)
            
            MOVE.L  #$00101060,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            LEA     .TXT2,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT
            
            MOVEM.L (A7)+,D0-D1/A0
            TRAP    #SCRUPTN

            RTS
            
.TXT1       DC.B    'GAME OVER :(',0
.TXT2       DC.B    '¡PRESIONA LA BARRA ESPACIADORA PARA CONTINUAR!',0
            DS.W    0

; ------------------------------------------------------------------------------
GOVUPD
; GAME OVER SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVE.B  #SNDGVR1,D7
            TRAP    #SNDPLTN
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
            RTS

.CONT       ;MOVE.B  #SNDGVR2,D7
            ;TRAP    #SNDPLTN
            RTS







*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
