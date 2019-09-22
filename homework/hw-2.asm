TITLE Polynomial Calculate (s181634HW02.asm)
; Calculates 38x_1 + 47x_2 + 19x_3.

; Suhyun Park (20181634)
; CSE undergraduate, Sogang U

; Input
; ======
; None.

; Output
; ======
; Outputs 38x_1 + 47x_2 + 19x_3, where
; x_1, x_2, x_3 is defined in CSE3030_PHW02_2019.inc
; as x1 (DWORD), x2 (DWORD), x3 (DWORD).

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW02_2019.inc

.code
main PROC
	mov ebx, x3
	add ebx, x1
	add ebx, x1     ; ebx = 2x_1 + x_3
	mov eax, x2
	add eax, x2
	add eax, x2     ; eax = 3x_2
	add eax, eax    ; eax = 6x_2
	add eax, ebx    ; eax = 2x_1 + 6x_2 + x_3
	add eax, ebx    ; eax = 4x_1 + 6x_2 + 2x_3
	add eax, eax    ; eax = 8x_1 + 12x_2 + 4x_3
	add eax, ebx    ; eax = 10x_1 + 12x_2 + 5x_3
	add eax, eax    ; eax = 20x_1 + 24x_2 + 10x_3
	add eax, eax    ; eax = 40x_1 + 48x_2 + 20x_3
	sub eax, ebx    ; eax = 38x_1 + 48x_2 + 19x_3
	sub eax, x2     ; eax = 38x_1 + 47x_2 + 19x_3
	call WriteInt   ; print eax
	exit
main ENDP
END main