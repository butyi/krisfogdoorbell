; =============================================================================
; Doorbell for Krisfog (wave player) with 9S08DZ60 board
; =============================================================================

; ===================== INCLUDE FILES ==========================================
#include "dz60.inc"
#include "cop.sub"
#include "lib.sub"
#include "wave.sub"
; ====================  EQUATES ===============================================

; ====================  VARIABLES  ============================================

#RAM

PTEe   	ds   	1		; Previous state of PTE 

; ====================  PROGRAM START  ========================================
#ROM

start:
        sei                     ; disable interrupts

        ldhx    #XRAM_END       ; H:X points to SP
        txs                     ; init SP

        jsr     COP_Init	; Init watchdog
        jsr     WAV_Init	; Init wave player PWM channels and enable its interrupt

        cli                     ; enable interrupts

        ; Init debug LED
        mov     #PIN6_,PTA      ; Switch debog LED On
        mov     #PIN6_,DDRA     ; Set debog LED port output
	mov	PTE,PTEe	; Save PTE state

	mov	#1,startbell	; Start wave at power on to hear end of power cut :)

; Main loop entry point
main
        jsr     KickCop         ; Update watchdog

	; Show active bell on status LED
        lda     startbell	; Check wave playing status
	beq	m_ledki		; Jump if not playing currently
        bset    PIN6.,PTA       ; Switch LED On, since is playing
	bra	m_ledend
m_ledki
        bclr    PIN6.,PTA       ; Switch LED Off
m_ledend

	; Check falling edge of button port, which is a button push event actually
	lda	PTE
	coma
	and	PTEe
	and	#PIN1_
	beq	m_nopushevent
	; Button press event
	mov	#3,startbell	; Start play wave 3 times
m_nopushevent
	mov	PTE,PTEe	; Save PTE state for edge detection

	bra	main            ; Jump back to main loop

; ===================== ROUTINES ================================================

; ===================== STRINGS ================================================

; ===================== IT VECTORS ==========================================
#VECTORS
        org     Vreset
        dw      start           ; Program Start




