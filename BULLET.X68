*-----------------------------------------------------------
* BULLET MANAGEMENT
*-----------------------------------------------------------

; ----------------------------------------------------------
BULINIT
; INITIALITZE BULLET
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVE.W  #SCRWIDTH/3,(BULPOSX)
            MOVE.W  #SCRHEIGH/3,(BULPOSY)
            MOVE.W  #BULSPEED,(BULVELX)
            MOVE.W  #BULSPEED,(BULVELY)
            
            RTS
; ----------------------------------------------------------
BULUPD
; UPDATE THE BULLET
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.W D0-D2,-(A7)            

            ; UPDATE BALL COORDINATES
            MOVE.W  (BULPOSX),D0
            MOVE.W  (BULPOSY),D1
            ADD.W   (BULVELX),D0
            ADD.W   (BULVELY),D1
            
            ; CHECK HORIZONTAL COLLISIONS
            CMP.W   #SCRWIDTH-BULRAD,D0
            BGT     .COLRGT
            CMP.W   #BULRAD,D0
            BLT     .COLLFT
            
            ; CHECK VERTICAL COLLISIONS
.CHKVERT    CMP.W   #SCRHEIGH-BULRAD,D1
            BGT     .COLBOT
            CMP.W   #BULRAD,D1
            BLT     .COLTOP
            BRA     .CHKTAN   
            
            ; RIGHT SIDE COLLISION    
.COLRGT     NEG.W   (BULVELX)
            MOVE.W  #SCRWIDTH-BULRAD,D0
            BRA     .CHKVERT

            ; LEFT SIDE COLLISION
.COLLFT     NEG.W   (BULVELX)
            MOVE.W  #BULRAD,D0
            BRA     .CHKVERT  

            ; BOTTOM COLLISION
.COLBOT     NEG.W   (BULVELY)
            MOVE.W  #SCRHEIGH-BULRAD,D1
            BRA     .CHKTAN

            ; TOP COLLISION
.COLTOP     NEG.W   (BULVELY)
            MOVE.W  #BULRAD,D1
            
            ; CHECK TANK COLLISIONS (solo para el tanque del jugador por ahora, para comprobar todos los tanques habría que hacer un bucle y comprobar con todas las posiciones de todos los tanques)
.CHKTAN     MOVE.W  (TANPOSX),D2
            SUB.W   D0,D2
            BPL     .ISPOS
            NEG.W   D2    
.ISPOS      CMP.W   #TANWIDTH/2+BULRAD,D2
            BGT     .DONE
            MOVE.W  (TANPOSY),D2
            SUB.W   D1,D2
            BPL     .ISPOS2
            NEG.W   D2
.ISPOS2     CMP.W   #TANHEIGH/2+BULRAD,D2
            BGT     .DONE

            ; TANK COLLISION (SUBSTRACT LIFE, DISSAPPEAR THE BULLET AND SPAWN PARTICLES)           
            ; (Por ahora he puesto que sume puntuación para comprobar que se detecte correctamente la colisión)
            NEG.W   (BULVELX)
            NEG.W   (BULVELY)
            ADDQ.W  #1,(SCORE)
            
            
            ; STORE POSITION
.DONE       MOVE.W  D0,(BULPOSX)
            MOVE.W  D1,(BULPOSY)
            
            MOVEM.W (A7)+,D0-D2
            
            RTS
            
; ----------------------------------------------------------
BULPLOT
; PLOT THE BULLET
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVEM.L D0-D4,-(A7)            

            ; SET PEN COLOR
            MOVE.B  #80,D0
            MOVE.L  #BULPCOL,D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  #BULFCOL,D1
            TRAP    #15
            
            ; DEFINE COORDINATES
            MOVE.W  (BULPOSX),D1
            SUB.W   #BULRAD,D1
            MOVE.W  (BULPOSY),D2
            SUB.W   #BULRAD,D2
            MOVE.W  D1,D3
            ADD.W   #2*BULRAD,D3
            MOVE.W  D2,D4
            ADD.W   #2*BULRAD,D4
            
            ; DRAW CIRCLE
            MOVE.B  #88,D0
            TRAP    #15 
            
            MOVEM.L (A7)+,D0-D4 

            RTS
            
                        
            



*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
