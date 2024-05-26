// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/26
// Design Name: BPSK
// Module Name: txd.v
// Tool versions: VsCode
// Description: 发射机
// Parameter:
// 1. 
// Input:
// 1. f_clk_sig: 高速时钟信号，用于产生载波信号 12.8 GHz
// 2. clk_sig: 时钟信号 10 MHz
// 3. rst_n: 复位信号
// Output:
// 1. txd_sig: 发射信号
// ************************************************************
`include "rtl/common/div.v"
`include "rtl/common/mseries.v"
`include "rtl/common/counter.v"
`include "rtl/service/Carrier.v"

module txd (
    input f_clk_sig,
    input clk_sig,
    input rst_n,

    output wire [15:0] txd_sig
);
    // 1. 分频产生时钟信号
    wire div_10_clk_sig;
    wire div_5_clk_sig;
    // 1.1. 十分频产生 1 MHz 时钟信号
    div #(
        .NUM(10)
    ) u_div_10 (
        .clk_sig  (clk_sig),
        .reset_sig(rst_n),
        .div_sig  (div_10_clk_sig)
    );
    // 1.2. 五分频产生 2 MHz 时钟信号
    div #(
        .NUM(5)
    ) u_div_5 (
        .clk_sig  (clk_sig),
        .reset_sig(rst_n),
        .div_sig  (div_5_clk_sig)
    );

    // 2. 产生基带信号
    wire [0:0] base_sig;
    wire [0:0] barker_sig;
    // 2.1. 产生随机信源信号

endmodule
