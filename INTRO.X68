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
            MOVE.W  #0,(DOPLOT)

            MOVE.B  #92,D0                  ;DESACTIVAR DOBLE BUFFER
            MOVE.B  #16,D1
            TRAP    #15
            
            CLR.W   (ISCTIMER) 
            MOVEM.L D0-D6/A0,-(A7)
            LEA     FILEDATA,A0
            
            CLR.L   D5
            
            MOVE.W  #SCRWIDTH/2,D1
            MOVE.W  #SCRHEIGH/2,D2
            SUB.W   #IMAWIDTH/2,D1          ; PARA CENTRAR LA IMAGEN EN LA PANTALLA
            SUB.W   #IMAHEIGH/2,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADDQ.W  #1,D3
            ADDQ.W  #1,D4

.FILA
            MOVE.W  #SCRWIDTH/2,D1
            SUB.W   #IMAWIDTH/2,D1
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
            ADD.W   #IMAWIDTH/2,D6
            CMP.W   D6,D3
            BLT     .COLUMNA
            
            MOVE.W  #SCRHEIGH/2,D6
            ADD.W   #IMAHEIGH/2,D6
            CMP.W   D6,D4
            BLT     .FILA
            
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
          
            MOVEM.L (A7)+,D0-D6/A0
            
            MOVE.B  #17,D1                    ; ACTIVAR DOUBLE BUFFER
            MOVE.B  #92,D0
            TRAP    #15
            
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
