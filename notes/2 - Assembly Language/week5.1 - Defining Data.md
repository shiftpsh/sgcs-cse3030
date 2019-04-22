<p align=right>Week 5</p>

# Assembling, Linking, and Running Programs

어셈블리 코드가 실행 파일로 변하는 과정

* **어셈블리 소스 파일 --> 오브젝트 파일 --> 실행 파일**
  * 어셈블러(assembler): 소스 --> 오브젝트 / 리스팅 파일 생성
  * 링커(linker): 오브젝트 --> 실행 파일 / 맵 파일 생성
  * 오브젝트 파일(.obj)에서 사용하는 주소는 전부 0을 기준으로 함 (상대 주소, relative address)
  * 리스팅 파일(.lst)에서는 프로그램이 어떻게 컴파일 되었는지 확인 가능

실행 파일은 로더(loader)에 의해 메모리에 로드되고 실행된다

### Listing File

```assembly
00000000 B8 00010000           mov eax, 10000h
00000005 05 00040000           add eax, 40000h
0000000A 2D 00020000           sub eax, 20000h
0000000F E8 00000000E          call DumpRegs
```

리스팅 파일의 예시. 왼쪽이 기계어, 오른쪽이 어셈블리 코드이다

- 어셈블리 소스 코드, 기계어, 주소 등을 포함하고 있는 파일이다

- 세그먼트 이름, 심볼(변수, 프로시저, 상수 등)도 볼 수 있다

- ```
  Segments and Groups:

  N a m e                      Size    Length    Align  Combine Class
  FLAT . . . . . . . . . . . . GROUP
  STACK  . . . . . . . . . . . 32 Bit  00001000  DWord  Stack   'STACK'
  _DATA  . . . . . . . . . . . 32 Bit  00000000  DWord  Public  'DATA'
  _TEXT  . . . . . . . . . . . 32 Bit  0000001B  DWord  Public  'CODE'
  ```

  - `_DATA`: 데이터 세그먼트, `_CODE`: 코드 세그먼트
  - 스택 크기는 `00001000` = 4KB, 코드 크기는 `0000001B` = 27B임을 알 수 있다

- ```
  Procedures, parameters and locals

  N a m e                  Type    Value     Attr
  CloseHandle  . . . . . . P Near  00000000  FLAT  Length=00000000 External STDCALL
  ClrScr . . . . . . . . . P Near  00000000  FLAT  Length=00000000 External STDCALL

  ...

  main . . . . . . . . . . P Near  00000000 _TEXT  Length=0000001B Public STDCALL
  ```

  - `Near`: 동일 세그먼트 내의 함수. `Far`는 동일 세그먼트에 있지 않은 함수

### Map File

.exe에서 사용하는 함수들의 코드 메모리 위치를 저장해 둔 파일

* 디버깅에 사용

# Defining Data

### Intrinsic Data Types

| Type             | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| `BYTE` `SBYTE`   | 8-bit integer                                                |
| `WORD` `SWORD`   | 16-bit integer                                               |
| `DWORD` `SDWORD` | 32-bit integer                                               |
| `QWORD` `SQWORD` | 64-bit integer                                               |
| `TBYTE`          | 80-bit integer if the initializer has a radix specifying the base of the number. |
| `REAL4`          | 4-byte(32-bit) IEEE short real                               |
| `REAL8`          | 8-byte(64-bit) IEEE long real                                |
| `REAL10`         | 10-byte(80-bit) IEEE extended real                           |

* 앞에 `S`가 붙는 정수형은 signed임을 말한다
  * C에서는 확연한 차이가 있지만 어셈블리에서는 그냥 구분을 쉽게 하기 위해 사용한다
  * e. g. `SBYTE`로 할당했더라도 unsigned로 사용 가능. 프로그래머가 쓰기 나름

## Data Definition Statement

* 메모리를 변수로 설정한다. `[name] directive initializer[,init...]`

* Data segment에 선언해야 한다. e. g.

* ```assembly
  .data
  B_Array    BYTE    00h, 10h, 31h
  Wval       SWORD   0A7A7h
  ```

* 여기 선언한 변수들은 전부 전역변수가 된다

  * 함수 내에서 지역변수를 설정할 수 있지만 지역변수는 stack에 들어간다

### Defining Bytes

```assembly
val1     BYTE   'A'   ; character constant
val2     BYTE   0     ; smallest unsigned byte
val3     BYTE   255   ; largest  unsigned byte
val4     SBYTE  -128  ; smallest signed   byte
val5     SBYTE  127   ; largest  signed   byte
val6     BYTE   ?     ; uninitialized byte
```

* `?`로 초기화되지 않은 변수를 선언할 수 있다
* `BYTE`(signed integer)를 음수로 초기화하는 건 불가능하진 않지만 좋은 코드 스타일은 아니라는 것 같다
  * `SBYTE`로 선언하면 MASM 디버거에서는 자동으로 signed integer로 취급한다

#### Defining multiple bytes of storage with initialization

```assembly
L1       BYTE   10, 20, 30, 40
L2       BYTE   10, 20, 30, 40
         BYTE   50, 60, 70, 80
         BYTE   81, 82, 83, 84
L3       BYTE   ?, 32, 41h, 00100010b
L4       BYTE   0Ah, 20h, 'A', 22h
```

* 어셈블리에는 배열에 경계가 없다 (배열의 끝은 프로그래머가 생각하기 나름)

* 위의 코드는 메모리에 다음과 같이 저장된다

  | Label           | Byte Value |
  | --------------- | ---------- |
  | `L1` (low-byte) | `0A`       |
  |                 | `14`       |
  |                 | `1E`       |
  |                 | `28`       |
  | `L2`            | `0A`       |
  |                 | `14`       |
  |                 | `1E`       |
  |                 | `28`       |
  |                 | (...)      |
  | `L3`            | `??`       |
  |                 | `20`       |
  |                 | `41`       |
  |                 | `22`       |
  | `L4`            | `0A`       |
  |                 | `20`       |
  |                 | `41`       |
  | (high-byte)     | `22`       |

### Defining Strings

```assembly
str1     BYTE   "Enter your name", 0            ; NUL: End of string
str2     BYTE   "Error: halting program", 0
str3     BYTE   'A', 'E', 'I', 'O', 'U'
str4     BYTE   "Checking Account", 0Dh, 0Ah,   ; \r\n
                "1. Create a new account", 0Dh, 0Ah,
                "2. Open an exsiting account", 0Dh, 0Ah, 0
```

* 전에 언급했듯이 큰따옴표와 작은따옴표 모두 쓸 수 있다
* `'A', 'E'. 'I', 'O', 'U'`는 `"AEIOU"`와 동치
* 맨 뒤에 `, 0`을 붙여 null-terminated string으로 만든다

### DUP Directive

```assembly
var1     BYTE   20 DUP(0)              ; 20 bytes, all 0
var2     BYTE   20 DUP(?)              ; 20 bytes, uninitialized
var3     BYTE   2 DUP("STACK")         ; 10 bytes, "STACKSTACK"
var4     BYTE   4 DUP(10, 20)          ; 8 bytes, 10, 20, 10, 20, ...
var5     BYTE   10, 3 DUP(0), 20       ; 5 bytes, 10, 0, 0, 0, 20
```

* `x DUP(y)`: `y`를 `x`번 반복해 할당
  * `x`와 `y`는 둘 다 상수 혹은 상수 식 인자여야 한다
  * `y`에는 쉽표가 들어가도 되고 string literal이 들어가도 된다

### Declaring Uninitialized Data

`.data?` 디렉티브를 사용할 수도 있다

* `.data?` 에서는 항상 값을 초기화하지 않는다
* 장점: 프로그램의 실행 파일 크기가 작아진다

### Defining WORD, DWORD, QWORD etc.

```assembly
var1     WORD   65535
var2     WORD   "AB"         ; 4142h
var3     DWORD  2 DUP(?)     ; 2 * 4 bytes
var4     REAL4  -2.1
```

* 특별히 다른 점은 없다
* string literal은 byte임에 유의. `00410042`가 아니라 `4142`이다

### Symbolic Constants

#### Equal Sign (=) Directive

`name = expression`

* e. g. `ANUM = 10` `mov eax, ANUM`
* 재정의될 수도 있다
* 이름을 Symbolic Constant라고 한다

#### EQU Directive

```assembly
PI          EQU   <3.1416>
pressKey    EQU   <"Press any key to continue...", 0>
prompt      BYTE  pressKey
```

* 재정의 불가능

#### TEXTEQU Directive

```assembly
continueMsg    TEXTEQU  <"Do you wish to continue (Y/N)?">
rowSize = 5

.data
prompt1        BYTE     continueMsg, 0
count          TEXTEQU  %(rowSize * 2)       ; treats the value of expression
                                             ; in macro argument as text
move           TEXTEQU  <mov>
setupAL        TEXTEQU  <move al, count>

.code
setupAL
```

* '텍스트 매크로'라고 불린다
* 재정의 가능하다
  * `%` 식: 위 예에서 계산 결과 10을 수 10이 아닌 텍스트 "10"으로 간주

### Current Location Counter Directive

`$`: **현재 주소**를 의미

```assembly
list           DWORD     1, 2, 3, 4
listSize = ($ - list) / 4
```

* 차이는 항상 바이트 단위이다
* constant expression이다 (어셈블러가 계산)

## Assembley Source File Structure

소스 코드에는 `.data`, `.data?`, `.code`를 섞어 써도 관계없다

* 어셈블러가 어셈블 할 때 같은 세그먼트끼리 묶어 나열한다

* | 어셈블 전                                                    | 어셈블 후                                                    |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | `.data`<br />D1<br />`.code`<br />C1<br />`.data?`<br />D1?<br />`.data`<br />D2<br />`.code`<br />C2 | `.data`<br />D1<br />D2<br />`.data?`<br />D1?<br />`.code`<br />C1<br />C2 |