; =============================================================================
; Doorbell for Krisfog (wave player) with 9S08DZ60 board for battery supply
; =============================================================================

; ===================== INCLUDE FILES ==========================================
#include "dz60.inc"
#include "cop.sub"
#include "lib.sub"
#include "wave.sub"
; ====================  EQUATES ===============================================
RXD1_A  @pin    PTA,0           ; Parallel to IRQ, to be input
RXD1_E  @pin    PTE,1           ; Parallel to IRQ, to be input
LED2    @pin    PTA,6           ; Status LED
IRQ     @pin    PTA,7           ; IRQ pin to wake up from sleep
UZ_MEAS @pin    PTA,5           ; Do not need to be handled, because R2 and R3 not populated
TXCAN   @pin    PTE,6           ; Do not need to be handled, because CAN tranceiver not populated
RXCAN   @pin    PTE,7           ; Do not need to be handled, because CAN tranceiver not populated

; ====================  VARIABLES  ============================================
#RAM

; ====================  PROGRAM START  ========================================
#ROM

start:
        sei                     ; Disable interrupts

        ldhx    #XRAM_END       ; H:X points to SP
        txs                     ; Init SP

        lda     SPMSC1
        and     #$F7            ; Clear LVDSE -> Disable low voltage detection in Stop Mode
        sta     SPMSC1

        jsr     COP_Init        ; Init watchdog
        bsr     PTX_Init        ; Init port bits to output to decrease current in stop mode
        jsr     WAV_Init        ; Init wave player PWM channels and enable its interrupt
        bsr     PIRQ_init       ; Init Port IRQ pin for wakeup

        cli                     ; enable interrupts

        bset    LED2.,LED2      ; LED On

	mov	#3,startbell	; Play wave 3 times

waitbell                        ; Wait for end of wave
        jsr     KickCop         ; Update watchdog
        lda     startbell       ; Check if wave is still playing
        bne     waitbell        ; Wait

        bclr    LED2.,LED2      ; LED Off

        ; Deinit RTC to not wake up from stop mode
        clr     RTCSC           ; Disable RTC
        bset    RTIF.,RTCSC     ; Clear the maybe pending RTC IT

        ; Sleep down (activate Stop Mode)
        stop

        bra     start           ; Re-init everything, start from skratch


; ===================== ROUTINES ================================================

; ------------------------------------------------------------------------------
; Parallel Input/Output Control
; To prevent extra current consumption caused by flying not connected input
; ports, all ports shall be configured as output. I have configured ports to
; low level output by default.
; There are only a few exceptions for the used ports, where different
; initialization is needed.
PTX_Init
        ; All ports to be low level
        clr     PTA
        clr     PTB
        clr     PTC
        clr     PTD
        clr     PTE
        clr     PTF
        clr     PTG

        ; All ports to be output
        lda     #$FF
        sta     DDRA
        bclr    IRQ.,DDRA       ; IRQ to be Input, otherwise IRQ wake up will not work
        bclr    RXD1_A.,DDRA    ; Parallel to IRQ pin, to be input
        sta     DDRB
        sta     DDRC
        sta     DDRD
        sta     DDRE
        bclr    RXD1_E.,DDRE    ; Parallel to IRQ pin, to be input
        sta     DDRF
        sta     DDRG

        rts

; ------------------------------------------------------------------------------
; Init Port Interrupt pin PTA0 to wake up from Stop Mode
PIRQ_init
        clra                    ; Interrupt disable
        sta     PTASC           ; Interrupt Status and Control Register

        clra                    ; A pull-up device is connected to the associated pin and detects falling edge/low level for interrupt generation
        sta     PTAES           ; Interrupt Edge Select Register

        lda     #RXD1_A_        ; Pin enabled as interrupt
        sta     PTAPS           ; Interrupt Pin Select Register

        lda     #PTAACK_        ; Write to PTxACK in PTxSC to clear any false interrupts
        sta     PTASC           ; Interrupt Status and Control Register

        lda     #PTAIE_         ; Edge only, Interrupt enable
        sta     PTASC           ; Interrupt Status and Control Register

        rts

; ------------------------------------------------------------------------------
; Port IRQ pin interrupt routine
PIRQ_IT
        lda     #PTAACK_|PTAIE_ ; Write to PTxACK in PTxSC to clear interrupt
        sta     PTASC           ; Interrupt Status and Control Register
        ; Do nothing, this is only a wake up interrupt
        rti

; ===================== STRINGS ================================================

; ===================== IT VECTORS ==========================================
#VECTORS
        org     Vport
        dw      PIRQ_IT

        org     Vreset
        dw      start           ; Program Start




