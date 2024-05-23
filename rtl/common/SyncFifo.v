// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/23
// Design Name: BPSK
// Module Name: SyncFifo.v
// Tool versions: VsCode
// Description: 同步 FIFO
// Parameter:
// 1. DEPTH: FIFO 的深度
// 2. WIDTH: FIFO 的宽度
// Input:
// 1. clk_sig: 时钟信号
// 2. rst_sig: 复位信号
// 3. w_en_sig: 写使能信号
// 4. r_en_sig: 读使能信号
// 5. data_in: 写入数据
// Output:
// 1. data_out: 读出数据
// 2. full: FIFO 满
// 3. empty: FIFO 空
// ************************************************************
module SyncFifo #(
    parameter DEPTH = 8,
    parameter WIDTH = 8
) (
    input                  clk_sig,
    input                  rst_sig,
    input                  w_en_sig,
    input                  r_en_sig,
    input      [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output                 full,
    output                 empty
);

    parameter PTR_WIDTH = $clog2(DEPTH);

    reg [PTR_WIDTH:0] w_ptr, r_ptr;
    reg [      WIDTH-1:0] fifo  [DEPTH - 1:0];
    reg [$clog2(DEPTH):0] count;

    // Set Default values on reset.
    always @(posedge clk_sig) begin
        if (!rst_sig) begin
            w_ptr    <= 0;
            r_ptr    <= 0;
            data_out <= 0;

        end
    end

    // To write data to FIFO
    always @(posedge clk_sig) begin
        if (w_en_sig & !full) begin
            fifo[w_ptr[PTR_WIDTH-1:0]] <= data_in;
            w_ptr                      <= w_ptr + 1;
        end
    end

    // To read data from FIFO
    always @(posedge clk_sig) begin
        if (r_en_sig & !empty) begin
            data_out <= fifo[r_ptr[PTR_WIDTH-1:0]];
            r_ptr    <= r_ptr + 1;
        end
    end

    assign full  = (w_ptr[PTR_WIDTH] ^ r_ptr[PTR_WIDTH]) & (w_ptr[PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0]);
    assign empty = (w_ptr == r_ptr);
endmodule
