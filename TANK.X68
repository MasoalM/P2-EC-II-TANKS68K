*-----------------------------------------------------------
* TANK MANAGEMENT
*-----------------------------------------------------------

; ----------------------------------------------------------
TANINIT
; INITIALITZE TANK
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVE.W  #SCRWIDTH/2,(TANPOSX)   ; INITIAL TANK POSITION X
            MOVE.W  #SCRHEIGH/2,(TANPOSY)   ; INITIAL TANK POSITION Y
            RTS
            
; ----------------------------------------------------------            
TANUPD
; UPDATE THE TANK
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            RTS
            
; ----------------------------------------------------------            
TANPLOT
; PLOT THE TANK
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)

            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  #TANPCOL,D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  #TANFCOL,D1
            TRAP    #15
            
            ; DEFINE COORDINATES
            MOVE.W  (TANPOSX),D1
            SUB.W   #TANWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #TANWIDTH,D3
            
            MOVE.W  (TANPOSY),D2
            SUB.W   #TANHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #TANHEIGH,D4
            
            ; DRAW RECTANGLE (TANK)
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            
            RTS    


*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
