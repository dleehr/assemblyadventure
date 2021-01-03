; ---
; File: nihil.s
; Description: First SNES game from tutorial
; ---

;--- Assembler Directives
.p816           ; This is 65816 code
.i16            ; X and Y registers are 16 bit
.a8             ; A Register is 8 bit
;--- End

;--- Code
.segment "CODE"
.proc   ResetHandler        ; Program entry point
        sei                 ; disable interrupts
        clc                 ; clear carry flag
        xce                 ; switch to native mode

        lda #$81            ; enable...
        sta $4200           ; ... non-maskable interrupt
        jmp GameLoop        ; init done, go to game loop
.endproc

.proc   GameLoop            ; Main game loop
        wai                 ; wait for NMI interrupt
        jmp GameLoop        ; jump to beginning
.endproc

.proc   NMIHandler          ; NMI handler, called every flame / V-blank
        lda $4210           ; Read NMI status
        rti                 ; Interrupt done, return to main game loop
.endproc

;--- Interrupt and reset vectors for 65816
.segment "VECTOR"
; native mode   COP,        BRK,        ABT
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           NMIHandler, $0000,      $0000

.word           $0000,      $0000   ; four unused bytes

; emu mode      COP,        BRK,        ABT
.addr           $0000,      $0000,      $0000
;               NMI,        RST,        IRQ
.addr           $0000,      ResetHandler, $0000
