// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/25
// Design Name: BPSK
// Module Name: duc.v
// Tool versions: VsCode
// Description: 数字上变频器
// Parameter:
// 1. BWIDTH: 基带信号宽度
// 2. CWIDTH: 载波信号宽度
// Input:
// 1. base_sig: 基带信号
// 2. carrier_sig: 载波信号
// Output:
// 1. duc_sig: 数字上变频信号
// ************************************************************
module duc #(
    parameter BWIDTH = 2,
    parameter CWIDTH = 16
) (
    input [BWIDTH-1:0] base_sig,
    input [CWIDTH-1:0] carrier_sig,

    output wire [CWIDTH-1:0] duc_sig
);
    wire [BWIDTH + CWIDTH - 1:0] extend_duc_sig;
    assign extend_duc_sig = $signed(base_sig) * $signed(carrier_sig);
    assign duc_sig        = extend_duc_sig[BWIDTH+CWIDTH-1:BWIDTH];
endmodule
