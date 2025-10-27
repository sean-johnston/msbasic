.ifdef PICO
.setcpu "65C02"                         ; We are using 65C02 instructions

.segment "C000"

.BYTE 1

.segment "D000"

.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

IO0:
        .byte   1 ;$00
COUT:
        .byte   2 ;$01
FILE_MODE:
        .byte   3 ;$02
FILE_DATA:
        .byte   4 ;$03
CIN:
        .byte   5 ;$04
FILE_LOAD_DATA:
        .byte   6 ;$05
DEBUG_FLAG:
        .byte   7 ;$06
LCD_STATE:
        .byte   8 ;$07
SND_V1_FREQ:
        .byte   9 ;$08
        .byte   10 ;$09
SND_V2_FREQ:
        .byte   11 ;$0A
        .byte   12 ;$0B
SND_V3_FREQ:
        .byte   13 ;$0C
        .byte   14 ;$0D
SND_V1_DUR:
        .byte   15 ;$0E
        .byte   16 ;$0F
SND_V2_DUR:
        .byte   17 ;$10
        .byte   18 ;$11
SND_V3_DUR:
        .byte   19 ;$18
        .byte   20 ;$19

.segment "IO"

.BYTE 1

.endif
