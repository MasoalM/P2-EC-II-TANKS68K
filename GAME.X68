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
            JSR     SCOINIT 
            
            MOVEM.L D0-D2/A1-A3,-(A7)
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            MOVE.W  #TANPLAY,D0   ; AGENTE TIPO 2 (TANQUE JUGADOR)
            JSR     AGLADD
            ;LEA     TANINIT,A1
            ;LEA     TANUPD,A2
            ;LEA     TANPLOT,A3
            MOVE.W  #TANENEM,D0
            MOVE.W  #SCRWIDTH-100,D1    ; ENEMIGO 1
            MOVE.W  #SCRHEIGH-100,D2
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-100,D1    ; ENEMIGO 2
            MOVE.W  #SCRHEIGH-300,D2
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A1-A3
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
            
; ----------------------------------------------------------
GAMPLOT
; PLOTS THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            JSR     MAPPLOT
            JSR     AGLPLOT
    
            BRA     SCOPLOT    







*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
