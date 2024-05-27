`timescale 1ns / 1ps
`include "rtl/txd.v"

module txd_tb;

    // txd Parameters
    parameter FPERIOD = 2.5;  //时钟周期 2.5 ns 400 MHz
    parameter PERIOD = 50;  //时钟周期 20 MHz

    // txd Inputs
    reg         f_clk_sig = 0;
    reg         clk_sig = 0;
    reg         rst_n = 0;

    // txd Outputs
    wire [15:0] txd_sig;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/txd.vcd");  //生成的vcd文件名称
        $dumpvars(0, txd_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(FPERIOD / 2) f_clk_sig = ~f_clk_sig;
    end

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_n = 1;
    end

    txd u_txd (
        .f_clk_sig(f_clk_sig),
        .clk_sig  (clk_sig),
        .rst_n    (rst_n),

        .txd_sig(txd_sig[15:0])
    );

    initial begin
        #142500 $finish;
    end

endmodule
