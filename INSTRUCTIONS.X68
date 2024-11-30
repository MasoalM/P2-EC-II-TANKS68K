; ==============================================================================
; INSTRUCTIONS SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
INSINIT
; INSTRUCTIONS SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.W   (INSTIMER)
            RTS

; ------------------------------------------------------------------------------
INSUPD
; INSTRUCTIONS SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
.CONT       ADDQ.W  #1,(INSTIMER)
            CMP.W   #INSMAXTM,(INSTIMER)
            BLT     .DONE
            CLR.W   (STANEXT)
            RTS
 
.DONE       MOVE.B  #SNDINSTR,D7
            TRAP    #SNDPLTN
            RTS

; ------------------------------------------------------------------------------
INSPLOT
; INSTRUCTIONS SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.B  #11,D0
            LEA     .TXTLST,A1
.LOOP       MOVE.L  (A1)+,D1
            BEQ     .LOOPEND
            MOVE.L  D1,A0
            JSR     UTLPRINT
            BRA     .LOOP
.LOOPEND            
            BTST.B  #4,(SCRCYCCT)           ; PARPADEO MENSAJE
            BEQ     .DONE
            
            LEA     .TXT6,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT

.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
.TXT1       DC.B    '¡BIENVENIDO A TANKS 68K!',0
.TXT2       DC.B    'TU OBJETIVO ES SUPERAR TODOS LOS NIVELES.',0
.TXT3       DC.B    'PARA ELLO, DEBES DERROTAR A TODOS LOS TANQUES ENEMIGOS',0
.TXT4       DC.B    'PARA MOVERTE UTILIZA LAS TECLAS WASD,',0
.TXT5       DC.B    'PARA DISPARAR PRESIONA LA BARRA ESPACIADORA',0
.TXT6       DC.B    'PULSA ESPACIO PARA REGRESAR AL MENÚ PRINCIPAL',0
            DS.W    0
.TXTLST     DC.L    .TXT1,.TXT2,.TXT3,.TXT4,.TXT5,0




*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
