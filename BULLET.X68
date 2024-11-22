*-----------------------------------------------------------
* BULLET MANAGEMENT (AGENT)
* BULPOSX (W) (A0)
* BULPOSY (W) 2(A0)
* BULVELX (W) 4(A0)     ; por ahora es una cte así que no habría que ponerlo aquí
* BULVELY (W) 6(A0)     ; idem
* TANPOSX (W) D1
* TANPOSY (W) D2
*-----------------------------------------------------------

; ----------------------------------------------------------
BULINIT
; INITIALITZE BULLET
; INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            ; PARA QUE LA BALA NO APAREZCA ENCIMA DEL TANQUE (modificar para que sea hacia donde apunta)
            ADD.W   #20,D1
            ADD.W   #20,D2
            ; BALA SPAWNEA DONDE EL TANQUE QUE LA GENERA
            MOVE.W  D1,(A0) 
            MOVE.W  D2,2(A0)
            
            MOVE.W  #BULSPEED,4(A0)             ; hacer que bulspeed sea variable y que sea 0 o el bulspeed actual (para que se mueva en 8 direcciones)
            MOVE.W  #BULSPEED,6(A0)
            RTS
            
; ----------------------------------------------------------
BULUPD
; UPDATE THE BULLET
; INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.W D0-D2,-(A7)            

            ; UPDATE BALL COORDINATES
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            ADD.W   4(A0),D0
            ADD.W   6(A0),D1
            
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
.COLRGT     NEG.W   4(A0)
            MOVE.W  #SCRWIDTH-BULRAD,D0
            MOVE.B  #SNDWALL,D7
            TRAP    #SNDPLTN
            BRA     .CHKVERT

            ; LEFT SIDE COLLISION
.COLLFT     NEG.W   4(A0)
            MOVE.W  #BULRAD,D0
            MOVE.B  #SNDWALL,D7
            TRAP    #SNDPLTN
            BRA     .CHKVERT    

            ; BOTTOM COLLISION
.COLBOT     NEG.W   6(A0)
            MOVE.W  #SCRHEIGH-BULRAD,D1
            MOVE.B  #SNDWALL,D7
            TRAP    #SNDPLTN
            BRA     .CHKTAN

            ; TOP COLLISION
.COLTOP     NEG.W   6(A0)
            MOVE.W  #BULRAD,D1
            MOVE.B  #SNDWALL,D7
            TRAP    #SNDPLTN
            
            ; CHECK TANK COLLISIONS (solo para el tanque del jugador por ahora, para comprobar todos los tanques habría que hacer un bucle y comprobar con todas las posiciones de todos los tanques)
.CHKTAN     ;MOVE.W  (TANPOSX),D2
;            SUB.W   D0,D2
;            BPL     .ISPOS
;            NEG.W   D2    
;.ISPOS      CMP.W   #TANWIDTH/2+BULRAD,D2
;            BGT     .DONE
;            MOVE.W  (TANPOSY),D2
;            SUB.W   D1,D2
;            BPL     .ISPOS2
;            NEG.W   D2
;.ISPOS2     CMP.W   #TANHEIGH/2+BULRAD,D2
;            BGT     .DONE

;            ; TANK COLLISION (SUBSTRACT LIFE, DISSAPPEAR THE BULLET AND SPAWN PARTICLES)           
            
            ;ADDQ.W  #1,(SCORE)
;            JSR     AGLKILL 
;            MOVE.B  #SNDHIT,D7
;            TRAP    #SNDPLTN
            
            
            ; STORE POSITION
.DONE       MOVE.W  D0,(A0)
            MOVE.W  D1,2(A0)
            
            MOVEM.W (A7)+,D0-D2
            
            RTS
            
; ----------------------------------------------------------
BULPLOT
; PLOT THE BULLET
; INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
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
            MOVE.W  (A0),D1
            SUB.W   #BULRAD,D1
            MOVE.W  2(A0),D2
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
