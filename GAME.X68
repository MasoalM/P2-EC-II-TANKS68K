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
            
            ;MOVE.B  #17,D1                    ; ACTIVAR DOUBLE BUFFER
            ;MOVE.B  #92,D0
            ;TRAP    #15
            
            JSR     DMMINIT
            ;JSR     FPSINIT
            JSR     SCOINIT 
            JSR     LVL1INIT
            
            MOVE.W  #1,(DOPLOT)
            MOVE.W  #0,(LVLNUM)

            RTS           
            
            ; Seguir inicializando tanques bot (tipo 3)

; ----------------------------------------------------------
GAMUPD
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            JSR     AGLUPD
            ;JSR     MOUUPD
            ;JSR     FPSUPD
            
            ; RECORDAR QUE EL NIVEL ES CONCEPTUALMENTE UN NÚMERO MAYOR QUE EN EL CÓDIGO (EL CÓDIGO DEL NIVEL 1 ES 0, DEL NIVEL 2 ES 1, ...)
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
            CMP.W   #KILLPLYR,(PLYRDEAD)    ; SI EL JUGADOR TIENE 0 DE VIDA
            BLT     .DONE
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
            MOVEM.L  D0/A0,-(A7)
            LEA     .TXT,A0                ; TEXTO DEMO
            MOVE.B  #10,D0
            JSR     UTLPRINT
            MOVEM.L  (A7)+,D0/A0
.NODEMO        
            BRA     SCOPLOT

.TXT        DC.B    'PANTALLA DE DEMOSTRACIÓN',0
            DS.W    0





















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
