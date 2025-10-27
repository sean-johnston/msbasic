# Memory Map For Pico-6502

|    |Address DEC  |Address HEX |Name          |Description          |
|----|---------    |---------    |--------------|---------------------|
| 2  | 0-1         | $00-$01     |              | Unused
| 2  | 2-4         | $02-$04     | GORESTART    | Don't know
| 2  | 5-7         | $05-$07     | GOSTROUT     | Don't know
| 2  | 8-9         | $08-$09     | GOAYINT      | Don't know
| 2  | 10-11       | $0A-$B0     | GOGIVEAYF    | Don't know
| 1  | 12          | $0C         | Z15          | (Not used)
| 1  | 13          | $0D         | POSX         | Don't know
| 1  | 14          | $0E         | Z17          | WIDTH (width of line) 79
| 1  | 15          | $0F         | Z18          | WIDTH2 (width of print) 30
| 2  | 16-17       | $10-$11     | LINNUM       | Integer Line Number Value
| 2  | 16-17       | $10-$11     | TXPSV        | TXTPTR Safe: Used in INPUT routine
| 79 | 18-97       | $12-$61     | INPUTBUFFER  | Input buffer for parsing commands
| 1  | 98          | $62         | CHARAC       | Search Character for Scanning BASIC Text Input
| 1  | 99          | $63         | ENDCHR       | Search Character for Statement Terminator or Quote
| 1  | 100         | $64         | EOLPNTR      | Don't know
| 1  | 101         | $65         | DIMFLG       | Flags for the Routines That Locate or Build an Array
| 2  | 102-103     | $66-$67     | VALTYP       | Flag: Type of Data (String or Numeric)
| 1  | 104         | $68         | DATAFLG      | Flag: Used for allowing 8 bit characters
| 1  | 105         | $69         | SUBFLG       | Flag: Subscript Reference to an Array or User-Defined Function Call (FN)
| 1  | 106         | $6A         | INPUTFLG     | Flag: Is Data Input to GET, READ or INPUT?
| 1  | 107         | $6B         | CPRMASK      | Compare Mask [(CPRTYP)<-FRMEVL]
| 1  | 108         | $6C         | Z14          | Don't know
| 1  | 109         | $6D         | TEMPPT       | Pointer to the Next Available Space in the Temporary String Stack
| 2  | 110-111     | $6E-$6F     | LASTPT       | Pointer to the Address of the Last String in the Temporary String Stack
| 2  | 112-113     | $70-$78     | TEMPST       | Descriptor Stack for Temporary Strings
| 2  | 114-115     | $79-$7A     | INDEX        | Miscellaneous Temporary Pointers and Save Area
| 2  | 116-117     | $7B-$7C     | DEST         | Don't know
| 12 | 118-129     | $7D-$81     | RESULT       | FP Result of Last Mult* or Div/
| 2  | 130-131     | $82-$83     | TXTTAB       | Pointer to the Start of BASIC Program Text
| 2  | 132-133     | $84-$85     | VARTAB       | Pointer to the Start of the BASIC Variable Storage Area
| 2  | 134-135     | $86-$87     | ARYTAB       | Pointer to the Start of the BASIC Array Storage Area
| 2  | 136-137     | $88-$89     | STREND       | Pointer to End of the BASIC Array Storage Area (+1), and the Start of Free RAM
| 2  | 138-139     | $8A-$8B     | FRETOP       | Pointer to the Bottom of the String Text Storage Area
| 2  | 140-141     | $8C-$8D     | FRESPC       | Temporary Pointer for Strings
| 2  | 142-143     | $8E-$8F     | MEMSIZ       | Pointer to the Highest Address Used by BASIC
| 2  | 144-145     | $90-$91     | CURLIN       | Current BASIC Line Number
| 2  | 146-147     | $92-$93     | OLDLIN       | Previous BASIC Line Number
| 2  | 148-149     | $94-$95     | OLDTEXT      | Pointer to the Address of the Current BASIC Statement
| 2  | 150-151     | $96-$97     | Z8C          | (DATLIN?)
| 2  | 152-153     | $98-$99     | DATPTR       | Pointer to the Address of the Current DATA Item
| 2  | 154-155     | $9A-$9B     | INPTR        | Pointer to the Source of GET, READ, or INPUT Information
| 2  | 156-157     | $9C-$9D     | VARNAM       | Current BASIC Variable Name
| 2  | 158-159     | $9E-$9F     | VARPNT       | Pointer to the Current BASIC Variable Value
| 2  | 160-161     | $A0-$A1     | FORPNT       | Temporary Pointer to the Index Variable Used by FOR
| 2  | 162-163     | $A2-$A3     | LASTOP       | FRMEVL Scratch Flag
| 1  | 164         | $A4         | CPRTYP       | FRMEVL Compare Flag (>,=,<)
| 2  | 165-166     | $A5-$A6     | FNCNAM       | Function Name Pointer
| 2  | 165-166     | $A5-$A6     | TEMP3        | Temporary FAC #3
| 2  | 167-169     | $A7-$A9     | DSCPTR       | String Descriptor Pointer
| 2  | 170-171     | $AA-$AB     | DSCLEN       | String Descriptor Length
| 1  | 171         | $AB         | JMPADRS      | Jump (from ZP) to <Address> 
| 1  | 172         | $AC         | Z52          | Don't know
| 1  | 173         | $AD         | ARGEXTENSION | Don't know
| 1  | 174         | $AE         | TEMP1        | FP Math Register
| 2  | 175-176     | $AF-$B0     | HIGHDS       | Highest Destination Adrs +1
| 2  | 177-178     | $B1-$B2     | HIGHTR       | Highest Source Address +1
| 1  | 179         | $B3         | TEMP2        | FP Math Register
| 1  | 180         | $B4         | INDX         | Pointer: End of Logical Line for Input
| 1  | 180         | $B4         | TMPEXP       | FIN (Eval) Routine 
| 1  | 181         | $B5         | EXPON        | Exponent Safe
| 1  | 182         | $B6         | LOWTR        | Copy Ptr: Lowest Source Address 
| 1  | 182         | $B6         | LOWTRX       | Copy Ptr: Lowest Source Address
| 1  | 183         | $B7         | EXPSGN       | Exponent Sign Safe
| 5  | 184-188     | $B8-$BC     | FAC          | Floating Point Accumulator 1
| 1  | 189         | $BD         | FACSIGN      | Floating Point Accumulator 1 Sign
| 1  | 190         | $BE         | SERLEN       | Holds Length of Series-1
| 1  | 191         | $BF         | SHIFTSIGNEXT | Don't know
| 5  | 192-196     | $C0-$C4     | ARG          | Floating Point Accumulator 2
| 1  | 197         | $C5         | ARGSIGN      | Floating Point Accumulator 2 Sign
| 2  | 198-199     | $C6-$C7     | STRNG1       | String Pointer #1
| 2  | 200-201     | $C8-$C9     | STRNG2       | String Pointer #2
| 24 | 202-225     | $CA-$E1     | CHRGET       | Subroutine: Get Next BASIC Text Character
| 27 | 226-252     | $E2-$FC     |              | Unused
| 1  | 253         | $FD         | EXTRATABFLAG | Flag to indicate that we are reading the second page of tokens
| 1  | 254         | $FE         | POS_HOLD     | Pointer to the position of the cursor when editing input buffer
| 1  | 255         | $FF         |              | Unused
| *  |             |             |              |                    |
|    | 256-511     | $0100-$01FF | STACK        | CPU stack
|    | 512-1023    | $0200-$03FF |              | Unused
|    | 1024-40959  | $0400-$9FFF | PROGMEM      | Basic Program Memory
|    | 40960-49151 | $A000-$BFFF | ROM          | BASIC ROM
|    | 49152-53247 | $C000-$CFFF |              | Unused RAM
| *  |             |             |              |                    |
|    | 53248-57343 | $D000-$DFFF | IO           | I/O area
|    | 53248       | $D000       | IODDRB       |
|    | 53249       | $D001       | IODDRA       |
|    | 53250       | $D002       | IOPORTB      |
|    | 53251       | $D003       | IOPORTA      |
| *  |             |             |              |                    |
|    | 53504       | $D100       |              | Unused
|    | 53505       | $D101       | CHROUT       | Character Out (Put byte in memory location, to send to terminal)
|    | 53506       | $D102       | FILEMODE     | File Mode (Select the mode)
|    | 53507       | $D103       | FILEDATA     | File Data Out (Used for setting filename, and sending data)
|    | 53508       | $D104       | CHRIN        | Character In (Read a byte from memory location, to read input from terminal)
|    | 53509       | $D105       | FILELOADDATA | File Data In (Used for LOAD and CAT)
|    | 53510       | $D106       | DBGIOENABLE  | Debug I/O Enable (Put non-zero in memory location to turn on I/O debugging)
|    | 53511       | $D107       | LCDSTATE     | LCD State (1 if LCD is installed)
|    | 53512       | $D108       | SNDVOC1LOW   | Voice 1 Frequency Low Byte (If sound is installed)
|    | 53513       | $D109       | SNDVOC1HIGH  | Voice 1 Frequency High Byte (If sound is installed)
|    | 53514       | $D10A       | SNDVOC2LOW   | Voice 2 Frequency Low Byte (If sound is installed)
|    | 53515       | $D10B       | SNDVOC2HIGH  | Voice 2 Frequency High Byte (If sound is installed)
|    | 53516       | $D10C       | SNDVOC3LOW   | Voice 3 Frequency Low Byte (If sound is installed)
|    | 53517       | $D10D       | SNDVOC3HIGH  | Voice 3 Frequency High Byte (If sound is installed)
|    | 53518       | $D10E       | SNDDUR1LOW   | Voice 1 Duration Low Byte (If sound is installed)
|    | 53519       | $D10F       | SNDDUR1HIGH  | Voice 1 Duration High Byte (If sound is installed)
|    | 53520       | $D110       | SNDDUR2LOW   | Voice 2 Duration Low Byte (If sound is installed)
|    | 53521       | $D111       | SNDDUR2HIGH  | Voice 2 Duration High Byte (If sound is installed)
|    | 53522       | $D112       | SNDDUR3LOW   | Voice 3 Duration Low Byte (If sound is installed)
|    | 53523       | $D113       | SNDDUR3HIGH  | Voice 3 Duration High Byte (If sound is installed)
| *  |             |             |              |                    |
|    | 57344-65529 | $E000-$FFF9 | KERNAL       | Kernal ROM
|    | 65530-65531 | $FFFA-$FFFB | NMIVECTOR    | CPU NMI Vector
|    | 65532-65533 | $FFFC-$FFFD | RESETVECTOR  | CPU RESET Vector
|    | 65534-65535 | $FFFE-$FFFF | IRQVECTOR    | CPU IRQ Vector
