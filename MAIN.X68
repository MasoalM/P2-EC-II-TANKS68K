*-----------------------------------------------------------
* Title      :  TANKS
* Written by :  Sergi Villalonga Gamundí y Marcos Socías Alberto
* Date       :  
* Description:
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
    INCLUDE "BULLET.X68"
    INCLUDE "TANK.X68"
    INCLUDE "SCORE.X68"
    INCLUDE "MAP.X68"           ; antes todo lo de mapa y casilla estaba después del game (creo que así es más correcto)
    INCLUDE "DATA/MAPDATA.X68"
    INCLUDE "DATA/CASDATA.X68"
    INCLUDE "CASILLA.X68"
    INCLUDE "NIVEL.X68"
    INCLUDE "GAME.X68"
    INCLUDE "INTRO.X68"
    INCLUDE "INSTRUCTIONS.X68"
    INCLUDE "WIN.X68"
    INCLUDE "GOVER.X68"
    INCLUDE "STATES.X68"
    
START:

; --- INITIALIZATION ---------------------------------------

            ORI.W   #$0700,SR   ; DESHABILITAR INTERRUPCIONES
            JSR     SYSINIT
            JSR     UTLINIT
            JSR     STAINIT
    
.LOOP

; --- UPDATE -----------------------------------------------

; READ INPUT DEVICES

            TRAP    #KBDUPTN
;            TRAP    #MOUUPTN

; UPDATE GAME LOGIC
    
            JSR     STAUPD
            
; --- SYNC -------------------------------------------------

.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT
            CLR.B   (SCRINTCT)


; --- PLOT -------------------------------------------------
    
            JSR     STAPLOT         
 
            TRAP    #SCRUPTN            ; UPDATE DOUBLE BUFFER

            BRA     .LOOP

    SIMHALT
    
    INCLUDE "VARS.X68"  
    INCLUDE "LIB/UTLVARS.X68"
    INCLUDE "SYSVARS.X68"
    INCLUDE "LIB/DMMVARS.X68"

    END    START




































*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
