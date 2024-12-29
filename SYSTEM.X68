*-----------------------------------------------------------
* SYSTEM
*-----------------------------------------------------------

; ----------------------------------------------------------
SYSINIT
; INICIAMOS EL SISTEMA
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            ; GENERAMOS TRAPS QUE NOS SERÁN ÚTILES
            MOVE.L  #SCRPLOT,($80+SCRUPTN*4)
            MOVE.L  #KBDUPD,($80+KBDUPTN*4) 
            MOVE.L  #SNDPLAY,($80+SNDPLTN*4)
            MOVE.L  #SCRTIM,($60+SCRINTN*4) ; INTERRUPCIÓN DE TIPO 1
            
            ; INICIALIZAMOS LOS ELEMENTOS DEL SISTEMA
            JSR     SCRINIT
            JSR     KBDINIT
            JSR     MOUINIT
            JSR     SNDINIT
            JSR     DMMINIT
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$D8FF,(A7) ; MODO USUARIO Y HABILITAR INTERRUPCIONES
            RTE        

; ----------------------------------------------------------            
SNDINIT
; INICIALIZACIÓN DEL SONIDO
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)
            
            CLR.B   D1
            ; CARGAMOS CADA SONIDO DE MEMORIA
            LEA     .SNDLIST,A0
.LOOP       MOVE.L  (A0)+,D0   
            BEQ     .DONE
            MOVE.L  D0,A1
            MOVE.B  #71,D0
            TRAP    #15
            ADDQ.B  #1,D1
            BRA     .LOOP
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1   
            RTS
.SNDINTRO   DC.B    'SND/INTRO.wav',0
.SNDINSTR   DC.B    'SND/INSTR.wav',0
.SNDWALL    DC.B    'SND/WALL.wav',0
.SNDHIT     DC.B    'SND/HIT.wav',0
.SNDKILL    DC.B    'SND/ENEMKILL.wav',0
.SNDDISP    DC.B    'SND/DISP.wav',0
.SNDGVR1    DC.B    'SND/GOVER1.wav',0
.SNDWIN     DC.B    'SND/WIN.wav',0
.SNDEXPLO   DC.B    'SND/EXPLO.wav',0
            DS.W    0
.SNDLIST    DC.L    .SNDINTRO,.SNDINSTR,.SNDWALL,.SNDHIT,.SNDKILL,.SNDDISP,.SNDGVR1,.SNDWIN,.SNDEXPLO,0
            
; ----------------------------------------------------------
SNDPLAY
; REPRODUCIMOS EL SONIDO
; INPUT     : D7 ID DEL SONIDO
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            MOVE.B  #72,D0
            MOVE.B  D7,D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTE
            
; ----------------------------------------------------------
SCRINIT
; INICIAMOS LA PANTALLA: AJUSTAMOS LA RESOLUCIÓN DE LA PANTALLA, PONEMOS EL 
; MODO VENTANA, LIMPIAMOS LA PANTALLA, ACTIVAMOS EL DOBLE BUFFER, ACTIVAMOS LAS
; INTERRUPCIONES DE TIEMPO
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D1,-(A7)

            ; SET SCREEN RESOLUTION
            MOVE.B  #33,D0
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1
            TRAP    #15
            
            ; SET WINDOWED MODE
            MOVE.L  #1,D1
            TRAP    #15
            
            ; CLEAR SCREEN
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            ; ENABLE DOUBLE BUFFER
            ;MOVE.B  #92,D0
            ;MOVE.B  #17,D1
            ;TRAP    #15
            
            ; ENABLE TIMED INTERRUPT
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$80|SCRINTN,D2 ; BIT 7 = 1 TO ENABLE INDIVIDUAL IRQ, BITS 6-0 = NUMBER OF INTERRUPT (1)
            MOVE.L  #1000/SCRFPS,D3
            TRAP    #15
            
            ; CLEAR INTERRUPT COUNTER
            CLR.B   (SCRINTCT)   
            
            MOVEM.L (A7)+,D0-D1            
            RTS
            
; ----------------------------------------------------------
SCRPLOT
; ACTUALIZA EL DOBLE BUFFER
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            ; CAMBIAMOS BUFFERS
            MOVE.B  #94,D0
            TRAP    #15
            
            ; LIMPIAMOS EL BUFFER OCULTO
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15 
            MOVEM.W (A7)+,D0-D1
            
            RTE

; ----------------------------------------------------------            
SCRTIM
; RUTINA DE SERVICIO DE LAS INTERRUPCIONES TEMPORALES
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            ADDQ.B  #1,(SCRINTCT)
            ADDQ.B  #1,(SCRCYCCT)
            RTE
            
; ----------------------------------------------------------
KBDINIT
; INICIAMOS EL TECLADO
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS
            
; ----------------------------------------------------------
KBDUPD
; ACTUALIZAMOS EL TECLADO
; 7 ->
; 6 ->
; 5 -> INSTRUCTIONS
; 4 -> FIRE
; 3 -> DOWN
; 2 -> RIGHT
; 1 -> UP
; 0 -> LEFT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVEM.L D0-D3,-(A7)

            ; READ FIRST PART
            MOVE.B  #19,D0
            MOVE.L  #KBDINSTR<<8|KBDFIRE,D1
            TRAP    #15
            
            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK
            
            ; READ SECOND PART
            MOVE.L  #KBDDOWN<<24|KBDRIGHT<<16|KBDUP<<8|KBDLEFT,D1
            TRAP    #15
            
            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK
            
            ; COMPUTE KBDEDGE
            MOVE.B  (KBDVAL),D0
            NOT.B   D0
            AND.B   D2,D0       ; KBDVAL NUEVO AND KBDVAL ANTERIOR NEGADO
            MOVE.B  D0,(KBDEDGE)
            
            ; STORE KBDVAL
            MOVE.B  D2,(KBDVAL)
            
            MOVEM.L (A7)+,D0-D3
            
            RTE
            
.PACK       MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP
            RTS
            

; ----------------------------------------------------------
MOUINIT
; INICIAMOS EL RATÓN
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            CLR.L   (MOUPOS)
            CLR.W   (MOUBUT)
            RTS
            
; ----------------------------------------------------------
MOUUPD
; ACTUALIZAMOS EL RATÓN
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #61,D0
            CLR.B   D1
            TRAP    #15
            ;GUARDAMOS LOS DATOS DEL RATÓN
            MOVE.L  D1,(MOUPOS)
            MOVE.B  (MOUBUT),D1
            MOVE.B  D0,(MOUBUT)
            NOT.B   D1
            AND.B   D1,D0
            MOVE.B  D0,(MOUEDGE)
            MOVEM.L (A7)+,D0-D1
            RTS
            

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
