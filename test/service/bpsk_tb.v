`timescale 1ns / 1ps
`include "rtl/service/bpsk.v"
`include "rtl/service/Carrier.v"
`include "rtl/common/mseries.v"
`include "rtl/service/duc.v"
module bpsk_tb;

    // Parameters
    parameter PERIOD = 10;

    // Inputs
    reg         clk_sig = 0;
    reg         lazy_clk_sig = 0;
    reg         rst_n = 0;

    // Outputs
    wire [15:0] carrier_sig;
    wire        q_sig;
    wire [15:0] bpsk_sig;
    wire [ 1:0] base_bpsk_sig;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/bpsk.vcd");  //生成的vcd文件名称
        $dumpvars(0, bpsk_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    always begin
        #(5 * 4 * 64 * PERIOD / 2) lazy_clk_sig = ~lazy_clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_n = 1;
    end

    Carrier u_Carrier (
        .clk_sig(clk_sig),
        .rst_n  (rst_n),

        .carrier_sig(carrier_sig[15:0])
    );

    mseries u_mseries (
        .clk_sig(lazy_clk_sig),
        .rst_sig(rst_n),

        .m_sig(q_sig)
    );

    bpsk u_bpsk (
        .clk_sig (lazy_clk_sig),
        .rst_n   (rst_n),
        .base_sig(q_sig),

        .bpsk_sig(base_bpsk_sig[1:0])
    );

    duc #(
        .BWIDTH(2),
        .CWIDTH(16)
    ) u_duc (
        .base_sig   (base_bpsk_sig[1:0]),
        .carrier_sig(carrier_sig[15:0]),
        .duc_sig    (bpsk_sig[15:0])
    );

    initial begin
        #500000 $finish;
    end

endmodule

