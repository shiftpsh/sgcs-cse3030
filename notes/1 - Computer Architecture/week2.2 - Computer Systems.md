<p align=right>Week 2</p>

# Computer Systems

일반적인 컴퓨터 시스템: CPU, 메모리, I/O 디바이스 등이 address bus, control bus 등으로 연결되어 있음.

- *Bus*: 프로토콜에 의해 기능 블록 간에 데이터를 주고받을 수 있다.

## CPU Architecture Review

CPU는 실리콘 칩으로 만든다. CPU가

- Fetch. Instruction 가져오기
- Decode. Instruction 해석
- Operand 있을 경우 가져오기
- Instruction 실행
- 결과 저장

의 무한루프를 돎을 기억하자. [RISC 컴퓨터](https://en.wikipedia.org/wiki/Classic_RISC_pipeline)의 경우,
Operand 가져오는 부분이 없고 Instruction 실행 이후에 Memory Access 후 Write Back 한다.

*Instruction Pointer*: 현재 명령이 저장된 주소의 포인터. 이것도 레지스터의 일종이다. 꼭 기억하라고 하셨다. 중요한가보다.

## System Bus

*Bridge*: 서로 다른 프로토콜을 갖는 bus들을 연결해 준다

- PCI Based System에서, North Bridge는 CPU, GFX, SDRAM 등 빠른 피드백이 필요한 장치들을, South Bridge는 모뎀, 오디오, 키보드 등등을 묶는다.
- FSB, IDE, ISA, PCI, SATA -> 무슨 약자인지 정도만 알아 두자
  - FSB: Front-Side Bus
  - IDE: Integrated Drivve Electronics (이 맥락에서는 Integrated Development Environment가 아니다)
  - ISA: Industry Standard Architecture
  - PCI: Peripheral Component Interconnect
  - SATA: Serial Advanced Technology Attachment

## Operations Inside the CPU Review

1장에서 봤던 Instruction 종류와 동일하다.

- Data Movement
  - 레지스터/메모리에서 레지스터/메모리로 데이터를 옮김
  - 가장 자주 쓰인다.
- Arithmetic
  - 덧셈, 뺄셈: ALU에서 지원하는 기본적인 연산
  - 곱셈, 나눗셈, 모듈로: 가속기를 이용해 계산
- Logical Operations
  - NOT, AND, OR, 비트 시프트 및 회전 등
- Control Operations
  - if, for, while 블럭 등을 사용하기 위해 있다고 한다.
- I/O
  - *Memory mapped*: IO 작업이 메모리 주소에 매핑되어 똑같은 주소 공간을 씀, Instruction도 같다. 현재는 이게 많이 쓰인다고 
  - *IO mapped*: 메모리랑 다른 주소를 쓴다. 별도의 IO instruction을 쓴다

## How a Program Runs

1. 유저가 선택한 프로그램 이름을 shell에 보내면
2. OS가 (현재 경로), (시스템 경로 / PATH)에서 프로그램을 찾고
3. 있다면 디렉토리 엔트리에서 시작 클러스터(디스크의 기본 logical 단위) 주소를 가져온 후
4. 로더가 프로그램을 로드한 후 시작한다
5. 프로그램이 잘 실행되다가 종료되면 OS로 복귀

- FAT: File Allocation Table.

## Machine Instructions

- 보통 8n비트로 구성되어 있다
- 앞부분은 op-code, 뒷부분은 operand
- Example: `1011 0000 0000 0101`에서 `1011 0000`은 op-code, `0000 0101`은 operand
- `1011 0000`에 대응되는 어셈블리 mnemonic은 `mov` - 그냥 기억하기 편하라고 만든 코드

## Pipeline
분업이다.

[![초코파이 공정](https://img.youtube.com/vi/TH-kZqIwBno/0.jpg)](https://www.youtube.com/watch?v=TH-kZqIwBno)

예를 들어 공장에서 맛있는 초코파이😋를 만드려면

- 빵을 굽고
- 마시멜로를 얹고
- 초콜릿으로 코팅하고
- 비닐 포장
- 박스 포장

해야 되는데, 기계 한 대가 이걸 혼자 다 하는 것보다 빵 굽는 기계, 마시멜로 얹는 기계, 초코 코팅 하는 기계, 비닐 포장 하는 기계,
박스 포장 하는 기계가 **따로따로 있으면** 더 좋다

각 작업이 10초씩 걸린다고 치면 초코파이 하나가 나오는 데는 똑같이 50초가 걸리겠지만
- 전자는 한 대가 초코파이 하나를 전부 프로세싱 해야 다음 재료가 들어갈 수 있어서, 결국 **50초당 1개**의 초코파이가 나오는데
- 후자는 각 기계에서 각 작업이 끝나면 전 단계 기계에 있던 초코파이를 계속 가져오면 되니까 첫 초코파이가
나오는 데는 조금 오래 걸릴지 몰라도 일단 나오기 시작하기만 하면 **10초당 1개**의 초코파이가 나오게 된다

(1학년 때 인턴 할 때는 Pipeline이 정확히 뭔진 몰랐는데, [알고 보니 회사에 있을 때 pipeline에 대해서 발표를 하고 나왔었다.](https://blog.shift.moe/2018/09/05/camera2-overview/)
Camera1은 pipeline을 쓰지 않는데 Camera2는 pipeline을 써서 속도 개선을 이뤘다는 내용.)

아무튼
- Latency: task 하나를 완료하는 데 걸리는 시간
- Throughput: 단위시간당 완료하는 task 개수
로 두면 pipeline이 있든 없든 latency는 같은데 throughput은 pipeline을 도입하면 훨씬 개선할 수 있다

## Pipelines in CPU

가령 CPU 작업 하나는 6개의 작업으로 이루어져 있다고 치자. 이 때

* 파이프라인이 없다면: 

| Cycle | S1 | S2 | S3 | S4 | S5 | S6 |
| ----- | -- | -- | -- | -- | -- | -- |
|     1 | 1️⃣ |    |    |    |    |    |
|     2 |    | 1️⃣ |    |    |    |    |
|     3 |    |    | 1️⃣ |    |    |    |
|     4 |    |    |    | 1️⃣ |    |    |
|     5 |    |    |    |    | 1️⃣ |    |
|     6 |    |    |    |    |    | 1️⃣ |
|     7 | 2️⃣ |    |    |    |    |    |
|     8 |    | 2️⃣ |    |    |    |    |
|     9 |    |    | 2️⃣ |    |    |    |
|    10 |    |    |    | 2️⃣ |    |    |
|    11 |    |    |    |    | 2️⃣ |    |
|    12 |    |    |    |    |    | 2️⃣ |

* 파이프라인이 있다면: 

| Cycle | S1 | S2 | S3 | S4 | S5 | S6 |
| ----- | -- | -- | -- | -- | -- | -- |
|     1 | 1️⃣ |    |    |    |    |    |
|     2 | 2️⃣ | 1️⃣ |    |    |    |    |
|     3 | 3️⃣ | 2️⃣ | 1️⃣ |    |    |    |
|     4 | 4️⃣ | 3️⃣ | 2️⃣ | 1️⃣ |    |    |
|     5 |    | 4️⃣ | 3️⃣ | 2️⃣ | 1️⃣ |    |
|     6 |    |    | 4️⃣ | 3️⃣ | 2️⃣ | 1️⃣ |
|     7 |    |    |    | 4️⃣ | 3️⃣ | 2️⃣ |
|     8 |    |    |    |    | 4️⃣ | 3️⃣ |
|     9 |    |    |    |    |    | 4️⃣ |

* 이 떄 **최대한 균등하게** 작업을 분배해야 된다. 만약 작업 S4가 사이클 2개를 필요로 한다면 이렇게 **버리는 사이클**😠이 생기고, 결국 파이프라인을 쓰나 마나가 된다

| Cycle | S1 | S2 | S3 | S4 | S5 | S6 |
| ----- | -- | -- | -- | -- | -- | -- |
|     1 | 1️⃣ |    |    |    |    |    |
|     2 | 2️⃣ | 1️⃣ |    |    |    |    |
|     3 | 3️⃣ | 2️⃣ | 1️⃣ |    |    |    |
|     4 |    | 3️⃣ | 2️⃣ | 1️⃣ |    |    |
|     5 |    |    | 3️⃣ | *1️⃣* |    |    |
|     6 |    |    |    | 2️⃣ | 1️⃣ |    |
|     7 |    |    |    | *2️⃣* | 😠 | 1️⃣ |
|     8 |    |    |    | 3️⃣ | 2️⃣ | 😠 |
|     9 |    |    |    | *3️⃣* | 😠 | 2️⃣ |

* Superscalar 프로세서: S4를 병렬 처리할 수도 있다. 이렇게 하면 버려지는 사이클이 없게 된다. 아예 이런 걸 연구하는 분야도 있다고 한다

| Cycle | S1 | S2 | S3 | S4<sub>u</sub> | S4<sub>v</sub> | S5 | S6 |
| ----- | -- | -- | -- | -- | -- | -- | -- |
|     1 | 1️⃣ |    |    |    |    |    |    |
|     2 | 2️⃣ | 1️⃣ |    |    |    |    |    |
|     3 | 3️⃣ | 2️⃣ | 1️⃣ |    |    |    |    |
|     4 | 4️⃣ | 3️⃣ | 2️⃣ | 1️⃣ |    |    |    |
|     5 |    | 4️⃣ | 3️⃣ | *1️⃣* | 2️⃣ |    |    |
|     6 |    |    | 4️⃣ | 3️⃣ | *2️⃣* | 1️⃣ |    |
|     7 |    |    |    | *3️⃣* | 4️⃣ | 2️⃣ | 1️⃣ |
|     8 |    |    |    |    | *4️⃣* | 3️⃣ | 2️⃣ |
|     9 |    |    |    |    |    | 4️⃣ | 3️⃣ |

## More on Memory

* RAM: Random Access Memory. 어디에 저장돼 있든지 아무때나 읽을 수 있어서 Random Access다.
Random Access가 힘든 케이스는 마그네틱 테이프 같은 게 있겠다 (특정 위치로 가려면 테이프를 돌려야 하니)

| 종류 | 기능 | 속도 | 비트당 가격 | 용도 |
| --- | --- | --- | ------- | --- |
| DRAM (Dynamic RAM) | 액세스하지 않으면 데이터가 점차 지워짐, Refresh 필요 | 느리다 | 싸다 | 대용량 메모리 |
| SRAM (Static RAM) | 전원을 끄지 않는 이상 데이터가 안 날아긴다 | 빠르다 | 비싸다 | Cache 메모리, ASIC에 들어가는 메모리 |
| NVRAM (Non Volatile RAM / Flash Memory) | 전원을 꺼도 데이터가 유지된다 | ? | 비싸다 | SSD, USB 메모리 등 |

* ROM: Read-Only Memory
  * **[하드 디스크와 ROM은 상관이 없다.](https://technology.blurtit.com/182375/is-hard-disk-a-rom-or-ram)** 그냥 메모리에 쓸 수 없으면 ROM이다.
  * PROM: Programmable ROM
  * EPROM: Erasable ROM
  * EEPROM: Elecrically EPROM
  * 그냥 이런 것들이 있다는 거만 알아두자

* Single / Dual Port Memory: 이름에서 보이듯이 I/O 포트가 한 개인 메모리 / 두 개인 메모리. 당연히 포트가 두 개인 게 비싸다.. GPU 같은 데서 쓴다는 듯

### Reading from Memory

메모리는 CPU보다 많이 느리기 때문에 여러 머신 사이클이 필요하다
* 주소 버스(address bus)에 읽을 메모리 주소를 집어넣고
* RD(read) 핀의 값을 바꾸고
* 메모리가 응답할 때까지 한 사이클 기다린 후
* 메모리에 있는 정보를 CPU로 복사해 온다
의 과정을 사용한다

### Locality of Reference (참조 지역성)
[동일한 값 또는 해당 값에 관계된 스토리지 위치가 자주 액세스되는 특성](https://jwprogramming.tistory.com/18). 이 블로그를 참고하면:

* *Temporal* locality (시간 지역성): 최근 사용되었던 기억 장소들이 집중적으로 액세스되는 경향으로, 참조했던 메모리는 빠른 시간에 다시 참조될 확률이 높다.
* *Spatial* locality (공간 지역성): 특성 클러스터의 기억 장소들에 대해 참조가 집중적으로 이루어지는 경향으로, 참조된 메모리 근처의 메모리를 참조할 확률이 높다.
* *Sequential* locality (순차 지역성): 데이터가 순차적으로 액세스되는 경향으로, 프로그램 내의 명령어가 순차적으로 구성되어 있다는 것이 대표적인 경우이다. 공간 지역성에 편입되어 설명되기도 한다고 한다.

*90/10 Rule*: 프로그램은 실행 시간의 90%를 10%의 코드를 작동시키는 데 할애한다는 법칙

### Cache Memory
비싸고 빠른 RAM, CPU 안에 있을 수도 있고 밖에 있을 수도 있다
* Level-1(L1) Cache: CPU 안에
* Level-2(L2) Cache: CPU 밖에

이런 용어도 쓰인다
* Cache hit: 읽으려는 데이터가 캐시 안에 존재
* Cache miss: 읽으려는 데이터가 캐시에 없음

## Multitasking
Multitasking = Rapid switching of tasks. 여러 작업을 **실제로 동시에 실행하는 것이 아니고**, 현재 처리 중인 작업을 빨리빨리 바꾸면서 동시에 실행되는 것처럼 눈속임? 하는 것

* VLIW(Very Large Instruction Word) Processor: 하나의 작업이 동시에 해도 괜찮은 작은 독립된 작업들로 이루어져 있다. 멀티미디어 프로세싱에 적합.
