TITLE Strange Worm House (s181634HW04.asm)
; Calculates the count of worms in the room of the
; strange worm house by its room row and column numbers.

; Suhyun Park (20181634)
; CSE undergraduate, Sogang U

; Input
; ======
; Reads two integers, R and C.

; Output
; ======
; Outputs the count of worms in the room of the
; strange worm house by its room row and column numbers,
; which is H[R][C].

INCLUDE Irvine32.inc

.data
promptR         BYTE    "Enter R: ", 0
promptC         BYTE    "Enter C: ", 0
__sentinel      DWORD   11 DUP (1)
dp              DWORD   13 DUP (11 DUP (0)) 

; Approach by dynamic programming:

; Let f(x, y) = H[x][y]. then

;           | 1                          if x = -1
; f(x, y) = | 0                          if x != -1 and y = 0
;           | f(x - 1, y) + f(x, y - 1)  if 0 <= x <= 12 and 1 <= y <= 10

; Precalculate all f-values and store them in 2-dimensional array dp
; with row-major order. then

;              dp[x][y] = dp[x - 1][y] + dp[x][y - 1]
; =>  *(dp + (11x + y)) = *(dp + (11(x - 1) + y)) + *(dp + (11x + (y - 1))

; Let (dp + (11x + y)) be the destination index, (edi). then

; =>             *(edi) = *(dp + (11(x - 1) + y)) + *(dp + (11x + (y - 1))
; =>             *(edi) = *(dp + 11x + y - 11) + *(dp + 11x + y - 1)
; =>             *(edi) = *(edi - 11) + *(edi - 1)

; Largest value H[12][10] = 497420, which does not fit in BYTE or WORD.

.code
main PROC
    mov     edi,         OFFSET dp

    ; Run precalculations for 0 <= x <= 12
    mov     ecx,         13
    Loop_I:
        ; Save outer loop counter
        mov     ebx,         ecx

        ; Run precalculations for 1 <= y <= 10,
        ; adding (TYPE dp) to (edi) to omit y = 0
        add     edi,         (TYPE dp)
        mov     eax,         0
        mov     ecx,         10
        Loop_J:
            ; *(edi) = *(edi - 11) + *(edi - 1)
            ; eax already has *(edi - 1),
            ; so *(edi) = *(edi - 11) + *(eax)
            add     eax,         [edi - 11 * (TYPE dp)]
            mov     [edi],       eax
            add     edi,         (TYPE dp)
        loop    Loop_J
        ; Restore outer loop counter
        mov     ecx,         ebx
    loop    Loop_I

    ; (esi) will be the source index for the answer,
    ; when *(esi) = dp[R][C] = *(DP + 11R + C)
    mov     esi,         OFFSET dp

    ; Input R
    mov     edx,         OFFSET promptR
    call    WriteString
    call    ReadInt

    ; Increment (esi) by R * 11 * (TYPE dp)
    mov     ecx,           eax
    Loop_R:
        add     esi,         11 * (TYPE dp)
    loop    Loop_R

    ; Input C
    mov     edx,         OFFSET promptC
    call    WriteString
    call    ReadInt

    ; Increment (esi) by C * (TYPE dp)
    mov     ecx,         eax
    Loop_C:
        add     esi,         (TYPE dp)
    loop    Loop_C

    ; Print *(esi)
    mov     eax,         [esi]
    call    WriteDec

    exit
main ENDP
END main