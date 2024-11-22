*-----------------------------------------------------------
* CONSTANTES DEL JUEGO
*-----------------------------------------------------------
    
; --- CONSTANTES RELACIONADAS CON LA BALA DEL TANQUE -------

BULRAD      EQU     4           ; RADIO DE LA BALA
BULPCOL     EQU     $0031494D   ; COLOR DE CONTORNO DE LA BALA        
BULFCOL     EQU     $007CB4BA   ; COLOR DE RELLENO DE LA BALA  
BULSPEED    EQU     4           ; MAGNITUD DE LA VELOCIDAD X E Y DE LA BALA

; --- CONSTANTES RELACIONADAS CON EL TANQUE ----------------

TANWIDTH    EQU     24          ; ANCHURA DEL TANQUE
TANHEIGH    EQU     24          ; ALTURA DEL TANQUE
TANSPEED    EQU     2           ; MAGNITUD DE LA VELOCIDAD X E Y DEL TANQUE

; --- CONSTANTES RELACIONADAS CON EL MARCADOR --------------

SCOFCOL     EQU     $00000000   ; COLOR DE FONDO DEL TEXTO
            ; podríamos poner una cte del color del texto
SCOLINE     EQU     $0101       ; COORDENADAS DE LA LÍNEA DE TEXTO ($CXCY)

; --- CONSTANTES RELACIONADAS COPN EL MAPA ------------------

MAPINIX     EQU     0           ; POSICIÓN DE INICIO DEL MAPA RESPECTO A X
MAPINIY     EQU     0           ; POSICIÓN DE INICIO DE MAPA RESPECTO A Y
MAPPIEX     EQU     20          ; NÚMERO DE CASILLAS EN EL EJE X
MAPPIEY     EQU     15          ; NÚMERO DE CASILLAS EN EL EJE Y
PIESIZX     EQU     32          ; TAMAÑO DE LAS CASILLAS EN EL EJE X
PIESIZY     EQU     32          ; TAMAÑO DE LAS CASILLAS EN EL EJE Y 

; --- CONSTANTES RELACIONADAS CON EL TIPO DE AGENTE ---------

BULTYPE     EQU     1           ; BALA
TANPLAY     EQU     2           ; TANQUE JUGADOR
TANENEM     EQU     3           ; TANQUE ENEMIGO










*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
