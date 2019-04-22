<p align=right>Week 5</p>

# Data Transfer Instructions

### Operand Types

```assembly
add     eax,     10      ; eax: register operand, 10: immediate operand
add     eax,     val     ; val: memory operand (direct)
```

```assembly
.data
Val     BYTE 10, 20, 30
ValN  = $ - Val          ; ValN = 3
ValS    BYTE ValN        ; 3 is initial value of ValS

...

.code
mov     ax,      @data   ; @data: data segment = immediate operand
mov     al,      Val     ; Val  : direct memory operand
mov     al,      ValN    ; ValN : immediate operand
mov     al,      ValS    ; ValS : memory operand
```

* **Immediate**: 상수 값. `1`, `4`, `3 * 5` 등등
* **Register**: 레지스터. `eax`, `esp` 등
* **Memory**: 메모리 위치.
  * **Direct**: Data label. 어셈블러가 알아서 dereference 해 줌. 예를 들어 위의 `Val`
  * **Direct Offset**: `[var + offset]` 형태. 예를 들어 `[Val + 1]`
    - offset은 **byte 단위**이다.
  * Indirect
  * Indexed

## MOV instruction

값을 이동하는 instruction. Syntax: `mov [destination], [source]`

제한조건들

* 1개를 초과하는 memory operand 사용 불가
* `cs`, `ip`로 이동 불가
* destination은 immediate operand가 될 수 없음 (당연하게도!)
* `~s` (세그먼트) 로 immediate operand 이동 불가
* source와 destination의 비트 크기는 같아야 한다

```assembly
bVal    BYTE    100
bVal2   BYTE    ?
wVal    WORD    2
dVal    DWORD   5

...

mov     ds,     45      ; error: no (immediate -> segment) moves
mov     esi,    wVal    ; error: (wVal = 16 bits, esi = 32 bits) mismatch
mov     eip,    dVal    ; error: moving to eip not permitted
mov     25,     bVal    ; error: destination can't be immediate operand
mov     bVal2,  bVal    ; error: no more than 1 memory operand
```

### Instructions for Bit Extension

* **movzx**: 0-extend 해서 작은 쪽에서 큰 쪽으로 옮긴다. 예를 들어 `10001111`을 `WORD` 크기의 메모리로 옮기면 `0000000010001111`
* **movsx**: sign extend 한다. 예를 들어 `10001111`을 `WORD` 크기의 메모리로 옮기면 `1111111110001111`

## XCHG instruction

두 값을 바꾸는 instruction. mov의 제약조건을 그대로 따르나

* 한 개의 operand는 무조건 register operand여야 하고
* immediate operand는 사용할 수 없다 (당연)