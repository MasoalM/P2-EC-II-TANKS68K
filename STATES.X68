; =============================================================================
; GESTIÓN DE LOS ESTADOS DEL JUEGO
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INICIALIZA EL GESTOR DE ESTADOS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #0,(DEMO)
            MOVE.W  #STANONE,(STACUR)
            CLR.W   (STANEXT)
            RTS

; -----------------------------------------------------------------------------
STAUPD
; REALIZA LA ACTUALIZACIÓN DEL ESTADO E INIT SI ES NECESARIO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; SI EL ESTADO HA CAMBIADO, 
                                            ; IR AL INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; EN CUALQUIER CASO, ACTUALIZAR
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    ISCINIT,INSINIT,GAMINIT,WININIT,GOVINIT
.UPDTBL     DC.L    ISCUPD,INSUPD,GAMUPD,WINUPD,GOVUPD

; -----------------------------------------------------------------------------
STAPLOT
; REALIZA EL PLOT DE LOS ESTADOS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAEMPTY,STAEMPTY,GAMPLOT,STAEMPTY,STAEMPTY

; -----------------------------------------------------------------------------
STAEMPTY
; SUBRUTINA VACÍA PARA CASOS EN LOS QUE NO HAYA QUE HACER NADA
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS













*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
