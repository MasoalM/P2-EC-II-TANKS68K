*-----------------------------------------------------------
* Title      :  TANKS
* Written by :  Sergi Villalonga Gamundí y Marcos Socías Alberto
* Date       :  
* Description:
*-----------------------------------------------------------
    ORG    $1000
    
    INCLUDE "CONST.X68"
    INCLUDE "SYSCONST.X68"
    INCLUDE "LIB/DMMCONST.X68"
    INCLUDE "LIB/DMMCODE.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "LIB/AGLCODE.X68"
    INCLUDE "LIB/UTLCODE.X68"
    INCLUDE "BULLET.X68"
    INCLUDE "TANK.X68"
    INCLUDE "SCORE.X68"
    INCLUDE "GAME.X68"
    INCLUDE "MAP.X68"
    INCLUDE "DATA/MAPDATA.X68"
    INCLUDE "DATA/CASDATA.X68"
    INCLUDE "CASILLA.X68"
    
START:

; --- INITIALIZATION ---------------------------------------

            ORI.W   #$0700,SR   ; DESHABILITAR INTERRUPCIONES
            JSR     SYSINIT
            JSR     UTLINIT
            JSR     GAMINIT
    
.LOOP

; --- UPDATE -----------------------------------------------

            ;MOVE.B  #SNDMUSIC,D7
            ;TRAP    #SNDPLTN

; READ INPUT DEVICES

            TRAP    #KBDUPTN

; UPDATE GAME LOGIC
    
            JSR     GAMUPD
            
; --- SYNC -------------------------------------------------

.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT
            CLR.B   (SCRINTCT)


; --- PLOT -------------------------------------------------
    
            JSR     GAMPLOT
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
