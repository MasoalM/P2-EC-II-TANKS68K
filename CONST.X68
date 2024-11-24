*-----------------------------------------------------------
* CONSTANTES DEL JUEGO
*-----------------------------------------------------------
    
; --- CONSTANTES RELACIONADAS CON LA BALA DEL TANQUE -------

BULRAD      EQU     4           ; RADIO DE LA BALA
BULPCOL     EQU     $0031494D   ; COLOR DE CONTORNO DE LA BALA        
BULFCOL     EQU     $007CB4BA   ; COLOR DE RELLENO DE LA BALA  
BULSPEED    EQU     4           ; MAGNITUD DE LA VELOCIDAD X E Y DE LA BALA
BULDMG      EQU     40          ; DAÑO DE LA BALA
MAXTOUCH    EQU     4           ; TOQUES MÁXIMOS DE LA BALA CON LAS PAREDES

; --- CONSTANTES RELACIONADAS CON EL TANQUE ----------------

TANWIDTH    EQU     24                      ; ANCHURA DEL TANQUE
TANHEIGH    EQU     24                      ; ALTURA DEL TANQUE
TANSPEED    EQU     2                       ; MAGNITUD DE LA VELOCIDAD X E Y DEL TANQUE
PLRINITX    EQU     50                      ; POSICIÓN X INICIAL DEL JUGADOR
PLRINITY    EQU     SCRHEIGH/2              ; POSICIÓN Y INICIAL DEL JUGADOR
PLRINILF    EQU     BULDMG*10               ; VIDA INICIAL DEL TANQUE JUGADOR
ENEINILF    EQU     BULDMG*3                ; VIDA INICIAL DEL TANQUE ENEMIGO
PLRLIFEH    EQU     20                      ; ALTURA DE LA BARRA DE VIDA DEL JUGADOR
PLRLIFEY    EQU     SCRHEIGH-PLRLIFEH-6     ; POSICIÓN Y DE LA BARRA DE VIDA DEL JUGADOR
PLRLIFEC    EQU     $000000FF               ; COLOR DE LA BARRA DE VIDA
MAXBULL     EQU     3                       ; CANTIDAD MÁXIMA DE BALAS DISPARADAS SIMULTÁNEAMENTE
;PLRUMDMG    EQU     %00000001               ; UPDATE DAMAGE MASK
;PLRPMDMG    EQU     %00000010               ; PLOT DAMAGE MASK
;PLRUBDMG    EQU     0                       ; UPDATE DAMAGE BIT
;PLRPBDMG    EQU     1                       ; PLOT DAMAGE BIT


; --- CONSTANTES RELACIONADAS CON EL MARCADOR --------------

SCOFCOL     EQU     $00000000   ; COLOR DE FONDO DEL TEXTO
            ; podríamos poner una cte del color del texto
SCOLINE     EQU     $0101       ; COORDENADAS DE LA LÍNEA DE TEXTO ($CXCY)

; --- CONSTANTES RELACIONADAS CON EL MAPA ------------------

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

; --- CONSTANTES RELACIONADAS CON LAS CASILLAS DEL MAPA

MARRONMOSTAZA           EQU $002873A6
OCRETIERRA              EQU $001C5074
MADERANOGAL             EQU $00143851
CAFETOSTADOINTENSO      EQU $000E2739
TIERRAHUMEDA            EQU $000A1B28
MADERACARBONIZADA       EQU $0007131C
BRONCEVIEJO             EQU $00001E30




















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
