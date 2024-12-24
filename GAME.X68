*-----------------------------------------------------------
* GAME MANAGEMENT
*-----------------------------------------------------------

; ----------------------------------------------------------
GAMINIT
; INITIALIZES GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            JSR     DMMINIT
            JSR     SCOINIT 
            JSR     LVL1INIT
            
            MOVE.W  #1,(DOPLOT)
            MOVE.W  #0,(LVLNUM)

            RTS           

; ----------------------------------------------------------
GAMUPD
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            JSR     AGLUPD
            
            ; RECORDAR QUE EL NIVEL ES CONCEPTUALMENTE UN NÚMERO MAYOR QUE SU PROPIO CÓDIGO (EL CÓDIGO DEL NIVEL 1 ES 0, DEL NIVEL 2 ES 1, ...)
            ; ESTO ES DEBIDO A QUE MULTIPLICAMOS EL NIVEL POR LO QUE OCUPA CADA MAPA (EL MAPA DEL NIVEL 1 TIENE QUE ESTAR EN LA POSICIÓN 0)
            
            CMP.W   #2,(LVLNUM) ; COMPROBAR SI YA ESTAMOS EN EL NIVEL 3
            BGE     .CHKWIN     
            CMP.W   #1,(LVLNUM) ; COMPROBAR SI YA ESTAMOS EN EL NIVEL 2
            BNE     .LVL1

            CMP.W   #ENEMLVL2,(SCORE)   ; ESTAMOS EN EL NIVEL 2, COMPROBAR SI LO HEMOS ACABADO
            BLT     .CHKLOSS
            ADDQ.W  #1,(LVLNUM)
            JSR     LVL3INIT
            BRA     .DONE
.LVL1       
            CMP.W   #1,(DEMO)
            BNE     .CONTLVL1
            ; SI ESTAMOS EN LA DEMO, COMPROBAR SI HAN PULSADO AL ESPACIO PARA VOLVER AL MENÚ
            BTST.B  #4,(KBDEDGE)
            BNE     .DEMOEND
.CONTLVL1     
            CMP.W   #ENEMLVL1,(SCORE)   ; ESTAMOS EN EL NIVEL 1, COMPROBAR SI LO HEMOS ACABADO
            BLT     .CHKLOSS
            CMP.W   #1,(DEMO)
            BEQ     .DEMOEND
            ADDQ.W  #1,(LVLNUM)
            JSR     LVL2INIT
            RTS
.DEMOEND                                ; EN LA DEMO SOLO SE MUESTRA EL PRIMER NIVEL
            MOVE.W  #0,(DEMO)
            MOVE.W  #0,(STANEXT)
            RTS         
.CHKWIN            
            CMP.W   #ENEMLVL3,(SCORE)
            BLT     .CHKLOSS
            MOVE.W  #3,(STANEXT)
            RTS
.CHKLOSS    
            CMP.W   #KILLPLYR,(PLYRDEAD)    
            BNE     .DONE
            CMP.W   #1,(DEMO)
            BEQ     .DEMOEND
            
            ; SI EL JUGADOR TIENE 0 DE VIDA Y NO ES UNA DEMO, IR A LA PANTALLA DE DERROTA
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

            JSR     MAPPLOT
            JSR     AGLPLOT
             
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
