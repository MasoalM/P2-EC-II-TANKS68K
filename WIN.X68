; ==============================================================================
; VICTORY SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
WININIT
; VICTORY SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  #0,(DOPLOT)
            MOVEM.L D0-D1/A0-A2,-(A7)
            
            MOVE.L  #$000098AD,D1           ; COLOR FONDO
            MOVE.B  #81,D0
            TRAP    #15

            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH,D3
            MOVE.L  #SCRHEIGH,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            LEA     WINDATA,A0
            
            MOVE.W  #WINWIDTH/2,(A2)
            MOVE.W  #WINHEIGH/2,2(A2)
            
            JSR     IMAPLOT
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT

            LEA     .TXT2,A0
            MOVE.B  #20,D0
            JSR     UTLPRINT
            
            MOVEM.L (A7)+,D0-D1/A0-A2
            
            TRAP    #SCRUPTN

            RTS
            
.TXT1       DC.B    '¡HAS GANADO!',0
.TXT2       DC.B    '¡PRESIONA LA BARRA ESPACIADORA PARA VOLVER AL MENÚ PRINCIPAL!',0
            DS.W    0

; ------------------------------------------------------------------------------
WINUPD
; VICTORY SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
            RTS

.CONT       MOVE.B  #SNDWIN,D7
            TRAP    #SNDPLTN
            RTS












*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
