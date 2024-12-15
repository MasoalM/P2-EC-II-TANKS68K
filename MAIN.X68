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
    INCLUDE "LIB/FILELOAD.X68"
    INCLUDE "BULLET.X68"
    INCLUDE "TANK.X68"
    INCLUDE "SCORE.X68"
    INCLUDE "MAP.X68"         
    INCLUDE "DATA/MAPDATA.X68"
    INCLUDE "DATA/CASDATA.X68"
    INCLUDE "CASILLA.X68"
    INCLUDE "NIVEL.X68"
    INCLUDE "FPS.X68"
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
            JSR     FPSINIT
            JSR     UTLINIT
            
            
            MOVEM.L  A0-A1,-(A7)
            LEA     FILEDATA,A0            ; DESTINATION ADDRESS
            LEA     .FILENAME,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     FILPLDAT,A0            ; DESTINATION ADDRESS
            LEA     .FILEPLYR,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     FILENDAT,A0            ; DESTINATION ADDRESS
            LEA     .FILEENEM,A1           ; FILE NAME
            JSR     FILLOAD
            
            MOVEM.L  (A7)+,A0-A1
            
            JSR     STAINIT

; --- UPDATE -----------------------------------------------

.LOOP

; READ INPUT DEVICES
            TRAP    #KBDUPTN
            ;TRAP    #MOUUPTN

; UPDATE GAME LOGIC
            JSR     STAUPD
            JSR     FPSUPD
            
; --- SYNC -------------------------------------------------

.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT
            CLR.B   (SCRINTCT)


; --- PLOT -------------------------------------------------
            
            JSR     STAPLOT
            JSR     FPSPLOT 

            CMP.W   #0,(DOPLOT)
            BEQ     .NOTPLOT        
 
            TRAP    #SCRUPTN            ; UPDATE DOUBLE BUFFER
.NOTPLOT
            BRA     .LOOP

.FILENAME    DC.B    'pythonProject/SALIDA.bin',0 
.FILEPLYR    DC.B    'pythonProject/PLAYER.bin',0
.FILEENEM    DC.B    'pythonProject/ENEMY.bin',0            

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
