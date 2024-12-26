*-----------------------------------------------------------
* Título      : TANKS 68K!
* Escrito por : Sergi Villalonga Gamundí y Marcos Socías Alberto 
* Descripción : Juego donde eres un tanque verde que se enfrenta
*               a otros tanques de color rojo. Se basa en 3 niveles
*               que debes superar antes de ser derrotado.
*-----------------------------------------------------------
        ORG    $1000
    
        INCLUDE "SYSCONST.X68"
        INCLUDE "CONST.X68"
        INCLUDE "LIB/DMMCONST.X68"
        INCLUDE "LIB/UTLCONST.X68"
        INCLUDE "LIB/DMMCODE.X68"
        INCLUDE "SYSTEM.X68"
        INCLUDE "LIB/AGLCODE.X68"
        INCLUDE "LIB/UTLCODE.X68"
        INCLUDE "LIB/FILELOAD.X68"
        INCLUDE "BULLET.X68"
        INCLUDE "TANK.X68"
        INCLUDE "SCORE.X68"
        INCLUDE "MAP.X68"         
        INCLUDE "DATA/MAPDATA.X68"
        INCLUDE "LEVEL.X68"
        INCLUDE "FPS.X68"
        INCLUDE "GAME.X68"
        INCLUDE "INTRO.X68"
        INCLUDE "INSTRUCTIONS.X68"
        INCLUDE "WIN.X68"
        INCLUDE "GOVER.X68"
        INCLUDE "STATES.X68"
        INCLUDE "LOADFILES.X68"
        
START:

; --- INITIALIZATION ---------------------------------------

            ORI.W   #$0700,SR               ; DESHABILITAR INTERRUPCIONES
            
            JSR     SYSINIT
            JSR     FPSINIT
            JSR     UTLINIT
            
            MOVE.L  #$00054B17,D1           ; COLOR FONDO
            MOVE.B  #81,D0
            TRAP    #15

            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH,D3
            MOVE.L  #SCRHEIGH,D4
            MOVE.B  #87,D0
            TRAP    #15

            LEA     .TXT,A0                 ; TEXTO DE LA PANTALLA DE CARGA
            MOVE.B  #15,D0
            JSR     UTLPRINT
            
            JSR     LOADFILES
            
            JSR     STAINIT    

; --- UPDATE -----------------------------------------------

.LOOP

; LEER DISPOSITIVOS DE ENTRADA
            TRAP    #KBDUPTN

; ACTUALIZAR LÓGICA DEL JUEGO
            JSR     STAUPD
            JSR     FPSUPD
            
; --- SYNC -------------------------------------------------

.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT
            CLR.B   (SCRINTCT)


; --- PLOT -------------------------------------------------
            
            CMP.W   #0,(DOPLOT)
            BEQ     .NOTPLOT 

            MOVE.W  SHWFPS,D6
            CMP.W   #20,D6
            BHI     .DOPLOT
            
            ; LOW FPS (FPS <= 20)
            CMP.W   #15,D6
            BLS     .SOLOWFPS
            BTST    #16,(SCRCYCCT)
            BEQ     .NOTPLOT
            BNE     .DOPLOT   
            
.SOLOWFPS   ; SO LOW FPS (FPS <= 15)
            BTST    #8,(SCRCYCCT)    
            BEQ     .NOTPLOT        
.DOPLOT            
            JSR     STAPLOT
            JSR     FPSPLOT 
 
            TRAP    #SCRUPTN                ; ACTUALIZAR DOUBLE BUFFER
.NOTPLOT

            BRA     .LOOP   

.TXT        DC.B    'CARGANDO...',0
            DS.W    0         

            SIMHALT
    
            INCLUDE "VARS.X68"  
            INCLUDE "LIB/UTLVARS.X68"
            INCLUDE "SYSVARS.X68"
            INCLUDE "LIB/DMMVARS.X68"

            END    START
    
      



























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
