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
    INCLUDE "MAP.X68"
    INCLUDE "DATA/MAPDATA.X68"
    
START:

; --- INITIALIZATION ---------------------------------------

            ORI.W   #$0700,SR   ; DESHABILITAR INTERRUPCIONES
            JSR     SYSINIT
            JSR     UTLINIT
            JSR     TANINIT
            JSR     SCOINIT 
    
.LOOP

; --- UPDATE -----------------------------------------------

            ;MOVE.B  #SNDMUSIC,D7
            ;TRAP    #SNDPLTN

; READ INPUT DEVICES

            TRAP    #KBDUPTN

; UPDATE GAME LOGIC
    
            ; no reiniciamos registros con MOVEM?
            BTST.B  #4,(KBDEDGE)    ; ESPACIO PULSADO
            BEQ     .GOUPD
            
            LEA     BULINIT,A1
            LEA     BULUPD,A2
            LEA     BULPLOT,A3
            
            MOVE.W  #1,D0
            JSR     AGLADD 
    
.GOUPD      JSR     AGLUPD
            JSR     TANUPD
            
            

; --- SYNC -------------------------------------------------

.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT
            CLR.B   (SCRINTCT)


; --- PLOT -------------------------------------------------
    
            JSR     MAPPLOT
            JSR     AGLPLOT    
            JSR     SCOPLOT    
            JSR     TANPLOT
    
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
