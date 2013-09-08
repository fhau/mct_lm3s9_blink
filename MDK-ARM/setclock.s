;  *********************************************
;  File:        setclock.s
;  Title:       setup for external XTAL clock
;  Purpose:     LM3S9D96-DK
;  Business:    HSA Elektrotechnik
;  Compiler:    MDK-ARM
;  Author/Date: Franz Haunstetter / 06.09.13
;  Comment:     new
;  *********************************************

SYSCTL_RCC_R          EQU 0x400FE060  ; Main run-mode clock config register
SYSCTL_RCC_SYSDIV_M   EQU 0x07800000  ; System Clock Divisor
SYSCTL_RCC_USESYSDIV  EQU 0x00400000  ; Enable System Clock Divider
SYSCTL_RCC_SYSDIV_S   EQU 23          ; System Clock Divider shift
SYSCTL_RCC_PWRDN      EQU 0x00002000  ; PLL Power Down
SYSCTL_RCC_BYPASS     EQU 0x00000800  ; PLL Bypass
SYSCTL_RCC_XTAL_M     EQU 0x000007C0  ; Crystal Value
SYSCTL_RCC_XTAL_16MHZ EQU 0x00000540  ; 16 MHz
SYSCTL_RCC_OSCSRC_M   EQU 0x00000030  ; Oscillator Source
SYSCTL_RCC_OSCSRC_MAIN EQU 0x00000000 ; MOSC
SYSCTL_RCC_IOSCDIS    EQU 0x00000002  ; Internal Oscillator Disable
SYSCTL_RCC_MOSCDIS    EQU 0x00000001  ; Main Oscillator Disable

SYSCTL_RCC2_R         EQU 0x400FE070  ; 2nd run-mode clock config register
SYSCTL_RCC2_USERCC2   EQU 0x80000000  ; Use RCC2
SYSCTL_RCC2_BYPASS2   EQU 0x00000800  ; PLL Bypass 2

;******************************************************************************
;
; Place code into the standard code section.
;
;******************************************************************************
        AREA    CLOCK, CODE, READONLY
        THUMB

        EXPORT  SetClockXTAL
SetClockXTAL
        ;
        ; Sets the external clock source for synchronizing the system clock
		; by disabling RCC2 and setting RCC for PLL 16 MHz -> 400 MHz -> 66.7 MHz output
        ;
        LDR     R0, = SYSCTL_RCC_R
		LDR     R1, [R0]
		AND     R1, #:NOT:(SYSCTL_RCC_XTAL_M:OR:SYSCTL_RCC_BYPASS:OR:SYSCTL_RCC_PWRDN)
		AND     R1, #:NOT:(SYSCTL_RCC_OSCSRC_M:OR:SYSCTL_RCC_MOSCDIS)
		AND     R1, #:NOT:(SYSCTL_RCC_SYSDIV_M)
		ORR     R1, #(2:SHL:SYSCTL_RCC_SYSDIV_S):OR:SYSCTL_RCC_USESYSDIV
		ORR     R1, #SYSCTL_RCC_OSCSRC_MAIN:OR:SYSCTL_RCC_XTAL_16MHZ
		STR     R1, [R0]
		
        LDR     R0, = SYSCTL_RCC2_R
		LDR     R1, [R0]
        AND     R1, #:NOT:SYSCTL_RCC2_USERCC2
		STR     R1, [R0]
		
        BX		LR

;******************************************************************************
;
; Make sure the end of this section is aligned.
;
;******************************************************************************
        ALIGN

;******************************************************************************
;
; Tell the assembler that we're done.
;
;******************************************************************************
        END
