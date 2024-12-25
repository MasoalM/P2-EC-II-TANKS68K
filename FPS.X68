; ----------------------------------------------------------
FPSINIT
; INICIALIZAR EL CONTADOR DE FPS
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : ACTFPS
; ----------------------------------------------------------

            CLR.W   (ACTFPS)    ; INICIALIZA EL CONTADOR DE FPS
            RTS

; ----------------------------------------------------------
FPSUPD     
; ACTUALIZAR LOS FPS
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : ACTFPS, SHWFPS, TIEMPO, D0-D2
; ----------------------------------------------------------   
            
            ; INCREMENTAR EL CONTADOR DE FPS
            ADDQ.W      #1,ACTFPS
            ; INVOCAR LA TAREA 8 PARA MEDIR EL TIEMPO EN CENTÉSIMAS DE SEGUNDO
	        MOVE.W		#8,D0			
	        TRAP		#15
	        ; COMPARAR EL TIEMPO DE LA INTERRUPCIÓN ANTERIOR Y LA ACTUAL
	        MOVE.L  D1,D2           ; D2 = TIEMPO ACTUAL          
            MOVE.L  TIEMPO,D0       ; D0 = TIEMPO ANTERIOR     
            ADD.L   #100,D0         ; D0 += 100 CENTÉSIMAS (1 SEGUNDO)     
            SUB.L   D0,D1           ; D1 = D2 - (D0 + 100)     
            ; VERIFICAR SI HA PASADO AL MENOS 1 SEGUNDO
            CMP.L   #0,D1            
            BLT     .END
	        ; SI ES NECESARIO, ACTUALIZAR LOS FPS EN PANTALLA
      	    MOVE.W  ACTFPS,SHWFPS   ; MUEVE EL VALOR ACTUAL DE FPS
	        MOVE.W  #0,ACTFPS       ; REINICIA EL CONTADOR DE FPS
	        MOVE.L  D2,TIEMPO       ; ACTUALIZA EL TIEMPO
.END
	        RTS
            
; ----------------------------------------------------------
FPSPLOT     
; MOSTRAR LOS FPS EN PANTALLA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)
                        
            ; ESTABLECER COORDENADAS PARA MOSTRAR LOS FPS OBJETIVO
            MOVE.B  #11,D0
            MOVE.W  #FPSLINE1,D1
            TRAP    #15
            
            ; MOSTRAR TEXTO
            LEA     .GOALFPS, A1
            CLR.L   D1
            MOVE.W  #SCRFPS,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ; MOSTRAR LOS FPS ACTUALES
            MOVE.B  #11,D0
            MOVE.W  #FPSLINE2,D1        ; COORDENADAS
            TRAP    #15
            LEA     .ACTUALFPS,A1
            CLR.L   D1
            MOVE.W  (SHWFPS),D1         ; CARGAR FPS ACTUALES
            MOVE.B  #17,D0              ; MOSTRAR TEXTO
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            
            RTS
            
.GOALFPS         DC.B   'FPS ESPERADOS:',0
.ACTUALFPS       DC.B   'FPS ACTUALES :',0
                 DS.W   0















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
