// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/26
// Design Name: BPSK
// Module Name: mux.v
// Tool versions: VsCode
// Description: 多路复用器
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module mux #(
    parameter WIDTH = 16
) (
    input                   sel_sig,
    input       [WIDTH-1:0] in0_sig,
    input       [WIDTH-1:0] in1_sig,
    output wire [WIDTH-1:0] out_sig
);
    assign out_sig = sel_sig ? in1_sig : in0_sig;
endmodule
