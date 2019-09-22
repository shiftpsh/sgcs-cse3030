TITLE asm-final-q1

; Suhyun Park (20181634)
; CSE undergraduate, Sogang U

include Irvine32.inc

.data
    CR              = 0Dh
    LF              = 0Ah
    stdinHandle     HANDLE  ?
    stdoutHandle    HANDLE  ?
    charInBuffer    BYTE    ?
    bytesRead       DWORD   ?
    charOutBuffer   BYTE    ?
    bytesWrite      DWORD   ?

    countArray      DWORD   10 DUP (1)
.code

; ALL procedures does not preserve registers if not specified.

init_stdio PROC
    ; Initializes standard IO.
    INVOKE  GetStdHandle,   STD_INPUT_HANDLE
    mov     stdinHandle,    eax
    INVOKE  GetStdHandle,   STD_OUTPUT_HANDLE
    mov     stdoutHandle,   eax
    ret
init_stdio ENDP

getchar PROC
    ; Reads one character.
    ; needs to call init_stdio first.
    ; Output:
    ;   al = read character
    ;   ecx = bytesRead

    xor     al,     al
    INVOKE  ReadFile, stdinHandle, OFFSET charInBuffer, 1, OFFSET bytesRead, 0
    mov     al,     charInBuffer
    mov     ecx,    bytesRead
    ret
getchar ENDP

putchar PROC
    ; Puts one character.
    ; needs to call init_stdio first.
    ; Input:
    ;   dl = char to write

    mov     [charOutBuffer], dl
    INVOKE  WriteFile, stdoutHandle, OFFSET charOutBuffer, 1, OFFSET bytesWrite, 0
    ret
putchar ENDP

print_ln PROC
    ; Prints newline.
    ; needs to call init_stdio first.
    
    mov     dl,     CR
    call    putchar
    mov     dl,     LF
    call    putchar
    ret
print_ln ENDP

consume_nondigit PROC
    ; Consumes non-digit and non-sign characters.
    ; needs to call init_stdio first.
    ; Output:
    ;   al = last read digit/sign character
    ;   ecx = 0 if no other characters are present
    
    Consume_Nondigit_Loop:
        call    getchar

        ; return if no chars read
        cmp     ecx,    0
        je      Consume_Nondigit_End

        ; return if sign found
        cmp     al,     '+'
        je      Consume_Nondigit_End
        cmp     al,     '-'
        je      Consume_Nondigit_End

        cmp     al,     CR
        je      Consume_Nondigit_Loop
        cmp     al,     LF
        je      Consume_Nondigit_Loop

        ; continue if number not found
        cmp     al,     '0'
        jb      Consume_Nondigit_Loop
        cmp     al,     '9'
        ja      Consume_Nondigit_Loop
        jmp     Consume_Nondigit_End
    Consume_Nondigit_End:
        ret
consume_nondigit ENDP

read_int32 PROC
    ; Read next signed integer presented in standard input.
    ; Output:
    ;   eax = read integer
    ;   ecx = 0 if no integer is present

    ; consume non-digit and check if there is more input
    call    consume_nondigit
    cmp     ecx,    0
    je      Read_End

    ; if read char is '+'
    cmp     al,     '+'
    je      Read_Start_Positive

    ; if read char is '-'
    cmp     al,     '-'
    je      Read_Start_Negative

    ; if read char is a number
    jmp     Read_Start_Numeric

    ; use edi as sign and eax as absolute value
    Read_Start_Positive:
        mov     edi,    1
        xor     eax,    eax             ; eax = 0
        jmp     Read_Loop
    Read_Start_Negative:
        mov     edi,    -1
        xor     eax,    eax             ; eax = 0
        jmp     Read_Loop
    Read_Start_Numeric:
        mov     bl,     al
        and     bl,     0Fh
        xor     eax,    eax
        movzx   eax,    bl              ; eax = (first digit)
        mov     edi,    1
        jmp     Read_Loop
    Read_Loop:
        ; temporarily save accumulated integer to edx
        mov     edx,    eax

        push    edi                     ; save registers
        push    edx
        INVOKE  getchar
        pop     edx                     ; restore registers
        pop     edi

        ; if no characters read
        cmp     ecx,    0
        je      Read_End

        ; if read character is not a number
        cmp     al,     '0'
        jb      Read_End
        cmp     al,     '9'
        ja      Read_End

        ; store read character
        xor     ebx,    ebx
        mov     bl,     al

        ; restore save accumulated integer from edx
        mov     eax,    edx
        xor     edx,    edx

        ; append read number to eax
        mov     ecx,    10
        mul     ecx
        and     bl,     0Fh
        add     eax,    ebx

        ; read more numbers
        jmp     Read_Loop
    Read_End:
        ; restore save accumulated integer from edx
        mov     eax,    edx

        ; multiply sign
        imul    edi
        ret
read_int32 ENDP

write_int32 PROC
    ; Write a single signed integer.
    ; Input:
    ;   eax = integer to write
    
    cmp     eax,    0
    jl      Write_Start_Negative
    je      Write_Start_Zero
    jmp     Write_Precalculate

    ; store absolute value at eax
    Write_Start_Negative:
        ; if negative, print '-'
        mov     dl,     '-'
        push    eax
        call    putchar
        pop     eax

        ; eax <- (-eax)
        mov     edi,    -1
        imul    edi
        jmp     Write_Precalculate
    Write_Start_Zero:
        ; just write '0 ' in this case
        mov     dl,     '0'
        call    putchar
        jmp     Write_End
    Write_Precalculate:
        ; ecx will store count of decimal places of eax
        xor     ecx,    ecx
        mov     ebx,    10
    Write_Calculate:
        ; divide eax by 10 until it gets 0
        cmp     eax,    0
        je      Write_Loop
        xor     edx,    edx
        mov     ebx,    10
        div     ebx

        ; store digits in stack - when popped, it'll be in reversed order
        push    edx
        inc     ecx
        jmp     Write_Calculate
    Write_Loop:
        ; pop digits in stack
        pop     edx

        ; convert integer to number character
        or      dl,     30h
        push    ecx
        call    putchar
        pop     ecx
        loop    Write_Loop
    Write_End:
        ret
write_int32 ENDP

solve PROC
    mov     esi,    0
    mov     ecx,    10
    Initialize_Loop:
        mov     countArray[esi * SIZEOF DWORD], 0
        inc     esi
        loop    Initialize_Loop

    mov     ebx,    10
    mov     ecx,    SIZEOF DWORD
    Division_Loop:
        div     ebx             ; eax -> eax * 10 + edx
        inc     countArray[edx * SIZEOF DWORD]
        xor     edx,    edx
        cmp     eax,    0       ; if (eax == 0) end procedure
        je      Division_Loop_End
        jmp     Division_Loop
    
    Division_Loop_End:
        mov     esi,    0
        mov     ecx,    10

    Array_Print:
        mov     eax,    countArray[esi * SIZEOF DWORD]
        push    esi
        push    ecx
        call    write_int32
        mov     dl,     ' '
        call    putchar
        pop     ecx
        pop     esi
        inc     esi
        loop    Array_Print

    call    print_ln

    ret
solve ENDP

main PROC
    call    init_stdio

    Main_Loop:
        call    read_int32      ; eax = (1st)
        cmp     ecx,    0
        je      Main_Exit
        push    eax             ; stack: (1st) <- top
        call    read_int32      ; eax = (2nd)
        push    eax             ; stack: (1st) (2nd) <- top
        call    read_int32      ; eax = (3rd)

        pop     ebx             ; ebx = (2nd)
        mul     ebx             ; eax = (2nd) * (3rd)
        pop     ebx             ; ebx = (1st)
        mul     ebx             ; eax = (1st) * (2nd) * (3rd)

        call    solve

        ; call    write_int32
        ; call    print_ln

        jmp     Main_Loop
    Main_Exit:
        exit

main ENDP
END main