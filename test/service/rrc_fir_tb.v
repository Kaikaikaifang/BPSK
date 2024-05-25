`timescale 1ns / 1ps
`include "rtl/service/rrc_fir.v"

module rrc_fir_tb;

    // rrc_filter Parameters
    parameter PERIOD = 10;
    parameter INPUT_WIDTH = 2;
    parameter OUTPUT_WIDTH = 16;
    parameter COEFF_WIDTH = 14;
    parameter NUM_TAPS = 16;

    // rrc_filter Inputs
    reg                     clk_sig = 0;
    reg                     lazy_clk_sig = 0;
    reg                     rst_n = 0;
    reg  [ INPUT_WIDTH-1:0] data_in = 0;

    // rrc_filter Outputs
    wire [OUTPUT_WIDTH-1:0] data_out;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/rrc_fir.vcd");  //生成的vcd文件名称
        $dumpvars(0, rrc_fir_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    always begin
        #(5 * PERIOD) lazy_clk_sig = ~lazy_clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_n = 1;
    end

    always @(posedge lazy_clk_sig) begin
        // Generate a random bit
        if ($random % 2 == 0) begin
            data_in <= 2'b11;
        end else begin
            data_in <= 2'b01;
        end
    end

    rrc_fir #(
        .INPUT_WIDTH (INPUT_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH),
        .COEFF_WIDTH (COEFF_WIDTH),
        .NUM_TAPS    (NUM_TAPS)
    ) u_rrc_filter (
        .clk    (clk_sig),
        .rst_n  (rst_n),
        .data_in(data_in[INPUT_WIDTH-1:0]),

        .data_out(data_out[OUTPUT_WIDTH-1:0])
    );

    initial begin
        #10000 $finish;
    end

endmodule
