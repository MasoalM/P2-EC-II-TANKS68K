*-----------------------------------------------------------
*   CONSTANTES DEL SISTEMA
*-----------------------------------------------------------

; --- CONSTANTES RELACIONADAS CON LA PANTALLA --------------

SCRWIDTH    EQU     640         ; ANCHURA DE LA PANTALLA DEL JUEGO
SCRHEIGH    EQU     480         ; ALTURA DE LA PANTALLA DEL JUEGO
SCRFPS      EQU     50          ; FRAMES POR SEGUNDO DE LA PANTALLA

; --- KEYCODES ---------------------------------------------

KBDLEFT     EQU     'A'         ; TECLA A DEL TECLADO
KBDUP       EQU     'W'         ; TECLA W DEL TECLADO
KBDRIGHT    EQU     'D'         ; TECLA D DEL TECLADO
KBDDOWN     EQU     'S'         ; TECLA S DEL TECLADO
KBDFIRE     EQU     ' '         ; TECLA ESPACIO DEL TECLADO
KBDINSTR    EQU     'I'         ; TECLA I DEL TECLADO

; --- SOUND IDENTIFIERS ------------------------------------

SNDINTRO    EQU     0           ; MÚSICA INTRO
SNDINSTR    EQU     1           ; MÚSICA INSTRUCCIONES
SNDWALL     EQU     2           ; MÚSICA BALA CON PARED
SNDHIT      EQU     3           ; MÚSICA BALA CONTRA TANQUE
SNDKILL     EQU     4           ; MÚSICA TANQUE MUERTO
SNDDISP     EQU     5           ; MÚSICA BALA DISPARADA
SNDGVR1     EQU     6           ; MÚSICA DERROTA
SNDWIN      EQU     7           ; MÚSICA VICTORIA
SNDEXPLO    EQU     8           ; MÚSICA EXPLOSIVA

; --- TRAP NUMBERS -----------------------------------------

SCRUPTN     EQU     0           ; SCREEN UPDATE TRAP NUMBER
KBDUPTN     EQU     1           ; KEYBOARD UPDATE TRAP NUMBER
MOUUPTN     EQU     2           ; MOUSE UPDATE TRAP NUMBER
SNDPLTN     EQU     3           ; SOUND PLAY TRAP NUMBER

; --- INTERRUPT NUMBERS ------------------------------------

SCRINTN     EQU     1           ; TIMED INTERRUPT NUMBER

















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
