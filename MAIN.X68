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
            
            LEA     DATPLXE,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXN,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXN,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXNE,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXNE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXNW,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXNW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXS,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXS,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXSE,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXSE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXSW,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXSW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLXW,A0            ; DESTINATION ADDRESS
            LEA     .FILPLXW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYE,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYN,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYN,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYNE,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYNE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYNW,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYNW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYS,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYS,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYSE,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYSE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYSW,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYSW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATPLYW,A0            ; DESTINATION ADDRESS
            LEA     .FILPLYW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXE,A0            ; DESTINATION ADDRESS
            LEA     .FILENXE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXN,A0            ; DESTINATION ADDRESS
            LEA     .FILENXN,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXNE,A0            ; DESTINATION ADDRESS
            LEA     .FILENXNE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXNW,A0            ; DESTINATION ADDRESS
            LEA     .FILENXNW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXS,A0            ; DESTINATION ADDRESS
            LEA     .FILENXS,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXSE,A0            ; DESTINATION ADDRESS
            LEA     .FILENXSE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXSW,A0            ; DESTINATION ADDRESS
            LEA     .FILENXSW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENXW,A0            ; DESTINATION ADDRESS
            LEA     .FILENXW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYE,A0            ; DESTINATION ADDRESS
            LEA     .FILENYE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYN,A0            ; DESTINATION ADDRESS
            LEA     .FILENYN,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYNE,A0            ; DESTINATION ADDRESS
            LEA     .FILENYNE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYNW,A0            ; DESTINATION ADDRESS
            LEA     .FILENYNW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYS,A0            ; DESTINATION ADDRESS
            LEA     .FILENYS,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYSE,A0            ; DESTINATION ADDRESS
            LEA     .FILENYSE,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYSW,A0            ; DESTINATION ADDRESS
            LEA     .FILENYSW,A1           ; FILE NAME
            JSR     FILLOAD
            
            LEA     DATENYW,A0            ; DESTINATION ADDRESS
            LEA     .FILENYW,A1           ; FILE NAME
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
            
            MOVE.W  SHWFPS,D6
            CMP.W   #20,D6
            BLS     .LOWFPS

            CMP.W   #0,(DOPLOT) ; subir esto arriba para que se vea la pantalla de título?
            BEQ     .NOTPLOT 
            BRA     .DOPLOT

.LOWFPS 
            CMP.W   #15,D6
            BLS     .SOLOWFPS
            BTST    #16,(SCRCYCCT)
            BEQ     .NOTPLOT
            BNE     .DOPLOT   
.SOLOWFPS
            BTST    #8,(SCRCYCCT)    
            BEQ     .NOTPLOT        
.DOPLOT            
            JSR     STAPLOT
            JSR     FPSPLOT 
 
            TRAP    #SCRUPTN            ; UPDATE DOUBLE BUFFER
.NOTPLOT

            BRA     .LOOP

.FILENAME       DC.B    'pythonProject/OUTPUT/SALIDA.bin',0 
.FILPLXE        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_E.bin',0
.FILPLXN        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_N.bin',0
.FILPLXNE       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_NE.bin',0
.FILPLXNW       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_NW.bin',0
.FILPLXS        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_S.bin',0
.FILPLXSE       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_SE.bin',0
.FILPLXSW       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_SW.bin',0
.FILPLXW        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_X_W.bin',0
.FILPLYE        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_E.bin',0
.FILPLYN        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_N.bin',0
.FILPLYNE       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_NE.bin',0
.FILPLYNW       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_NW.bin',0
.FILPLYS        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_S.bin',0
.FILPLYSE       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_SE.bin',0
.FILPLYSW       DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_SW.bin',0
.FILPLYW        DC.B    'pythonProject/OUTPUT/PLAYER_OUTPUT/PLAYER_Y_W.bin',0
.FILENXE        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_E.bin',0
.FILENXN        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_N.bin',0
.FILENXNE       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_NE.bin',0
.FILENXNW       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_NW.bin',0
.FILENXS        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_S.bin',0
.FILENXSE       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_SE.bin',0
.FILENXSW       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_SW.bin',0
.FILENXW        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_X_W.bin',0
.FILENYE        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_E.bin',0
.FILENYN        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_N.bin',0
.FILENYNE       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_NE.bin',0
.FILENYNW       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_NW.bin',0
.FILENYS        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_S.bin',0
.FILENYSE       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_SE.bin',0
.FILENYSW       DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_SW.bin',0
.FILENYW        DC.B    'pythonProject/OUTPUT/ENEMY_OUTPUT/ENEMY_Y_W.bin',0
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
