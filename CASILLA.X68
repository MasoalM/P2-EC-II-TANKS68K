*-----------------------------------------------------------
* Title      : Clase CASILLA
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

CASPLOT:

    MOVEM.W D5-D7/A0-A6, -(A7) 
    
    ;LEEMOS LA CASILLA EN MEMORIA
    LEA.L   CASDATA,A0
    
    ;GUARDAMOS LOS REGISTROS, EL MÉTODO PRINCIPAL LOS USA
    MOVE.W  D1,D5
    MOVE.W  D2,D6
    MOVE.W  D3,D7
    MOVE.W  D4,A1
    
    ;AJUSTAMOS UNOS VALORES
    MOVE.W  D2,D4
    ADDQ.W  #1,D4
    
    ;INICIO DEL BUCLE QUE RECORRE LA MATRIZ CASILLA
.SEGX
    MOVE.W  D5,D3
.SEG    
    SUBQ.W  #1,D4
        
    ;MIRAMOS DE QUE COLOR ES EL PÍXEL    
    CMP.W   #$00,(A0)
    BEQ     .MARMOS
    CMP.W   #$01,(A0)
    BEQ     .OCRTRA
    CMP.W   #$02,(A0)
    BEQ     .MADNOG
    CMP.W   #$03,(A0)
    BEQ     .CAFTSTINT
    CMP.W   #$04,(A0)
    BEQ     .TRAHUM
    CMP.W   #$05,(A0)
    BEQ     .MADCBZ
    CMP.W   #$06,(A0)
    BEQ     .BRZVEJ
    
    ;SEGÚN EL COLOR, COLOCAMOS LA BROCHA
.MARMOS 
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #MARRONMOSTAZA,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #MARRONMOSTAZA,D1
    TRAP    #15
    BRA     .FINCOL

.OCRTRA
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #OCRETIERRA,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #OCRETIERRA,D1
    TRAP    #15
    BRA     .FINCOL

.MADNOG
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #MADERANOGAL,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #MADERANOGAL,D1
    TRAP    #15
    BRA     .FINCOL

.CAFTSTINT    
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #CAFETOSTADOINTENSO,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #CAFETOSTADOINTENSO,D1
    TRAP    #15
    BRA     .FINCOL

.TRAHUM
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #TIERRAHUMEDA,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #TIERRAHUMEDA,D1
    TRAP    #15
    BRA     .FINCOL

.MADCBZ
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #MADERACARBONIZADA,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #MADERACARBONIZADA,D1
    TRAP    #15
    BRA     .FINCOL

.BRZVEJ        
    ; SET CONTOUR COLOR
    MOVE.B  #80,D0
    MOVE.L  #BRONCEVIEJO,D1
    TRAP    #15
            
    ; SET FILL COLOR
    MOVE.B  #81,D0
    MOVE.L  #BRONCEVIEJO,D1
    TRAP    #15

.FINCOL
    
    ;FIJAMOS COORDENADAS
    MOVE.W  D3,D1
    MOVE.W  D4,D2
    ADDQ.W  #1,D3
    ADDQ.W  #1,D4
    
    ; DRAW RECTANGLE (CASILLA)
    MOVE.B  #87,D0
    TRAP    #15
           
    ;INCREMENTAMOS A0
    ADDQ.L  #2,A0       
           
    ;COMPROBAMOS EL BUCLE 
    CMP.W   D3,D7
    BNE     .SEG
    CMP.W   D4,A1
    BNE     .SEGX
    ;RESTAURAMOS
    MOVE.W  D5,D1
    MOVE.W  D6,D2
    MOVE.W  D7,D3
    MOVE.W  A1,D4

    MOVEM.W (A7)+,D5-D7/A0-A6
RTS
*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
