.setcpu "65C02"

L2520Z:
L256AZ:
        rts

; ----------------------------------------------------------------------------
; "EDIT" STATEMENT
; This is a variation of LIST (Need to clean this up)
; ----------------------------------------------------------------------------
EDIT:
        jsr     LINGET                  ; Get the line
        jsr     FNDLIN                  ; Find the line
        bcc     L2520Z                  ; If not found, exit
        ;jsr     CHRGOT                 ; Got all characters
        ;beq     L2598Z
        ;RTS
;L2598Z:
        pla                             ; Pull two bytes off the stack
        pla                             ; Not sure that this is for
        ;lda     LINNUM
        ;ora     LINNUM+1
        ;bne     L25A6Z
        ;lda     #$FF
        ;sta     LINNUM
        ;sta     LINNUM+1
L25A6Z:
;L25A6XZ:
        ldy     #$01
        lda     (LOWTRX),y
        beq     L25E5Z
LC5A9Z:
        jsr     ISCNTC
        jsr     CRDO
        iny
        lda     (LOWTRX),y
        tax
        iny
        lda     (LOWTRX),y
        cmp     LINNUM+1
        bne     L25C1Z
        cpx     LINNUM
        beq     L25C3Z
L25C1Z:
        bcs     L25E5Z
; ---LIST ONE LINE----------------
L25C3Z:
        sty     FORPNT                  ; Stare into the (for?) pointer
        jsr     LINBUF                  ; Store the line number in the input buffer
        lda     #$20                    ; Load A with a space
L25CAZ:
        ldy     FORPNT                  ; Get the pointer
        and     #$7F                    ; Remove the high bit from y
L25CEZ:
        JSR     APPEND_INPUTBUFFER      ; Store character to input buffer
;LA519Z:
        iny                             ; Increment the pointer
        beq     L25E5Z                  ; If at end of the buffer, end edit
        lda     (LOWTRX),y
        bne     L25E8Z
        tay
        lda     (LOWTRX),y
        tax
        iny
        lda     (LOWTRX),y
        stx     LOWTRX
        sta     LOWTRX+1
        bne     L25A6Z
L25E5Z:
        jmp     RESTART                 ; Return from edit by doing a warm start.
L25E8Z:
        bpl     L25CEZ
        sec
        sbc     #$7F
        tax
        sty     FORPNT
        ldy     #$FF
L25F2Z:
        dex
        beq     L25FDZ
L25F5Z:
        iny
        lda     TOKEN_NAME_TABLE,y
        bpl     L25F5Z
        bmi     L25F2Z

; Output token to the input buffer
L25FDZ:
        iny
        lda     TOKEN_NAME_TABLE,y
        bmi     L25CAZ

        JSR     APPEND_INPUTBUFFER

        JMP     L25FDZ             ; 

        ;bne     L25FDZ   ; always



; ----------------------------------------------------------------------------
; Put the line number into the input buffer
; ----------------------------------------------------------------------------
LINBUF:
        sta     FAC+1
        stx     FAC+2
        ldx     #$90
        sec
        jsr     FLOAT2
        jsr     FOUT
        jsr     STRLIT
        jsr     FREFAC
        tax
        ldy     #$00
        inx
L2A22X:
        dex
        beq     L29DDX
        lda     (INDEX),y
        jsr     APPEND_INPUTBUFFER
        iny
        jmp     L2A22X
L29DDX:
        RTS

; Append character to the input buffer

APPEND_INPUTBUFFER:
        PHX
        LDX     LINE_LENGTH
        STA     INPUTBUFFER, x
        INC     LINE_LENGTH
        PLX
        RTS
