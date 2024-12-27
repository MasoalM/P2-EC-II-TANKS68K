*-----------------------------------------------------------
* GESTIÓN DE LA BALA (AGENTE)
* BULPOSX (W) (A0)      ; POSICIÓN X
* BULPOSY (W) 2(A0)     ; POSICIÓN Y
* BULVELX (W) 4(A0)     ; VELOCIDAD X
* BULVELY (W) 6(A0)     ; VELOCIDAD Y
* BULFATH (W) 8(A0)     ; IDENTIFICADOR DEL PADRE DE LA BALA
* TOUCHLFT(W) 10(A0)    ; TOQUES RESTANTES PARA QUE EXPLOTE LA BALA
* TANPOSX     D1        ; POSICIÓN X DEL TANQUE QUE LA HA CREADO
* TANPOSY     D2        ; POSICIÓN Y DEL TANQUE QUE LA HA CREADO
* FATHID      D3        ; ID DEL PADRE DE LA BALA (RECIBIDO POR PARÁMETRO)
*-----------------------------------------------------------

; ----------------------------------------------------------
BULINIT
; INICIALIZAR BALA
; INPUT     : PUNTERO DE A0 A LAS VARIABLES DE INSTANCIA
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            ; AJUSTAR POSICIÓN INICIAL PARA QUE NO APAREZCA SOBRE EL TANQUE
            ADD.W   (BULPOSORGX),D1
            ADD.W   (BULPOSORGY),D2

            MOVEM.W D0-D5,-(A7)
            
            ; CALCULAR LA POSICIÓN RELATIVA
            MOVE.W  D1,D0
            MOVE.W  D2,D1
            LEA.L   MAPDATA,A1
            
            MOVE.W  (LVLNUM),D6
            MULU.W  #SIZLVL,D6
            ADD.L   D6,A1
            
            JSR     RELPOS
            MOVE.W  D1,D2
            MOVE.W  D0,D1
            
            ; ESTABLECER LA POSICIÓN INICIAL DE LA BALA
            MOVE.W  D1,(A0) 
            MOVE.W  D2,2(A0)
            
            MOVEM.W (A7)+,D0-D5
            
            ; GUARDAR EL ID DEL PADRE DE LA BALA
            MOVE.W  D3,8(A0)
            
            CMP.W   #$01,(A1)   ; COMPROBAR ESTADO DEL MAPA
            BNE     .SEGBULL
            ; LA BALA HA HECHO SPAWN ENCIMA DE UN BLOQUE
            MOVEM.W D4-D5,-(A7)
            
            CMP.W   #0,8(A0)    ; COMPROBAR SI EL PADRE DE LA BALA ES EL JUGADOR
            BNE     .NOTPLAYER
            
            ; EL JUGADOR ES EL PADRE DE LA BALA
            MOVE.L  A0,A1
            
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            ADDQ.W  #1,18(A0)   ; AGREGARLE UNA BALA DISPONIBLE AL JUGADOR
            MOVE.L  A1,A0            
.NOTPLAYER
            JSR     AGLKILL     ; DESTRUIR BALA
            MOVEM.W (A7)+,D4-D5
            RTS
             
.SEGBULL    ; LA BALA HA HECHO SPAWN CORRECTAMENTE                
            MOVE.W  #MAXTOUCH,10(A0)    ; TOQUES DE LA BALA DISPONIBLES CON LAS PAREDES EMPIEZAN SIENDO EL MÁXIMO
            MOVE.W  (BULVELX),4(A0)
            MOVE.W  (BULVELY),6(A0)
            RTS
            
; ----------------------------------------------------------
BULUPD
; ACTUALIZA LA BALA
; INPUT     : PUNTERO DE A0 A LAS VARIABLES DE INSTANCIA
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
            MOVE.W  (LVLNUM),D6
            MULU.W  #SIZLVL,D6
            ADD.L   D6,A1
            JSR     RELPOS
            
            CMP.W   #01,(A1)
            BNE .CHKTAN
            
            CMP.W   #PIESIZX/3,D4
            BLO     .COLX
            CMP.W   #2*PIESIZX/3,D4  
            BHI     .COLX
            BRA     .SVPNT
.COLX
            MOVE.W  #$FF,D2
            NEG.W   4(A0)
.SVPNT            
            CMP.W   #PIESIZY/3,D5
            BLO     .COLY
            CMP.W   #2*PIESIZY/3,D5  
            BHI     .COLY
            BRA     .SVPNT2
.COLY
            NEG.W   6(A0)
            MOVE.W  #$FF,D3     
.SVPNT2           

            CMP.W   #$FF,D2
            BEQ     .TRATCOL
.TRATCOLU
            SUBQ.W  #1,10(A0)
            CMP.W   #0,10(A0)
            BNE     .BULWALL
            MOVE.W  8(A0),D3
            JSR     AGLKILL
            BRA     .BULFACHK
.TRATCOL            
            CMP.W   #$FF,D3
            BNE     .TRATCOLU
            CMP.W   D5,D4
            BHI     .GAND5
            BLO     .GAND4
            BRA     .TRATCOLU
.GAND4            
            NEG.W   6(A0)
            BRA     .TRATCOLU
.GAND5
            NEG.W   4(A0)
            BRA     .TRATCOLU


            BRA     .CHKTAN
.BULFACHK   CLR.W   D4              ; CONTADOR
            MOVE.W  #TANENEM,D0
            JSR     DMMFRSTO
.LOOP31     CMP.L   #0,A0
            BEQ     .CHKPLAY2
            ADDQ.W  #1,D4
            CMP.W   D3,D4
            BNE     .LOOP32
            ADDQ.W  #1,18(A0)       ; AGREGAR UNA BALA DISPONIBLE AL TANQUE SI ES EL PADRE ; no llega aquí?
            BRA     .ENDCOLEX
.LOOP32     JSR     DMMNEXTO
            BRA     .LOOP31

.CHKPLAY2   
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            CMP.W   #0,D3
            BNE     .ENDCOLEX
            ADDQ.W  #1,18(A0)
            
.ENDCOLEX   ; FINAL EN EL QUE LA BALA EXPLOTA POR TENER X COLISIONES CON BLOQUES         
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
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
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
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            SUB.W   #TANWIDTH/2,D0
            SUB.W   #TANHEIGH/2,D1
            MOVE.W  #TANWIDTH,D4
            MOVE.W  #TANHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .EXPLO
            BRA     .END

            ; TANK COLLISION (SUBSTRACT LIFE, DISSAPPEAR THE BULLET)  ; agregar part?culas?         
.EXPLO          
            SUB.W   #BULDMG,16(A0)
            
            CMP.W   #0,16(A0)
            BHI     .ALIVE
            ; IF TANK LIFE IS 0
            
            CMP.W   #TANPLAY,14(A0)
            BNE.W   .ENSNDKIL
            ; IF HIT TANK IS NOT A BOT (PLAYER)
            MOVE.W  #KILLPLYR,(PLYRDEAD)
            JSR     AGLKILL
            BRA     .BULFINAL   
.ENSNDKIL   ; IF TANK IS A BOT 
            ADDQ.W  #1,(SCORE)  ; SUMAMOS 1 A LA PUNTUACI?N 
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
     
            ; SUMARLE UNA BALA DISPONIBLE AL TANQUE
            ; COMPROBAR SI EL TANQUE PADRE DE LA BALA ES UN BOT, RECORRER TODOS Y COMPROBAR CON CU?L COINCIDE EL TANID
            MOVE.W  #TANENEM,D0
            CLR.W   D2          ; CONTADOR
            JSR     DMMFRSTO
.LOOP21     CMP.L   #0,A0
            BEQ     .PLAYBULL   ; NO ENCONTRADO NING?N TANQUE ENEMIGO QUE SEA PADRE DE LA BALA, COMPROBAR JUGADOR
            ADDQ.W  #1,D2       ; AGREGAR 1 AL CONTADOR
            
            CMP.W   D2,D3
            BNE     .LOOP22     
            ADDQ.W  #1,18(A0)   ; SI ES EL PADRE LE SUMAMOS UNA BALA DISPONIBLE
            BRA     .KILLBULL

.LOOP22     JSR     DMMNEXTO
            BRA     .LOOP21     ; SEGUIR CON EL BUCLE YA QUE NO ES EL PADRE            


.PLAYBULL   ; EL TANQUE PADRE DE LA BALA ES EL JUGADOR (O ES UN ENEMIGO QUE HA MUERTO)
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            CMP.W   #0,D3
            BNE     .KILLBULL
            ADDQ.W  #1,18(A0)
            
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
; DIBUJA LA BALA
; INPUT     : PUNTERO DE A0 A LAS VARIABLES DE INSTANCIA
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
