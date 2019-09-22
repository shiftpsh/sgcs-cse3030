TITLE Multiplication Table (s181634HW03.asm)
; Calculates the multiplication table of a single digit integer.

; Suhyun Park (20181634)
; CSE undergraduate, Sogang U

; Input
; ======
; Reads one single digit integer n.

; Output
; ======
; Outputs n * 1 to n * 9.

INCLUDE Irvine32.inc

.data
prompt          BYTE    "Enter a digit(2~9): ", 0
template        BYTE    "0 * 0 = ", 0

; Since input is guaranteed to be a single digit integer,
; the program directly sets the 1st and 5th character
; of the template string (template[0] and template[4]
; respectively) and prints it.

.code
main PROC
    mov     edx,         OFFSET prompt
    call    WriteString                       ; (prompt) -> output
    mov     edx,         OFFSET template
    call    ReadInt                           ; eax <- input
    add     template[0], al                   ; set 1st char of template to
                                              ; the input number.
    mov     ebx,         eax                  ; ebx <- eax
                                              ; ebx will hold the initial input;
                                              ; eax will be the accumulator.

    mov     ecx,         9                    ; ecx <- 9
    L_Table:                                  ; while (ecx > 0):
        inc     template[4]                   ; increment 4th char of template
                                              ; so that it becomes the number
                                              ; of current loop count.
        call    WriteString                   ; (template) -> output
        call    WriteDec                      ; eax -> output
        add     eax,         ebx              ; eax <- ebx * (loop count)
        call    Crlf                          ; (CRLF) -> output
    loop    L_Table                           ; ecx <- ecx - 1

    exit
main ENDP
END main