//~ `New testbench
`timescale 1ns / 1ps
`include "rtl/common/SyncFifo.v"

module SyncFifo_tb;

    // SyncFifo Parameters
    parameter PERIOD = 10;
    parameter DEPTH = 8;
    parameter WIDTH = 8;

    // SyncFifo Inputs
    reg              clk_sig = 0;
    reg              rst_sig = 0;
    reg              w_en_sig = 0;
    reg              r_en_sig = 0;
    reg  [WIDTH-1:0] data_in = 0;

    // SyncFifo Outputs
    wire [WIDTH-1:0] data_out;
    wire             full;
    wire             empty;

    /*iverilog */
    initial begin
        $dumpfile("simulation/vcd/SyncFifo.vcd");  //生成的vcd文件名称
        $dumpvars(0, SyncFifo_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    initial begin
        #(PERIOD * 2) rst_sig = 1;
        drive(20);
        drive(40);
        drive(80);
        $finish;
    end

    SyncFifo #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) u_SyncFifo (
        .clk_sig (clk_sig),
        .rst_sig (rst_sig),
        .w_en_sig(w_en_sig),
        .r_en_sig(r_en_sig),
        .data_in (data_in[WIDTH-1:0]),

        .data_out(data_out[WIDTH-1:0]),
        .full    (full),
        .empty   (empty)
    );

    task push();
        if (!full) begin
            w_en_sig = 1;
            data_in  = $random;
            #1 $display("Push In: w_en=%b, r_en=%b, data_in=%h", w_en_sig, r_en_sig, data_in);
        end else $display("FIFO Full!! Can not push data_in=%d", data_in);
    endtask

    task pop();
        if (!empty) begin
            r_en_sig = 1;
            #1 $display("Pop Out: w_en=%b, r_en=%b, data_out=%h", w_en_sig, r_en_sig, data_out);
        end else $display("FIFO Empty!! Can not pop data_out");
    endtask

    task drive(int delay);
        w_en_sig = 0;
        r_en_sig = 0;
        fork
            begin
                repeat (10) begin
                    @(posedge clk_sig) push();
                end
                w_en_sig = 0;
            end
            begin
                #delay;
                repeat (10) begin
                    @(posedge clk_sig) pop();
                end
                r_en_sig = 0;
            end
        join
    endtask

endmodule
