.setcpu "65C02"
.debuginfo

.zeropage
                .org ZP_START0
READ_PTR:       .res 1
WRITE_PTR:      .res 1

.segment "INPUT_BUFFER"
INPUT_BUFFER:   .res $100

.segment "BIOS"

ACIA_DATA       = $5000
ACIA_STATUS     = $5001
ACIA_CMD        = $5002
ACIA_CTRL       = $5003
PORTA           = $6001
DDRA            = $6003

CIN             = $f004
COUT            = $f001
FILE_MODE       = $F002
FILE_DATA       = $F003
FILE_LOAD_DATA  = $F005
DEBUG_FLAG      = $F006
LCD_STATE       = $F007

LOAD:
                jsr LOAD_PROG
                rts

SAVE:
                jsr SAVE_PROG
                rts

;SYS:
;                rts


; Input a character from the serial interface.
; On return, carry flag indicates whether a key was pressed
; If a key was pressed, the key value will be in the A register
;
; Modifies: flags, A
MONRDKEY:
CHRIN:
                phx
                LDA CIN
                beq     @no_keypressed
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
                lda #'C'
                jsr CHROUT
                LDA #$03
@CHRIN3:
                jsr     CHROUT                  ; echo
@no_keypressed:
                plx
                rts



; Output a character(from the A register) to the serial interface.
;
; Modifies: flags
MONCOUT:
CHROUT:
                sta COUT
                rts

; Initialize the circular input buffer
; Modifies: flags, A
INIT_BUFFER:
;                lda READ_PTR
;                sta WRITE_PTR
;                lda #$01
;                sta DDRA
;                lda #$fe
;                and PORTA
;                sta PORTA
                rts

; Write a character (from the A register) to the circular input buffer
; Modifies: flags, X
WRITE_BUFFER:
;                ldx WRITE_PTR
;                sta INPUT_BUFFER,x
;                inc WRITE_PTR
                rts

; Read a character from the circular input buffer and put it in the A register
; Modifies: flags, A, X
READ_BUFFER:
;                ldx READ_PTR
;                lda INPUT_BUFFER,x
;                inc READ_PTR
                rts

; Return (in A) the number of unread bytes in the circular input buffer
; Modifies: flags, A
BUFFER_SIZE:
;                lda WRITE_PTR
;                sec
;                sbc READ_PTR
                rts


; Interrupt request handler
IRQ_HANDLER:
;                pha
;                phx
;                lda     ACIA_STATUS
;                ; For now, assume the only source of interrupts is incoming data
;                lda     ACIA_DATA
;                jsr     WRITE_BUFFER
;                jsr     BUFFER_SIZE
;                cmp     #$F0
;                bcc     @not_full
;                lda     #$01
;                ora     PORTA
;                sta     PORTA
;@not_full:
;                plx
;                pla
                rti

.include "wozmon.s"

.segment "RESETVEC"
                .word   $0F00           ; NMI vector
;                .word   RESET          ; RESET vector
                .word   BASIC_START     ; RESET vector
                .word   IRQ_HANDLER     ; IRQ vector

