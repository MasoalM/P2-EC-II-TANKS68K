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
                     
            MOVEM.L  D1/A0-A1,-(A7)            
            LEA     FILEDATA,A0             ; DESTINATION ADDRESS
            LEA     .FILENAME,A1            ; FILE NAME
            
            MOVE.W  #15,D1
            
            LEA     FILPLDAT,A0             ; DESTINATION ADDRESS
            LEA     .FILPLXE,A1             ; FILE NAME
.FILLOOP1            
            CMP.W   #0,(A1)+
            BEQ     .DONE1
            JSR     FILLOAD
            DBRA    D1,.FILLOOP1
.DONE1            
            LEA     FILENDAT,A0             ; DESTINATION ADDRESS
            LEA     .FILENXE,A1             ; FILE NAME
.FILLOOP2 
            CMP.W   #0,(A1)+
            BEQ     .DONE2
            JSR     FILLOAD
            BRA     .FILLOOP2

.DONE2               
            
            MOVEM.L  (A7)+,D1/A0-A1
            
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
