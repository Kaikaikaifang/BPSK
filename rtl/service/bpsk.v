// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/24
// Design Name: BPSK
// Module Name: bpsk.v
// Tool versions: VsCode
// Description: BPSK 基带信号调制
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module bpsk (
    input       clk_sig,
    input       rst_n,
    input [0:0] base_sig,

    output reg [1:0] bpsk_sig
);
    always @(posedge clk_sig) begin
        if (!rst_n) begin
            bpsk_sig <= 2'b11;
        end else begin
            case (base_sig)
                1'b0: bpsk_sig <= 2'b11;
                1'b1: bpsk_sig <= 2'b01;
                default: bpsk_sig <= 2'b11;
            endcase
        end
    end
endmodule
