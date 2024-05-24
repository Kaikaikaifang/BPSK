`timescale 1ns / 1ps
`include "rtl/service/Carrier.v"

module Carrier_tb;

    // Carrier Parameters
    parameter PERIOD = 10;


    // Carrier Inputs
    reg         clk_sig = 0;
    reg         rst_n = 0;

    // Carrier Outputs
    wire [15:0] carrier_sig;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/Carrier.vcd");  //生成的vcd文件名称
        $dumpvars(0, Carrier_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_n = 1;
    end

    Carrier u_Carrier (
        .clk_sig(clk_sig),
        .rst_n  (rst_n),

        .carrier_sig(carrier_sig[15:0])
    );

    initial begin
        #10000 $finish;
    end

endmodule
