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
            MOVEM.L D0-D1/A0,-(A7)
            
            LEA     WINDATA,A0
            MOVE.W  #SCRWIDTH/2,D1
            MOVE.W  #SCRHEIGH/2,D2
            SUB.W   #WINWIDTH/2,D1          ; PARA CENTRAR LA IMAGEN EN LA PANTALLA
            SUB.W   #WINHEIGH/2,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADDQ.W  #1,D3
            ADDQ.W  #1,D4

.FILA
            MOVE.W  #SCRWIDTH/2,D1
            SUB.W   #WINWIDTH/2,D1
            MOVE.W  D1,D3
            
            ADDQ.W  #1,D2
            ADDQ.W  #1,D4
.COLUMNA

            MOVE.L  D1,D5
            MOVE.L  (A0)+,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  D5,D1

            ADDQ.W  #1,D1
            ADDQ.W  #1,D3

            MOVE.B  #84,D0
            TRAP    #15
            
            MOVE.W  #SCRWIDTH/2,D6
            ADD.W   #WINWIDTH/2,D6
            CMP.W   D6,D3
            BLT     .COLUMNA
            
            MOVE.W  #SCRHEIGH/2,D6
            ADD.W   #WINHEIGH/2,D6
            CMP.W   D6,D4
            BLT     .FILA
           
            MOVE.L  #$0000BACF,D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            
            LEA     .TXT2,A0
            MOVE.B  #20,D0
            JSR     UTLPRINT
            
            MOVEM.L (A7)+,D0-D1/A0
            
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
