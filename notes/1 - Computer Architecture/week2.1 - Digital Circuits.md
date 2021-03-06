<p align=right>Week 2</p>

# Digital Circuits

## Binary Addition
*가산기*: 두 비트를 더해서 계산 결과를 반환. 정확히는 받아올라온 비트까지 세 비트를 더해서,
지금 계산하고 있는 자릿수의 계산 결과와 받아올라가는 비트를 출력하는 장치이다.

A, B, C<sub>in</sub> 비트를 받아서 S, C<sub>out</sub>을 출력하는 가산기의 진리표는 다음과 같음

| A | B | C<sub>in</sub> | | S | C<sub>out</sub> |
| - | - | - | - | - | - |
| 0 | 0 | 0 |  | 0 | 0 |
| 0 | 0 | 1 |  | 1 | 0 |
| 0 | 1 | 0 |  | 1 | 0 |
| 0 | 1 | 1 |  | 0 | 1 |
| 1 | 0 | 0 |  | 1 | 0 |
| 1 | 0 | 1 |  | 0 | 1 |
| 1 | 1 | 0 |  | 0 | 1 |
| 1 | 1 | 1 |  | 1 | 1 |

*n-bit adder*: 이 가산기들을 *n*개 겹쳐 놓으면 된다. 가산기 한 개에 시간이 *Δ*만큼 걸린다면 총 시간은 *nΔ*만큼 걸리게 된다.

- `S = (A + B + C_in) % 2`
- `C_out = floor((A + B + C_in) / 2)`

이므로, 가산기를 Boolean expression으로 나타내면

- `S = A ^ B ^ C_in`
- `C_out = a & b + c_in & (a | b)`

이다. `^`는 XOR 기호이다. 그래서 가산기에 XOR 게이트가 많이 쓰인다고 한다

## Storage Elements

### Flip Flop

[![Flip Flop](https://img.youtube.com/vi/wAUXJE4PZRc/0.jpg)](https://www.youtube.com/watch?v=wAUXJE4PZRc)

명곡이다.

#### SR Flip Flop

![SR Flip Flop](/images/sr-flipflop.gif)

기본적인 형태의 Flip Flop이다. 1비트의 데이터를 저장할 수 있다.

| S | R |   | Q | ~Q |
| - | - | - | - | -- |
| 0 | 0 |   | - | -  |
| 0 | 1 |   | 0 | 1  |
| 1 | 0 |   | 1 | 0  |
| 1 | 1 |   | 0 | 0  |

S = R = 0일 경우 현재 값이 유지된다. 근데 S = R = 1일 경우 Q = 0, ~Q = 0이 된다.
이건 뭔가 모순이다. 그래서 이를 보완한 D Flip Flop, JK Flip Flop 등이 등장

#### Edge Flip Flop

컴퓨터에서는 이걸 주로 쓴다. Clock의 rising 혹은 falling edge에서만 데이터가 바뀐다. positive edge triggered -> rising edge에서 신호가 업데이트.

![Positive Edge Triggered D Flip Flop](/images/pos-edge-d-flipflop.jpg)

강의노트에서 가져온 Positive Edge Triggered D Flip Flop의 예시

- D : 입력
- Q : 출력
- R : Reset. 이게 1이면 출력은 무조건 0이다
- EN : Enable. 이게 1일 경우에만 데이터를 쓸 수 있다
- CLK : Clock. Positive Edge Triggered 이니까 이게 0에서 1로 바뀔 때만 값이 업데이트 된다

### Register

Flip Flop들 여러 개 붙여 놓은 거. 속도가 엄청 빠르다.

*m-bit register*는 *m* 비트의 정보를 담음, 플립플롭처럼 D Q R EN CLK가 있다. D랑 Q는 각각 *m*개 비트로 이루어져 있다

*Register file*: register들 여러 개 붙여 놓은 거. 비싸다! D Q R EN CLK에 추가로 ADDRESS가 있다. 어디에다 저장하고 어디에서 읽어야 할지 알아야 하니까

*Memory*: 좀 큰 거 저장하려고 있는 거. 

- *On-chip* memory: CPU에 붙어 있다. 빠르고 비싸다
- *Off-chip* memory: 그 반대겠지

- *Static* memory: 전원이 켜져 있는 한 데이터가 유지된다
- *Dynamic* memory: 전원이 켜져 있어도 지속적으로 업데이트 해 주지 않으면 데이터가 날아갈 수 있다.
  예로 DRAM은 축전기에 전자를 가둬 놓는 방식을 쓰기 때문에 업데이트를 해 주지 않을 경우 몇 ms만에 방전되어 버림
