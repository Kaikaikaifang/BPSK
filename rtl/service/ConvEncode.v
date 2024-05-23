// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/23
// Design Name: BPSK
// Module Name: ConvEncode.v
// Tool versions: VsCode
// Description: This is the convolutional encoder module.
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module ConvEncode (
    input [0:0] q_sig,
    input       en_sig,
    input       clk_sig,
    input       rst_sig,

    output [1:0] encode_sig
);
    reg [3:0] encoder_reg;

    always @(posedge clk_sig) begin
        if (rst_sig) encoder_reg <= 4'b0;

        if (en_sig == 1'b0) encoder_reg <= {q_sig, encoder_reg[3:1]};
    end

    assign encode_sig[1] = encoder_reg[3] ^ encoder_reg[1] ^ encoder_reg[0];
    assign encode_sig[0] = encoder_reg[3] ^ encoder_reg[2] ^ encoder_reg[1] ^ encoder_reg[0];
endmodule
