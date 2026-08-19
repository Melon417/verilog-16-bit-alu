// 16-bit ALU Design
// Author: Mohammad Memon
//
// Description:
// Combinational 16-bit ALU supporting arithmetic, logic, and shift operations.
// Generates zero, carry, overflow, and negative flags.

module alu_16bit (
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic [3:0]  op,

    output logic [15:0] y,
    output logic zero,
    output logic carry,
    output logic overflow,
    output logic negative
);

    logic [16:0] add_result;
    logic [16:0] sub_result;

    localparam OP_ADD = 4'b0000;
    localparam OP_SUB = 4'b0001;
    localparam OP_AND = 4'b0010;
    localparam OP_OR  = 4'b0011;
    localparam OP_XOR = 4'b0100;
    localparam OP_NOT = 4'b0101;
    localparam OP_SHL = 4'b0110;
    localparam OP_SHR = 4'b0111;

    always_comb begin
        y        = 16'h0000;
        carry    = 1'b0;
        overflow = 1'b0;

        add_result = {1'b0, a} + {1'b0, b};
        sub_result = {1'b0, a} - {1'b0, b};

        case (op)
            OP_ADD: begin
                y     = add_result[15:0];
                carry = add_result[16];

                // Signed overflow for addition:
                // If a and b have the same sign, but result has different sign.
                overflow = (~a[15] & ~b[15] & y[15]) |
                           ( a[15] &  b[15] & ~y[15]);
            end

            OP_SUB: begin
                y     = sub_result[15:0];

                // Borrow flag behavior:
                // carry = 1 means no borrow, carry = 0 means borrow occurred.
                carry = ~sub_result[16];

                // Signed overflow for subtraction:
                // If a and b have different signs, and result sign differs from a.
                overflow = (~a[15] & b[15] & y[15]) |
                           ( a[15] & ~b[15] & ~y[15]);
            end

            OP_AND: begin
                y = a & b;
            end

            OP_OR: begin
                y = a | b;
            end

            OP_XOR: begin
                y = a ^ b;
            end

            OP_NOT: begin
                y = ~a;
            end

            OP_SHL: begin
                y     = a << 1;
                carry = a[15];
            end

            OP_SHR: begin
                y     = a >> 1;
                carry = a[0];
            end

            default: begin
                y        = 16'h0000;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    assign zero     = (y == 16'h0000);
    assign negative = y[15];

endmodule
