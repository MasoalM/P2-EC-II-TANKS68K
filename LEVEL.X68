*-----------------------------------------------------------
* CLASE LEVEL
*-----------------------------------------------------------

; ----------------------------------------------------------
LVL1INIT
; INITIALIZES LEVEL 1
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D2/A1-A3,-(A7)
            
            CLR.W   (TANID)
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            MOVE.W  #TANPLAY,D0   ; AGENTE TIPO 2 (TANQUE JUGADOR)
            MOVE.W  #PLRINITX,D1
            MOVE.W  #PLRINITY,D2
            JSR     AGLADD

            MOVE.W  #TANENEM,D0         ; ENEMIGO 1
            MOVE.W  #SCRWIDTH-100,D1    
            MOVE.W  #SCRHEIGH-100,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-100,D1    ; ENEMIGO 2
            MOVE.W  #SCRHEIGH-300,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A1-A3
            
            RTS

; ----------------------------------------------------------
LVL2INIT
; INITIALIZES LEVEL 2
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D2/A0-A3,-(A7)
            
            MOVE.W  #1,(TANID)
            
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            MOVE.W  #40,8(A0)
            MOVE.W  #440,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            MOVE.W  #TANENEM,D0         ; ENEMIGO 1
            MOVE.W  #50,D1    
            MOVE.W  #50,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-50,D1     ; ENEMIGO 2 
            MOVE.W  #160,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #50,D1              ; ENEMIGO 3
            MOVE.W  #320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD

            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS

; ----------------------------------------------------------
LVL3INIT
; INITIALIZES LEVEL 3
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D2/A0-A3,-(A7)
            
            MOVE.W  #1,(TANID)
            
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            MOVE.W  #320,8(A0)
            MOVE.W  #400,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            MOVE.W  #TANENEM,D0         ; ENEMIGO 1
            MOVE.W  #SCRWIDTH-64,D1    
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-576,D1    ; ENEMIGO 2 
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD

            MOVE.W  #SCRWIDTH-448,D1    ; ENEMIGO 3
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD

            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS
            
; ----------------------------------------------------------
LVL4INIT
; INITIALIZES LEVEL 4
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D2/A0-A3,-(A7)
            
            MOVE.W  #1,(TANID)
            
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            
            MOVE.W  #320,8(A0)
            MOVE.W  #360,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            MOVE.W  #TANENEM,D0         ; ENEMIGO 1
            MOVE.W  #SCRWIDTH-64,D1    
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-576,D1    ; ENEMIGO 2 
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-448,D1    ; ENEMIGO 3
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-192,D1    ; ENEMIGO 4
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS
            

; ----------------------------------------------------------
LVL5INIT
; INITIALIZES LEVEL 5
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------


            MOVEM.L D0-D2/A0-A3,-(A7)
            
            MOVE.W  #1,(TANID)
            
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            
            MOVE.W  #320,8(A0)
            MOVE.W  #360,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            MOVE.W  #TANENEM,D0         ; ENEMIGO 1
            MOVE.W  #SCRWIDTH-64,D1    
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-576,D1    ; ENEMIGO 2 
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-448,D1    ; ENEMIGO 3
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVE.W  #SCRWIDTH-192,D1    ; ENEMIGO 4
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS
            





*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
