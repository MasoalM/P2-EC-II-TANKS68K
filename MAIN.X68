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

            TRAP    #1

; UPDATE GAME LOGIC

    JSR     BULUPD
    JSR     TANUPD

; --- SYNC -------------------------------------------------

            ; sincronismo incorrecto para salir del paso
            MOVE.B  #23,D0
            MOVE.L  #1,D1
            TRAP    #15


; --- PLOT -------------------------------------------------
    
    JSR     SCOPLOT    
    JSR     BULPLOT
    JSR     TANPLOT
    
    TRAP    #0              ; UPDATE DOUBLE BUFFER

    BRA     .LOOP

    SIMHALT
    
    INCLUDE "VARS.X68"  
    INCLUDE "SYSVARS.X68"

    END    START







*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
