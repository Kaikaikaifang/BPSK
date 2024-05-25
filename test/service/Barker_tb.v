`timescale 1ns / 1ps
`include "rtl/service/Barker.v"

module Barker_tb;

    // Barker Parameters
    parameter PERIOD = 10;
    parameter barker_code = 7'b1110010;

    // Barker Inputs
    reg  clk_sig = 0;
    reg  rst_n = 0;
    // Barker Outputs
    wire barker_sig;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/Barker.vcd");  //生成的vcd文件名称
        $dumpvars(0, Barker_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_n = 1;
    end

    Barker #(
        .barker_code(barker_code)
    ) u_Barker (
        .clk_sig(clk_sig),
        .rst_n  (rst_n),
        .en_p   (rst_n),

        .barker_sig(barker_sig)
    );

    initial begin
        #10000 $finish;
    end

endmodule
