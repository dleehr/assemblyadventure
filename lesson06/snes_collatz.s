; Calculate the total stopping time of the Collatz Conjecture on SNES

NMITIMEN    = $4200 ; enable flag for v-blank
RDNMI       = $4210 ; read the NMI flag status

.segment "CODE"
.proc   ResetHandler
        ; switch to emulation mode, set X and Y to 16-bit
        clc
        xce
        rep #$10
        sep #$20
        ; set the stack pointer to $1fff
        ldx #$1fff  ; load $1fff into X
        txs         ; transfer X to stack pointer

        ; calculate total stopping time of 27 ($1b)
        lda #27     ; start value n = 27 (can I do it this way instead of hex)
        pha         ; push A to the stack
        lda #$00    ; now load 0 into a, this will be result
        pha
        jsr Collatz ; jump to subroutine
        pla         ; pull result off stack - A = 111 ($6f)
        .byte $42, $00  ; breakpoint for bsnes+
        pla         ; reset stack pointer
Loop:   jmp Loop    ; Loop forever
.endproc


; Subroutine to calculate total stopping time for 8 bit integer
; parameters: n : .byte
; returns: r: .byte
.proc Collatz
    phd     ; Push Direct register to stack
    tsc     ; transfer stack to (via accumulator)...
    tcd     ; ...direct register (is this only 8 bits - NO, C is the 16-bit accumulator)
    ; Now establish constants for variable access by direct addressing
    StepCount = $05
    Input = $06
    ; Local variable for calculations
    lda Input   ; git input number off the stack
    rep #$20    ; set A to 16-bit
    and #$00ff  ; Clear B (upper 8 bits of accumulator) so that we're working with 8 bits
    pha         ; Create local variable on the stack
    ; Check if result is one
CheckOne:
    lda $01, S  ; load current value into A from local stack variable
    dec         ; decrement by 1
    beq Return  ; Done if now zero
    ; Otherwise, check if value is even
CheckEven:
    lda #$0001  ; A = $0001
    and $01, S  ; bit-wise AND of the current value and A above
    bne CheckOdd ; if bit 0 is set, value was odd
    pla         ; now pull the value off the stack
    lsr         ; divide by two since it was even
    pha         ; push it back on the stack
    inc StepCount ; Took another step
    bra CheckOne ; Start over at CheckOne to see if we're done
CheckOdd:
    jsr MulByThree  ; Multiply current value by 3
    pla             ; pull value off stack
    inc             ; increment by one
    pha             ; push value back onto stack
    inc StepCount   ; took a step
    bra CheckEven   ; check for even-ness. Skips CheckOne because we just added 1
Return:
    pla             ; pull current value off stack to restore SP before rts
    sep #$20        ; set A back to 8-bit
    pld             ; restore caller's frame pointer
    rts             ; return to caller
.endproc

; subroutine to multiply a 16 bit value by 3
; parameters: n : .word
.proc   MulByThree
    ; create frame pointer for this subroutine
    phd     ; push existing direct register to the stack
    tsc     ; transfer stack to ...
    tcd     ; ... direct register
    ; Constant to access input param
    ; This is 05 because...
    ; SP+00 and 01 are the direct register we just pushed (16-bit)
    ; 02 and 03 are the return address (16-bit)
    ; 04 is the 8-bit placeholder for the result
    ; 05 is the 8-bit input value pushed
    Input = $05
    lda Input       ; Load direct the input value into a
    clc             ; clear carry flag - ensure we're not mixing in old junk
    adc Input       ; Input = Input + Input
    adc Input       ; Input = Input + Input
    sta Input       ; Store input back on stack (note we don't push or pull)
    pld             ; prepare to return, we're done with our direct reg, so undo the phd
    rts             ; return to caller
.endproc

; Now setup V-Blank NMI Handler
.proc   NMIHandler
    lda RDNMI           ; read NMI status, acknowledge NMI
    ; this is where we would do graphics update
    rti                 ; return to (from?) interrupt
.endproc

; Interrupt and reset vectors for 65816

.segment "VECTOR"
; native        COP,    BRK,    ABT
.addr           $0000,  $0000,  $0000
;               NMI,    RST,    IRQ
.addr           NMIHandler, $0000, $0000

.word           $0000, $0000 ; four unused bytes

; emulation     COP,    BRK,    ABT
.addr           $0000,  $0000,  $0000
;               NMI,    RST,    IRQ
.addr           $0000,  ResetHandler, $0000

