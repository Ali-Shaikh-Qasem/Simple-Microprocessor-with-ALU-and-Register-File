# Microprocessor Model

## Overview
This project aims to build a simple microprocessor model, including an Arithmetic Logic Unit (ALU) and a register file, and to simulate a simple machine code program to test the design. The project is implemented using Verilog.

## Features
- **ALU**: Performs arithmetic and bitwise logical operations based on an opcode.
- **Register File**: Small memory unit that stores operands and results.
- **Microprocessor**: Executes instructions using the ALU and register file, handling synchronization.
- **Test Bench**: Simulates a machine code program to validate the design.

## Implementation
- **ALU**: Designed using behavioral modeling with signed number representation.
- **Register File**: Implements clocked memory with input validation.
- **Microprocessor**: Uses structural modeling to integrate ALU and register file, ensuring correct timing and synchronization.

## Testing
A set of machine instructions is executed, and results are verified against expected values. The simulation confirms that all calculations and memory operations function correctly.

## Conclusion
This project demonstrates digital system design using hardware description languages. Synchronization and timing considerations play a crucial role in microprocessor behavior, and the design verification through a test bench ensures correct execution of instructions.
