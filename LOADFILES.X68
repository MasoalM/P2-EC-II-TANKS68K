; ------------------------------------------------------------------------------
LOADFILES
; CARGA TODOS LOS ARCHIVOS NECESARIOS DEL JUEGO. EL PRIMERO ES LA IMAGEN DE LA
; PANTALLA PRINCIPAL, EL SIGUIENTE ES LA IMAGEN DE VICTORIA,
; LOS 16 CONSECUTIVOS SON LAS IMÁGENES DEL JUGADOR Y LOS 16 SIGUIENTES SON LAS 
; IMÁGENES DEL ENEMIGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L  A0-A1,-(A7)            

            ; IMAGEN MENÚ PRINCIPAL
            LEA     FILEDATA,A0             ; DIRECCIÓN DE DESTINO
            LEA     .FILENAME,A1            ; NOMBRE DEL ARCHIVO
            JSR     FILLOAD
            
            ; IMAGEN VICTORIA
            LEA     WINDATA,A0
            LEA     .FILEWIN,A1
            JSR     FILLOAD
            
            ; IMÁGENES JUGADOR
            LEA     DATPLXE,A0       
            LEA     .FILPLXE,A1           
            JSR     FILLOAD
            
            LEA     DATPLXN,A0
            LEA     .FILPLXN,A1
            JSR     FILLOAD
            
            LEA     DATPLXNE,A0
            LEA     .FILPLXNE,A1           
            JSR     FILLOAD
            
            LEA     DATPLXNW,A0 
            LEA     .FILPLXNW,A1
            JSR     FILLOAD
            
            LEA     DATPLXS,A0            
            LEA     .FILPLXS,A1           
            JSR     FILLOAD
            
            LEA     DATPLXSE,A0            
            LEA     .FILPLXSE,A1           
            JSR     FILLOAD
            
            LEA     DATPLXSW,A0            
            LEA     .FILPLXSW,A1           
            JSR     FILLOAD
            
            LEA     DATPLXW,A0            
            LEA     .FILPLXW,A1           
            JSR     FILLOAD
            
            LEA     DATPLYE,A0            
            LEA     .FILPLYE,A1           
            JSR     FILLOAD
            
            LEA     DATPLYN,A0            
            LEA     .FILPLYN,A1           
            JSR     FILLOAD
            
            LEA     DATPLYNE,A0            
            LEA     .FILPLYNE,A1           
            JSR     FILLOAD
            
            LEA     DATPLYNW,A0            
            LEA     .FILPLYNW,A1           
            JSR     FILLOAD
            
            LEA     DATPLYS,A0            
            LEA     .FILPLYS,A1           
            JSR     FILLOAD
            
            LEA     DATPLYSE,A0            
            LEA     .FILPLYSE,A1           
            JSR     FILLOAD
            
            LEA     DATPLYSW,A0            
            LEA     .FILPLYSW,A1           
            JSR     FILLOAD
            
            LEA     DATPLYW,A0           
            LEA     .FILPLYW,A1           
            JSR     FILLOAD
            
            ; IMÁGENES ENEMIGO
            LEA     DATENXE,A0            
            LEA     .FILENXE,A1           
            JSR     FILLOAD
            
            LEA     DATENXN,A0            
            LEA     .FILENXN,A1           
            JSR     FILLOAD
            
            LEA     DATENXNE,A0            
            LEA     .FILENXNE,A1           
            JSR     FILLOAD
            
            LEA     DATENXNW,A0            
            LEA     .FILENXNW,A1           
            JSR     FILLOAD
            
            LEA     DATENXS,A0           
            LEA     .FILENXS,A1           
            JSR     FILLOAD
            
            LEA     DATENXSE,A0            
            LEA     .FILENXSE,A1           
            JSR     FILLOAD
            
            LEA     DATENXSW,A0            
            LEA     .FILENXSW,A1           
            JSR     FILLOAD
            
            LEA     DATENXW,A0            
            LEA     .FILENXW,A1           
            JSR     FILLOAD
            
            LEA     DATENYE,A0            
            LEA     .FILENYE,A1           
            JSR     FILLOAD
            
            LEA     DATENYN,A0           
            LEA     .FILENYN,A1          
            JSR     FILLOAD
            
            LEA     DATENYNE,A0           
            LEA     .FILENYNE,A1           
            JSR     FILLOAD
            
            LEA     DATENYNW,A0            
            LEA     .FILENYNW,A1           
            JSR     FILLOAD
            
            LEA     DATENYS,A0            
            LEA     .FILENYS,A1           
            JSR     FILLOAD
            
            LEA     DATENYSE,A0           
            LEA     .FILENYSE,A1           
            JSR     FILLOAD
            
            LEA     DATENYSW,A0            
            LEA     .FILENYSW,A1           
            JSR     FILLOAD
            
            LEA     DATENYW,A0            
            LEA     .FILENYW,A1           
            JSR     FILLOAD

            MOVEM.L  (A7)+,A0-A1
            
            RTS
            
.FILENAME       DC.B    'pythonProject/OUTPUT/MENUIMAGE.bin',0 
.FILEWIN        DC.B    'pythonProject/OUTPUT/WINIMAGE.bin',0
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
            



*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
