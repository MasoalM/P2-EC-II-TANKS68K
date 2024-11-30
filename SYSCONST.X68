*-----------------------------------------------------------
*   CONSTANTES DEL SISTEMA
*-----------------------------------------------------------

; --- CONSTANTES RELACIONADAS CON LA PANTALLA --------------

SCRWIDTH    EQU     640         ; ANCHURA DE LA PANTALLA DEL JUEGO
SCRHEIGH    EQU     480         ; ALTURA DE LA PANTALLA DEL JUEGO
SCRFPS      EQU     50          ; SCREEN FRAMES PER SECOND, EN NUESTRO CASO 50 FPS (UNA INTERRUPCIÓN CADA 20 ms)

; --- KEYCODES ---------------------------------------------

KBDLEFT     EQU     'A'
KBDUP       EQU     'W'
KBDRIGHT    EQU     'D'
KBDDOWN     EQU     'S'
KBDFIRE     EQU     ' '
KBDPAUSE    EQU     'P'

; --- SOUND IDENTIFIERS ------------------------------------

SNDMUSIC    EQU     0
SNDWALL     EQU     1
SNDHIT      EQU     2
SNDKILL     EQU     3
SNDWAA      EQU     4
SNDBULEX    EQU     5
SNDDISP     EQU     6

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
