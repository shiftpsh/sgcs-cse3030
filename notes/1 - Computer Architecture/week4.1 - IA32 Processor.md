<p align=right>Week 4</p>

# IA32 Processor

## Modes of Operation
동작 모드.

* *Protected Mode*: 주로 사용. 프로세서가 프로그램에 **메모리 세그먼트**(segment)를 할당하고, 그 밖을 참조하지 못하게 제한한다
  * 이제 [*Segmentation* fault](https://en.wikipedia.org/wiki/Segmentation_fault)가 왜 그런 이름인지 알았다
* *Real-Address Mode*: 프로그램이 모든 메모리 영역을 참조할 수 있는 모드. Windows x64부터는 이걸 막아 뒀다
* *Virtual 8086 Mode*: Protected Mode 안에서 Real-Address Mode 프로그램을 안전한 환경에서 실행할 수 있게 만들어 주는 모드.
Win 9x에서 3.1이나 그 아래 프로그램들과의 호환성을 위해 만든 거 같다. 역시 Windows x64에서는 안 된다
* *System Management Mode*: 제조사들이 쓰는 모드. 전원 관리, 시스템 보안 등을 구현해야 할 때 쓰는 모드라고 한다

## Addressable Memory
예전 32bit 프로세서에서
* Protected Mode: 4GiB(=2<sup>32</sup>B), 32비트 주소를 쓸 수 있다
* Real-Address / Virtual 8086 Mode: 1MiB, <strike>16</strike> 20비트 주소를 쓸 수 있다 (왜 16비트가 아닌지는 후술)

## Registers
IA32에 내장된 레지스터 목록

* 앞에 `e` (extended) 가 붙으면 32bit 레지스터이다
* 아니면 16bit 레지스터이다 (예를 들어 `ax`는 `eax`의 뒷 16 bits)
* 뒤에 `h` (high) 가 붙으면 16bits 중 앞 8bits, `l` (low) 이 붙으면 뒷 8bits 이다 (예를 들어 `ah`, `al`)

| Name | Purpose |
| ---- | ------- |
| `eax` | **a**ccumulator |
| `ebx` | **b**ase register |
| `ecx` | loop **c**ounter |
| `edx` | general purpose **d**ata register |
| `ebp` | **b**ase **p**ointer |
| `esp` | **s**tack **p**ointer |
| `esi` | **s**ource **i**ndex |
| `edi` | **d**estination **i**ndex |
| `eflags` | status and control **flags** |
| `eip` | **i**nstruction **p**ointer |
| `cs` | **c**ode **s**egment |
| `ds` | **d**ata **s**egment |
| `ss` | **s**tack **s**egment |
| `es` | additional **s**egment |
| `fs` | additional **s**egment |
| `gs` | additional **s**egment |

### `eax`: **a**ccumulator
정수 리스트를 더하는 과정에서 중간 결과는 보통 여기에 저장됨
* 여기에 저장하는 instruction이 다른 데 저장하는 것보다 op-code 크기가 작은 경우가 많다
`add eax, 1000h`는 1B, `add ecx, 1000h`는 2B (내부적으로 서로 다른 machine code를 가지나보다)

### `ebx`: **b**ase register
base address 또는 offset 저장에 쓰인다. 데이터 저장용으로 쓸 수도 있다

### `ecx`: loop **c**ounter
for-loop과 같은 반복문에서 instruction loop의 카운터로 사용된다

### `esp`: **s**tack **p**ointer
stack을 구현하는 데 사용.
* push, pop instruction이 있다 - push 하면 low address 쪽으로, pop 하면 high address 쪽으로 이동
* high address에서 low address 방향으로 쌓이게 된다
* Function call에서 return address, arguments, local variables 모두 stack을 사용한다

### `ebp`: **b**ase **p**ointer
stack frame에 쓰인다. (후술)

### `eip`: **i**nstruction **p**ointer
다음에 실행할 instruction의 주소를 담고 있다

### `cs`, `ds`, `es`, `fs`, `gs`, `ss`: **s**egment registers
segment의 base address를 담고 있다

### `eflags`: status and control **flags**
여러 비트 플래그를 bitwise하게 갖고 있다. 다음과 같은 flag들이 있다

| Flag | Purpose |
| ---- | ------- |
| carry | unsigned 연산에서 오버플로가 있는지 여부 |
| overflow | signed 연산에서 오버플로가 있는지 여부 |
| sign | 계산 결과의 양/음수 여부 |
| zero | 계산 결과의 0 여부 |
| auxillary carry | 4bits 단위 10진 연산에서 받아올림이 있는지 여부 |
| parity | bit들의 합이 짝수인지 여부 (메모리/통신 오류 체크, 현대에는 저 복잡한 알고리즘 사용) |

## Variables in C and Assembly
* `register` 키워드 - 레지스터에 값을 바로 저장한다. 요즘 컴파일러에서는 굳이 이럴 필요 없음
* `static` 키워드
* C에서 변수는 일반적으로 메모리에 저장된다

## Segment : Offset Concept (16bit Architecture)
IBM PC XT의 Intel 8086/8088 프로세서는 16bit 아키텍쳐인데 어떻게 20bit 주소를 사용할 수 있었을까?

-> 세그먼트 시작 위치를 항상 **16의 배수**로 두고(2<sup>16</sup> × 4 = 2<sup>20</sup>), **segment address를 따로 더해** 쓴다.
segment 크기는 64KiB = 2<sup>16</sup>B로 제한되긴 하지만 전체 메모리는 1MiB까지 쓸 수 있다

* Segment 시작 위치는 항상 LSB 4 bits가 0이다
* Segment register에 시작 위치를 저장한다
* 결론적으로, 20bits 메모리 주소를 표현하는 데 (segment 주소) + (offset)을 사용한다
* 세그먼트가 16의 배수로만 시작하기 때문에 버려지는 메모리가 있을 수도 있는데(fragmentation), 최대 15 bits이기 때문에 큰 손실은 아니다

### Calculation of Linear Addresses (Physical Address)
* `cs:ip`, `ss:sp`, `ds:si` 등으로 주소를 표현할 수 있다
* 세그먼트 주소가 `08F1:0100` 이라면 실제 주소는 `08F10 + 0100 = 09010`
* 세그먼트 주소가 `028F:0030` 이라면 실제 주소는 `028F0 + 0100 = 02920`
* 반대로 변환하는 건 별로 의미가 없긴 하다 - 애초에 반대로는 변환 방법이 유일하지 않다

## Descriptor Table

### Global Descriptor Table (GDT)
* Intel x86 계열에서 쓰이는 자료구조로 프로그램에서 쓰이는 세그먼트들과 그 특징들을 저장하고 있음
* base address, size, access previleges 같은 것들을 포함하고 있다

### Flat Segment Model
여기 세그먼트 단 한 개!!

| Base Address | Limit | Access |
| ------------ | ----- | ------ |
| `00000000`   | `00040` | `----` |

(예시) 이 테이블은 `00000000` ~ `00040000` 까지만 참조 가능하다

### Multi-Segment Model
세그먼트가 여러 개. 모든 프로그램이 local descriptor table(LDT)을 갖고 있고, GDT가 LDT를 레퍼런스하고 있다.
GDT 안에 LDT라는 서브폴더가 있다고 생각하면 편함

| Base Address | Limit | Access |
| ------------ | ----- | ------ |
| `00026000`   | `0010` | `----` |
| `00008000`   | `000A` | `----` |
| `00003000`   | `0002` | `----` |

(예시) 이 테이블은 명시된 세 개의 세그먼트에 참조 가능하다

## Paging 
세그먼트를 (일반적으로) 4096B 크기의 블럭으로 나눠 관리한다. 블럭 하나를 **페이지**라고 부른다.
페이징은 사용 중인 프로그램은 RAM에 로드하고, **사용 중이지 않은 프로그램의 페이지들을 디스크에 저장하는 기술**
* 이 기술로 돌아가고 있는 프로그램의 크기의 총합이 RAM 크기를 넘을 수 있다
* 이 기술은 CPU가 직접 지원한다
* Virtual Memory Manager: 페이지 로드/언로드를 관리하는 OS 도구
* *Page fault*: 참조하려는 메모리가 디스크에 있을 때 발생.
  * 엄청나게 큰 2차원 배열에 값을 집어넣는데 가로 우선으로 집어넣는 것과 세로 우선으로 집어넣는 것의 시간이 다르다
  (연속적이 아닌 메모리를 참조하면 page fault가 자주 발생하기 때문)
  
## 64bit x86-64 Processors
이런 게 있다 정도만 다루고 넘어갔다

### Differences
* RAM 제한이 2<sup>64</sup>B (현재는 아래 48비트만 쓸 수 있다 - 2<sup>48</sup>B = 256 TiB)
* 64bit 모드 추가
* 앞에 `r` ([register](https://stackoverflow.com/questions/43933379/what-do-the-e-and-r-prefixes-stand-for-in-the-names-of-intel-32-bit-and-64-bit-r))
가 붙으면 64bit 레지스터이다 - `rax`, `rbx` 등등
* `r8` ~ `r15`의 레지스터가 추가되었다
  * 아래 32bits는 `r8d` ~ `r15d` (DWORD)
  * 아래 16bits는 `r8w` ~ `r15w` (WORD)

## CISC and RISC
* CISC: Complex Instruction Set. CPU에서 많은 종류의 복잡한 연산 가능 - Intel 80x86
* RISC: Reduced Instruction Set. 간단한 연산만 가능하지만 컴파일러 기술로 극복하는 추세다. 하드웨어가 간단해 같단한 계산만 하는
경우 속도가 빠르고 가격이 싸다 - ARM

## Levels of I/O
* Level 3: 라이브러리 함수 부르기 (C++, Java 등)
  * 쉽다, 대체로 플랫폼에 구애받지 않는다
  * 느리다
* Level 2: OS 함수 부르기
  * 플랫폼과 환경에 구애받는다
  * 조금 빠르다
* Level 1: BIOS 함수 부르기
  * 환경에 심하게 구애받는다
  * 많이 빠르다
* Level 0: 하드웨어와 직접 통신
  * 가장 빠르나, 대부분의 OS에서 많은 제한을 두고 있다

어셈블리 프로그램은 Level 2 이하라면 아무 레벨에서나 I/O를 할 수 있다
