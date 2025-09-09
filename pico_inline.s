.setcpu "65C02"                         ; We are using 65C02 instructions
.segment "CODE"

LINE_LENGTH := $03FF                      ; Location that holds the line length
CHAR_HOLD   := $FE
POS_HOLD    := $FE
END_OF_LINE := $4F

L2420:                                  ; Delete a character from the input buffer
        DEC     LINE_LENGTH             ; Decrement line length since we are delete a character
        dex
        bpl     INLIN2

L2423:                                  ; Abort line
        LDX     #$00
        STX     LINE_LENGTH             ; Reset the input buffer line length
        jsr     CRDO


; ----------------------------------------------------------------------------
; READ A LINE, AND STRIP OFF SIGN BITS
; ----------------------------------------------------------------------------
INLIN:
        
        ldx     LINE_LENGTH             ; Load line length into X
        CPX     #$00                    ; Check if line length is zero
        BEQ     INLIN2                  ; If is, empty line

; Output the characters in input buffer, if the line length is not 0
        LDX     #$00                    ; Index to 0
LINE_LENGTH_LOOP:
        LDA     INPUTBUFFER, x          ; Load character from buffer
        JSR     CHROUT                  ; Output it
        INX                             ; increment index
        CPX     LINE_LENGTH             ; Check if end of buffer
        BNE     LINE_LENGTH_LOOP        ; No, get next character
        LDX     LINE_LENGTH             ; Load X with the buffer length

; Get the next character and process the key

INLIN2:
        jsr     GETLN                   ; Get a character

        ;cmp     #$07                    ; See if it is a bell
        ;beq     L2443                   

        cmp     #$0D                    ; Enter
        beq     L2453                   ; Process input buffer

        cmp     #$1d                    ; Cursor right
        beq     NAV_KEYS                ; Process navigation key
        cmp     #$9d                    ; Cursor left
        beq     NAV_KEYS                ; Process navigation key
        cmp     #$94                    ; Insert
        beq     NAV_KEYS                ; Process navigation key
        cmp     #$13                    ; Home
        beq     NAV_KEYS                ; Process navigation key
        cmp     #$93                    ; End
        beq     NAV_KEYS                ; Process navigation key

        cmp     #$20                    ; Key is less than space
        bcc     INLIN2                  ; Ignore

        ;cmp     #$80                    ; Key is greater than 127
        ;bcs     INLIN2                  ; Ignore

        cmp     #$7E  ; ~               ; Key is ~
        beq     L2423                   ; Abort line

        cmp     #$7F                    ; Delete
        BNE     L2443                   ; Not delete, it is some other character, add character to INIT_BUFFER
        JMP     PROCESS_DELETE          ; Process the delete

L2443:
        cpx     #END_OF_LINE            ; Check if we got to the end of the buffer
        bcs     L244C                   ; If so, don't add a character

        CPX     LINE_LENGTH             ; If we are at the end of the buffer
        BEQ     INSERT_INTO_BUFFER      ; Do not insert character

        pha                             ; Save A on the stack, since we need it for later

        LDA     #$08                    ; Backspace
        JSR     CHROUT

        JSR     INSERT_SUB              ; Insert into the line

        PLA                             ; Load A with the last character pressed
        JSR     CHROUT                  ; Output character in the space of the insert

INSERT_INTO_BUFFER:
        sta     INPUTBUFFER,x           ; Add a character to the input buffer
        CPX     LINE_LENGTH             ; Check if pointer is at end of buffer
        BNE     NOT_AT_END              ; If not, don't extend line length
        INC     LINE_LENGTH             ; Extend line length
NOT_AT_END:
        inx                             ; Increment input buffer pointer
        bne     INLIN2                  ; We are not at 0 position, get the next character

L244C:                                  ; Max line size, can not add another character
        LDA     #$08                    ; Delete the character (Same as backspace)
        JSR     CHROUT
        LDA     #$20                    ; Put a space
        JSR     CHROUT
        LDA     #$08                    ; Backup (Same as backspace)
        JSR     CHROUT

        lda     #$07 ; BEL              ; Ring the bell
L244E:
        jsr     OUTDO
        JMP     INLIN2                  ; Get the next character

; Return/Enter was press. Move position to end of line, and reset the line length

L2453:
        LDX     LINE_LENGTH             ; Move the buffer pointer to the end of the line
        LDA     #$00
        STA     LINE_LENGTH             ; Reset line length

        jmp     L29B9                   ; Process the line

; Get the character from the keyboard

GETLN:
        jsr     MONRDKEY                ; Get a character from the keyboard
        cmp     #$0F
        bne     L2465                   ; If it is not a 0F, return from the subroutine.
        pha
        lda     Z14                     ; Not sure what this does
        eor     #$FF
        sta     Z14
        pla
L2465:
        rts

; Process navigation keys

NAV_KEYS:
        cmp     #$9D                    ; Left arrow
        beq     LEFT_ARROW
        cmp     #$1D                    ; Right arrow
        beq     RIGHT_ARROW
        cmp     #$13                    ; Home
        beq     HOME_IB
        cmp     #$93                    ; End
        beq     END_IB
        cmp     #$94                    ; Insert
        beq     INSERT_IB               

INLIN3:
        JMP     INLIN2                  ; Get next character

; Process left arrow

LEFT_ARROW:
        CPX     #$00                    ; If at the beginning of line
        BNE     LEFT_ARROW2             ; Move left if not
        JMP     INLIN2
LEFT_ARROW2:                            ; Ignore, and get next character
        DEX                             ; Move pointer to toward front
        LDA     #$08
        JSR     CHROUT                  ; Move cursor to left
        JMP     INLIN2                  ; Get next character

; Process right arrow

RIGHT_ARROW:
        CPX     LINE_LENGTH             ; Check of the end of line
        BNE     RIGHT_ARROW2            ; Yes, process right arrow
        JMP     INLIN2                  ; No, get next character
RIGHT_ARROW2:                       
        LDA     INPUTBUFFER,X
        JSR     CHROUT                  ; Print the character at the current position, to move cursor to right
        INX                             ; Move pointer to toward end
        JMP     INLIN2                  ; Get next character

; Process home

HOME_IB:
        CPX     #00                     ; Check if at the beginning of the buffer
        BNE     HOME_IB2                ; If not, move home
        JMP     INLIN2                  ; Get next character
HOME_IB2:
        DEX                             ; Go back a character
        LDA     #$08
        JSR     CHROUT                  ; Move cursor to left
        JMP     HOME_IB

; Process end

END_IB:
        CPX     LINE_LENGTH             ; Check if at the end of the buffer
        BNE     END_IB2                 ; If not move to the end of line
        JMP     INLIN2                  ; Get next character
END_IB2:
        LDA     INPUTBUFFER,X
        JSR     CHROUT                  ; Print the character at the current position, to move cursor to right
        INX                             ; Move pointer to toward end
        JMP     END_IB

; Insert subroutine

INSERT_SUB:
        JSR     SHIFT_BUFFER_UP
        INC     LINE_LENGTH
        JSR     UPDATE_FROM_BUFFER      ; Update the oine with new characters
        JSR     MOVE_CURSOR_TO_POS      ; Move the cursor from the end of the line to current X
        RTS

; Check if we can insert

INSERT_IB:
        CPX     LINE_LENGTH             ; Check if we are at the end of the buffer
        BNE     INSERT_IB2              ; If not, insert
        JMP     INLIN2                  ; Get the next character

; Check if the buffer can be extended

INSERT_IB2:

        LDA     LINE_LENGTH             ; Get the length of the buffer
        CMP     #END_OF_LINE            ; Have we reached the end
        BNE     INSERT_IB3              ; If no, process insert
        JMP     INLIN2                  ; Get the next character

INSERT_IB3:
        JSR     INSERT_SUB              ; Call insert subroutine
        JMP     INLIN2                  ; Get the next character

; Process the delete character

PROCESS_DELETE:
        CPX     LINE_LENGTH             ; Check if end of input buffer
        BNE     DELETE_IN_MIDDLE        ; If not, go to delete in middle logic
        LDA     #$20                    ; Overwrite the deleted character
        JSR     CHROUT                  
        LDA     #$08                    ; Move cursor back 
        JSR     CHROUT
        JMP     L2420

; Check if we can delete

DELETE_IN_MIDDLE:                       
        CPX     #$00                    ; Check if we are at the beginning of the buffer
        BNE     DELETE_IN_MIDDLE2       ; If not, process delete in the middle

        LDA     INPUTBUFFER,x           ; If we are at the first position, print the first character
        JSR     CHROUT                  ; since it gets deleted for some reason
        LDA     #$08                    ; Move the cursor back to the first position
        JSR     CHROUT

        JMP     INLIN2                  ; Get the next character

; Delete is in the middle of the line

DELETE_IN_MIDDLE2:                      ; Need to delete in the middle of the line
        DEC     LINE_LENGTH             ; Decrement the line length, since it is now smaller

        JSR     SHIFT_BUFFER_DOWN       ; Shift the character in the buffer down to deleted character

        DEX                             ; Move the buffer point back

        JSR     UPDATE_FROM_BUFFER      ; Display the character in the buffer, from the delete character

        LDA     #$20                    ; Put a space at the end, to move the last character
        JSR     CHROUT

        JSR     MOVE_CURSOR_TO_POS      ; Move back to the cursor position

        LDA     #$08                    ; Move back one more
        JSR     CHROUT

        JMP     INLIN2                  ; Get the next character

; Shift all characters up to make room for the inserted position

SHIFT_BUFFER_UP:
        STX     POS_HOLD                ; Store pointer position
        LDX     LINE_LENGTH             ; Move pointer to the end of the line

SHIFT_BUFFER_UP2:
        DEX                             ; Move pointer back on positon
        LDA     INPUTBUFFER,x           ; Load character at current position
        STA     INPUTBUFFER + 1,x       ; Store in in the next position
        CPX     POS_HOLD                ; Did we reach the original position
        BNE     SHIFT_BUFFER_UP2        ; No, copy the next character
        LDA     #$20                    ; Insert a space at the inserted position
        STA     INPUTBUFFER, X
        RTS                             ; Return

; Shift all character down to the delete position

SHIFT_BUFFER_DOWN:
        STX     POS_HOLD                ; Store the pointer position
        DEX                             ; Move back one, to start in the correct postion
SHIFT_BUFFER_DOWN2:
        INX                             ; Move pointer forward
        LDA     INPUTBUFFER, X          ; Get the character at the current position
        STA     INPUTBUFFER - 1, x      ; Store it in the one before it
        CPX     LINE_LENGTH             ; Did we get to the end of the line
        BNE     SHIFT_BUFFER_DOWN2      ; No, copy the next character

        LDA     #$20                    ; Store a space at the last postition
        STA     INPUTBUFFER, x
        LDX     POS_HOLD                ; Get the original position
        RTS                             ; Return

; Update the characters on the screen from the cursor position to the end of the buffer

UPDATE_FROM_BUFFER:
        STX     POS_HOLD                ; Store the current position
UPDATE_FROM_BUFFER2:
        LDA     INPUTBUFFER,x           ; Load character from the current position
        JSR     CHROUT                  ; Output the character
        INX                             ; Got to the next position
        CPX     LINE_LENGTH             ; Are we at the end of the line
        BNE     UPDATE_FROM_BUFFER2     ; No, output the next character
        LDX     POS_HOLD                ; Load original position into X
        RTS                             ; Return

; Move the cursor back to the original position

MOVE_CURSOR_TO_POS:
        LDA     #$08                    ; Load backspace
        STX     POS_HOLD                ; Store the current position
        LDX     LINE_LENGTH             ; Move to the end of the line
MOVE_CURSOR_TO_POS2:
        JSR     CHROUT                  ; Output the backspace
        DEX                             ; Decrement the position
        CPX     POS_HOLD                ; Did we get back to the orignal position
        BNE     MOVE_CURSOR_TO_POS2     ; No, move the cursor again
        LDX     POS_HOLD                ; Get the original position
        RTS                             ; Return
