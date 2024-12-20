*-----------------------------------------------------------
* SYSTEM
*-----------------------------------------------------------

; ----------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            
            MOVE.L  #SCRPLOT,($80+SCRUPTN*4)
            MOVE.L  #KBDUPD,($80+KBDUPTN*4) 
            MOVE.L  #SNDPLAY,($80+SNDPLTN*4)
            MOVE.L  #SCRTIM,($60+SCRINTN*4) ; INTERRUPCIÓN DE TIPO 1
            
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
; SOUND SYSTEM INIT
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)

            CLR.B   D1
            LEA     .SNDLIST,A0
.LOOP       MOVE.L  (A0)+,D0    ; SI HICIESEMOS MOVEA (PASAR DE A0 A A1 DIRECTAMENTE) NO ACTUALIZARÍA EL FLAG Z
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
.SNDBULEX   DC.B    'SND/BULEXP.wav',0
.SNDDISP    DC.B    'SND/DISP.wav',0
.SNDGVR1    DC.B    'SND/GOVER1.wav',0
.SNDGVR2    DC.B    'SND/GOVER2.wav',0
.SNDWIN     DC.B    'SND/WIN.wav',0
            DS.W    0
.SNDLIST    DC.L    .SNDINTRO,.SNDINSTR,.SNDWALL,.SNDHIT,.SNDKILL,.SNDBULEX,.SNDDISP,.SNDGVR1,.SNDGVR2,.SNDWIN,0
            
; ----------------------------------------------------------
SNDPLAY
; PLAY SOUND
; INPUT     : D7 SOUND ID
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
; INIT SCREEN. SET SCREEN RESOLUTION, SET WINDOWED MODE, CLEAR SCREEN,
; ENABLE DOUBLE BUFFER, ENABLE TIMED INTERRUPT
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
; UPDATE DOUBLE BUFFER
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            ; SWITCH BUFFERS
            MOVE.B  #94,D0
            TRAP    #15
            
            ; CLEAR HIDDEN BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15 
            MOVEM.W (A7)+,D0-D1
            
            RTE

; ----------------------------------------------------------            
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------
            
            ADDQ.B  #1,(SCRINTCT)
            ADDQ.B  #1,(SCRCYCCT)
            RTE
            
; ----------------------------------------------------------
KBDINIT
; INIT KEYBARD
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS
            
; ----------------------------------------------------------
KBDUPD
; UPDATE KEYBOARD INFO
; 7 ->
; 6 ->
; 5 -> PAUSE
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
            MOVE.L  #KBDPAUSE<<8|KBDFIRE,D1
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
; INIT MOUSE
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            CLR.L   (MOUPOS)
            CLR.W   (MOUBUT)
            RTS
            
; ----------------------------------------------------------
MOUUPD
; INIT MOUSE
; INPUT     : NONE
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #61,D0
            CLR.B   D1
            TRAP    #15
            MOVE.L  D1,(MOUPOS)
            MOVE.B  (MOUBUT),D1
            MOVE.B  D0,(MOUBUT)
            NOT.B   D1
            AND.B   D1,D0
            MOVE.B  D0,(MOUEDGE)
            MOVE.B  (MOUEDGE),D0
            MOVEM.L (A7)+,D0-D1
            RTS
            
; ----------------------------------------------------------------------------           
READMOU
;READ MOUSE VARIABLES
;
;----------------------------------------------------------------------------- 
            MOVEM.L D0-D3, -(A7)
            CLR.L   D1
            
            MOVE.W  #61,D0           ;LECTURA DEL RATÓN
            MOVE.B  #0,D1
            TRAP    #15
            
            BTST    #0,D0
            BEQ     .NOCLICKED
      
            MOVE.L  D1, D2           ;PROCESO DE EXTRACCIÓN DE LA COORDENADA X
            ANDI.L  #$0000FFFF, D2
            
            MOVE.L  D1, D3           ;PROCESO D'EXTRACCIÓN DE LA COORDENADA Y
            ;ANDI.L  #$FFFF0000, D3
            ;LSR.L   #8, D3
            ;LSR.L   #8, D3
.NOCLICKED:             
            MOVEM.L (A7)+, D0-D3
            RTS


; ----------------------------------------------------------------------------           
APUNTADOR
; COLOCA LA DIRECCIÓN EN LA CUAL APUNTA EL RATÓN O EL ENEMIGO (LA FOTO, LAS VARS DE LA BALA)
; INPUT     : D7 (0 indica que es el jugador, 1 el enemigo)
; OUTPUT    : NONE
; MODIFIES  : NONE
;----------------------------------------------------------------------------- 

            MOVEM.L D2-D7,-(A7)
            
            CMP.W   #0,D7
            BNE     .ENEMY
            MOVE.L (MOUPOS),D2
            MOVE.L  D2,D3            ;PROCESO DE EXTRACCIÓN DE LA COORDENADA X
            ANDI.L  #$0000FFFF,D3
            
            MOVE.L  D2,D4            ;PROCESO DE EXTRACCIÓN DE LA COORDENADA Y
            ANDI.L  #$FFFF0000,D4
            LSR.L   #8,D4
            LSR.L   #8,D4
            BRA     .CONT
.ENEMY      
            MOVE.W  (PLAYPOSX),D3
            MOVE.W  (PLAYPOSY),D4
.CONT            
            SUB.W   D0,D3
            SUB.W   D1,D4
            
            MOVE.W  D4,D5
            EXT.L   D5
            LSR.L   #1,D5             ;DIVIDIR POR Y 2
            CMP.W   D3,D5
            BLT     .UPRECTEI         ;SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA EMPINADA INFERIOR
            
            MOVE.W  D4,D5
            LSL.W   #1,D5             ;MULTIPLICAR POR Y 2
            NEG.W   D5                ;NEGAMOS Y
            CMP.W   D3,D5
            BLT     .DWRECTSS         ;SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA SUAVE SUPERIOR

            MOVE.W  D4,D5
            LSL.W   #1,D5             ;MULTIPLICAR POR Y 2
            CMP.W   D3,D5
            BLT     .DWRECTSI         ;SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA SUAVE INFERIOR
            MOVE.W  #-BULSPEED,(BULVELX)          ;ZONA 6 
            MOVE.W  #0,(BULVELY)
            MOVE.W  #-20,(BULPOSORGX)
            MOVE.W  #0,(BULPOSORGY)
            
            MOVE.W  #12,D6
            BRA     .FINAPU  
.DWRECTSI            
            MOVE.W  #-BULSPEED/2,(BULVELX)          ;ZONA 7
            MOVE.W  #-BULSPEED/2,(BULVELY)
            MOVE.W  #-20,(BULPOSORGX)
            MOVE.W  #-20,(BULPOSORGY)
            
            MOVE.W  #14,D6
            BRA     .FINAPU
            
.DWRECTSS            
            MOVE.W  D4,D5
            EXT.L   D5
            LSR.L   #1,D5             ;DIVIDIR Y POR 2
            NEG.W   D5
            
            CMP.W   D3,D5
            BLT     .DWRECTES         ; SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA SUAVE SUPERIOR
            MOVE.W  #-BULSPEED/2,(BULVELX)          ;ZONA 5
            MOVE.W  #BULSPEED/2,(BULVELY)
            MOVE.W  #-20,(BULPOSORGX)
            MOVE.W  #20,(BULPOSORGY) 
            
            MOVE.W  #10,D6
            BRA     .FINAPU  
.DWRECTES            
            MOVE.W  #BULSPEED,(BULVELY)          ;ZONA 4
            MOVE.W  #0,(BULVELX)
            MOVE.W  #20,(BULPOSORGY)
            MOVE.W  #0,(BULPOSORGX)
            
            MOVE.W  #8,D6
            BRA     .FINAPU
            
.UPRECTEI            

            MOVE.W  D4,D5
            LSL.W   #1,D5             ;MULTIPLICAR POR Y 2
            NEG.W   D5                 ;NEGAMOS Y
            CMP.W   D3,D5
            BGT     .UPRECTSS         ;SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA SUAVE SUPERIOR


            MOVE.W  D4,D5
            LSL.W   #1,D5             ;MULTIPLICAR POR Y 2
            CMP.W   D3,D5
            BLT     .UPRECTSI         ;SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA SUAVE INFERIOR
            MOVE.W  #BULSPEED/2,(BULVELX)          ;ZONA 3
            MOVE.W  #BULSPEED/2,(BULVELY)
            MOVE.W  #20,(BULPOSORGX)
            MOVE.W  #20,(BULPOSORGY)
            
            MOVE.W  #6,D6
            BRA     .FINAPU  
.UPRECTSI            
            MOVE.W  #BULSPEED,(BULVELX)          ;ZONA 2
            MOVE.W  #0,(BULVELY)
            MOVE.W  #20,(BULPOSORGX)
            MOVE.W  #0,(BULPOSORGY)
            
            MOVE.W  #4,D6
            BRA     .FINAPU
            
.UPRECTSS            
            MOVE.W  D4,D5
            EXT.L   D5
            LSR.L   #1,D5             ;DIVIDIR Y POR 2
            NEG.W   D5
            
            CMP.W   D3,D5
            BLT     .UPRECTES         ; SI X<Y/2, APUNTAMOS POR ENCIMA DE LA RECTA SUAVE SUPERIOR
            MOVE.W  #-BULSPEED,(BULVELY)          ;ZONA 0
            MOVE.W  #0,(BULVELX)
            MOVE.W  #-20,(BULPOSORGY)
            MOVE.W  #0,(BULPOSORGX)
            
            MOVE.W  #0,D6
            BRA     .FINAPU  
.UPRECTES            
            MOVE.W  #BULSPEED,(BULVELX)          ;ZONA 1
            MOVE.W  #-BULSPEED/2,(BULVELY)
            MOVE.W  #20,(BULPOSORGX)
            MOVE.W  #-20,(BULPOSORGY)
            
            MOVE.W  #2,D6
            
.FINAPU  
            CMP.W   #0,D7
            BEQ     .FINPLY
            MOVE.W  D6,(ENCANPOS)
.FINPLY            
            MOVE.W  D6,(PLCANPOS)
.FINENE            
            MOVEM.L (A7)+,D2-D7
            RTS















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
