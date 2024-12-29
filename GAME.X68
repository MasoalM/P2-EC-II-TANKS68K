*-----------------------------------------------------------
* GAME MANAGEMENT
*-----------------------------------------------------------

; ----------------------------------------------------------
GAMINIT
; INICIAMOS EL JUEGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            ;INICIALIZAMOS LA MEMORIA DINÁMICA, LA PUNTUACIÓN, Y EL NIEVL 1
            JSR     DMMINIT
            JSR     SCOINIT 
            JSR     LVL1INIT
            
            ; SETEAMOS LOS VALORES DEL NIVEL Y DEL PLOT
            MOVE.W  #1,(DOPLOT)
            MOVE.W  #0,(LVLNUM)

            RTS           

; ----------------------------------------------------------
GAMUPD
; ACTUALIZAMOS EL JUEGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            ; ACTUALIZAMOS LOS AGENTES
            JSR     AGLUPD
            
            ; COMPROBAMOS EN QUÉ NIVEL NOS ENCONTRAMOS
            ; (RECORDAR QUÉ, CADA NIVEL ES REPRESENTADO POR SU NÚMERO-1; EJ: 
            ; NIVEL4 TIENE EL NÚMERO 3)
            CMP.W   #4,(LVLNUM) ; COMPROBAR SI YA ESTAMOS EN EL NIVEL 5
            BGE     .CHKWIN
            CMP.W   #3,(LVLNUM) ; COMPROBAR SI YA ESTAMOS EN EL NIVEL 4
            BEQ     .LVL4
            CMP.W   #2,(LVLNUM) ; COMPROBAR SI YA ESTAMOS EN EL NIVEL 3
            BEQ     .LVL3 
            CMP.W   #1,(LVLNUM) ; COMPROBAR SI YA ESTAMOS EN EL NIVEL 2
            BNE     .LVL1

            CMP.W   #ENEMLVL2,(SCORE)   ; ESTAMOS EN EL NIVEL 2, COMPROBAR 
            BLT     .CHKLOSS            ; SI LO HEMOS ACABADO
            ADDQ.W  #1,(LVLNUM)
            JSR     KILLBULS
            JSR     LVL3INIT
            BRA     .DONE
.LVL4
            CMP.W   #ENEMLVL4,(SCORE)   ; ESTAMOS EN EL NIVEL 4, COMPROBAMOS 
            BLT     .CHKLOSS            ; SI LO HEMOS ACABADO
            ADDQ.W  #1,(LVLNUM)
            JSR     KILLBULS
            JSR     LVL5INIT
            BRA     .DONE
.LVL3       
            CMP.W   #ENEMLVL3,(SCORE)   ; ESTAMOS EN EL NIVEL 3, COMPROBAMOS 
            BLT     .CHKLOSS            ; SI LO HEMOS ACABADO
            ADDQ.W  #1,(LVLNUM)
            JSR     KILLBULS
            JSR     LVL4INIT
            BRA     .DONE  
.LVL1       
            CMP.W   #1,(DEMO)           ; ESTAMOS EN EL NIVEL 1 DE LA DEMO
            BNE     .CONTLVL1           ; COMPROBAMOS SI LO HEMOS ACABADO
            ; SI ESTAMOS EN LA DEMO, COMPROBAR SI HAN PULSADO AL ESPACIO
            ;PARA VOLVER AL MENÚ 
            BTST.B  #4,(KBDEDGE)                       
            BNE     .DEMOEND
.CONTLVL1     
            CMP.W   #ENEMLVL1,(SCORE)   ; ESTAMOS EN EL NIVEL 1, COMPROBAR 
            BLT     .CHKLOSS            ; SI LO HEMOS ACABADO
            CMP.W   #1,(DEMO)
            BEQ     .DEMOEND
            ADDQ.W  #1,(LVLNUM)
            JSR     KILLBULS
            JSR     LVL2INIT
            RTS
.DEMOEND                                ; EN LA DEMO SOLO SE MUESTRA EL PRIMER 
            MOVE.W  #0,(DEMO)           ; NIVEL
            MOVE.W  #0,(STANEXT)
            RTS         
.CHKWIN                                 ; COMPROBAMOS SI EL JUGADOR HA 
            CMP.W   #ENEMLVL5,(SCORE)   ; COMPLETADO EL JUEGO
            BLT     .CHKLOSS
            JSR     KILLBULS
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            JSR     AGLKILL
            MOVE.W  #3,(STANEXT)
            RTS
.CHKLOSS                                ; COMPROBAMOS SI EL JUGADOR HA PERDIDO
            CMP.W   #KILLPLYR,(PLYRDEAD)    
            BNE     .DONE
            JSR     KILLBULS
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            JSR     AGLKILL
            CMP.W   #1,(DEMO)
            BEQ     .DEMOEND
            
            ; SI EL JUGADOR TIENE 0 DE VIDA Y NO ES UNA DEMO, IR A LA PANTALLA 
            ; DE DERROTA
            MOVE.W  #4,(STANEXT)
.DONE
            RTS      
      
; ----------------------------------------------------------
GAMPLOT
; PLOTS THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            ; MOSTRAMOS EL MAPA
            JSR     MAPPLOT
            ; MOSTRAMOS A LOS AGENTES
            JSR     AGLPLOT
            
            ; COMPROBAMOS SI ESTAMOS EN LA DEMO
            CMP.W   #1,(DEMO)
            BNE     .NODEMO
            
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            LEA     .TXT1,A0                ; TEXTO DEMO
            MOVE.B  #15,D0
            JSR     UTLPRINT
            LEA     .TXT2,A0                
            MOVE.B  #16,D0
            JSR     UTLPRINT
            LEA     .TXT3,A0                
            MOVE.B  #25,D0
            JSR     UTLPRINT
.NODEMO        
            BRA     SCOPLOT

.TXT1       DC.B    'PANTALLA',0
.TXT2       DC.B    'DE DEMOSTRACIÓN',0
.TXT3       DC.B    'PULSA LA BARRA ESPACIADORA PARA VOLVER AL MENÚ PRINCIPAL',0
            DS.W    0



























*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
