<p align=right>Week 3</p>

# Bit Representations of Real Numbers and Characters

## Fixed Point Real Numbers
소숫점이 어딘가에 고정되어 있는 실수. 2's complement 연산과 동일하며 통신, 신호처리 등에서 많이 쓰임.
예를 들어 4비트 fixed point 실수에서 뒤의 2비트를 소수부라고 정하면, `0111` = +7 / 4 = +1.75가 된다. 특별한 건 없음.

* Guard bit: Sign bit 오른쪽 비트를 Guard bit라고 두고 나머지는 소수부라고 하면 값이 -1, 1 사이에 들어와야 되는 경우, 또는 비슷한 경우에
  * `01xxxxxx` -> `00111111` (if *x* >= 1)
  * `10xxxxxx` -> `11000001` (if *x* <= -1)
  * `11000000` -> `11000001` (if *x* <= -1)  
  
  과 같은 방법으로 값이 범위 밖으로 떨어졌을 때 -1과 1 사이에 오도록 보정해 줄 수 있다
  
## Floating Point Real Numbers
소숫점이 어딘가에 '떠다니는' 실수. 부동(浮動)소수점. 한자를 보면 바로 이해가 가는데,
[처음 보면 '왜 안 움직이는데 floating이라고 하지?' 라고 생각할 수도 있겠다.](https://twitter.com/shiftpsh/status/1107791853246517248)
(['둥둥소수점'으로 해야 한다는 주장](https://twitter.com/RYUUSEIKANG/status/1107792169937494016)도 있다. 직관적이다.)

첫 비트는 sign bit, 그 이후는 exponent(정수)와 mantissa(실수)로 나뉜다. 천문학적인 숫자를 표시할 때 *r* × 10<sup>*x*</sup> 같은 식으로 표기하는 것처럼
sign bit을 *s*, exponent를 *e*, mantissa를 *m*이라고 하면 floating point 값은 (-1)<sup>*s*</sup>*m*2<sup>*e*</sup>이다.

mantissa는 MSB 다음이 바로 소수점이고, 항상 1.0과 2.0 사이인 fixed point 실수이다. exponent에는 미리 정해둔 bias를 더해 unsigned integer가 되도록 한다.

### 곱셈 알고리즘
*x* : *s*<sub>*x*</sub>, *e*<sub>*x*</sub>, *m*<sub>*x*</sub> -> (-1)<sup>*s*<sub>*x*</sub></sup>*m*<sub>*x*</sub>2<sup>*e*<sub>*x*</sub></sup>

*y* : *s*<sub>*y*</sub>, *e*<sub>*y*</sub>, *m*<sub>*y*</sub> -> (-1)<sup>*s*<sub>*y*</sub></sup>*m*<sub>*y*</sub>2<sup>*e*<sub>*y*</sub></sup>

그러므로 *xy* = (-1)<sup>*s*<sub>*x*</sub> + *s*<sub>*y*</sub></sup>*m*<sub>*x*</sub></sup>*m*<sub>*y*</sub>2<sup>*e*<sub>*x*</sub> + *e*<sub>*y*</sub></sup>

이고, 새 *s* = *s*<sub>*x*</sub> + *s*<sub>*y*</sub>, *e* = *e*<sub>*x*</sub> + *e*<sub>*y*</sub>, *m* = *m*<sub>*x*</sub></sup>*m*<sub>*y*</sub>이 된다.
bias 감안해서 덧셈을 수행하고 mantissa가 1과 2 사이의 수가 되도록 bit shift 해서 조정한다.

### 덧셈 알고리즘
자릿수 맞춰 주고 signed magnitude 덧셈 수행.

## Characters

* Character set: 문자의 집합
* *Coded* character set: 문자들에 각각 고유번호를 부여한 집합
  * 예를 들어 A = 65, B = 66, C = 67, ...
* Character Encoding: 문자에 고유번호를 부여하는 방법
  * 예를 들어 '가'는 Unicode에서는 고유번호 44032번이 부여되는데, EUC-KR 인코딩에서는 고유번호 9026번이 부여된다

### Character Set

* ASCII: American Standard Code for Information Interchange

  * 7 bits로 숫자, 특수문자, 영어 대/소문자 등 표현

* ANSI: American National Standards Institute

  * 8 bits로 표현

* Unicode: 세계 모든 문자를 컴퓨터에서 일괄적으로 다룰 수 있도록 설계된 산업 표준.

  * 세계 모든 문자를 `0x000000`부터 `0x10FFFF`까지의 코드 포인트로 매핑

  * 사용하는 인코딩에는 UTF-8, UTF-16, UTF-32 등이 있다

  * 교수님께서 [나무위키의 UTF-8 문서](https://namu.wiki/w/UTF-8)가 재밌다고 시간 나면 읽어볼 것을 추천하셨다

    > 내가 자꾸 나무 얘기해서 미안한데 여기 글들이 일반인들이 써서 그런지 참 맛깔나게 쓰여 있어요

#### ASCII Code Table

|        | +0      | +1   | +2   | +3   | +4   | +5   | +6   | +7   | +8   | +9   | +A   | +B   | +C   | +D   | +E   | +F   |
| ------ | ------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| **20** | ` `     | `!`  | `"`  | `#`  | `$`  | `%`  | `&`  | `'`  | `(`  | `)`  | `*`  | `+`  | `,`  | `-`  | `.`  | `/`  |
| **30** | `0`     | `1`  | `2`  | `3`  | `4`  | `5`  | `6`  | `7`  | `8`  | `9`  | `:`  | `;`  | `<`  | `=`  | `>`  | `?`  |
| **40** | `@`     | `A`  | `B`  | `C`  | `D`  | `E`  | `F`  | `G`  | `H`  | `I`  | `J`  | `K`  | `L`  | `M`  | `N`  | `O`  |
| **50** | `P`     | `Q`  | `R`  | `S`  | `T`  | `U`  | `V`  | `W`  | `X`  | `Y`  | `Z`  | `[`  | `\`  | `]`  | `^`  | _    |
| **60** | `` ` `` | `a`  | `b`  | `c`  | `d`  | `e`  | `f`  | `g`  | `h`  | `i`  | `j`  | `k`  | `l`  | `m`  | `n`  | `o`  |
| **70** | `p`     | `q`  | `r`  | `s`  | `t`  | `u`  | `v`  | `w`  | `x`  | `y`  | `z`  | `{`  | `|`  | `}`  | `~`  |      |

* 특징: `0` = `0x30`, `A` = `0x41`, `a` = `0x61`이고 이후 연속적이다

#### ASCII Control Characters

`0x00`~`0x1F`까지는 특수한 문자들이 자리하고 있는데, 그 중 중요한 거 몇 개만 다루자면

* `0x0A`: LF. `\n`. Line feed, 줄바꿈
* `0x0D`: CR. `\r`. Carriage return
  * Linux에서 LF, Windows에서 CRLF라는 게 리눅스는 줄을 바꿀 때 `\n`을 사용하고 Windows에서는 `\r\n`을 사용해서 그렇다
  * DOS에서 LF는 커서를 한 줄 내리고 CR은 커서를 맨 왼쪽에서 보냈다고 한다. (교수님 설명)
* `0x08`: BS. `\b`. Backspace
* `0x09`: HT. `\t`. Horizontal tab. 키보드의 `Tab` 키를 누르면 입력할 수 있는 그 문자다

### Null-terminated String

문자열의 맨 뒤에 `\0` (NUL)이 붙는 문자열 저장 방식