// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/26
// Design Name: BPSK
// Module Name: txd.v
// Tool versions: VsCode
// Description: 发射机
// Parameter:
// 1. 
// Input:
// 1. f_clk_sig: 高速时钟信号，用于产生载波信号 12.8 GHz
// 2. clk_sig: 时钟信号 10 MHz
// 3. rst_n: 复位信号
// Output:
// 1. txd_sig: 发射信号
// ************************************************************
`include "rtl/service/Barker.v"
`include "rtl/service/ConvEncode.v"
`include "rtl/service/bpsk.v"
`include "rtl/service/rrc_fir.v"
`include "rtl/service/Carrier.v"
`include "rtl/service/duc.v"
`include "rtl/service/mux.v"

`include "rtl/common/div.v"
`include "rtl/common/mseries.v"
`include "rtl/common/counter.v"
`include "rtl/common/parallel2serial.v"

module txd (
    input f_clk_sig,
    input clk_sig,
    input rst_n,

    output wire [15:0] txd_sig
);
    // 1. 分频产生时钟信号
    wire div_10_clk_sig;
    wire div_5_clk_sig;
    // 1.1. 二十分频产生 1 MHz 时钟信号
    div #(
        .NUM (20),
        .DUTY(10)
    ) u_div_10 (
        .clk_sig(clk_sig),
        .div_sig(div_10_clk_sig)
    );
    // 1.2. 十分频产生 2 MHz 时钟信号
    div #(
        .NUM (10),
        .DUTY(5)
    ) u_div_5 (
        .clk_sig(clk_sig),
        .div_sig(div_5_clk_sig)
    );

    // 2. 产生基带信号
    wire [0:0] m_sig;
    wire [0:0] barker_sig;
    // 2.1. 产生随机信源信号
    mseries u_mseries (
        .clk_sig(div_10_clk_sig),
        .rst_sig(rst_n),

        .m_sig(m_sig)
    );
    // 2.2. 产生 Barker 序列
    Barker u_barker (
        .clk_sig   (div_5_clk_sig),
        .rst_n     (rst_n),
        .en_p      (~sel_sig),       // TODO: 使能信号 由计数器驱动
        .barker_sig(barker_sig)
    );

    // 3. 信道编码：(2, 1, 3) 卷积码
    wire [1:0] parallel_encode_sig;
    wire [0:0] encode_sig;
    // 3.1 产生卷积码
    ConvEncode u_ConvEncode (
        .q_sig  (m_sig),
        .en_p   (sel_sig),         // TODO: 使能信号 由计数器驱动
        .clk_sig(div_10_clk_sig),
        .rst_n  (rst_n),

        .encode_sig(parallel_encode_sig[1:0])
    );
    // 3.2 并串转换
    parallel2serial #(
        .WIDTH(2)
    ) u_parallel2serial (
        .clk_sig     (div_5_clk_sig),
        .reset_sig   (rst_n),
        .parallel_sig(parallel_encode_sig),
        .serial_sig  (encode_sig)
    );

    // 4. 基带信号 BPSK 调制
    wire [1:0] base_bpsk_sig;
    wire [1:0] barker_bpsk_sig;
    // 4.1 巴克码 BPSK 调制
    bpsk u_bpsk (
        .clk_sig (div_5_clk_sig),
        .rst_n   (rst_n),
        .base_sig(barker_sig),

        .bpsk_sig(barker_bpsk_sig[1:0])
    );
    // 4.2 编码信号 BPSK 调制
    bpsk u_base_bpsk (
        .clk_sig (div_5_clk_sig),
        .rst_n   (rst_n),
        .base_sig(encode_sig),

        .bpsk_sig(base_bpsk_sig[1:0])
    );

    // 5. 基带信号成型滤波
    wire [15:0] fir_sig;
    rrc_fir u_rrc_filter (
        .clk    (clk_sig),
        .rst_n  (rst_n),
        .data_in(base_bpsk_sig),

        .data_out(fir_sig)
    );

    // 6. 正交上变频
    // 6.1 产生载波信号
    wire [15:0] carrier_sig;
    Carrier u_Carrier (
        .clk_sig(f_clk_sig),
        .rst_n  (rst_n),

        .carrier_sig(carrier_sig[15:0])
    );
    // 6.2 上变频
    wire [15:0] barker_duc_sig;
    wire [15:0] encode_duc_sig;
    // 6.2.1 巴克码上变频
    duc #(
        .BWIDTH(2),
        .CWIDTH(16)
    ) u_barker_duc (
        .base_sig   (barker_bpsk_sig[1:0]),
        .carrier_sig(carrier_sig[15:0]),

        .duc_sig(barker_duc_sig)
    );
    // 6.2.2 编码信号上变频
    duc #(
        .BWIDTH(16),
        .CWIDTH(16)
    ) u_encode_duc (
        .base_sig   (fir_sig[15:0]),
        .carrier_sig(carrier_sig[15:0]),

        .duc_sig(encode_duc_sig)
    );

    // 7. 选择合路器
    localparam NUM = 57;
    wire [              0:0] sel_sig;
    wire [$clog2(NUM-1)-1:0] counter_sig;
    // 7.1 计数器产生选择信号
    counter #(
        .NUM(NUM)
    ) u_counter (
        .clk_sig  (div_5_clk_sig),
        .reset_sig(rst_n),

        .counter_sig(counter_sig[$clog2(NUM-1)-1:0])
    );
    assign sel_sig = (counter_sig >= 0 && counter_sig < 7) ? 1'b0 : 1'b1;
    // 7.2 合路器
    mux u_mux (
        .sel_sig(sel_sig),
        .in0_sig(barker_duc_sig),
        .in1_sig(encode_duc_sig),

        .out_sig(txd_sig)
    );
endmodule
