; ==============================================================================
; INSTRUCTIONS SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
INSINIT
; INICIALIZACIÓN DE LA PANTALLA DE INSTRUCCIONES
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVE.B  #17,D1                  ; ACTIVAR DOUBLE BUFFER
            MOVE.B  #92,D0
            TRAP    #15
            TRAP    #SCRUPTN
            
            MOVEM.L D0-D1/A0-A1,-(A7)
            
            ; COLOR FONDO VERDE
            MOVE.L  #$00054B17,D1           
            MOVE.B  #81,D0
            TRAP    #15

            ; DIBUJAR RECTÁNGULO (FONDO)
            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH,D3
            MOVE.L  #SCRHEIGH,D4
            MOVE.B  #87,D0
            TRAP    #15

            ; TEXTO INICIAL
            LEA     .TXT1,A0
            MOVE.B  #5,D0
            JSR     UTLPRINT
            
            ; SECUENCIA DE TEXTOS
            MOVE.B  #11,D0
            LEA     .TXTLST,A1
.LOOP       MOVE.L  (A1)+,D1
            BEQ     .LOOPEND
            MOVE.L  D1,A0
            JSR     UTLPRINT
            BRA     .LOOP
.LOOPEND           
            ; TEXTO FINAL
            LEA     .TXT9,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT

            MOVEM.L (A7)+,D0-D1/A0-A1

            TRAP    #SCRUPTN
            RTS
            
.TXT1       DC.B    '¡BIENVENIDO A TANKS 68K!',0
.TXT2       DC.B    'TU OBJETIVO ES SUPERAR TODOS LOS NIVELES.',0
.TXT3       DC.B    'PARA ELLO, DEBES DERROTAR A TODOS LOS TANQUES ENEMIGOS',0
.TXT4       DC.B    'SIN QUE ELLOS AGOTEN TU BARRA DE VIDA.',0
.TXT5       DC.B    'PARA MOVERTE UTILIZA LAS TECLAS WASD,',0
.TXT6       DC.B    'PARA APUNTAR UTILIZA EL RATÓN,',0
.TXT7       DC.B    'PARA DISPARAR PRESIONA EL CLICK IZQUIERDO,',0
.TXT8       DC.B    'TIENES UN MÁXIMO DE 3 BALAS SIMULTÁNEAS.',0
.TXT9       DC.B    'PULSA ESPACIO PARA REGRESAR AL MENÚ PRINCIPAL',0
.VOIDTXT    DC.B    '',0
            DS.W    0
.TXTLST     DC.L    .TXT2,.TXT3,.TXT4,.VOIDTXT,.VOIDTXT,.TXT5,.TXT6,.TXT7,.TXT8,0            

; ------------------------------------------------------------------------------
INSUPD
; ACTUALIZACIÓN DE LA PANTALLA DE INSTRUCCIONES
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ; SI SE PULSA EL ESPACIO, VOLVER AL MENÚ PRINCIPAL
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
            RTS
.CONT       ; CANCIÓN MENÚ INSTRUCCIONES
            MOVE.B  #SNDINSTR,D7
            TRAP    #SNDPLTN
            RTS










*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
