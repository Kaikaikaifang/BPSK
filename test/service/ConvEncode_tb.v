//~ `New testbench
`timescale 1ns / 1ps
`include "rtl/service/ConvEncode.v"
`include "rtl/common/mseries.v"

module ConvEncode_tb;

    // ConvEncode Parameters
    parameter PERIOD = 10;

    // Mseries Parameters
    parameter M = 4;

    // Mseries Outputs
    wire       q_sig;

    // ConvEncode Inputs
    reg        en_sig = 0;
    reg        clk_sig = 0;
    reg        rst_sig = 0;

    // ConvEncode Outputs
    wire [1:0] encode_sig;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/ConvEncode.vcd");  //生成的vcd文件名称
        $dumpvars(0, ConvEncode_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_sig = 1;
    end

    mseries #(
        .M(4)
    ) u_mseries (
        .clk_sig(clk_sig),
        .rst_sig(rst_sig),

        .m_sig(q_sig)
    );

    ConvEncode u_ConvEncode (
        .q_sig  (q_sig),
        .en_sig (en_sig),
        .clk_sig(clk_sig),
        .rst_n  (rst_sig),

        .encode_sig(encode_sig[1:0])
    );

    initial begin
        #10000 $finish;
    end

endmodule
