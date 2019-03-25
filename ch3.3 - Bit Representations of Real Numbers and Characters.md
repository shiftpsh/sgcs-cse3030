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

