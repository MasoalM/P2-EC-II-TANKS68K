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
            CLR.W   (ISCTIMER) 
            MOVEM.L D0-D5/A0-A1,-(A7)
            
            LEA     FILEDATA,A0            ; DESTINATION ADDRESS
            LEA     .FILENAME,A1            ; FILE NAME
            JSR     FILLOAD
            
            MOVE.L  #-1,D1
            MOVE.L  #-1,D2
            MOVE.L  #0,D3
            MOVE.L  #0,D4


.FILA
            MOVE.L  #-1,D1
            MOVE.L  #0,D3
            ADDQ.L  #1,D2
            ADDQ.L  #1,D4
.COLUMNA

            MOVE.L  D1,D5
            MOVE.L  (A0)+,D1
            MOVE.B  #80,D0                  ; MOVE.B #81,D0 falla porque pinta un cuadrado blanco
            TRAP    #15
            MOVE.L  D5,D1

            ADDQ.L  #1,D1
            ADDQ.L  #1,D3


            MOVE.B  #84,D0
            TRAP    #15

            CMP.L   #260,D3
            BLT     .COLUMNA
            CMP.L   #162,D4
            BLT     .FILA
            
            MOVEM.L (A7)+,D0-D5/A0-A1
             
            RTS  

.FILENAME   DC.B    'salida3.txt',0
            DS.W    0                     

; ------------------------------------------------------------------------------
ISCUPD
; INTRO SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            MOVE.W  #2,(STANEXT)
            RTS
            
.CONT       ADDQ.W  #1,(ISCTIMER)
            CMP.W   #ISCMAXTM,(ISCTIMER)
            BLT     .DONE
            MOVE.W  #1,(STANEXT)
            RTS
     
.DONE       MOVE.B  #SNDINTRO,D7
            TRAP    #SNDPLTN
            RTS

; ------------------------------------------------------------------------------
ISCPLOT
; INTRO SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
             
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            BTST.B  #4,(SCRCYCCT)           ; PARPADEO MENSAJE
            BEQ     .DONE
            
            LEA     .TXT2,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D1/A0

            RTS
.TXT1       DC.B    'TANKS 68K',0
.TXT2       DC.B    '¡PRESIONA LA BARRA ESPACIADORA PARA EMPEZAR!',0
            DS.W    0
           











*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
