module rrc_fir #(
    parameter INPUT_WIDTH = 2,
    parameter OUTPUT_WIDTH = 16,
    parameter COEFF_WIDTH = 14,
    parameter NUM_TAPS = 16
) (
    input                            clk,
    input                            rst_n,
    input  signed [ INPUT_WIDTH-1:0] data_in,
    output signed [OUTPUT_WIDTH-1:0] data_out
);

    reg signed  [ INPUT_WIDTH-1:0] delay_line  [  0:NUM_TAPS];
    reg signed  [ COEFF_WIDTH-1:0] coefficients[0:NUM_TAPS/2];
    wire signed [OUTPUT_WIDTH-1:0] products    [  0:NUM_TAPS];
    wire signed [OUTPUT_WIDTH-1:0] sum;

    integer                        i;

    // 初始化滤波器系数
    initial begin
        $readmemh("assets/sources/coe.hex", coefficients);
    end

    // 移位寄存器
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_TAPS + 1; i = i + 1) begin
                delay_line[i] <= 0;
            end
        end else begin
            delay_line[0] <= data_in;
            for (i = 1; i < NUM_TAPS + 1; i = i + 1) begin
                delay_line[i] <= delay_line[i-1];
            end
        end
    end

    // 乘法器
    genvar j;
    generate
        for (j = 0; j < NUM_TAPS / 2 + 1; j = j + 1) begin
            assign products[j]          = $signed(delay_line[j]) * $signed(coefficients[j]);
            assign products[NUM_TAPS-j] = $signed(delay_line[NUM_TAPS-j]) * $signed(coefficients[j]);
        end
    endgenerate

    // 加法器
    assign sum      = $signed(products[0]) + products[1] + products[2] + products[3] + products[4] + products[5] + products[6] + products[7] + products[8] + products[9] + products[10] + products[11] + products[12] + products[13] + products[14] + products[15] + products[16];

    // 输出结果
    assign data_out = sum[OUTPUT_WIDTH-1:0];

endmodule
