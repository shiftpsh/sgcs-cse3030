# Lecture Notes

강의 정리 노트. 강의를 듣고 매주 복습하면서 정리한 노트입니다. 배운 순서이며 교재의 목차와는 크게 관련없습니다.

## Computer Architecture

**Week 1**

* [Introduction](/notes/1%20-%20Computer%20Architecture/week1%20-%20Introduction.md)
  * Machine Language
  * Virtual Machine Concept
  * Instruction Execution Cycle
  * Binary Numbers

**Week 2**

* [Digital Circuits](/notes/1%20-%20Computer%20Architecture/week2.1%20-%20Digital%20Circuits.md)
  * Binary Addition
  * Storage Elements - Flip Flops, Registers
* [Computer Systems](/notes/1%20-%20Computer%20Architecture/week2.2%20-%20Computer%20Systems.md)
  * System Bus
  * How a Program Runs
  * Machine Instructions
  * Pipeline, Pipelines in CPU
  * More on Memory
  * Multitasking

**Week 3**

* [Number Systems](/notes/1%20-%20Computer%20Architecture/week3.1%20-%20Number%20Systems.md)
  * Number Representation
  * Radix Conversion
* [Bit Representations of Integers](/notes/1%20-%20Computer%20Architecture/week3.2%20-%20Bit%20Representations%20of%20Integers.md)
  * Unsigned Integer Representation
  * Signed Magnitude
  * 1's Complement
  * 2's Complement
* [Bit Representations of Real Numbers and Characters](/notes/1%20-%20Computer%20Architecture/week3.3%20-%20Bit%20Representations%20of%20Real%20Numbers%20and%20Characters.md)
  * Fixed Point Real Numbers
  * Floating Point Real Numbers
  * Characters

**Week 4**

* [IA32 Processor](/notes/1%20-%20Computer%20Architecture/week4.1%20-%20IA32%20Processor.md)
  * Modes of Operation
  * Addressable Memory
  * Registers
  * Variables in C and Assembly
  * Segment : Offset Concept (16bit Architecture)
  * Descriptor Table - Global Descriptor Table (GDT), Flat Segment Model, Multi-Segment Model
  * Paging
  * 64bit x86-64 Processors
  * CISC and RISC

## Assembly Language

**Week 4**

* [Basic Elements of Assembly Language](/notes/2%20-%20Assembly%20Language/week4.2%20-%20Basic%20Elements%20of%20Assembly%20Language.md)
  * Constants, Expressions and Literals
  * Identifiers
  * Directives
  * Instructions - Labels, Mnemonics, Operands

**Week 5**

* [Assembling, Linking, and Running Programs](/notes/2%20-%20Assembly%20Language/week5.1%20-%20Defining%20Data.md)
  * Listing File
  * Map File
* [Defining Data](/notes/2%20-%20Assembly%20Language/week5.1%20-%20Defining%20Data.md)
  * Intrinsic Data Types
  * Data Definition Statement
    * Defining Bytes, Strings, Uninitialized Data
    * Symbolic Constants - EQU, TEXTEQU, Current Location Counter Directive
  * Assembley Source File Structure

* [Data Transfer Instructions](/notes/2%20-%20Assembly%20Language/week5.2%20-%20Data%20Transfer%20Instructions.md)
  * Operand Types
  * MOV Instruction - mov, movzx, movsx
  * XCHG Instruction

Week 6

* 실습 1

**Week 7**

* [Arithmetic Instructions](/notes/2%20-%20Assembly%20Language/week7.1%20-%20Arithmetic%20Instructions.md)
  * INC and DEC Instructions
  * ADD and SUB Instructions
  * NEG Instruction
  * Arithmetic Expressions