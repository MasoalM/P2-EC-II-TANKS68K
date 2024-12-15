*-----------------------------------------------------------
* Title      : FILE LOAD
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

; ------------------------------------------------------------------------------
FILLOAD
; LOADS AN FILE FROM DISK TO MEMORY
; INPUT    : A0 - DESTINATION ADDR. WITH ENOUGH SPACE AVAILABLE.
;            A1 - POINTER TO FILE NAME
; OUTPUT   : NONE
; MODIFIES : NONE
; NOTE     : THE READ DATA LOOP READS 1 BYTE AT A TIME TO ENSURE ALL FILES CAN
;            BE LOADED. HOWEVER, IF THE FILE SIZE IS KNOWN BEFOREHAND, NO LOOP
;            WOULD BE NECESSARY AND A SINGLE CALL TO TRAP #15 TASK 53 WOULD READ
;            THE WHOLE FILE AS LONG AS THE FILE SIZE IS PLACED INTO D2.L.
; NOTE     : THE ZERO-TERMINATOR (JUST BEFORE CLOSE THE FILE) IS A REQUIREMENT
;            FOR TEXT-FILES IF THE TEXT IS TO BE PRINTED. FOR OTHER USES, IT
;            CAN BE REMOVED.
; ------------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)          ; SAVE REGISTERS
            ; CLOSE ALL FILES
            MOVE.B  #50,D0
            TRAP    #15
            ; OPEN FILE (ASSUMES A1 POINTS TO FILENAME)
            MOVE.B  #51,D0
            TRAP    #15                     ; D1.L:=FILE HANDLER
            ; READ DATA
            MOVE.L  A0,A1                   ; A1 MUST BE THE BUFFER ADDRESS
.LOOP       MOVE.B  #53,D0                  ; READ DATA TASK
            MOVE.L  #1,D2                   ; BYTES TO READ (ONE BY ONE)
            TRAP    #15
            ADD.L   D2,A1                   ; ADVANCE POINTER
            TST.B   D0                      ; END OF FILE OR ERROR?
            BEQ     .LOOP                   ; NO: READ MORE
            CLR.B   (A1)                    ; PUT A ZERO-TERMINATOR.
            ; CLOSE THE FILE
            MOVE.B  #56,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D2/A1          ; RESTORE REGISTERS
            RTS


*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
