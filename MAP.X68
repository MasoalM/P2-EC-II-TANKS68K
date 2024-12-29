; =============================================================================
; CLASE MAP
; =============================================================================

; -----------------------------------------------------------------------------
MAPINIT
; INITALIZES THE MAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            RTS

; -----------------------------------------------------------------------------
MAPUPD
; UPDATES THE MAP IF PLAYER CHANGES SCREEN
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            RTS

; -----------------------------------------------------------------------------
MAPPLOT
; PLOTS THE MAP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L D0/A0,-(A7)
            
            ; SELECCIONAMOS EL MAPA ACTUAL
            LEA.L   MAPDATA, A0
            MOVE.W  (LVLNUM),D6
            MULU.W  #SIZLVL,D6
            ADD.L   D6,A0
                        
            ;INICIO BUCLE MATRICIAL DE PINTURA
            MOVE.W #MAPPIEY-1, D6
            MOVE.W  #-PIESIZY, D2
            CLR.L   D3
            CLR.L   D4
.LINEY      ;PARA TODAS LAS FILAS
            MOVE.W  #MAPPIEX-1, D5
            MOVE.W  #-PIESIZX, D7
            ADD.W   #PIESIZY,D2
.LINEX      ;PINTAMOS SU CUADRADO

            ;MIRAMOS SI ES PARED O SUELO
            MOVE.W  (A0)+,D0
            CMP.W   #$01, D0
            
            BEQ    .PARED
            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  #$0042C0FF,D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  #$0042C0FF,D1
            TRAP    #15
            
            ; DEFINE COORDINATES (D2 ESTÁ ARRIBA)
            ADD.W  #PIESIZX, D7
            MOVE.W  D7, D1
            ADD.W   #PIESIZX, D3
            ADD.W   #PIESIZY, D4 
            
            ; DRAW RECTANGLE (CASILLA)
            MOVE.B  #87,D0
            TRAP    #15
            
            BRA     .SOLEADO

.PARED                   
            ; SET CONTOUR COLOR
            MOVE.B  #80,D0
            MOVE.L  #$000076AC,D1
            TRAP    #15
            
            ; SET FILL COLOR
            MOVE.B  #81,D0
            MOVE.L  #$000076AC,D1
            TRAP    #15
            
            ; DEFINE COORDINATES (D2 ESTÁ ARRIBA)
            ADD.W  #PIESIZX, D7
            MOVE.W  D7, D1
            ADD.W   #PIESIZX, D3
            ADD.W   #PIESIZY, D4 
            
            ; DRAW RECTANGLE (CASILLA)
            MOVE.B  #87,D0
            TRAP    #15
            
.SOLEADO            
            DBRA D5, .LINEX
            DBRA D6, .LINEY
            
            MOVEM.L (A7)+,D0/A0
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
