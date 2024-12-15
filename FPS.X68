; ----------------------------------------------------------
FPSINIT
; INICIALIZAR EL CONTADOR DE FPS
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------

            CLR.W   (ACTFPS)
            RTS

; ----------------------------------------------------------
FPSUPD     
; ACTUALIZAR LOS FPS DEL JUEGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------   
            
            ; INCREMENTAR EL CONTADOR DE FPS
            ADDQ.W      #1,ACTFPS
            ; INVOCAR LA TAREA 8 PARA MEDIR EL TIEMPO EN CENTÉSIMAS DE SEGUNDO
	        MOVE.W		#8,D0			
	        TRAP		#15
	        ; COMPARAR EL TIEMPO DE LA INTERRUPCIÓN ANTERIOR Y LA ACTUAL
	        MOVE.L  D1,D2            
            MOVE.L  TIEMPO,D0        
            ADD.L   #100,D0          
            SUB.L   D0,D1            
            CMP.L   #0,D1            

            BLT     .END
	        ; SI ES NECESARIO, ACTUALIZAR LOS FPS EN PANTALLA
      	    MOVE.W  ACTFPS,SHWFPS
	        MOVE.W  #0,ACTFPS
	        MOVE.L  D2,TIEMPO

.END
  
	        RTS
            
            
GOALFPS         DC.B    'FPS ESPERADOS:',0
ACTUALFPS       DC.B    'FPS ACTUALES :',0

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
            LEA     GOALFPS, A1
            CLR.L   D1
            MOVE.W  #SCRFPS,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ; ESTABLECER COORDENADAS PARA MOSTRAR LOS FPS ACTUALES
            MOVE.B  #11,D0
            MOVE.W  #FPSLINE2,D1
            TRAP    #15
            
            ; MOSTRAR TEXTO
            LEA     ACTUALFPS,A1
            CLR.L   D1
            MOVE.W  (SHWFPS),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            
            RTS














*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
