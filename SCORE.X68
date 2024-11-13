*-----------------------------------------------------------
* SCOREBOARD MANAGEMENT
*-----------------------------------------------------------

; ----------------------------------------------------------
SCOINIT
; INITIALITZE SCOREBOARD
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            CLR.W   (SCORE)
            RTS

; ----------------------------------------------------------
SCOPLOT
; PLOT THE SCOREBOARD
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)

            ; SET BACKGROUND COLOR
            MOVE.B  #81,D0
            MOVE.L  #SCOFCOL,D1
            TRAP    #15
            
            ; SET LINE POSITION
            MOVE.B  #11,D0
            MOVE.W  #SCOLINE,D1
            TRAP    #15

            ; PRINT LINE
            LEA     .TXT,A1
            CLR.L   D1
            MOVE.W  (SCORE),D1
            MOVE.B  #17,D0
            TRAP    #15    

            MOVEM.L (A7)+,D0-D1/A1          

            RTS
.TXT        DC.B    'PUNTUACIÓN: ',0   
            DC.W    0                   ; PARA QUE LAS INSTRUCCIONES ESTÉN ALINEADAS

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
