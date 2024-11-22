*-----------------------------------------------------------
* TANK MANAGEMENT (AGENT)
*
* TANPOSX (W)       (A0)
* TANPOSY (W)       2(A0)
* TANSPEED(W)       4(A0)
* TANPCOL (L)       6(A0)
* TANFCOL (L)       10(A0)
* TANID   (W)       14(A0)
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
            ;AND.L   #$0000000C,D0           ; MÁSCARA PARA OBTENER MÚLTIPLOS DE 4 (ALEATORIOS)
            ;LEA     .POSVEC,A1
            ;MOVE.L  (A1,D0),(A0)       ; INITIAL TANK POSITION X AND Y    
            ;MOVEM.L (A7)+,D0/A1
            ;RTS      

            MOVE.W  #TANSPEED,4(A0)     
            
            ; IF TANK IS NOT A BOT (PLAYER)
            CMP.W   #TANPLAY,D0
            BNE.W   .BOT
            MOVE.W  #SCRWIDTH/2,(A0)
            MOVE.W  #SCRHEIGH/2,2(A0)
            MOVE.L  #$00344D31,6(A0)     ; COLOR DE CONTORNO DEL TANQUE   
            MOVE.L  #$00608C59,10(A0)    ; COLOR DE RELLENO DEL TANQUE
            MOVE.W  #TANPLAY,14(A0)      ; EL TANQUE ES EL JUGADOR 
            RTS 
            
            ; ELSE (TANK IS A BOT)
.BOT        MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)
            MOVE.L  #$000B2187,6(A0)  
            MOVE.L  #$00081658,10(A0)
            MOVE.W  #TANENEM,14(A0)      ; EL TANQUE ES UN BOT
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
            SUB.W   4(A0),D0  ;RESTAMOS LA DISTANCIA X
.CHKLEFT    BTST.B  #2,(KBDVAL)
            BEQ     .CONT1
            ADD.W   4(A0),D0  ;SUMAMOS LA DISTANCIA X
.CONT1            
            BTST.B  #1,(KBDVAL)
            BEQ     .CHKDWN 
            SUB.W   4(A0),D1  ;SUMAMOS LA VELOCIDAD AL EJE Y
.CHKDWN     BTST.B  #3,(KBDVAL)
            BEQ     .DISP
            ADD.W   4(A0),D1  ;RESTAMOS LA VELOCIDAD AL EJE Y
.DISP          
            ; COMPROBAR SI ESTÁ DISPARANDO  
        
            BTST.B  #4,(KBDEDGE)    ; ESPACIO PULSADO
            BEQ     .CONT2  
            
            MOVE.W  D0,D3
            MOVE.W  D1,D4
                   
            LEA     BULINIT,A1
            LEA     BULUPD,A2
            LEA     BULPLOT,A3            
            MOVE.W  #BULTYPE,D0
            MOVE.W  (A0),D1                 ;MOVE.W  D3,D1
            MOVE.W  2(A0),D2                ;MOVE.W  D4,D2
            JSR     AGLADD
                            
            MOVE.W  D3,D0
            MOVE.W  D4,D1

.BOT2       ; ELSE (TANK IS A BOT)
            ; AI ALGORITHM


.CONT2

            

;TRY2
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
            ADD.L  #40,A1
            ADD.W   #PIESIZY,D3
.CHKY            
            CMP.W   #PIESIZX,D5
            BGT     .NOORGY
            
            
            ;CMP.L   #$00,(A1)
            ;BNE     .NOCOL
            
            
            ; CHECK HORIZONTAL COLLISIONS
            CMP.W   #PIESIZX-TANWIDTH/2,D4
            BGE     .COLRGT
.RECX
            CMP.W   #TANWIDTH/2,D4            
            BLT     .COLLFT                 
            
            ; CHECK VERTICAL COLLISIONS
.CHKVERT    CMP.W   #PIESIZY-TANHEIGH/2,D5
            BGE     .COLBOT
.RECY            
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
.FARSC
            SUBQ.L  #2,A1
            BRA     .RECX

            ; LEFT SIDE COLLISION
.COLLFT     
            SUBQ.L  #2,A1
            CMP.W   #$01,(A1)
            BNE     .FALSC
            MOVE.W  #TANWIDTH/2,D0
            ADD.W   D2,D0                   
.FALSC
            ADDQ.L  #2,A1
            BRA     .CHKVERT  

            ; BOTTOM COLLISION
.COLBOT     
            ADD.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .FABSC
            MOVE.W  #PIESIZY-TANHEIGH/2,D1
            ADD.W   D3,D1
.FABSC
            SUB.L  #40,A1            
            BRA     .RECY

            ; TOP COLLISION
.COLTOP     
            SUB.L   #40,A1
            CMP.W   #$01,(A1)
            BNE     .FATSC
            MOVE.W  #TANHEIGH/2,D1
            ADD.W   D3,D1         
.FATSC
            SUB.L  #40,A1          

;.NOCOL
            
            ; STORE POSITION
.DONE       MOVE.W  D0,(A0)
            MOVE.W  D1,2(A0)
            
            MOVEM.W (A7)+,D0-D7/A1
            RTS
   

            
; ----------------------------------------------------------            
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
            
            MOVEM.L (A7)+,D0-D4
            
            RTS    



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
