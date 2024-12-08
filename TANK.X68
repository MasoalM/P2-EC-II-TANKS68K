*-----------------------------------------------------------
* TANK MANAGEMENT (AGENT)
*
* TANPOSX (W)             (A0)
* TANPOSY (W)             2(A0)
* TANSPEED(W)             4(A0)
* TANPCOL (L)             6(A0)
* TANFCOL (L)             10(A0)
* TANTYPE (W)             14(A0)
* TANLIFE (W)             16(A0)
* BULLEFT (W)             18(A0)
* TANID   (W)             20(A0)            ; IDENTIFICADOR ÚNICO DE CADA TANQUE
* TANRTFTI(W)             22(A0)            ; TANK RTF TIME (TIEMPO RESTANTE PARA QUE PUEDA VOLVER A DISPARAR)
* INITIAL TANK X POSITION D1
* INITIAL TANK Y POSITION D2
* ENEMY TANK ID           D3
*-----------------------------------------------------------

; ----------------------------------------------------------
TANINIT
; INITIALITZE TANK
; INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            ;MOVEM.L D0/A1,-(A7)
            ;JSR     UTLRAND
            ;AND.L   #$0000000C,D0      ; MÁSCARA PARA OBTENER MÚLTIPLOS DE 4 (ALEATORIOS)
            ;LEA     .POSVEC,A1
            ;MOVE.L  (A1,D0),(A0)       ; INITIAL TANK POSITION X AND Y    
            ;MOVEM.L (A7)+,D0/A1
            ;RTS      

            MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)

            CMP.W   #TANPLAY,D0
            BNE.W   .BOT
            
            ; IF TANK IS NOT A BOT (PLAYER)
            MOVE.W  #PLYRALIV,(PLYRDEAD)           ; EL JUGADOR NO ESTÁ MUERTO
            MOVE.W  #PLRSPEED,4(A0)         
            MOVE.L  #$00344D31,6(A0)        ; COLOR DE CONTORNO DEL TANQUE   
            MOVE.L  #$00608C59,10(A0)       ; COLOR DE RELLENO DEL TANQUE
            MOVE.W  #TANPLAY,14(A0)         ; EL TANQUE ES EL JUGADOR 
            MOVE.W  #PLRINILF,16(A0)        ; VIDA INICIAL DEL TANQUE JUGADOR
            MOVE.W  #PLMAXBUL,18(A0)        ; MÁXIMAS BALAS DISPONIBLES PARA DISPARAR
            MOVE.W  #0,20(A0)               ; TANID DEL JUGADOR SERÁ 0
            RTS 
            
            ; ELSE (TANK IS A BOT)
.BOT
            MOVE.W  #ENESPEED,4(A0)
            MOVE.L  #$000B2187,6(A0)  
            MOVE.L  #$00081658,10(A0)
            MOVE.W  #TANENEM,14(A0)         ; EL TANQUE ES UN BOT
            MOVE.W  #ENEINILF,16(A0)        ; VIDA INICIAL DEL TANQUE ENEMIGO
            MOVE.W  #ENMAXBUL,18(A0)        ; MÁXIMAS BALAS DISPONIBLES PARA DISPARAR
            MOVE.W  D3,20(A0)               ; IDENTIFICADOR DEL TANQUE ENEMIGO
            MOVE.W  #0,22(A0)               ; CUANDO SEA 0 PODRÁ VOLVER A DISPARAR
            RTS
            
            ; 4 posiciones aleatorias ( modificar para que no dependa de este vector )
;.POSVEC     DC.W    SCRWIDTH/4,SCRHEIGH-100   ; 0
;            DC.W    SCRWIDTH-50,SCRHEIGH/12   ; 4
;            DC.W    SCRWIDTH-320,SCRHEIGH-30  ; 8
;            DC.W    SCRWIDTH/5,SCRHEIGH/5     ; 12 
            

; ----------------------------------------------------------            
TANUPD
; UPDATE THE TANK
; INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------

            MOVEM.W D0-D7/A1,-(A7)
            
            ; UPDATE COORDINATES
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            
            ; IF TANK IS NOT A BOT (PLAYER)
            CMP.W   #TANPLAY,14(A0)
            BNE.W   .BOT2
            
            BTST.B  #0,(KBDVAL)
            BEQ     .CHKLEFT
            SUB.W   4(A0),D0  ;RESTAMOS LA VELOCIDAD AL EJE X
.CHKLEFT    BTST.B  #2,(KBDVAL)
            BEQ     .CONT1
            ADD.W   4(A0),D0  ;SUMAMOS LA VELOCIDAD AL EJE X
.CONT1            
            BTST.B  #1,(KBDVAL)
            BEQ     .CHKDWN 
            SUB.W   4(A0),D1  ;RESTAMOS LA VELOCIDAD AL EJE Y
.CHKDWN     BTST.B  #3,(KBDVAL)
            BEQ     .DISP
            ADD.W   4(A0),D1  ;SUMAMOS LA VELOCIDAD AL EJE Y
.DISP          
            ; COMPROBAR SI ESTÁ DISPARANDO  
        
            BTST.B  #4,(KBDEDGE)            ; ESPACIO PULSADO
            BEQ     .CONT2
            
            CMP.W   #0,18(A0)
            BEQ     .CONT2                  ; NO QUEDAN BALAS DISPONIBLES 

            MOVE.B  #SNDDISP,D7             ; SONIDO DISPARO
            TRAP    #SNDPLTN  

            MOVE.W  D0,D4
            MOVE.W  D1,D5
                   
            LEA     BULINIT,A1
            LEA     BULUPD,A2
            LEA     BULPLOT,A3            
            MOVE.W  #BULTYPE,D0
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  20(A0),D3
            JSR     AGLADD
                            
            MOVE.W  D4,D0
            MOVE.W  D5,D1
            SUBQ.W  #1,18(A0)               ; UNA BALA DISPONIBLE MENOS
            BRA .CONT2
            
.BOT2       ; ELSE (TANK IS A BOT)
            ; AI ALGORITHM (greedy por ahora para testear)
            ;MOVEM.L D0-D5,-(A7)             ; MOVEM.L D0-D3/A0-A1,-(A7)
            
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  4(A0),D3                ; guardo la velocidad del tanque enemigo aunque no haría falta (por si la velocidad en un futuro la cambiamos a variable según el tanque)
            
            ; -> HACER QUE EL TANQUE A VECES HAGA UN MOVIMIENTO ALEATORIO Y A VECES SE ACERQUE AL JUGADOR.
            ; -> HACER QUE NO SE PUEDA ACERCAR AL JUGADOR A MÁS DE ? POSICIÓN
            ; -> HACER QUE DISPARE CON UNA FRECUENCIA ASIGNADA (predecible?)
            
            ;MOVEM.L D0/A1,-(A7)
            ;JSR     UTLRAND
            ;AND.L   #$0000000C,D0      ; MÁSCARA PARA OBTENER MÚLTIPLOS DE 4 (ALEATORIOS)
            ;LEA     .POSVEC,A1
            ;MOVE.L  (A1,D0),(A0)       ; RANDOM MOVEMENT    
            ;MOVEM.L (A7)+,D0/A1
            ;RTS
            
            MOVE.L  A0,A1
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            
            CMP.W   8(A0),D1
            BHI     .NEGVELX                ; XENEM > XPLAY
            BLO     .POSVELX                ; XENEM < XPLAY
            BRA     .VELY                   ; XENEM = XPLAY
            
.NEGVELX    SUB.W   D3,D1
            BRA     .VELY
.POSVELX    ADD.W   D3,D1

.VELY       CMP.W   10(A0),D2
            BHI     .NEGVELY                ; YENEM > YPLAY
            BLO     .POSVELY                ; YENEM < YPLAY
            BRA     .ENDALG                 ; YENEM = YPLAY

.NEGVELY    SUB.W   D3,D2
            BRA     .ENDALG
.POSVELY    ADD.W   D3,D2           
       
.ENDALG     MOVE.L  A1,A0

            MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)
            
            MOVE.W  D1,D0
            MOVE.W  D2,D1
            
            ; DISPARO
            MOVE.W  D0,D4
            MOVE.W  D1,D5
            
            CMP.W   #0,22(A0)               
            BHI     .SUBRTF                 ; ENEMIGO AÚN NO TIENE DISPONIBLE DISPARAR     

            CMP.W   #0,18(A0)
            BEQ     .SUBRTF                 ; NO QUEDAN BALAS DISPONIBLES           

            MOVE.W  #ENEMYRTF,22(A0)        ; REINICIAR CONTADOR

            MOVE.B  #SNDDISP,D7             ; SONIDO DISPARO
            TRAP    #SNDPLTN  

            LEA     BULINIT,A1
            LEA     BULUPD,A2
            LEA     BULPLOT,A3            
            MOVE.W  #BULTYPE,D0
            MOVE.W  (A0),D1                 ;MOVE.W  D3,D1
            MOVE.W  2(A0),D2                ;MOVE.W  D4,D2
            MOVE.W  20(A0),D3
            JSR     AGLADD

            SUBQ.W  #1,18(A0)               ; UNA BALA DISPONIBLE MENOS
            
            MOVE.W  D4,D0
            MOVE.W  D5,D1
            

.SUBRTF
            CMP.W   #0,22(A0)               ; PARA QUE NO PONGA NÚMEROS NEGATIVOS (puede que estas líneas no hagan falta)
            BEQ     .CONT2
            SUBQ.W  #1,22(A0)               ; RESTARLE 1 AL RTF DEL TANQUE

            ; COMPROBACIÓN DE LA COLISIÓN DE LOS TANQUES CON OTROS TANQUES

.CONT2 
            ;INICIALIZAMOS
            LEA.L   MAPDATA,A1
            MOVE.W  (LVLNUM),D6
            MULU.W  #SIZLVL,D6
            ADD.L   D6,A1
            ;SUBQ.L  #2,A1

            JSR     RELPOS
            
            ;CMP.L   #$00,(A1)
            ;BNE     .NOCOL
            
            ;DERECHA : 1 
            ;IZQUIERDA : 2
            ;ABAJO : 3
            ;ARRIBA : 5
            CLR.L   D6
            
            ; CHECK HORIZONTAL COLLISIONS
            CMP.W   #PIESIZX-TANWIDTH/2,D4
            BGT     .COLRGT
            CMP.W   #TANWIDTH/2,D4            
            BLT     .COLLFT                 
            
            ; CHECK VERTICAL COLLISIONS
.CHKVERT    CMP.W   #PIESIZY-TANHEIGH/2,D5
            BGT     .COLBOT            
            CMP.W   #TANHEIGH/2,D5
            BLT     .COLTOP                
            BRA     .DONE   
            
            ; RIGHT SIDE COLLISION    
.COLRGT     
            ADDQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FARSC
            MOVE.W  #PIESIZX-TANWIDTH/2,D0
            ADD.W   D2,D0
            SUBQ.L  #2,A1
            BRA     .CHKVERT
.FARSC
            ADDQ.W  #1,D6
            SUBQ.L  #2,A1
            BRA     .CHKVERT

            ; LEFT SIDE COLLISION
.COLLFT     
            SUBQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FALSC
            MOVE.W  #TANWIDTH/2,D0
            ADD.W   D2,D0 
            ADDQ.L  #2,A1
            BRA     .CHKVERT                  
.FALSC
            ADDQ.W  #2,D6
            ADDQ.L  #2,A1
            BRA     .CHKVERT  

            ; BOTTOM COLLISION
.COLBOT     
            ADD.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .FABSC
            MOVE.W  #PIESIZY-TANHEIGH/2,D1
            ADD.W   D3,D1
            SUB.L   #40,A1            
            BRA     .DONE
.FABSC
            CMP.W   #1,D6
            BNE     .IB
            ADDQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FDB
            MOVE.W  #PIESIZY-TANHEIGH/2,D1
            ADD.W   D3,D1
            MOVE.W  #PIESIZX-TANWIDTH/2,D0
            ADD.W   D2,D0
            BTST.B  #0,(KBDVAL)
            BEQ     .NOADVR
            ADD.W   4(A0),D0
.NOADVR            
            BTST.B  #1,(KBDVAL)
            BEQ     .FDB 
            ADD.W   4(A0),D1
.FDB            
            SUBQ.L  #2,A1
            BRA     .NNB         
.IB            
            CMP.W   #2,D6
            BNE     .NNB
            SUBQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FIB
            MOVE.W  #PIESIZY-TANHEIGH/2,D1
            ADD.W   D3,D1
            MOVE.W  #TANWIDTH/2,D0
            ADD.W   D2,D0
            
            BTST.B  #2,(KBDVAL)
            BEQ     .NOADVL
            SUB.W   4(A0),D0
.NOADVL            
            BTST.B  #1,(KBDVAL)
            BEQ     .FIB 
            ADD.W   4(A0),D1        
.FIB            
            ADDQ.L  #2,A1         
.NNB            
            SUB.L  #40,A1            
            BRA     .DONE

            ; TOP COLLISION
.COLTOP     
            SUB.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .FATSC
            MOVE.W  #TANHEIGH/2,D1
            ADD.W   D3,D1 
            BRA     .DONE        
.FATSC       
            CMP.W   #1,D6
            BNE     .IA
            ADDQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FDA
            MOVE.W  #TANHEIGH/2,D1
            ADD.W   D3,D1
            MOVE.W  #PIESIZX-TANWIDTH/2,D0
            ADD.W   D2,D0
            BTST.B  #0,(KBDVAL)
            BEQ     .NOADVRA
            ADD.W   4(A0),D0
.NOADVRA            
            BTST.B  #3,(KBDVAL)
            BEQ     .FDA 
            ADD.W   4(A0),D1
.FDA           
            SUBQ.L  #2,A1
            BRA     .NNA         
.IA            
            CMP.W   #2,D6
            BNE     .NNA
            SUBQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FIA
            MOVE.W  #TANHEIGH/2,D1
            ADD.W   D3,D1
            MOVE.W  #TANWIDTH/2,D0
            ADD.W   D2,D0
            
            BTST.B  #2,(KBDVAL)
            BEQ     .NOADVLA
            SUB.W   4(A0),D0
.NOADVLA            
            BTST.B  #3,(KBDVAL)
            BEQ     .FIA 
            ADD.W   4(A0),D1        
.FIA            
            ADDQ.L  #2,A1         
.NNA            
            SUB.L  #40,A1            
            BRA     .DONE
           
            ; STORE POSITION
.DONE       MOVE.W  D0,(A0)
            MOVE.W  D1,2(A0)
            
            MOVEM.W (A7)+,D0-D7/A1
            RTS
                      
TANPLOT
; PLOT THE TANK
; INPUT     : A0 POINTER TO THE INSTANCE VARIABLES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)

            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  6(A0),D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  10(A0),D1
            TRAP    #15
            
            ; DEFINE COORDINATES
            MOVE.W  (A0),D1
            SUB.W   #TANWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #TANWIDTH,D3
            
            MOVE.W  2(A0),D2
            SUB.W   #TANHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #TANHEIGH,D4
            
            ; DRAW RECTANGLE (TANK)
            MOVE.B  #87,D0
            TRAP    #15
        
            ; PLOT LIFE
            ; IF TANK IS NOT A BOT (PLAYER)
            CMP.W   #TANPLAY,14(A0)
            BNE.W   .END

            UTLSPEN #$00FFFFFF 
            UTLSFIL #PLRLIFEC
            MOVE.W  #(SCRWIDTH-PLRINILF)/2,D1
            MOVE.W  #PLRLIFEY,D2
            MOVE.W  16(A0),D3
            ADD.W   D1,D3
            MOVE.W  #PLRLIFEY+PLRLIFEH,D4
            MOVE.B  #87,D0
            TRAP    #15
            MOVE.W  #(SCRWIDTH+PLRINILF)/2,D3
            MOVE.B  #90,D0
            TRAP    #15
.END            
            MOVEM.L (A7)+,D0-D4
            
            RTS    




































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
