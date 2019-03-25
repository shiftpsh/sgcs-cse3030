<p align=right>Week 3</p>

# Number Systems
> 이게 지금까지 나온 내용 중에 가장 쉬운 내용이 아닐까

## Number Representation
컴퓨터는 2진수를 사용하는데, 비트들을 그냥 2진수로 보고 10진수로 변환시켜 버릴 수도 있지만
그렇게 하면 음수나 실수 같은 건 표현할 수 없으니까 **비트들이 뭘 의미하는지 미리 정의해 줄 필요가 있다**.

### 2진수
`10110100`

여기서 맨 왼쪽 비트는 *MSB*(Most Significant Bit), 맨 오른쪽 비트는 *LSB*(Least Significant Bit)
* 다른 진법의 경우 MSD(~ Digit), LSB(~ Digit)이라고도 한다

8 비트 = 1 옥텟(octet), 혹은 1 바이트(byte).

8 비트 이상: 일반적으로 워드(word).

특히 Windows에서는

| 비트 | 이름 |
| --- | --- |
| 16 | WORD |
| 32 | DWORD |
| 64 | QWORD |

라고도 한다.

### 16진수
0-9에다 A-F를 추가로 갖다 써서 16진수.

64비트 2진수

`11111100 00111100 00100011 11111100 11011111 00101110 10110101 11111001`

는 너무 길다. 이걸 16진수로 변환하면

`FC 3C 23 FC DF 2E B5 F9`

이다. 사람이 한 눈에 보기에 편하고, 4비트가 1자리수로 바로 변환되는 이점이 있어 16진수가 자주 쓰인다.

#### Literals
* C에서: `0x7fff` 등 (`0x` prefix)
* asm에서: `7fffh`, `7fffH`, `0abcdh` 등 (`h` or `H` postfix, 첫 숫자가 0-9 사이가 아니면 `0` prefix)

## Radix Conversion
