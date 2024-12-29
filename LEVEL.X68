*-----------------------------------------------------------
* CLASE LEVEL
* ENCARGADA DE INICIAR LOS NIVELES DEL JUEGO
*-----------------------------------------------------------

; ----------------------------------------------------------
LVL1INIT
; INICIALIZAMOS EL NIVEL 1
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D2/A1-A3,-(A7)
            
            CLR.W   (TANID)
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            ; INTRODUCIMOS AL JUGADOR
            MOVE.W  #TANPLAY,D0   
            MOVE.W  #PLRINITX,D1
            MOVE.W  #PLRINITY,D2
            JSR     AGLADD

            ; INTRODUCIMOS AL ENEMIGO 1
            MOVE.W  #TANENEM,D0         
            MOVE.W  #SCRWIDTH-100,D1    
            MOVE.W  #SCRHEIGH-100,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 2
            MOVE.W  #SCRWIDTH-100,D1    
            MOVE.W  #SCRHEIGH-300,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A1-A3
            
            RTS

; ----------------------------------------------------------
LVL2INIT
; INICIALIZAMOS EL NIVEL 2
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D2/A0-A3,-(A7)
            
            ; INTRODUCIMOS AL JUGADOR
            MOVE.W  #1,(TANID)
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            MOVE.W  #440,8(A0)
            MOVE.W  #440,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)                
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            ; INTRODUCIMOS AL ENEMIGO 1
            MOVE.W  #TANENEM,D0         
            MOVE.W  #50,D1    
            MOVE.W  #50,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 2
            MOVE.W  #SCRWIDTH-50,D1    
            MOVE.W  #160,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 3
            MOVE.W  #50,D1            
            MOVE.W  #320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD

            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS

; ----------------------------------------------------------
LVL3INIT
; INICIALIZAMOS EL NIVEL 3
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D2/A0-A3,-(A7)
            
            ; INTRODUCIMOS AL JUGADOR
            MOVE.W  #1,(TANID)
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            MOVE.W  #320,8(A0)
            MOVE.W  #400,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            ; INTRODUCIMOS AL ENEMIGO 1
            MOVE.W  #TANENEM,D0       
            MOVE.W  #SCRWIDTH-64,D1    
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 2
            MOVE.W  #30,D1    
            MOVE.W  #SCRHEIGH-380,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 3
            MOVE.W  #SCRWIDTH-448,D1    
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD

            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS
            
; ----------------------------------------------------------
LVL4INIT
; INICIALIZAMOS EL NIVEL 4
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D2/A0-A3,-(A7)
            
            ; INTRODUCIMOS AL JUGADOR
            MOVE.W  #1,(TANID)
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            MOVE.W  #320,8(A0)
            MOVE.W  #360,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            ; INTRODUCIMOS AL ENEMIGO 1
            MOVE.W  #TANENEM,D0         
            MOVE.W  #SCRWIDTH-64,D1    
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 2
            MOVE.W  #SCRWIDTH-576,D1     
            MOVE.W  #SCRHEIGH-416,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 3
            MOVE.W  #SCRWIDTH-448,D1   
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 4
            MOVE.W  #SCRWIDTH-192,D1   
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS
            

; ----------------------------------------------------------
LVL5INIT
; INICIALIZAMOS EL NIVEL 5
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------


            MOVEM.L D0-D2/A0-A3,-(A7)
            
            ; INTRODUCIMOS AL JUGADOR
            MOVE.W  #1,(TANID)
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            MOVE.W  #160,8(A0)
            MOVE.W  #352,10(A0)
            MOVE.W  #PLMAXBUL,18(A0)    ; DEVOLVERLE LAS BALAS AL JUGADOR
            
            LEA     TANINIT,A1
            LEA     TANUPD,A2
            LEA     TANPLOT,A3
            
            ; INTRODUCIMOS AL ENEMIGO 1
            MOVE.W  #TANENEM,D0         
            MOVE.W  #SCRWIDTH-416,D1    
            MOVE.W  #SCRHEIGH-352,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 2
            MOVE.W  #SCRWIDTH-352,D1     
            MOVE.W  #SCRHEIGH-320,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 3
            MOVE.W  #SCRWIDTH-256,D1   
            MOVE.W  #SCRHEIGH-224,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            ; INTRODUCIMOS AL ENEMIGO 4
            MOVE.W  #SCRWIDTH-192,D1    
            MOVE.W  #SCRHEIGH-160,D2
            ADDQ.W  #1,(TANID)
            MOVE.W  (TANID),D3
            JSR     AGLADD
            
            MOVEM.L (A7)+,D0-D2/A0-A3
            
            RTS

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
