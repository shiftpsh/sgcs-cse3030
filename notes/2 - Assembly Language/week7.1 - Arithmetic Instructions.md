<p align=right>Week 7</p>

# Arithmetic Instructions

### Flags

자세한 내용은 후술한다

* 연산 후 side effect로 설정된다
* signed, unsigned 모두 고려해 설정된다
* 플래그를 활용하는 건 프로그래머의 몫이다

## INC and DEC Instructions

값을 하나 증가시키거나 감소시키는 instruction. C의 `++`, `--`과 같다. Syntax: `{inc|dec} [destination]`

* destination은 register나 memory operand가 가능하다

```assembly
myByte   BYTE    0FFh, 0

...

mov      al,     myByte          ; al = FFh, ax = 00FFh
mov      ah,     [myByte + 1]    ; ah = 00h, ax = 00FFh

dec      ah                      ; ah = FFh, ax = FFFFh
inc      al                      ; al = 00h, ax = FF00h
dec      ax                      ;           ax = FFEFh
```

## ADD and SUB Instructions

C의 `+=`, `-=`과 비슷해 보인다. Syntax:  `{add|sub} [destination] [source]`

* 제한조건은 [mov](/notes/2%20-%20Assembly%20Language/week5.1%20-%20Defining%20Data.md)와 동일하다

```assembly
var1     DWORD   10000h
var2     DWORD   20000h

...

mov      eax,    var1             ; eax = 00010000h
add      eax,    var2             ; eax = 00030000h
add      ax,     0FFFFh           ; eax = 0003FFFFh, ax = FFFF
add      eax,    1                ; eax = 00040000h, ax = 0000
sub      ax,     1                ; eax = 0004FFFFh, ax = FFFF
```

## NEG Instruction

값의 부호를 바꾸는 instruction. Syntax: `neg [destination]`

* destination은 register나 memory operand가 가능하다
* `sub 0, [operand]`를 계산하는 것과 같은 방식으로 계산된다 (틀린 코드지만)
* destination이 0이 아닌 경우 CF(carry flag)가 꽂힌다
* negate 했는데 값이 2's complement 범위를 벗어나는 경우 OF(overflow flag)가 꽂힌다
  * 이 경우는 BYTE에서 -256, WORD에서 -32768, DWORD에서 -2147483648 등을 negate 하는 경우밖에 없다

```assembly
valB     BYTE    -1
valW     WORD    +32767

...

mov      al,     valB             ; al = FFFFh
neg      al                       ; al = 0001h      | CF = 1, OF = 0
neg      valW                     ; valW = -32767
mov      ax,     -32768           ; ax = 80000000h
neg      ax                       ; ax = 80000000h  | CF = 1, OF = 1
```

## Arithmetic Expressions

*r* = -*x* + (*y* - *z*)는 다음과 같은 여러 방법들로 구현할 수 있다

* 그냥 계산

```assembly
mov      eax,     Xval            ; eax = x
neg      eax                      ; eax = -x
mov      ebx,     Yval            ;                      ebx = y
sub      ebx,     Zval            ;                      ebx = y - z
add      eax,     ebx             ; eax = -x + (y - z)
mov      Rval,    eax             ; Rval = -x + (y - z)
```

* `eax`만 사용해 계산 (괄호 무시)

```assembly
mov      eax,     Xval            ; eax = x
neg      eax                      ; eax = -x
add      eax,     Yval            ; eax = -x + y
sub      eax,     Zval            ; eax = -x + y - z
mov      Rval,    eax             ; Rval = -x + (y - z)
```

* 최소 instruction 사용 (계산 순서 무시)

```assembly
mov      eax,     Yval            ; eax = y
sub      eax,     Xval            ; eax = y - x
sub      eax,     Zval            ; eax = y - x - z
mov      Rval,    eax             ; Rval = -x + (y - z)
```

결국 필요에 맞게 구현하기 나름이다