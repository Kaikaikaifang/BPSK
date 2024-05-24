// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/24
// Design Name: BPSK
// Module Name: bpsk.v
// Tool versions: VsCode
// Description: BPSK 信号调制
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module bpsk (
    input        clk_sig,
    input        rst_n,
    input        en_p,
    input [ 0:0] base_sig,
    input [15:0] carrier_sig,

    output reg [15:0] bpsk_sig
);
    always @(posedge clk_sig) begin
        if (!rst_n) begin
            bpsk_sig <= 16'b0;
        end else begin
            if (en_p == 1'b1) begin
                if (base_sig == 1'b0) begin
                    bpsk_sig <= ~carrier_sig + 1'b1;
                end else begin
                    bpsk_sig <= carrier_sig;
                end
            end else begin
                bpsk_sig <= 1'b0;
            end
        end
    end
endmodule
