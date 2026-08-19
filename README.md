# 16-bit ALU Design and Verification

16-bit ALU written in Verilog/SystemVerilog with arithmetic, logic, and shift operations. The project includes a testbench for validating operation selection, output correctness, and status flag behavior.

## Project Status

In Progress

## Overview

This project implements a 16-bit arithmetic logic unit similar to a small processor datapath block. The ALU supports common arithmetic, bitwise logic, and shift operations while producing status flags used by digital systems.

## Features

- 16-bit datapath
- ADD and SUB operations
- AND, OR, XOR, and NOT operations
- Logical shift left and shift right
- Zero flag
- Carry flag
- Overflow flag
- Negative flag
- Directed testbench cases for normal and edge-case inputs

## Repository Structure

```text
verilog-16-bit-alu/
├── src/
│   └── alu_16bit.sv
├── tb/
│   └── alu_16bit_tb.sv
├── docs/
│   └── waveforms/
└── README.md
