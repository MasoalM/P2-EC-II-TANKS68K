; =============================================================================
; UTILITY MACROS
; =============================================================================

; -----------------------------------------------------------------------------
UTLSPEN     MACRO
; WRAPPER FOR SET PEN TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UTLSFIL     MACRO
; WRAPPER FOR SET FIL TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM


; =============================================================================
; UTILITY CODE
; =============================================================================

; -----------------------------------------------------------------------------
UTLINIT
; INITIALIZES UTILITY CODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #8,D0
            TRAP    #15
            MOVE.B  D1,(UTLRNDIX)
            MOVEM.L (A7)+,D0-D1
            RTS
 
; -----------------------------------------------------------------------------
UTLPRINT
; PRINT SCREEN  CENTERED TEXT
; INPUT    : A0 POINTER TO ZERO-TERMINATED STRING
;            D0.B SCREEN ROW TO PRINT TEXT
; OUTPUT   : D0.B NEXT ROW
; MODIFIES : NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A1,-(A7)
            CLR.B   D1
            MOVE.L  A0,A1
.LOOP       TST.B   (A0)+
            BEQ     .ENDLOOP
            ADDQ.B  #1,D1
            BRA     .LOOP
.ENDLOOP    LSR.B   #1,D1                   ; DIVIDIR D1 ENTRE 2
            SUB.B   #(SCRWIDTH/UTLCHRWD)/2,D1
            NEG.B   D1
            ASL.W   #8,D1
            OR.W    D0,D1
            MOVE.B  #11,D0
            TRAP    #15
            MOVE.B  #13,D0
            TRAP    #15          
            MOVEM.L (A7)+,D0-D1/A0-A1
            ADDQ.B  #1,D0
            RTS
  
; -----------------------------------------------------------------------------
UTLCHCOL
; CHECKS COLLISION
; INPUT    - D0.W X0 COORDINATE
;            D1.W Y0 COORDINATE
;            D2.W X1 COORDINATE
;            D3.W Y1 COORDINATE
;            D4.W WIDTH 0
;            D5.W WIDTH 1
;            D6.W HEIGHT 0
;            D7.W HEIGHT 1
; OUTPUT   - D0.B=FF - COLLISION, =0 - NO COLLISION
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D4-D7,-(A7)
            ADD.W   D0,D4
            CMP.W   D2,D4
            BLE     .NOCOL
            ADD.W   D2,D5
            CMP.W   D0,D5
            BLE     .NOCOL
            ADD.W   D1,D6
            CMP.W   D3,D6
            BLE     .NOCOL
            ADD.W   D3,D7
            CMP.W   D1,D7
            BLE     .NOCOL
            MOVE.B  #$FF,D0
            BRA     .END
.NOCOL      CLR.B   D0
.END        MOVEM.W (A7)+,D4-D7
            RTS
            
; -----------------------------------------------------------------------------
RELPOS
; PROVIDES THE RELATIVE POSITION
; INPUT    - DO.W : POSITION X OF THE AGENT
;            D1.W : POSITION Y OF THE AGENT
;            A1.L : ADDRESS OF THE MAP 
; OUTPUT   - D0.W : POSITION X OF THE AGENT
;            D1.W : POSITION Y OF THE AGENT
;            D2.W : DISTANCE BETWEEN 0 AND THE BEGINNING OF THE BLOCK WHERE IS THE TANK (X)
;            D3.W : DISTANCE BETWEEN 0 AND THE BEGINNING OF THE BLOCK WHERE IS THE TANK (Y)
;            D4.W : RELATIVE POSITION OF THE TANK IN X
;            D5.W : RELATIVE POSITION OF THE TANK IN Y
;            A1.L : POSITION OF THE TANK AT THE MAP (A1)
; MODIFIES - A1.L
; -----------------------------------------------------------------------------

            MOVE.W  D0,D4
            MOVE.W  D1,D5
            MOVE.W  #0,D2
            MOVE.W  #0,D3
            
            ;SACAMOS LA POSICIÓN RELATIVA DE X
            BRA .CHKX
.NOORGX
            SUB.W   #PIESIZX,D4
            ADDQ.L  #2,A1
            ADD.W   #PIESIZX,D2
.CHKX            
            CMP.W   #PIESIZX,D4
            BGT     .NOORGX             
            
            ;SACAMOS LA POSICIÓN RELATIVA DE Y
            BRA .CHKY
.NOORGY
            SUB.W   #PIESIZY,D5
            ADD.L   #40,A1
            ADD.W   #PIESIZY,D3
.CHKY            
            CMP.W   #PIESIZX,D5
            BGT     .NOORGY

            RTS
            
; -----------------------------------------------------------------------------
KILLBULS
; SUBRUTINA QUE DESTRUYE TODAS LAS BALAS QUE EXISTAN 
; EN LA PILA DE AGENTES
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(A7)
            
            MOVE.W  #BULTYPE,D0 
            JSR     DMMFRSTO
.BULLOOP            
            CMP.L   #0,A0
            BEQ     .NOBULS
            JSR     AGLKILL
            JSR     DMMNEXTO
            BRA     .BULLOOP
            ; DEVOLVERLE LAS BALAS AL JUGADOR
            MOVE.W  #TANPLAY,D0 
            JSR     DMMFRSTO
            MOVE.W  #PLMAXBUL,18(A0)
.NOBULS            
            MOVEM.L (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
PLIMASEL
; SELECCIONA LA POSICIÓN DEL TANQUE Y DEL CAÑÓN PARA 
; DIBUJAR AL JUGADOR
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - A1
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7,-(A7)
            CMP.W   #8,(PLCANPOS)
            BLO     .LOW1     
            CMP.W   #12,(PLCANPOS)
            BLO     .LOW2
            CMP.W   #14,(PLCANPOS)
            BLO     .LOW3
            BNE     .QUINCE
            LEA     DATPLYNW,A1
            BRA     .ENDDECOD
.QUINCE
            LEA     DATPLXNW,A1
            BRA     .ENDDECOD
.LOW3
            CMP.W   #12,(PLCANPOS)
            BNE     .TRECE
            LEA     DATPLYW,A1
            BRA     .ENDDECOD
.TRECE
            LEA     DATPLXNW,A1
            BRA     .ENDDECOD
.LOW2
            CMP.W   #10,(PLCANPOS)
            BLO     .LOW31
            BNE     .ONCE
            LEA     DATPLYSW,A1
            BRA     .ENDDECOD
.ONCE
            LEA     DATPLXNW,A1
            BRA     .ENDDECOD
.LOW31
            CMP.W   #8,(PLCANPOS)
            BNE     .NUEVE
            LEA     DATPLYS,A1
            BRA     .ENDDECOD
.NUEVE
            LEA     DATPLXS,A1
            BRA     .ENDDECOD


            
.LOW1
            CMP.W   #4,(PLCANPOS)
            BLO     .LOW211
            CMP.W   #6,(PLCANPOS)
            BLO     .LOW311
            BNE     .SIETE
            LEA     DATPLYSE,A1
            BRA     .ENDDECOD
.SIETE
            LEA     DATPLXSE,A1
            BRA     .ENDDECOD
.LOW311
            CMP.W   #4,(PLCANPOS)
            BNE     .CINCO
            LEA     DATPLYE,A1
            BRA     .ENDDECOD
.CINCO
            LEA     DATPLXE,A1
            BRA     .ENDDECOD
.LOW211
            CMP.W   #2,(PLCANPOS)
            BLO     .LOW321
            BNE     .TRES
            LEA     DATPLYNE,A1
            BRA     .ENDDECOD
.TRES
            LEA     DATPLXNW,A1
            BRA     .ENDDECOD
.LOW321
            CMP.W   #0,(PLCANPOS)
            BNE     .UNO
            LEA     DATPLYN,A1
            BRA     .ENDDECOD
.UNO
            LEA     DATPLXN,A1
.ENDDECOD           
            MOVEM.L (A7)+,D0-D7
            RTS
            
; -----------------------------------------------------------------------------
ENIMASEL
; SELECCIONA LA POSICIÓN DEL TANQUE Y DEL CAÑÓN PARA 
; DIBUJAR AL ENEMIGO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - A1
; -----------------------------------------------------------------------------

            MOVEM.L D0-D7,-(A7)
            CMP.W   #8,(ENCANPOS)
            BLO     .ELOW1     
            CMP.W   #12,(ENCANPOS)
            BLO     .ELOW2
            CMP.W   #14,(ENCANPOS)
            BLO     .ELOW3
            BNE     .EQUINCE
            LEA     DATENYNW,A1
            BRA     .EENDDCOD
.EQUINCE
            LEA     DATENXNW,A1
            BRA     .EENDDCOD
.ELOW3
            CMP.W   #12,(ENCANPOS)
            BNE     .ETRECE
            LEA     DATENYW,A1
            BRA     .EENDDCOD
.ETRECE
            LEA     DATENXNW,A1
            BRA     .EENDDCOD
.ELOW2
            CMP.W   #10,(ENCANPOS)
            BLO     .ELOW31
            BNE     .EONCE
            LEA     DATENYSW,A1
            BRA     .EENDDCOD
.EONCE
            LEA     DATENXNW,A1
            BRA     .EENDDCOD
.ELOW31
            CMP.W   #8,(ENCANPOS)
            BNE     .ENUEVE
            LEA     DATENYS,A1
            BRA     .EENDDCOD
.ENUEVE
            LEA     DATENXS,A1
            BRA     .EENDDCOD
.ELOW1
            CMP.W   #4,(ENCANPOS)
            BLO     .ELOW211
            CMP.W   #6,(ENCANPOS)
            BLO     .ELOW311
            BNE     .ESIETE
            LEA     DATENYSE,A1
            BRA     .EENDDCOD
.ESIETE
            LEA     DATENXSE,A1
            BRA     .EENDDCOD
.ELOW311
            CMP.W   #4,(ENCANPOS)
            BNE     .ECINCO
            LEA     DATENYE,A1
            BRA     .EENDDCOD
.ECINCO
            LEA     DATENXE,A1
            BRA     .EENDDCOD
.ELOW211
            CMP.W   #2,(ENCANPOS)
            BLO     .ELOW321
            BNE     .ETRES
            LEA     DATENYNE,A1
            BRA     .EENDDCOD
.ETRES
            LEA     DATENXNW,A1
            BRA     .EENDDCOD
.ELOW321
            CMP.W   #0,(ENCANPOS)
            BNE     .EUNO
            LEA     DATENYN,A1
            BRA     .EENDDCOD
.EUNO
            LEA     DATENXN,A1
.EENDDCOD           
            MOVEM.L (A7)+,D0-D7
            RTS
            
; ----------------------------------------------------------
IMAPLOT
; DIBUJA UNA IMAGEN
; INPUT     : A2: (A2)  CONTIENE LA DIMENSIÓN X DE LA IMAGEN (LA MITAD)
;           :     2(A2) CONTIENE LA DIMENSIÓN Y DE LA IMAGEN (LA MITAD)
;           : A0: DIRECCIÓN DE LA IMAGEN
; OUTPUT    : NONE
; MODIFIES  : NONE
; ----------------------------------------------------------            
            
            MOVEM.L D0-D6/A0-A2,-(A7)
            
            MOVE.W  #SCRWIDTH/2,D1
            MOVE.W  #SCRHEIGH/2,D2
            SUB.W   (A2),D1          ; PARA CENTRAR LA IMAGEN EN LA PANTALLA
            SUB.W   2(A2),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADDQ.W  #1,D3
            ADDQ.W  #1,D4
.FILA
            MOVE.W  #SCRWIDTH/2,D1
            SUB.W   (A2),D1
            MOVE.W  D1,D3
            
            ADDQ.W  #1,D2
            ADDQ.W  #1,D4
.COLUMNA

            MOVE.L  D1,D5
            MOVE.L  (A0)+,D1
            MOVE.B  #80,D0
            TRAP    #15
            MOVE.L  D5,D1

            ADDQ.W  #1,D1
            ADDQ.W  #1,D3

            MOVE.B  #84,D0
            TRAP    #15
            
            MOVE.W  #SCRWIDTH/2,D6
            ADD.W   (A2),D6
            CMP.W   D6,D3
            BLT     .COLUMNA
            
            MOVE.W  #SCRHEIGH/2,D6
            ADD.W   2(A2),D6
            CMP.W   D6,D4
            BLT     .FILA
            
            MOVEM.L (A7)+,D0-D6/A0-A2
            
            RTS
            
; ----------------------------------------------------------
TANKCOL
; COLOCA EN A3 EL NÚMERO DE COLISIONES QUE TENDRÁ EL TANQUE EN EL SIGUIENTE MOVIMIENTO
; INPUT     : D0: POSICIÓN X DEL TANQUE
;             D1: POSICION Y DEL TANQUE 
; OUTPUT    : A3: NÚMERO DE COLISIONES DEL TANQUE
; MODIFIES  : POSXTEMP
;             POSYTMP
; ----------------------------------------------------------
            MOVEM.L A0-A1/D0-D7,-(A7)
            MOVE.W  #0,(COLTANKP)
            MOVE.W  #0,A3
            MOVE.W  D0,(POSXTEMP)
            MOVE.W  D1,(POSYTEMP)
            MOVE.W  (A0),D2                 ; PREPARE SHOT COORDINATES FOR
            MOVE.W  2(A0),D3                ; COLLISION CHECK
            MOVE.W  #TANWIDTH/2,D5
            MOVE.W  #TANHEIGH/2,D7
            MOVE.L  A0,A1
            MOVE.W  #TANENEM,D0
            JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .CHKPLAY
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            SUB.W   #TANWIDTH/2,D0
            SUB.W   #TANHEIGH/2,D1
            MOVE.W  #TANWIDTH,D4
            MOVE.W  #TANHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BEQ     .NTHG
            ADDQ.W  #1,A3
.NTHG
            MOVE.W  #TANENEM,D0
            JSR     DMMNEXTO
            BRA     .LOOP
.CHKPLAY    ; PLAYER TANK COLLISIONS
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            CMP.L   #0,A0
            BEQ     .NTHG1
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            SUB.W   #TANWIDTH/2,D0
            SUB.W   #TANHEIGH/2,D1
            MOVE.W  #TANWIDTH,D4
            MOVE.W  #TANHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BEQ     .NTHG1
            MOVE.W  #1,(COLTANKP)
            ADDQ.W  #1,A3
.NTHG1
            MOVEM.L (A7)+,A0-A1/D0-D7
            RTS


; -----------------------------------------------------------------------------
COLBYKMKZ
; LE QUITA AL JUGADOR LA VIDA POR COLISIÓN DE KAMIKAZE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------

            MOVEM.L D0-D7/A0-A1,-(A7)
            MOVE.W  #TANPLAY,D0
            JSR     DMMFRSTO
            CMP.L   #0,A0
            BEQ     .NTHG1
            SUB.W   #3*BULDMG,16(A0)
            CMP.W   #0,16(A0)
            BGT     .NTHG1
            MOVE.W  #KILLPLYR,(PLYRDEAD)
.NTHG1            
            MOVEM.L (A7)+,A0-A1/D0-D7
            RTS

; -----------------------------------------------------------------------------
UTLRAND
; PROVIDES A PSEUDO-RANDOM BYTE
; INPUT    - NONE
; OUTPUT   - D0.L RANDOM VALUE (ONLY BYTE)
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            LEA     .RANDVEC,A0
            CLR.L   D0
            MOVE.B  (UTLRNDIX),D0
            MOVE.B  (A0,D0.L),D0
            ADDQ.B  #1,(UTLRNDIX)
            MOVE.L  (A7)+,A0
            RTS


.RANDVEC    DC.B    162, 238, 154, 12 , 245, 36 , 32 , 103
            DC.B    42 , 163, 81 , 38 , 224, 172, 19 , 69
            DC.B    117, 81 , 202, 253, 51 , 235, 108, 154
            DC.B    96 , 204, 231, 184, 154, 235, 34 , 203
            DC.B    29 , 118, 181, 149, 176, 137, 62 , 108
            DC.B    57 , 21 , 72 , 201, 110, 202, 159, 41
            DC.B    67 , 231, 226, 124, 55 , 37 , 84 , 62
            DC.B    233, 148, 206, 233, 228, 82 , 243, 78
            DC.B    55 , 109, 154, 132, 162, 40 , 30 , 39
            DC.B    25 , 226, 198, 119, 128, 212, 232, 225
            DC.B    10 , 90 , 50 , 103, 51 , 194, 222, 40
            DC.B    89 , 128, 220, 14 , 87 , 252, 243, 252
            DC.B    138, 171, 188, 247, 7  , 77 , 29 , 234
            DC.B    239, 213, 119, 110, 30 , 187, 131, 23
            DC.B    214, 224, 42 , 143, 189, 40 , 212, 130
            DC.B    19 , 79 , 102, 236, 10 , 100, 122, 188
            DC.B    86 , 82 , 154, 22 , 155, 144, 7  , 199
            DC.B    6  , 138, 164, 247, 1  , 218, 166, 82
            DC.B    242, 231, 119, 40 , 177, 118, 220, 102
            DC.B    164, 66 , 227, 129, 177, 103, 165, 108
            DC.B    191, 206, 250, 22 , 191, 56 , 30 , 161
            DC.B    209, 139, 80 , 12 , 95 , 73 , 168, 56
            DC.B    222, 76 , 20 , 162, 64 , 220, 93 , 12
            DC.B    182, 155, 10 , 56 , 93 , 171, 89 , 6
            DC.B    226, 27 , 221, 117, 21 , 130, 101, 18
            DC.B    138, 38 , 81 , 48 , 159, 71 , 57 , 21
            DC.B    30 , 138, 187, 113, 198, 110, 185, 152
            DC.B    159, 71 , 229, 52 , 148, 39 , 77 , 6
            DC.B    125, 6  , 214, 186, 48 , 15 , 212, 22
            DC.B    236, 127, 126, 3  , 207, 45 , 193, 2
            DC.B    148, 91 , 35 , 242, 139, 205, 248, 237
            DC.B    116, 51 , 236, 185, 15 , 213, 221, 6
            















*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~
