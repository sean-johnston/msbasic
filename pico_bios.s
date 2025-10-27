.setcpu "65C02"
.debuginfo

.zeropage
                .org ZP_START0
READ_PTR:       .res 1
WRITE_PTR:      .res 1

.segment "INPUT_BUFFER"
INPUT_BUFFER:   .res $100

.segment "BIOS"

LOAD:
                jsr LOAD_PROG
                rts

SAVE:
                jsr SAVE_PROG
                rts

; Input a character from the serial interface.
; On return, carry flag indicates whether a key was pressed
; If a key was pressed, the key value will be in the A register
;
; Modifies: flags, A
MONRDKEY:
CHRIN:
                LDA CIN
                beq @no_keypressed
@CHRIN2:        
                cmp #$1d                        ; Cursor right
                beq @no_keypressed
                cmp #$9d                        ; Cursor left
                beq @no_keypressed
                cmp #$94                        ; Insert
                beq @no_keypressed
                cmp #$13                        ; Home
                beq @no_keypressed
                cmp #$93                        ; End
                beq @no_keypressed

                cmp #$03
                BNE @CHRIN3
                LDA #$03
@CHRIN3:
                jsr     CHROUT                  ; echo
@no_keypressed:
                rts

; Output a character(from the A register) to the serial interface.
;
; Modifies: flags
MONCOUT:
CHROUT:
                sta COUT
                rts

; Interrupt request handler
IRQ_HANDLER:
                rti

TEST:
                RTS

.include "pico_wozmon.s"

.segment "RESETVEC"
                .word   $0F00           ; NMI vector
;                .word   RESET          ; RESET vector
                .word   BASIC_START     ; RESET vector
                .word   IRQ_HANDLER     ; IRQ vector

