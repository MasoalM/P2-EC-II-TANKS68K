; ==============================================================================
; INTRO SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
ISCINIT
; INTRO SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D5/A0-A2,-(A7)

            MOVE.W  #0,(DOPLOT)

            MOVE.B  #92,D0                  ;DESACTIVAR DOBLE BUFFER
            MOVE.B  #16,D1
            TRAP    #15
            
            MOVE.L  #$00054B17,D1           ; COLOR FONDO
            MOVE.B  #81,D0
            TRAP    #15
            
            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH,D3
            MOVE.L  #SCRHEIGH,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            CLR.W   (ISCTIMER) 
            
            CLR.L   D5
            
            LEA     FILEDATA,A0
            MOVE.W  #IMAWIDTH/2,(A2)
            MOVE.W  #IMAHEIGH/2,2(A2)
            MOVE.W  #SCRWIDTH/2,4(A2)       ; POSICIONES X E Y INICIALE
            MOVE.W  #SCRHEIGH/2,6(A2)
            
            JSR     IMAPLOT
            
            MOVE.L  #$00054B17,D1
            MOVE.B  #81,D0
            TRAP    #15
 
            LEA     .TXT1,A0                ; TEXTO 1
            MOVE.B  #25,D0
            JSR     UTLPRINT
            
            LEA     .TXT2,A0                ; TEXTO 2
            MOVE.B  #28,D0
            JSR     UTLPRINT
            
            LEA     .TXT3,A0                ; TEXTO 3
            MOVE.B  #29,D0
            JSR     UTLPRINT
          
            MOVE.B  #17,D1                    ; ACTIVAR DOUBLE BUFFER
            MOVE.B  #92,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D5/A0-A2
            
            RTS  

.TXT1       DC.B    '¡PRESIONA LA BARRA ESPACIADORA PARA EMPEZAR!',0
.TXT2       DC.B    'PRESIONA LA TECLA "i" PARA',0 
.TXT3       DC.B    'VISITAR EL MENÚ DE INSTRUCCIONES',0
            DS.W    0
                              

; ------------------------------------------------------------------------------
ISCUPD
; INTRO SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT1
            MOVE.W  #2,(STANEXT)
            RTS
            
.CONT1      BTST.B  #5,(KBDEDGE)
            BEQ     .CONT2
            MOVE.W  #1,(STANEXT)
            RTS
            
.CONT2      ADDQ.W  #1,(ISCTIMER)
            CMP.W   #ISCMAXTM,(ISCTIMER)
            BLT     .DONE
            MOVE.W  #1,(DEMO)
            MOVE.W  #2,(STANEXT)
            RTS
     
.DONE       MOVE.B  #SNDINTRO,D7
            TRAP    #SNDPLTN
            RTS




















*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
