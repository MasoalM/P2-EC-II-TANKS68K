; ------------------------------------------------------------------------------
FPSINIT
; INICIAMOS EL CONTADOR DE FPS 
; ------------------------------------------------------------------------------

            CLR.W   (ACTFPS)
            RTS

; ------------------------------------------------------------------------------
FPSPLOT
; DIBUJAMOS LOS FPS POR PANTALLA
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)
                        
            ; DEFINIR COODENADAS DONDE SE IMPRIME EL GOAL FPS
            MOVE.B  #11,D0
            MOVE.W  #100,D1
            TRAP    #15
            
            ; IMPRIMIR
            LEA     GOALFPS, A1
            CLR.L   D1
            MOVE.W  #SCRFPS,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ; DEFINIR COODENADAS DONDE SE IMPRIME EL ACTUAL FPS
            MOVE.B  #11,D0
            MOVE.W  #120,D1
            TRAP    #15
            
            ; IMPRIMIR
            LEA     ACTUALFPS,A1
            CLR.L   D1
            MOVE.W  (SHWFPS),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            
            RTS

; ------------------------------------------------------------------------------
FPSUPD     
; VAMOS ACTUALIZANDO LOS FPS DEL JUEGO

; ------------------------------------------------------------------------------    
           
            
            ; VAMOS AÑADIENDO FPS A SU CONTADOR
            ADDQ.W      #1,ACTFPS
            ; LLAMAMOS A LA TAREA 8 PARA CONTAR EL TIEMPO EN CENTÉSIMAS DE SEGUNDO
	        MOVE.W		#8,D0			
	        TRAP		#15
	        ; COMPARAMOS EL TIEMPO DE LA INTERRUPCIÓN ANTERIOR Y LA QUE TENEMOS ACTUAL
	        MOVE.L  D1,D2            
            MOVE.L  TIEMPO,D0        
            ADD.L   #100,D0          
            SUB.L   D0,D1            
            CMP.L   #0,D1            

            BLT     .END
	        ; LLEGAMOS A ESTA PARTE DEL CÓDIGO SI NECESITAMOS ACTUALIZAR LOS FPS DE LA PANTALLA
      	    MOVE.W  ACTFPS,SHWFPS
	        MOVE.W  #0,ACTFPS
	        MOVE.L  D2,TIEMPO

.END
                 
	        RTS
            
            
GOALFPS         DC.B    'FPS ESPERADOS:',0
ACTUALFPS       DC.B    'FPS ACTUALES :',0












*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
