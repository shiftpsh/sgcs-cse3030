TITLE Character Repeat (s181634HW05.asm)
; Repeats each of the characters in given string
; by given amount and prints it.

; Suhyun Park (20181634)
; CSE undergraduate, Sogang U

; Input
; ======
; Reads multiple lines. Each lines has one single digit
; integer and a string, separated by single space.
; The maximum length of the given input is 20,
; excluding CR, LF and including whitespaces.

; Output
; ======
; Outputs the repeated string line by line corresponding to
; the input.

include Irvine32.inc

.data
    READ_LIMIT      = 20
    WRITE_LIMIT     = READ_LIMIT * 9
    READ_BUF_SIZE   = READ_LIMIT + 3              ; character limit + cr + lf + nul
    WRITE_BUF_SIZE  = WRITE_LIMIT + 2             ; character limit + cr + lf
    CR              = 0Dh
    LF              = 0Ah
    stdinHandle     HANDLE  ?
    stdoutHandle    HANDLE  ?
    charBuffer      BYTE    ?
    inBuffer        BYTE    READ_BUF_SIZE DUP(?)  ; input buffer
    bytesRead       DWORD   ?
    outBuffer       BYTE    WRITE_BUF_SIZE DUP(?) ; output buffer
    bytesWrite      DWORD   ?

.code
main PROC
    INVOKE  GetStdHandle,   STD_INPUT_HANDLE
    mov     stdinHandle,    eax
    INVOKE  GetStdHandle,   STD_OUTPUT_HANDLE
    mov     stdoutHandle,   eax

    Main_Loop:
        mov     edx,    OFFSET inBuffer

        ; Read string
        Read_Loop:
            push    edx                     ; Save register; ReadFile does not preserve registers
            ; read a single char
            INVOKE  ReadFile, stdinHandle, OFFSET charBuffer, 1, OFFSET bytesRead, 0
            pop     edx                     ; restore registers

            cmp     DWORD PTR bytesRead, 0  ; check # of chars read
            je      Read_End                ; if read nothing, return

            ; Each end of line consists of CR and then LF
            mov     bl,     charBuffer      ; load chracter
            cmp     bl,     CR
            je      Read_Loop               ; if CR, read once more
            cmp     bl,     LF
            je      Read_End                ; End of line detected, return

            mov     [edx],  bl              ; Move the character to input buf
            inc     edx                     ; Increment buffer pointer
        jmp Read_Loop                       ; Go to start to read the next line
        Read_End:
            mov     BYTE PTR [edx], CR      ; Append CRLF and 0 at the end
            mov     BYTE PTR [edx + 1], LF
            mov     BYTE PTR [edx + 2], 0

        ; Check if first character is within '1' .. '9'
        ; If not, terminate program
        cmp     inBuffer, '1'
        jb      Main_End
        cmp     inBuffer, '9'
        ja      Main_End

        ; Use 1st char of inBuffer as our memory for repeat count
        and     inBuffer, 0Fh

        ; Save resulting string to buffer
        ; Use eax as out byte write count
        mov     eax,    2                   ; CRLF appended at the end
        mov     edx,    (OFFSET inBuffer) + 2 * (TYPE inBuffer) ; Start from third character
        mov     edi,    OFFSET outBuffer
        Write_Loop:
            mov     bl,     [edx]
            cmp     bl,     CR              ; If current character is CR or LF, return
            je      Write_End
            cmp     bl,     LF
            je      Write_End
            movzx   ecx,    inBuffer        ; Loop inBuffer times
            Character_Repeat:
                mov     ebx,    [edx]       ; Copy from inBuffer to outBuffer
                mov     [edi],  ebx
                inc     edi                 ; Increment outBuffer pointer
                inc     eax                 ; Increment out byte write count
                loop    Character_Repeat
            inc     edx
            jmp     Write_Loop
        Write_End:
            mov     BYTE PTR [edi], CR      ; append CRLF at the end
            mov     BYTE PTR [edi + 1], LF
            mov     bytesWrite, eax

        ; Write resulting string
        INVOKE  WriteFile, stdoutHandle, OFFSET outBuffer, bytesWrite, OFFSET bytesWrite, 0

        jmp     Main_Loop
    Main_End:
    exit
main ENDP
END main