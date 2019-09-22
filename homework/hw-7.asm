; (단독) 20181634 박수현

TITLE Minimum Work Time (s181634HW07.asm)
; Given length of m tasks t_1, t_2, ..., t_m and
; free time of n days d_1, d_2, ..., d_n, calculates
; minimum time required to finish all given tasks.
; If it's impossible, print -1.

; Suhyun Park (20181634)
; CSE undergraduate, Sogang U

; Input
; ======
; Reads multiple lines. First line has the number of test cases K.
; 2K lines follows. Two lines are a single test case.
; First line contains m and t_1 .. t_m, and second line contains
; n and d_1 .. d_n.

; Output
; ======
; Outputs the minimum time required to finish all given tasks,
; by test case. If it's impossible, print -1.

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
    
    ; variables as defined in the problem
    t               DWORD   31 DUP (?)
    m               DWORD   ?
    d               DWORD   31 DUP (?)
    n               DWORD   ?

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

swap PROC
    ; Swap two DWORDs.
    ; registers are preserved.
    ; Input:
    ;   edi = offset of first DWORD
    ;   esi = offset of second DWORD
    push    eax
    push    ebx
    mov     eax,    [edi]
    mov     ebx,    [esi]
    mov     [edi],  ebx
    mov     [esi],  eax
    pop     ebx
    pop     eax
    ret
swap ENDP

quicksort PROC
    ; Perform quicksort on DWORD array.
    ; registers are preserved.
    ; Input:
    ;   edi = array start offset
    ;   esi = array end offset

    ; if start >= end, return
    cmp     edi,    esi
    jae     Sort_Return

    push    eax                         ; save registers
    push    ebx
    push    ecx
    push    edx
    
    ; set pivot to 1st element
    mov     eax,    edi                 ; = pointer p
    mov     ebx,    edi                 ; = pointer i
    mov     ecx,    esi                 ; = pointer j
    mov     edx,    esi                 ; = end index

    push    esi
    push    edi

    Sort_Loop:
        ; while (i < j)
        cmp     ebx,    ecx
        jae     Sort_End

        Sort_Left_Increment:
            ; while (*i <= *p) increment pointer i
            mov     esi,    [ebx]       ; esi = [i]
            mov     edi,    [eax]       ; edi = [p]
            cmp     esi,    edi
            ja      Sort_Right_Decrement
            cmp     ebx,    edx
            ja      Sort_Right_Decrement
            add     ebx,    SIZEOF DWORD
            jmp     Sort_Left_Increment
        Sort_Right_Decrement:
            ; while (*j > *p) decrement pointer j
            mov     esi,    [ecx]       ; esi = [j]
            mov     edi,    [eax]       ; edi = [p]
            cmp     esi,    edi
            jbe     Sort_Swap
            sub     ecx,    SIZEOF DWORD
            jmp     Sort_Right_Decrement
        Sort_Swap:
            ; if (i < j) swap array[i] and array[j]
            cmp     ebx,    ecx
            jae     Sort_Loop
            mov     esi,    ebx
            mov     edi,    ecx
            call    swap
        jmp     Sort_Loop
    
    Sort_End:
        ; swap array[p] and array[j]
        mov     esi,    eax
        mov     edi,    ecx
        call    swap

        ; quicksort [start .. j - 1] recursively
        pop     edi
        sub     ecx,    SIZEOF DWORD
        mov     esi,    ecx
        call    quicksort

        ; quicksort [j + 1 .. end] recursively
        pop     esi
        add     ecx,    2 * SIZEOF DWORD
        mov     edi,    ecx
        call    quicksort

        ; restore registers
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax

    Sort_Return:
        ret
quicksort ENDP

solve PROC
    ; Read values and solves problem.

    ; stdin >> m
    call    read_int32
    mov     m,      eax

    ; stdin >> t (array)
    mov     ecx,    m
    mov     edi,    OFFSET t
    t_Read_Loop:
        push    ecx
        push    edi
        call    read_int32
        pop     edi
        pop     ecx
        mov     [edi],  eax
        add     edi,    SIZEOF DWORD
        loop    t_Read_Loop

    ; sort t (array)
    sub     edi,    SIZEOF DWORD
    mov     esi,    edi
    mov     edi,    OFFSET t
    call    quicksort

    ; stdin >> n
    call    read_int32
    mov     n,      eax

    ; stdin >> d (array)
    mov     ecx,    n
    mov     edi,    OFFSET d
    d_Read_Loop:
        push    ecx
        push    edi
        call    read_int32
        pop     edi
        pop     ecx
        mov     [edi],  eax
        add     edi,    SIZEOF DWORD
        loop    d_Read_Loop

    ; sort d (array)
    sub     edi,    SIZEOF DWORD
    mov     esi,    edi
    mov     edi,    OFFSET d
    call    quicksort

    ; Maintain two pointers and match values in array t - array d.
    ; For each t_i, there must exist d_j such that t_i <= d_j.
    xor     eax,    eax                 ; answer
    xor     ebx,    ebx                 ; (i) index to t
    xor     ecx,    ecx                 ; (j) index to d
    mov     esi,    OFFSET t
    mov     edi,    OFFSET d
    Solve_Loop:
        ; if (ebx >= m || ecx >= n) break loop
        cmp     ebx,    m
        jae     Solve_Loop_End
        cmp     ecx,    n
        jae     Solve_Loop_End

        ; if (t_i <= d_j) we found a match -- increment i and j
        ; else increment j
        push    ebx
        push    ecx
        mov     ebx,    [esi]
        mov     ecx,    [edi]
        cmp     ebx,    ecx
        pop     ecx
        pop     ebx
        ja      Not_Matched
        Matched:
            add     eax,    [edi]
            inc     ebx
            inc     ecx
            add     esi,    SIZEOF DWORD
            add     edi,    SIZEOF DWORD
            jmp     Solve_Loop
        Not_Matched:
            inc     ecx
            add     edi,    SIZEOF DWORD
            jmp     Solve_Loop
    Solve_Loop_End:
        ; if all t_i is matched, then i should be equal to m
        cmp     ebx,    m
        je      Solve_Matched
    ; not matched:
        mov     eax,    -1
    Solve_Matched:
        call    write_int32
        call    print_ln
    Solve_Return:
        ret
solve ENDP

main PROC
    call    init_stdio

    ; stdin >> testcase count
    call    read_int32
    mov     ecx,    eax

    ; if testcase count = 0, return immediately
    test    ecx,    ecx
    jz      Main_Exit

    Main_Loop:
        push    ecx
        call    solve
        pop     ecx
        loop    Main_Loop
    Main_Exit:
        exit

main ENDP
END main