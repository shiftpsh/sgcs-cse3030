<p align=right>Week 7</p>

# Flags

## Flags Affected by Arithmetic

ALU가 계산하는 도중에 플래그를 설정한다

* ZF: Zero. 계산된 값이 0
* SF: Sign. 계산된 값의 부호
  * 음수일 경우 1, 양수 혹은 0일 경우 0

* CF: Carry. unsigned 값의 범위 초과
* OF: Overflow. signed 값의 범위 초과

전에 언급했듯이 CPU는 signed integer와 unsigned integer를 구별하지 않고 플래그를 signed, unsigned의 경우 모두 고려해 전부 업데이트하기 때문에 이를 사용하는 것은 프로그래머 몫이다

(참고) mov instruction은 이들 flag를 설정하지 않는다

## ZF: Zero Flag

단순히 계산 결과가 0이면 ZF = 1

```assembly
mov  cx,  1
sub  cx,  1         ; cx = 0, zf = 1 (set)
mov  ax,  0FFFFh
inc  ax             ; ax = 0, zf = 1
inc  ax             ; ax = 1, zf = 0 (clear)
```

## SF: Sign Flag

계산 결과를 2's complement로 표현했을 때의 부호. 

* 사실 단순히 계산 결과의 MSB다.

```assembly
mov  cx,  0
sub  cx,  1         ; cx = -1, sf = 1 
add  cx,  2         ; cx =  1, sf = 0
mov  al,  0
sub  al,  1         ; al = -1, sf = 1
add  al,  2         ; al =  1, sf = 0
```

## Overflow Detection (in unsigned & signed)

* unsigned: MSB에서 carry가 발생했는지 여부를 CF에 저장
* signed: (MSB로 carry 된 비트) xor CF

### Unsigned Subtraction

* 덧셈을 이용한다. `z = x - y = x + (~y)`
* CF = `x + ~y`의 carry out에 **NOT을 취한다**
  * 밴 윗 비트에서 빌려와야 되는 상황이 발생할 경우 CF가 꽂힌다

### Signed Subtraction

* 덧셈을 이용한다. `z + x - y = x + (~y) + 1`
* OF는 signed addition의 경우와 동일하게 NOT을 취한다.

## CF, OF: Carry Flag and Overflow Flag

간단하게 생각하면 된다

<text align="center">

OF는 계산 결과를 2's complement로 표현할 수 있는 범위 밖이면 무조건 1이고

CF는 단순히 두 수를 이진수로 더했을 때 MSB에서 받아올림이 발생하면 무조건 1이다

</text>

```assembly
mov  al,  -128      ; -(-128)
neg  al             ; cf = 1, of = 1

mov  ax,  8000h     ; signed: -32768 + 2 = -32766  unsigned: 32768 + 2 = 32770
add  ax,  2         ; cf = 0, of = 0

mov  ax,  0         ; signed: 0 - 2 = -2           unsigned: 0 - 2 = -2
sub  ax,  2         ; cf = 1, of = 0

mov  al,  -5        ; signed: -5 - 125 = -130      unsigned: 251 - 125 = 126
sub  al,  +125      ; cf = 0, of = 1
```

## Flags Affected by Instructions

* inc, dec
  * OF, SF, ZF, AF(Aux Carry), PF(Parity)
  * CF에는 영향을 주지 않음
* add, sub, neg
  * CF, ZF, SF, OF, AF, PF