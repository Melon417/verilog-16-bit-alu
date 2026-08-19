# 16-bit ALU Verification Test Plan

## Objective

Verify that the 16-bit ALU correctly performs arithmetic, logical, and shift operations while generating accurate status flags.

## Supported Operations

| Opcode | Operation |
|---|---|
| 0000 | ADD |
| 0001 | SUB |
| 0010 | AND |
| 0011 | OR |
| 0100 | XOR |
| 0101 | NOT |
| 0110 | Shift Left |
| 0111 | Shift Right |

## Flags

### Zero Flag
Asserts when the ALU output is equal to zero.

### Carry Flag
For addition, asserts when the result produces a carry out of bit 15.

For subtraction, the carry flag is used as a no-borrow indicator:
- `carry = 1` means no borrow occurred
- `carry = 0` means borrow occurred

For shift operations:
- Shift left carry is the original MSB
- Shift right carry is the original LSB

### Overflow Flag
Asserts when signed arithmetic overflow occurs during ADD or SUB operations.

### Negative Flag
Asserts when the most significant bit of the ALU output is 1.

## Test Cases

### 1. ADD Normal
Verify simple addition without carry or overflow.

### 2. ADD Zero
Verify addition that produces a zero result.

### 3. ADD Carry
Verify unsigned carry behavior.

### 4. ADD Signed Overflow
Verify signed overflow when adding two positive numbers gives a negative result.

### 5. SUB Normal
Verify subtraction without borrow or overflow.

### 6. SUB Zero
Verify subtraction that produces a zero result.

### 7. SUB Borrow
Verify borrow behavior when subtracting a larger value from a smaller value.

### 8. SUB Signed Overflow
Verify signed overflow during subtraction.

### 9. Logical Operations
Verify AND, OR, XOR, and NOT behavior.

### 10. Shift Operations
Verify shift-left and shift-right outputs and carry behavior.

### 11. Invalid Opcode
Verify that unsupported operations produce a safe default output.
