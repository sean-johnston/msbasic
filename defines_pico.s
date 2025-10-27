; configuration
CONFIG_2A           := 1
CONFIG_DATAFLG      := 1 ; Allow 8 bit characters
TOKEN_ALT           := 1
CONFIG_SCRTCH_ORDER := 2

; zero page
ZP_START0 = $00
ZP_START1 = $02
ZP_START2 = $0C
ZP_START3 = $62
ZP_START4 = $6D

; extra/override ZP variables
USR := GORESTART

;INPUTBUFFER     := $0200

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP       := $FA
WIDTH           := 79
WIDTH2          := 30
RAMSTART2       := $0400

LINE_LENGTH     := $FC                      ; Location that holds the line length
.ifdef TOKEN_ALT
EXTRA_TABLE_FLAG := $FD
.endif
POS_HOLD        := $FE

