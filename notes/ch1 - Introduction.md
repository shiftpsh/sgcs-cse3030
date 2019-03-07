<p align=right>Week 1</p>

## Machine Language
*Machine Instructions*으로 작성되어 있음
- Machine Instructions: 이진수로 표현되머 컴퓨터들이 곧바로 알아들을 수 있는 인스트럭션
- Set of Machine Instructions = *Machine Code*
- *Assembly Instructions*: Symbolized Machine Instructions. 사람이 이진수 기계어를 보고 바로 이해하기 힘들어서 만들어짐

Types of Instructions?
- Data Movement
- Arithmetic
- Logical Operations
- Control Operations
- I/O
    
## Virtual Machine Concept
언어 L<sub>0</sub>으로 프로그램 짜기가 힘들다? 그럼 **새로운 언어** L<sub>1</sub>을 만들어서...
- 실행하는 중에 L<sub>1</sub> 인스트럭션들을 **실시간으로** L<sub>0</sub> 인스트럭션으로 번역해서 실행하자! = *Interpretation*
    - 비유하자면 동시통역, 이런 방식을 쓰는 언어는 Java, Python 등
- 아예 L<sub>0</sub> 프로그램으로 **미리 다 바꿔 버린 후**에 실행하자! = *Translation*
    - 비유하자면 이미 번역되어 있는 스크립트 읽기, 이런 방식을 쓰는 언어는 C, C++, Fortran 등
    - 첨언하자면 동시통역보다 이미 번역된 스크립트를 읽는 게 당연히 빠를 테니 실행 시간 면에서 C가 Java에 비해 갖는 이점이 있다.
    하지만 뭐 Java도 Java만의 장점이 있으니..
    
*Virtual Machine*: 가상 머신
- VM0을 L<sub>0</sub>을 실행할 수 있는 기계로, VM1을 L<sub>1</sub>을 실행할 수 있는 기계로 둔다면 VM1을 위한 프로그램을 짜면
VM1의 프로그램이 VM0의 프로그램으로 *translated* 혹은 *interpreted* 될 수 있다
- L<sub>1</sub>이 어려우면 L<sub>2</sub>, L<sub>3</sub>, ... 같은 식으로 계속 만들면 되지! 이런 식으로
조금의 코드로 많은 일을 하는 언어를 만들 수 있다

### Translation의 예
- L<sub>3</sub> = 자연어:
```
A와 B의 곱에 C를 더한 값을 출력해라
```
- L<sub>2</sub> = C: 
```C
printf("%d", A * B + C);
```
- L<sub>1</sub> = x86 Assembly:
```Assembly
mov eax, A
mul B
add eax, C
call WriteInt
```

- L<sub>0</sub> = Intel x86 Machine Language:
```
A1 00 00 00 00
F7 25 00 00 00 04
03 05 00 00 00 08
E8 00 50 00 00
```

### Specific Virtual Machine Levels
위로 올라갈수록 *High-Level Language*라고 한다

- High-Level Language (Level 4)
    - C++, Java, Python 등 사람이 알아보기 쉽게 만든 모든 프로그래밍 언어
    - C 계열: 컴파일러가 아래로 컴파일
- Assembly Language (Level 3)
    - Machine Language와 1:1 대응되는 언어
    - 링커가 아래로 링킹
- Level 2
    - ISA (아직은 몰라도 된다고 한다)
- Level 1
    - 실제 회로
    - 프로그램이 메모리에 로드되어 실행되는 것은 이 단계
    
## Instruction Execution Cycle
CPU는 아래와 같은 동작으로 무한루프를 돈다
- Instruction 가져오기
- Instruction 해석
- Operand 있을 경우 가져오기
- Instruction 실행
- 결과 저장

이걸 *Generic Instruction Cycle*이라고 한다.

PC (Program Counter)가 현재 수행할 Instruction의 메모리 주소를 저장하고 있다고 강의자료에 언급되어 있다

## Binary Numbers
Boolean Operations는 너무 trivial한 내용이라 생략. 실제 회로에서는 5V를 True, 0V를 False라고 보고
전압이 얼마 이상이면 1, 얼마 이하면 0 같은 식으로 처리한다고 한다

![Android meme](images/android.jpg)

> 회로 모양이 헷갈리면 이걸로 외우자. **And**roid 캐릭터의 머리 윗부분이 **AND** 회로 기호와 같다

NAND와 NOR 만으로 모든 회로를 표현할 수 있다고 해서 *Universal Gate*라고 하고, XOR은 덧셈기에 쓰인다고 한다.

*Two Input Multiplier*: `(Y & S) | (X & ~S)`
- S가 0이면 X를, 1이면 Y를 내보냄 (boolean 식 보면 알 수 있다)
