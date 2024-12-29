*-----------------------------------------------------------
* CLASE TANQUE (AGENTE)
*
* TANPOSX (W)             (A0)
* TANPOSY (W)             2(A0)
* TANSPEED(W)             4(A0)
* TANTYPE (W)             6(A0)
* TANLIFE (W)             8(A0)
* BULLEFT (W)             10(A0)
* TANID   (W)             12(A0)            ; IDENTIFICADOR ÚNICO DE CADA TANQUE
* TANRTFTI(W)             14(A0)            ; TANK RTF TIME (TIEMPO RESTANTE PARA QUE PUEDA VOLVER A DISPARAR)
* ENEDIR  (W)             16(A0)            ; DIRECCIÓN ALEATORIA TEMPORAL ASIGNADA A UN TANQUE ENEMIGO O BOT
* POSAPUN (W)             18(A0)            ; POSICIÓN DE APUNTADO DEL ENEMIGO
* INITIAL TANK X POSITION D1
* INITIAL TANK Y POSITION D2
*-----------------------------------------------------------

; ----------------------------------------------------------
TANINIT
; INICIALIZA EL TANQUE
; INPUT     : A0 PUNTERO A LA PILA DE AGENTES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)

            CMP.W   #TANPLAY,D0
            BNE.W   .BOT
            
            MOVE.W  D1,(PLAYPOSX)
            MOVE.W  D2,(PLAYPOSY)
            
            ; SI EL TANQUE ES DEL JUGADOR
            MOVE.W  #PLYRALIV,(PLYRDEAD)    ; EL JUGADOR NO ESTÁ MUERTO
            MOVE.W  #PLRSPEED,4(A0)         
            MOVE.W  #TANPLAY,6(A0)          ; EL TANQUE ES EL JUGADOR 
            MOVE.W  #PLRINILF,8(A0)         ; VIDA INICIAL DEL TANQUE JUGADOR
            MOVE.W  #PLMAXBUL,10(A0)        ; MÁXIMAS BALAS DISPONIBLES PARA DISPARAR
            MOVE.W  #0,12(A0)               ; TANID DEL JUGADOR SERÁ 0
            CMP.W   #1,(DEMO)
            BNE     .NOTDEMO
            MOVE.W  #ENEMYRTF,14(A0)        ; CUANDO SEA 0 PODRÁ VOLVER A DISPARAR
.NOTDEMO            
            RTS 
            
            ; ELSE, SI ES UN BOT
.BOT
            MOVE.W  #ENESPEED,4(A0)
            MOVE.W  #TANENEM,6(A0)         ; EL TANQUE ES UN BOT
            MOVE.W  #ENEINILF,8(A0)        ; VIDA INICIAL DEL TANQUE ENEMIGO
            MOVE.W  D3,12(A0)              ; IDENTIFICADOR DEL TANQUE ENEMIGO
            MOVE.W  #ENEMYRTF,14(A0)       ; CUANDO SEA 0 PODRÁ VOLVER A DISPARAR
            RTS

; ----------------------------------------------------------            
TANUPD
; ACTUALIZA EL TANQUE
; INPUT     : A0 PUNTERO A LA PILA DE AGENTES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D7/A1,-(A7)
            
            ; ACTUALIZAMOS LAS COORDENADAS
            MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            
            ; SI EL TANQUE NO ES UN BOT
            CMP.W   #TANPLAY,6(A0)
            BNE.W   .BOT2
            
            ; SI NO ES LA DEMO
            CMP.W   #1,(DEMO)
            BEQ     .BOT2            

            ; COMPROBAMOS EL RATÓN
            JSR     MOUUPD
            MOVE.W  #0,D7
            JSR     APUNTADOR
            
            ; PONEMOS ESTOS VALORES A VARIABLES AUXILIARES
            MOVE.W  #0,(MOVXTEMP)
            MOVE.W  #0,(MOVYTEMP)
            BTST.B  #0,(KBDVAL)
            
            ;REALIZAMOS EL MOVIMIENTO
            BEQ     .CHKLEFT
            SUB.W   4(A0),D0  ;RESTAMOS LA VELOCIDAD AL EJE X
            ADDQ.W  #1,(PLCANPOS)
            MOVE.W  #-1,(MOVXTEMP)
.CHKLEFT    BTST.B  #2,(KBDVAL)
            BEQ     .CONT1
            ADD.W   4(A0),D0  ;SUMAMOS LA VELOCIDAD AL EJE X
            ADDQ.W  #1,(PLCANPOS)
            MOVE.W  #1,(MOVXTEMP)
.CONT1            
            BTST.B  #1,(KBDVAL)
            BEQ     .CHKDWN 
            SUB.W   4(A0),D1  ;RESTAMOS LA VELOCIDAD AL EJE Y
            MOVE.W  #-1,(MOVYTEMP)
.CHKDWN     BTST.B  #3,(KBDVAL)
            BEQ     .DISP
            ADD.W   4(A0),D1  ;SUMAMOS LA VELOCIDAD AL EJE Y
            MOVE.W  #1,(MOVYTEMP)
.DISP          

            ; COMPROBAR SI ESTÁ DISPARANDO              
            MOVE.B  (MOUEDGE),D2   
            CMP.B   #1,D2
            BNE     .CONT2
            
            ;COMPROBAMOS SI QUEDAN BALAS            
            CMP.W   #0,10(A0)
            BEQ     .CONT2                   

            MOVE.B  #SNDDISP,D7             ; SONIDO DISPARO
            TRAP    #SNDPLTN  

            ; AJUSTAMOS LOS REGISTROS
            MOVE.W  D0,D4
            MOVE.W  D1,D5
                   
            ; CREAMOS LA BALA
            LEA     BULINIT,A1
            LEA     BULUPD,A2
            LEA     BULPLOT,A3            
            MOVE.W  #BULTYPE,D0
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  12(A0),D3
            JSR     AGLADD
                         
            ; REAJUSTAMOS LOS REGISTROS   
            MOVE.W  D4,D0
            MOVE.W  D5,D1
            SUBQ.W  #1,10(A0)               ; UNA BALA DISPONIBLE MENOS
            BRA     .CONT2

.BOT2       ; ELSE, SI ES UN BOT
            MOVE.W  #0,(MOVXTEMP)
            MOVE.W  #0,(MOVYTEMP)
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  4(A0),D3                
            
            ;MIRAMOS SI ESTÁ EN LA DEMO
            CMP.W   #1,(DEMO)
            BEQ     .DEMOPLAY
            
            ;COMPROBAMOS SI SEGUIRÁ AL JUGADOR, O SI SE MOVERÁ AL AZAR)
            CMP.W   #60,14(A0)                     
            BHI     .FLLOWPLR     
.DEMOPLAY            
            ; EN CASO DE NO SEGUIR AL JUGADOR, HACEMOS UN MOVIMIENTO RANDOM

            CMP.W   #0,14(A0)
            BHI     .DIRASIGN
            MOVEM.L D0/A1,-(A7)
            JSR     UTLRAND
            AND.L   #$00000006,D0      ; MÁSCARA PARA OBTENER MÚLTIPLOS DE 2 
            LEA     .MOVVEC,A1         ; (ALEATORIOS)
            MOVE.L  (A1,D0),16(A0)     ; RANDOM MOVEMENT   
            MOVEM.L (A7)+,D0/A1
            
            ; COMPROBAMOS DONDE DEBEMOS IR
.DIRASIGN           
            CMP.B   #0,16(A0)
            BEQ     .CASOCERO
            CMP.B   #1,16(A0)
            BEQ     .CASOUNO
            CMP.B   #2,16(A0)
            BEQ     .CASODOS
            
            ; CASO TRES
            MOVE.W  #-1,(MOVXTEMP)
            MOVE.W  #-1,(MOVYTEMP)
            SUB.W   D3,D2
            BRA     .ENDALG2
            
            ; CASO CERO
.CASOCERO   ADD.W   D3,D1
            ADDQ.W  #1,(PLCANPOS)
            MOVE.W  #1,(MOVXTEMP)
            MOVE.W  #1,(MOVYTEMP)
            BRA     .ENDALG2
         
            ; CASO UNO
.CASOUNO    SUB.W   D3,D1
            ADDQ.W  #1,(PLCANPOS)
            MOVE.W  #1,(MOVXTEMP)
            MOVE.W  #-1,(MOVYTEMP)
            BRA     .ENDALG2       
  
            ; CASO DOS
.CASODOS    ADD.W   D3,D2   
            MOVE.W  #-1,(MOVXTEMP)
            MOVE.W  #1,(MOVYTEMP) 
            BRA     .ENDALG2
            
            ; ALGORITMO QUE PERMITE AL TANQUE SEGUIR AL JUGADOR   
.FLLOWPLR               
            MOVE.L  A0,A1
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
         
            CMP.W   8(A0),D1
            BHI     .NEGVELX                ; XENEM > XPLAY
            BLO     .POSVELX                ; XENEM < XPLAY
            BRA     .VELY                   ; XENEM = XPLAY
            
.NEGVELX    SUB.W   D3,D1
            MOVE.W  #-1,(MOVXTEMP)
            BRA     .VELY
.POSVELX    ADD.W   D3,D1
            MOVE.W  #1,(MOVXTEMP)

.VELY       CMP.W   10(A0),D2
            BHI     .NEGVELY                ; YENEM > YPLAY
            BLO     .POSVELY                ; YENEM < YPLAY                  
            BRA     .ENDALG                 ; YENEM = YPLAY

.NEGVELY    SUB.W   D3,D2
            MOVE.W  #-1,(MOVYTEMP)
            BRA     .ENDALG
.POSVELY    ADD.W   D3,D2   
            MOVE.W  #1,(MOVYTEMP)         

.ENDALG     MOVE.L  A1,A0       
.ENDALG2
            MOVE.W  D1,D0
            MOVE.W  D2,D1
            
            ; DISPARO
            MOVE.W  D0,D4
            MOVE.W  D1,D5
            
            CMP.W   #0,14(A0)               
            BHI     .SUBRTF                 ; ENEMIGO AÚN NO TIENE DISPONIBLE DISPARAR  
            MOVE.W  #ENEMYRTF,14(A0)        ; REINICIAR CONTADOR   
            
            CMP.W   #2,6(A0)
            BNE     .ENEDISP                ; SALTAR SI ES EL ENEMIGO (EL JUGADOR PUEDE ESTAR AQUÍ SI ES LA DEMO)

            MOVE.W  #1,D7
            JSR     APUNTADOR
            
            BRA     .ENEDISP2

.ENEDISP
            MOVE.W  #2,D7
            JSR     APUNTADOR  
            MOVE.W  (ENCANPOS),18(A0)  
.ENEDISP2
            MOVE.B  #SNDDISP,D7             ; SONIDO DISPARO
            TRAP    #SNDPLTN  

            ; CREAMOS LA BALA
            LEA     BULINIT,A1
            LEA     BULUPD,A2
            LEA     BULPLOT,A3            
            MOVE.W  #BULTYPE,D0
            MOVE.W  (A0),D1                 
            MOVE.W  2(A0),D2                
            MOVE.W  12(A0),D3
            JSR     AGLADD
            
            MOVE.W  D4,D0
            MOVE.W  D5,D1
.SUBRTF            
            SUBQ.W  #1,14(A0)               ; RESTARLE 1 AL RTF DEL TANQUE  
.CONT2 
            ; COMPROBAMOS SI HAY COLISIONES ENTRE TANQUES
            JSR     TANKCOL
            CMP.W   #1,A3
            BLS     .SEG                    ; SALTA SI NO HAY COLISIÓN
            CMP.W   #1,(COLTANKP)
            BNE     .SEG                 ; SI NO SE HAN CHOCADO CON EL JUGADOR,
                                         ; SEGUIMOS CON EL TRATAMIENTO NORMAL
            CMP.W   #TANPLAY,6(A0)       
            BEQ     .SEG
            
            JSR     AGLKILL
            MOVE.B  #SNDEXPLO,D7             ; SONIDO EXPLOSIÓN
            TRAP    #SNDPLTN  
            ADDQ.W  #1,(SCORE)
            JSR     COLBYKMK
            BRA     .FINISH
            
            ; COMENZAMOS CON LAS COLISIONES DE LOS TANQUES CON LAS PAREDES
.SEG        
            ;INICIALIZAMOS
            LEA.L   MAPDATA,A1
            MOVE.W  (LVLNUM),D6
            MULU.W  #SIZLVL,D6
            ADD.L   D6,A1

            ; SACAMOS LA POSICIÓN RELATIVA
            JSR     RELPOS
            
            ;DERECHA : 1 
            ;IZQUIERDA : 2
            ;ABAJO : 3
            ;ARRIBA : 5
            CLR.L   D6
            
            ; COMPROBAMOS LAS COLISIONES HORIZONTALES
            CMP.W   #PIESIZX-TANWIDTH/2,D4
            BGT     .COLRGT
            CMP.W   #TANWIDTH/2,D4            
            BLT     .COLLFT                 
            
            ; COMPROBAMOS LAS COLISIONES VERTICALES
.CHKVERT    CMP.W   #PIESIZY-TANHEIGH/2,D5
            BGT     .COLBOT            
            CMP.W   #TANHEIGH/2,D5
            BLT     .COLTOP                
            BRA     .DONE   
            
            ; COLISIÓN POR LA DERECHA    
.COLRGT     
            ADDQ.L  #2,A1                   ; COMPROBAMOS SI TOCA LA PARED DE 
            CMP.W   #$01,(A1)               ; LA DERECHA
            BNE     .FARSC
            MOVE.W  #PIESIZX-TANWIDTH/2,D0  ; TRATAMIENTO DE COLISIÓN
            ADD.W   D2,D0
            SUBQ.L  #2,A1
            BRA     .CHKVERT
.FARSC      ; PREPARAMOS PARA LA SIGUIENTE PRUEBA
            ADDQ.W  #1,D6
            SUBQ.L  #2,A1
            BRA     .CHKVERT

            ; COLISIÓN POR LA IZQUIERDA
.COLLFT     
            SUBQ.L  #2,A1                   ; COMPROBAMOS SI TOCA LA PARED DE
            CMP.W   #$01,(A1)               ; LA IZQUIERDA
            BNE     .FALSC
            MOVE.W  #TANWIDTH/2,D0          ; TRATAMIENTO DE COLISIÓN
            ADD.W   D2,D0 
            ADDQ.L  #2,A1
            BRA     .CHKVERT                  
.FALSC      ; PREPARAMOS PARA LA SIGUIENTE PRUEBA

            ADDQ.W  #2,D6
            ADDQ.L  #2,A1
            BRA     .CHKVERT  

.COLBOT     ; COLISIÓN POR ABAJO     
            ADD.L   #40,A1                  ; COMPROBAMOS SI TOCA LA PARED DE
            CMP.W   #$01,(A1)               ; LA IZQUIERDA
            BNE     .FABSC
            MOVE.W  #PIESIZY-TANHEIGH/2,D1  ; TRATAMIENTO NORMAL DE LA COLISIÓN
            ADD.W   D3,D1
            SUB.L   #40,A1            
            BRA     .DONE
            
.FABSC      ; SI PODÍA HABER COLISIÓN, Y NO HA HABIDO
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

.COLTOP     ; COLISIÓN POR ARRIBA
            SUB.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .FATSC
            MOVE.W  #TANHEIGH/2,D1
            ADD.W   D3,D1 
            BRA     .DONE        
.FATSC      ; SI PODÍA HABER COLISIÓN, Y NO HA HABIDO
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
           
            ; GUARDAMOS LA POSICIÓN
.DONE       MOVE.W  D0,(A0)
            MOVE.W  D1,2(A0)
            
            CMP.W   #2,6(A0)
            BNE     .ENEMPOS
            MOVE.W  D0,(PLAYPOSX)
            MOVE.W  D1,(PLAYPOSY)
            BRA     .FINISH
.ENEMPOS    
            MOVE.W  D0,(ENEMPOSX)
            MOVE.W  D1,(ENEMPOSY)
.FINISH   
            MOVEM.L (A7)+,D0-D7/A1
            RTS
            
            ; 4 posibilidades aleatorias
.MOVVEC     DC.B    0  ; 0
            DC.B    1  ; 2
            DC.B    2  ; 4
            DC.B    3  ; 6         
          
; ----------------------------------------------------------            
TANPLOT
; PINTA EL TANQUE
; INPUT     : A0 PUNTERO A LA PILA DE AGENTES
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D6/A1,-(A7)
            
            ; MIRAMOS SI DIBUJAR AL JUGADOR O AL ENEMIGO
            CMP.W   #2,6(A0)
            BEQ     .DRAWPLAY
            MOVE.W  18(A0),(ENCANPOS)
            JSR     ENIMASEL
            BRA     .DRAW
.DRAWPLAY   
            JSR     PLIMASEL
.DRAW       ; INICIAMOS EL BUCLE DE DIBUJADO                 
            MOVE.W  2(A0),D2
            SUB.W   #TANHEIGH/2,D2
            MOVE.W  D2,D4
            SUBQ.W  #1,D2
.FILA
            MOVE.W  (A0),D1
            SUB.W   #TANWIDTH/2,D1
            MOVE.W  D1,D3
            
            ADDQ.W  #1,D2
            ADDQ.W  #1,D4
.COLUMNA
            MOVE.L  D1,D5
            MOVE.L  (A1)+,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  D5,D1

            ADDQ.W  #1,D1
            ADDQ.W  #1,D3

            MOVE.B  #84,D0
            TRAP    #15
            
            ; MIRAMOS SI HEMOS COMPLETADO LA COLUMNA
            MOVE.W  (A0),D6
            ADD.W   #TANWIDTH/2,D6
            CMP.W   D6,D3
            BLT     .COLUMNA
            
            ; MIRAMOS SI HEMOS COMPLETADO LA FILA
            MOVE.W  2(A0),D6
            ADD.W   #TANHEIGH/2,D6
            CMP.W   D6,D4
            BLT     .FILA
        
            ; DIBUJAMOS LA VIDA SI EL TANQUE ES EL JUGADOR
            CMP.W   #TANPLAY,6(A0)
            BNE.W   .END
            
            CMP.W   #BULDMG*3,8(A0)
            BHI     .PLOTLIFE
            BTST.B  #4,(SCRCYCCT) ; PARPADEO VIDA EN CASO DE QUE QUEDEN TRES 
            BEQ     .END          ; GOLPES O MENOS
.PLOTLIFE
            UTLSPEN #$00FFFFFF 
            UTLSFIL #PLRLIFEC
            MOVE.W  #(SCRWIDTH-PLRINILF)/2,D1
            MOVE.W  #PLRLIFEY,D2
            MOVE.W  8(A0),D3
            ADD.W   D1,D3
            MOVE.W  #PLRLIFEY+PLRLIFEH,D4
            MOVE.B  #87,D0
            TRAP    #15
            MOVE.W  #(SCRWIDTH+PLRINILF)/2,D3
            MOVE.B  #90,D0
            TRAP    #15
.END            
            MOVEM.L (A7)+,D0-D6/A1
            
            RTS    





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
