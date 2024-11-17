*-----------------------------------------------------------
* TANK MANAGEMENT
*
* TANPOSX ? (W) (A0)
* TANPOSY ? (W) 2(A0)
* TANSPEED(W)   4(A0)
* TANPCOL (L)   6(A0)
* TANFCOL (L)   10(A0)
* TANISBOT(W)   14(A0)
*-----------------------------------------------------------

; ----------------------------------------------------------
TANINIT
; INITIALITZE TANK
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            ; IF TANK IS NOT A BOT (PLAYER)
            MOVE.L  #$00344D31,(TANPCOL)     ; COLOR DE CONTORNO DEL TANQUE   
            MOVE.L  #$00608C59,(TANFCOL)     ; COLOR DE RELLENO DEL TANQUE
            ; ELSE (TANK IS A BOT) -> SELECT A RANDOM COLOR


            MOVEM.L D0/A1,-(A7)
            JSR     UTLRAND
            AND.L   #$0000000C,D0           ; MÁSCARA PARA OBTENER MÚLTIPLOS DE 4 (ALEATORIOS)
            LEA     .POSVEC,A1
            MOVE.L  (A1,D0),(TANPOSX)       ; INITIAL TANK POSITION X AND Y    
            MOVEM.L (A7)+,D0/A1
            RTS            
            
            
            ; 4 posiciones aleatorias ( modificar para que no dependa de este vector )
.POSVEC     DC.W    SCRWIDTH/4,SCRHEIGH-100   ; 0
            DC.W    SCRWIDTH-50,SCRHEIGH/12   ; 4
            DC.W    SCRWIDTH-320,SCRHEIGH-30  ; 8
            DC.W    SCRWIDTH/5,SCRHEIGH/5     ; 12 
            
; ----------------------------------------------------------            
TANUPD
; UPDATE THE TANK
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------

            MOVEM.W  D0-D1,-(A7)
            
            ; UPDATE COORDINATES
            
            ; IF TANK IS NOT A BOT
            MOVE.W  (TANPOSX),D0
            MOVE.W  (TANPOSY),D1
            
            BTST.B  #0,(KBDVAL)
            BEQ     .CHKLEFT
            SUB.W   #TANSPEED,D0  ;RESTAMOS LA DISTANCIA X
.CHKLEFT    BTST.B  #2,(KBDVAL)
            BEQ     .CONT1
            ADD.W   #TANSPEED,D0  ;SUMAMOS LA DISTANCIA X
.CONT1            
            BTST.B  #1,(KBDVAL)
            BEQ     .CHKDWN 
            SUB.W   #TANSPEED,D1  ;SUMAMOS LA VELOCIDAD AL EJE Y
.CHKDWN     BTST.B  #3,(KBDVAL)
            BEQ     .CONT2
            ADD.W   #TANSPEED,D1  ;RESTAMOS LA VELOCIDAD AL EJE Y
            ;BRA     .CONT2
            
            ; ELSE (TANK IS A BOT)
            ; AI ALGORITHM


.CONT2

            ; CHECK HORIZONTAL COLLISIONS
            CMP.W   #SCRWIDTH-TANWIDTH/2,D0
            BGE     .COLRGT
            CMP.W   #TANWIDTH/2,D0            
            BLT     .COLLFT                 
            
            ; CHECK VERTICAL COLLISIONS
.CHKVERT    CMP.W   #SCRHEIGH-TANHEIGH/2,D1
            BGE     .COLBOT
            CMP.W   #TANHEIGH/2,D1
            BLT     .COLTOP                
            BRA     .DONE   
            
            ; RIGHT SIDE COLLISION    
.COLRGT     MOVE.W  #SCRWIDTH-TANWIDTH/2,D0
            BRA     .CHKVERT

            ; LEFT SIDE COLLISION
.COLLFT     MOVE.W  #TANWIDTH/2,D0                   
            BRA     .CHKVERT  

            ; BOTTOM COLLISION
.COLBOT     MOVE.W  #SCRHEIGH-TANHEIGH/2,D1
            BRA     .DONE

            ; TOP COLLISION
.COLTOP     MOVE.W  #TANHEIGH/2,D1                   
            
            ; STORE POSITION
.DONE       MOVE.W  D0,(TANPOSX)
            MOVE.W  D1,(TANPOSY)
            
            MOVEM.W (A7)+,D0-D1

            RTS
            
; ----------------------------------------------------------            
TANPLOT
; PLOT THE TANK
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D4,-(A7)

            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  (TANPCOL),D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  (TANFCOL),D1
            TRAP    #15
            
            ; DEFINE COORDINATES
            MOVE.W  (TANPOSX),D1
            SUB.W   #TANWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #TANWIDTH,D3
            
            MOVE.W  (TANPOSY),D2
            SUB.W   #TANHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #TANHEIGH,D4
            
            ; DRAW RECTANGLE (TANK)
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4
            
            RTS    









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
