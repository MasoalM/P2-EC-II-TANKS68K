*-----------------------------------------------------------
* Title      :  TANKS
* Written by :  Sergi Villalonga Gamundí y Marcos Socías Alberto
* Date       :  
* Description:
*-----------------------------------------------------------
    ORG    $1000
    
    INCLUDE "CONST.X68"
    INCLUDE "SYSCONST.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "BULLET.X68"
    INCLUDE "TANK.X68"
    INCLUDE "SCORE.X68"
    
START:

; --- INITIALIZATION ---------------------------------------

    JSR     SYSINIT
    JSR     BULINIT
    JSR     TANINIT
    JSR     SCOINIT 

.LOOP

; --- UPDATE -----------------------------------------------

; READ INPUT DEVICES

; UPDATE GAME LOGIC

    JSR     BULUPD
    JSR     TANUPD

; --- SYNC -------------------------------------------------

; --- PLOT -------------------------------------------------
    
    JSR     SCOPLOT    
    JSR     BULPLOT
    JSR     TANPLOT

    BRA     .LOOP

    SIMHALT
    
    INCLUDE "VARS.X68"  
    INCLUDE "SYSVARS.X68"

    END    START





*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
