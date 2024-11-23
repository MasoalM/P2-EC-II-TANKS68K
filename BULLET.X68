*-----------------------------------------------------------
* BULLET MANAGEMENT (AGENT)
* BULPOSX (W) (A0)
* BULPOSY (W) 2(A0)
* BULVELX (W) 4(A0)     ; por ahora es una cte as? que no habr?a que ponerlo aqu?
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
            
            ; CHECK TANK COLLISIONS
.CHKTAN     ; ENEMY TANK COLLISIONS
            MOVEM.L A0-A1/D0-D7,-(A7)
            MOVE.W  (A0),D2                 ; PREPARE SHOT COORDINATES FOR
            MOVE.W  2(A0),D3                ; COLLISION CHECK
            MOVE.W  #BULRAD,D5
            MOVE.W  #BULRAD,D7
            MOVE.L  A0,A1
            MOVE.W  #TANENEM,D0
            JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .CHKPLAY
            MOVE.W  8(A0),D0    ;??
            MOVE.W  10(A0),D1   ;??
            SUB.W   #TANWIDTH/2,D0
            SUB.W   #TANHEIGH/2,D1
            MOVE.W  #TANWIDTH,D4
            MOVE.W  #TANHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .EXPLO
            MOVE.W  #TANENEM,D0
            JSR     DMMNEXTO
            BRA     .LOOP  
.CHKPLAY    ; PLAYER TANK COLLISIONS
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  8(A0),D0    ;??
            MOVE.W  10(A0),D1   ;??
            SUB.W   #TANWIDTH/2,D0
            SUB.W   #TANHEIGH/2,D1
            MOVE.W  #TANWIDTH,D4
            MOVE.W  #TANHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .EXPLO
            BRA     .END

            ; TANK COLLISION (SUBSTRACT LIFE, DISSAPPEAR THE BULLET AND SPAWN PARTICLES)           
.EXPLO          
            SUB.W   #BULDMG,24(A0)
            ; IF TANK LIFE IS 0
            CMP.W   #0,24(A0)
            BHI     .ALIVE
            
            CMP.W   #TANPLAY,D0
            
            BNE.W   .BOTSNDKILL
            ; IF TANK IS NOT A BOT (PLAYER)
            MOVE.B  #SNDWAA,D7
            TRAP    #SNDPLTN
            JSR     AGLKILL
            BRA     .KILBUL   
.BOTSNDKILL ; IF TANK IS A BOT  
            MOVE.B  #SNDKILL,D7
            TRAP    #SNDPLTN
            JSR     AGLKILL
            BRA     .KILBUL
.ALIVE
            MOVE.B  #SNDHIT,D7  ; HIT SOUND IF TANK DOESN'T DIE
            TRAP    #SNDPLTN
.KILBUL            
            MOVE.L  A1,A0              
            JSR     AGLKILL 
             
.END        MOVEM.L (A7)+,A0-A1/D0-D7
            BRA     .DONE   
              
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
