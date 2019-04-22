<p align=right>Week 4</p>

# Basic Elements of Assembly Language

예제 코드

```assembly
TITLE Add and Subtract               (AddSub.asm)
; adds and subtracts 32-bit integers.
INCLUDE Irvine32.inc
.code                     ; beginning of the code segment
main PROC                 ; beginning of a procedure (main)
    mov eax, 10000h       ; EAX = 10000h
    add eax, 40000h       ; EAX = 50000h
    sub eax, 20000h       ; EAX = 30000h
    call DumpRegs         ; display registers
    exit                  ; calls predefined Windows function that halts the proc
main ENDP                 ; end of a procedure
END main
```

## Constants, Expressions and Literals

### Constants

* Integer: `[{+|-}] digits [radix]`
  * e. g. `26`, `-26`, `26d`, `11010011b`, `42q`, `42o`, `1Ah`, `0A3h`
  * Suffixes: `b` = binary, `o`/`q` = octal, `d` = decimal, `h` = hexadecimal. 대소문자 상관 없음
  * `A`부터 `F` 사이의 글자로 시작하는 16진수는 앞에 `0`을 붙여줘야 한다. e. g. `0ABCDh`
* Real: `[{+|-}] digits.[digits][exponent]`
  * e. g. `+1.0`, `3f800000r`
  * Suffix: `r` = encoded real. 대소문자 상관 없음
    * Encoded real: 실수의 비트 표현. `+1.0 ` = `3f800000r`
* Character and String
  * `'A'`, `"A"`
  * `'A Baby'`, `"A Baby"`
  * 큰따옴표와 작은따옴표 중 아무거나 사용해도 무관.

### Expressions

* `()`, `+`, `-`, `*`, `/`, `mod` 등
  * e. g. `16 / 5`, `-(3 + 4) * (6 - 1)`, `25 mod 3`
  * 전부 **constant expression** - 런타임이 아닌 **컴파일(어셈블) 타임에 어셈블러가 계산**한다

## Identifiers

변수, 상수, 프로시저, 라벨 이름.

* 1~247자, 기본적으로 **대소문자 구별하지 않음**
* 첫 글자는 알파벳이나 `_`, `@`, `$` 중 하나
* 일부 단어(reserved words) 사용 불가능
  * Instruction mnemonics, directives, type attributes, operators, predefined symbols

## Directives

어셈블러가 알아듣는 키워드

* 대소문자 구별하지 않으며, Intel instruction set에 속하지 않음 (단순히 어셈블러가 알아들으라고 있는 것)
* 코드 영역, 데이터 영역, 메모리 모델, 프로시저 선언 등에 사용
* e. g. `.data`, `.code`, `name PROC` 등
* 어셈블러 종속적이다 (다른 어셈블러는 다른 디렉티브를 쓸 수 있다)

## Instructions

어셈블러가 기계어로 어셈블해서 **CPU가 런타임에 실제 실행하는 코드** (기계 명령과 1:1로 대응됨)

* 표준 명령 형식: `[label:] mnemonic [operands...] [;comment]`

### Labels

코드와 데이터의 주소를 문자열로 표현, 저장

* 코드에서: `L1:`
  * 뒤에 `:` 붙음
  * goto 문과 비슷한 경우로 사용
* 데이터에서: `myArray` 
  * 뒤에 `:` 안 붙음

### Mnemonics

기계 명령을 기억하기 쉽게 만들어둔 것

* e. g. `mov`, `add`, `sub`, `inc`, `dec`, `mul`, ...

### Operands

기계 명령에 필요한 인자

* 상수 (constant)
  * 상수 인자는 immediate operand라고 불리기도 한다
  * e. g. `10`, `0DE34h` 등
* 상수 식 (constant-expression: 어셈블러가 계산해서 결국 constant)
  * e. g. `3 * 5` 등
* 레지스터 (register)
  * e. g. `eax`, `esp`, `eip` 등
* 메모리 (memory; <u>data label로 표현</u>)
  * e. g. `myArray`, `myByte`, `[myArray + 1]` 등

```assembly
stc

inc     eax
inc     myByte

add     ebx, ecx
sub     myByte, 25
add     eax, 36 * 25
```

위의 예와 같이 인자는 없을 수도 있고 여러 개 있을 수도 있다



### Comments

* `;`로 시작해서 뒤에 주석을 작성하거나...

* 아래와 같은 식으로 여러 줄에 걸쳐 코드를 작성할 수도 있다

* ```assembly
  COMMENT @
      (comment)
  @
  ```

  * 열고 닫는 문자 `@`는 프로그래머가 고를 수 있다

