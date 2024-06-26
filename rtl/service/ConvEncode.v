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
    input       en_p,
    input       clk_sig,
    input       rst_n,

    output [1:0] encode_sig
);
    reg [3:0] encoder_reg;

    always @(posedge clk_sig) begin
        if (!rst_n) begin
            encoder_reg <= 4'b0;
        end else begin
            if (en_p == 1'b1) encoder_reg <= {q_sig, encoder_reg[3:1]};
        end
    end

    assign encode_sig[1] = encoder_reg[3] ^ encoder_reg[1] ^ encoder_reg[0];
    assign encode_sig[0] = encoder_reg[3] ^ encoder_reg[2] ^ encoder_reg[1] ^ encoder_reg[0];
endmodule
