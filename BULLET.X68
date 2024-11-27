*-----------------------------------------------------------
* BULLET MANAGEMENT (AGENT)
* BULPOSX (W) (A0)
* BULPOSY (W) 2(A0)
* BULVELX (W) 4(A0)     ; por ahora es una cte as? que no habr?a que ponerlo aqu?
* BULVELY (W) 6(A0)     ; idem
* BULFATH (W) 8(A0)     ; IDENTIFICADOR DEL PADRE DE LA BALA
* TOUCHLFT(W) 10(A0)    ; TOQUES RESTANTES PARA QUE EXPLOTE LA BALA
* TANPOSX     D1
* TANPOSY     D2
* FATHID      D3
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
            ; GUARDAMOS EL ID DEL PADRE DE LA BALA
            MOVE.W  D3,8(A0)
            ; TOQUES DE LA BALA DISPONIBLES CON LAS PAREDES EMPIEZAN SIENDO EL MÁXIMO
            MOVE.W  #MAXTOUCH,10(A0)
            
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
            
            MOVEM.W D0-D4,-(A7)            

            ; UPDATE BALL COORDINATES
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            ADD.W   4(A0),D0
            ADD.W   6(A0),D1
            
            ;INICIALIZAMOS
            LEA.L   MAPDATA,A1
            ;SUBQ.L  #2,A1
            MOVE.W  D0,D4
            MOVE.W  D1,D5
            MOVE.W  #0,D2
            MOVE.W  #0,D3
            
            ;SACAMOS LA POSICIÓN RELATIVA DE X
            BRA .CHKX
.NOORGX
            SUB.W   #PIESIZX,D4
            ADDQ.L  #2,A1
            ADD.W   #PIESIZX,D2
.CHKX            
            CMP.W   #PIESIZX,D4
            BGT     .NOORGX             
            
            ;SACAMOS LA POSICIÓN RELATIVA DE Y
            BRA .CHKY
.NOORGY
            SUB.W   #PIESIZY,D5
            ADD.L   #40,A1
            ADD.W   #PIESIZY,D3
.CHKY            
            CMP.W   #PIESIZX,D5
            BGT     .NOORGY
            
            ; CHECK HORIZONTAL COLLISIONS
            CMP.W   #PIESIZX-BULRAD/2,D4
            BGE     .COLRGT
.RECX
            CMP.W   #BULRAD+2,D4            
            BLT     .COLLFT                 

            ; CHECK VERTICAL COLLISIONS
.CHKVERT    CMP.W   #PIESIZY-BULRAD/2,D5
            BGE     .COLBOT
.RECY            
            CMP.W   #BULRAD+2,D5
            BLT     .COLTOP                
            BRA     .CHKTAN   

            ; RIGHT SIDE COLLISION    
.COLRGT     
            ADDQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FARSC
            MOVE.W  #PIESIZX-BULRAD,D0
            ADD.W   D2,D0
            NEG.W   4(A0)
            SUBQ.W  #1,10(A0)
            CMP.W   #0,10(A0)
            BNE     .BULWALL
            MOVE.W  8(A0),D3
            JSR     AGLKILL
            BRA     .BULFACHK  
.FARSC
            SUBQ.L  #2,A1
            BRA     .RECX

            ; LEFT SIDE COLLISION
.COLLFT     
            SUBQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FALSC
            MOVE.W  #BULRAD,D0
            ADD.W   D2,D0
            NEG.W   4(A0) 
            SUBQ.W  #1,10(A0)  
            CMP.W   #0,10(A0)
            BNE     .BULWALL
            MOVE.W  8(A0),D3
            JSR     AGLKILL
            BRA     .BULFACHK            
                
.FALSC
            ADDQ.L  #2,A1
            BRA     .CHKVERT  

            ; BOTTOM COLLISION
.COLBOT     
            ADD.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .FABSC
            MOVE.W  #PIESIZY-BULRAD,D1
            ADD.W   D3,D1
            NEG.W   6(A0)
            SUBQ.W  #1,10(A0)
            CMP.W   #0,10(A0)
            BNE     .BULWALL
            MOVE.W  8(A0),D3
            JSR     AGLKILL
            BRA     .BULFACHK
.FABSC
            ;SUB.L   #40,A1            
            BRA     .RECY

            ; TOP COLLISION
.COLTOP     
            SUB.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .CHKTAN
            MOVE.W  #BULRAD,D1
            ADD.W   D3,D1         
            NEG.W   6(A0)
            SUBQ.W  #1,10(A0)
            CMP.W   #0,10(A0)
            BNE     .BULWALL
            JSR     AGLKILL
            MOVE.W  8(A0),D3
            JSR     AGLKILL
            BRA     .BULFACHK

.BULFACHK   CLR.W   D4              ; CONTADOR
            MOVE.W  #TANENEM,D0
            JSR     DMMFRSTO
.LOOP31     CMP.L   #0,A0
            BEQ     .CHKPLAY2
            ADDQ.W  #1,D4
            CMP.W   D3,D4
            BNE     .LOOP32
            ADDQ.W  #1,26(A0)       ; AGREGAR UNA BALA DISPONIBLE AL TANQUE SI ES EL PADRE
            BRA     .ENDCOLEX
.LOOP32     JSR     DMMNEXTO
            BRA     .LOOP31

.CHKPLAY2   MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            ;CMP.L   #0,A0           ; COMPROBACIÓN POR SI ACASO
            ;BEQ     .ENDCOLEX
            ADDQ.W  #1,26(A0)
            BRA     .ENDCOLEX

.ENDCOLEX   ; FINAL EN EL QUE LA BALA EXPLOTA POR TENER X COLISIONES CON BLOQUES         
            MOVE.B  #SNDBULEX,D7
            TRAP    #SNDPLTN
            MOVEM.W (A7)+,D0-D4
            RTS 


.BULWALL    MOVE.B  #SNDWALL,D7 ; BULLET WALL SOUND
            TRAP    #SNDPLTN           
            
.CHKTAN     
            ; CHECK TANK COLLISIONS
            ; ENEMY TANK COLLISIONS
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
            
            CMP.W   #TANPLAY,22(A0)
            BNE.W   .BOTSNDKILL
            ; IF TANK IS NOT A BOT (PLAYER)
            MOVE.B  #SNDWAA,D7
            TRAP    #SNDPLTN
            JSR     AGLKILL
            BRA     .BULFINAL   
.BOTSNDKILL ; IF TANK IS A BOT  
            MOVE.B  #SNDKILL,D7
            TRAP    #SNDPLTN
            JSR     AGLKILL
            BRA     .BULFINAL
.ALIVE
            MOVE.B  #SNDHIT,D7  ; HIT SOUND IF TANK DOESN'T DIE
            TRAP    #SNDPLTN
.BULFINAL    
            MOVE.L  A1,A0
            MOVE.W  8(A0),D3    ; ALMACENAR EL FATHER ID
            MOVE.L  A0,A1        
            ; SUMARLE UNA BALA DISPONIBLE AL TANQUE
            ; COMPROBAR SI EL TANQUE PADRE DE LA BALA ES UN BOT, RECORRER TODOS Y COMPROBAR CON CUÁL COINCIDE EL TANID
            MOVE.W  #TANENEM,D0 ;22(A0)
            CLR.W   D2          ; CONTADOR
            JSR     DMMFRSTO
.LOOP2      CMP.L   #0,A0
            BEQ     .PLAYBULL   ; NO ENCONTRADO NINGÚN TANQUE ENEMIGO QUE SEA PADRE DE LA BALA, COMPROBAR JUGADOR
            ADDQ.W  #1,D2       ; AGREGAR 1 AL CONTADOR
            JSR     DMMNEXTO
            CMP.W   D2,D3
            BNE     .LOOP2      ; SEGUIR CON EL BUCLE SI NO ES EL PADRE
            ADDQ.W  #1,26(A0)   ; SI ES EL PADRE LE SUMAMOS UNA BALA DISPONIBLE
            BRA     .KILLBULL


.PLAYBULL   ; EL TANQUE PADRE DE LA BALA ES EL JUGADOR
            MOVE.W  #TANPLAY,D0 ;22(A0)
            JSR     DMMFRSTO
            ADDQ.W  #1,26(A0)
            
.KILLBULL
            MOVE.L  A1,A0             
            JSR     AGLKILL 
            
.END        MOVEM.L (A7)+,A0-A1/D0-D7
            BRA     .DONE   
              
            ; STORE POSITION
.DONE       MOVE.W  D0,(A0)
            MOVE.W  D1,2(A0)
            
            MOVEM.W (A7)+,D0-D4
            
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
