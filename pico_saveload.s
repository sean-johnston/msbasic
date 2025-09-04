.segment "CODE"
.ifdef PICO

SAVE_PROG:
            jsr FRMEVL              ; Evaluate the parameter
            bit VALTYP              ; Check if it is a string
            bmi SAVE_PROG1          ; If so, save program
            jsr FOUT                
            jsr STRLIT
SAVE_PROG1:
            jsr FREFAC              ; Get the string, and store it the position in INDEX
            ldy #0                  
            STY FILE_MODE           ; Clear data
            dey                     ; Decrement Y to get file mode
            STY FILE_MODE           ; Start filename
            tax                     ; Transfer length to X
            iny                     ; Increment Y to 0
            STX FILE_DATA           ; Send filname length

            ; Send the filename
SAVE_PROG_LOOP:
            lda (INDEX),y           ; Get filename byte
            STA FILE_DATA           ; Send it 
            iny                     ; Increment Y index for filename
            dex                     ; Decrement x filename length counter
            bne SAVE_PROG_LOOP      ; If x is 0, filename is done, start sending data

            ; Send file data
            LDA #$FE                ; Load file data mode
            STA FILE_MODE           ; Set mode

            SEC                     ; Set the Carry flag for initial "no borrow" condition
                                    ; (C=1 means no borrow, C=0 means borrow)
            LDA VARTAB              ; Load the lower byte of the first number
            SBC #<RAMSTART2         ; Subtract the lower byte of the second number with carry
            TAY                     ; Store the lower byte of the result

            LDA VARTAB + 1          ; Load the higher byte of the first number
            SBC #>RAMSTART2         ; Subtract the higher byte of the second number with carry
            STA FILE_DATA           ; Send the high byte of length
            STY FILE_DATA           ; Send the low byte of length

            LDY #$00                ; Set to low byte as 0
            LDA #<RAMSTART2         ; Get the low byte of start of ram
            STA INDEX               ; Store it in index
            LDA #>RAMSTART2         ; Get the high byte of start of ram
            STA INDEX + 1           ; Store it in index + 1
NEXT_PROG_BYTE:
            LDY #$00                ; Set Y to 0, since we want to first character of index
            LDA (INDEX),Y           ; Get the byte from program memory
            STA FILE_DATA           ; Send it to data
            INC INDEX               ; Increment the low byte program memory
            LDA INDEX               ; Load it into the accumulator
            CMP #$00                ; Check if we rolled over to next page
            BNE COMPARE_PROG_END    ; If we didn't, we don't increment the high index
            INC INDEX+1             ; Increment high index
COMPARE_PROG_END:
            LDA VARTAB+1            ; Load high byte of first number
            CMP INDEX+1             ; Compare with high byte of second number
            BNE NOT_EQUAL_HIGH      ; If not equal, comparison is done

            LDA VARTAB              ; If high bytes are equal, compare low bytes
            CMP INDEX
            BEQ EQUAL_16BIT         ; If low bytes also equal, numbers are equal

NOT_EQUAL_HIGH:
            JMP NEXT_PROG_BYTE      ; Jump back to do the next byte

            ; File save done
EQUAL_16BIT:
            LDA #$FD                ; Save the data        
            STA FILE_MODE           ; Set mode to save data
            LDA FILE_DATA           ; Read the status
            CMP #$06
            BEQ SHOW_FILE_EXIST     ; If file exists
            CMP #$00
            BNE SHOW_IO_ERROR       ; If error, print I/O error

            ; File save was successful
            LDA #<FILE_SAVED        ; Get low byte of file saved message
            STA INDEX               ; Store it in index
            LDA #>FILE_SAVED        ; Get hight byte of file saved message
            STA INDEX + 1           ; Store it in index + 1
            JMP OUTPUT_MESSAGE      ; Output the message

            rts                     ; Return

CATALOG:
            LDA #$00                ; Clear
            STA FILE_MODE           ; Reset the file system
            LDA #$FB                ; Catalog
            STA FILE_MODE           ; Request a catalog
            LDA FILE_DATA           ; Get error status
            BNE SHOW_IO_ERROR       ; If error, jump to display I/O error
            LDA FILE_LOAD_DATA      ; Load high byte of length of data
            STA INDEX+1             ; Store it in high byte of index
            LDA FILE_LOAD_DATA      ; Load low byte of length of data
            STA INDEX               ; Store it in low byte of index

            jmp COMPARE_FOR_ZERO    ; Compare if reached the end

            ; Read the catalog
READ_NEXT:
            LDA FILE_LOAD_DATA      ; Read the next byte
            JSR CHROUT              ; Output it
            DEC INDEX               ; Decrement the low byte of the index
            LDA INDEX               ; Load it into A
            CMP #$FF                ; Check it rolled over
            BNE COMPARE_FOR_ZERO    ; If it didn't, compare if we reached the end 
            DEC INDEX + 1           ; Increment the high byte of the index

            ; Check if we reached the end
COMPARE_FOR_ZERO:
            LDA INDEX               ; Load low byte of index
            CMP #$00                ; Check if it is zero
            BNE READ_NEXT           ; If not, read the next byte
            LDA INDEX + 1           ; Load the high byte of index
            CMP #$00                ; Check if it is zero
            BNE READ_NEXT           ; If not, read the next byte
            RTS                     ; Return from the subroutine

SHOW_IO_ERROR:
            LDA #<IO_ERROR          ; Get low byte of I/O error string
            STA INDEX               ; Store it in low byte of index
            LDA #>IO_ERROR          ; Get hight byte of I/O error string
            STA INDEX + 1           ; Store it in high byte of index
            JMP OUTPUT_MESSAGE      ; Call output message

SHOW_FILE_EXIST:
            LDA #<FILE_EXISTS          ; Get low byte of I/O error string
            STA INDEX               ; Store it in low byte of index
            LDA #>FILE_EXISTS          ; Get hight byte of I/O error string
            STA INDEX + 1           ; Store it in high byte of index
            JMP OUTPUT_MESSAGE      ; Call output message

LOAD_PROG:
            jsr FRMEVL              ; Evaluate first parameter
            bit VALTYP              ; Check if it is the correct type
            bmi LOAD_PROG1          ; If so, load the program
            jsr FOUT                
            jsr STRLIT
LOAD_PROG1:
            jsr FREFAC              ; Get the string, and store it the position in INDEX
            ldy #0
            STY FILE_MODE           ; Clear data
            dey                     ; Set Y to filename mode
            STY FILE_MODE           ; Start filename
            tax                     ; Transfer length to X
            iny                     ; Increment Y to 0
            STX FILE_DATA           ; Send filename length
LOAD_PROG_LOOP:
            lda (INDEX),y           ; Get next filename character
            STA FILE_DATA           ; Set the data
            iny                     ; Increment the index
            dex                     ; Decrement the count
            bne LOAD_PROG_LOOP      ; If X doesn't equal 0 continue the loop

            LDA #$00                ; Set 0 so the new executes
            JSR NEW                 ; Call new

            LDA #$FC                ; Mode to read data
            STA FILE_MODE           ; Set to file mode

            LDA FILE_DATA           ; Check the error status
            BNE SHOW_FNF_ERROR      ; If error, output FILE NOT FOUND error

            LDA #<RAMSTART2         ; Get low byte of start of RAM
            STA VARTAB              ; Store it in low byte of start of variable pointer
            LDA #>RAMSTART2         ; Get high byte of start of RAM
            STA VARTAB + 1          ; Store it in high byte of start of variable pointer

            LDY FILE_LOAD_DATA      ; Get the high byte of the length
            CLC                     ; Clear carry for adding
            LDA FILE_LOAD_DATA      ; Get the low byte of the length
            ADC VARTAB              ; Add low length to low byte of variable pointer
            STA VARTAB              ; Store it back
            TYA                     ; Transfer high byte of the length to accumulator
            ADC VARTAB + 1          ; Add high length to high byte of variable pointer
            STA VARTAB + 1          ; Store it back

            LDA #<RAMSTART2         ; Get low byte of start of basic
            STA INDEX               ; Initalize low index
            LDA #>RAMSTART2         ; Get high byte of start of basic
            STA INDEX + 1           ; Initalize high index

START_LOAD:
            LDY #$00                ; Load Y with 0 

LOAD_READ_NEXT:
            LDA FILE_LOAD_DATA      ; Load program byte
            STA (INDEX),Y           ; Set the byte in program memory

            INC INDEX               ; Increment low byte index
            LDA INDEX               ; Load it into A
            CMP #$00                ; Compare it to 0, index wrapped
            BNE LOAD_CMP            ; If didn't wrap go to check.
            INC INDEX + 1           ; Increment the high byte of index

LOAD_CMP:

            LDA INDEX               ; Get low byte of index
            CMP VARTAB              ; Compare to low byte of start of variables
            BNE LOAD_READ_NEXT      ; If not equal get next byte
            LDA INDEX + 1           ; Get high byte of index
            CMP VARTAB + 1          ; Compare to high byte of start of variables
            BNE LOAD_READ_NEXT      ; If not equal get next byte

            LDA #<FILE_LOADED       ; Load low byte of file loaded string
            STA INDEX               ; Store it in the low byte of index
            LDA #>FILE_LOADED       ; Load high byte of file loaded string
            STA INDEX + 1           ; Store it in the high byte of index
            JMP OUTPUT_MESSAGE      ; Output the message

            RTS                     ; Finished with load

SHOW_FNF_ERROR:
            LDA #<FILE_NOT_FOUND    ; Load low byte of file not found message
            STA INDEX               ; Store it into index
            LDA #>FILE_NOT_FOUND    ; Load high byte of file not found message
            STA INDEX + 1           ; Store it in index + 1
            JMP OUTPUT_MESSAGE      ; Output message

DELETE_FILE:
            jsr FRMEVL              ; Evaluate first parameter
            bit VALTYP              ; Check if it is the correct type
            bmi DELETE_FILE1        ; If so, load the program
            jsr FOUT                
            jsr STRLIT
DELETE_FILE1:
            jsr FREFAC              ; Get the string, and store it the position in INDEX
            ldy #0
            STY FILE_MODE           ; Clear data
            dey                     ; Set Y to filename mode
            STY FILE_MODE           ; Start filename
            tax                     ; Transfer length to X
            iny                     ; Increment Y to 0
            STX FILE_DATA           ; Send filename length
DELETE_FILE_LOOP:
            lda (INDEX),y           ; Get next filename character
            STA FILE_DATA           ; Set the data
            iny                     ; Increment the index
            dex                     ; Decrement the count
            bne DELETE_FILE_LOOP    ; If X doesn't equal 0 continue the loop

            LDA #$FA                ; Mode to read data
            STA FILE_MODE           ; Set to file mode

            LDA FILE_DATA           ; Check the error status
            BNE SHOW_FNF_ERROR      ; If error, output FILE NOT FOUND error

            LDA #<FILE_DELETED      ; Load low byte of file deleted string
            STA INDEX               ; Store it in the low byte of index
            LDA #>FILE_DELETED      ; Load high byte of file deleted string
            STA INDEX + 1           ; Store it in the high byte of index
            JMP OUTPUT_MESSAGE      ; Output the message

            RTS                     ; Finished with delete

FILE_NOT_FOUND:
            .asciiz "FILE NOT FOUND"

IO_ERROR:
            .asciiz "I/O ERROR"

FILE_EXISTS:
            .asciiz "FILE EXISTS"

FILE_SAVED:
            .asciiz "FILE SAVED"

FILE_LOADED:
            .asciiz "FILE LOADED"

FILE_DELETED:
            .asciiz "FILE DELETED"

LCD_INIT_MSG:
            .asciiz "LCD WAS INITIALIZED"

SHOW_LCD_INIT:
            LDA #<LCD_INIT_MSG          ; Get low byte of I/O error string
            STA INDEX               ; Store it in low byte of index
            LDA #>LCD_INIT_MSG          ; Get hight byte of I/O error string
            STA INDEX + 1           ; Store it in high byte of index
            JMP OUTPUT_MESSAGE      ; Call output message


OUTPUT_MESSAGE:
            LDY #$00
OUTPUT_MESSAGE1:
            LDA (INDEX), y
            BEQ OUTPUT_DONE
            JSR CHROUT
            INY
            JMP OUTPUT_MESSAGE1
OUTPUT_DONE:
            LDA #$0D 
            JSR CHROUT
            LDA #$0A
            JSR CHROUT
            RTS


SYS:	    jsr FRMNUM              ;eval formula
	        jsr GETADR              ;convert to int. addr
	        lda #>csysrz            ;push return address
	        pha
	        lda #<csysrz
	        pha
;	        lda spreg               ;status reg
;	        pha
;	        lda sareg               ;load 6502 regs
;	        ldx sxreg
;	        ldy syreg
;	        plp                     ;load 6502 status reg
	        jmp (LINNUM)            ;go do it
csysrz	=*-1                        ;return to here
;	        php                     ;save status reg
;	        sta sareg               ;save 6502 regs
;	        stx sxreg
;	        sty syreg
;	        pla                     ;get status reg
;	        sta spreg
	        rts                     ;return to system
.endif
