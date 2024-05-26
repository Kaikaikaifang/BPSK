`timescale 1ps / 1fs
`include "rtl/txd.v"

module txd_tb;

    // txd Parameters
    parameter FPERIOD = 78.125;  //时钟周期 78.125ps 12.8GHz
    parameter PERIOD = 50000;  //时钟周期 20MHz

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
        #50000000 $finish;
    end

endmodule
