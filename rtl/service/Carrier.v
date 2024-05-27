// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/24
// Design Name: BPSK
// Module Name: Carrier.v
// Tool versions: VsCode
// Description: 
// Parameter:
// 1. WIDTH: 量化后的宽度
// 2. NUM: 1/4 周期采样点数
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
`include "rtl/common/rom.v"
module Carrier #(
    parameter WIDTH = 16,
    parameter NUM   = 2
) (
    input wire clk_sig,
    input wire rst_n,

    output reg [WIDTH-1:0] carrier_sig
);
    wire [$clog2(NUM)-1:0] counter_sig;
    wire [            0:0] flag_sig;
    wire [      WIDTH-2:0] carrier_reg;

    reg  [  $clog2(NUM):0] addr_sig;
    reg  [            1:0] state_reg;

    localparam [1:0] I_QURTER = 0;
    localparam [1:0] II_QURTER = 1;
    localparam [1:0] III_QURTER = 2;
    localparam [1:0] IV_QURTER = 3;

    counter #(
        .NUM(NUM)
    ) counter_inst (
        .clk_sig    (clk_sig),
        .reset_sig  (rst_n),
        .counter_sig(counter_sig),
        .carry_sig  (flag_sig)
    );

    rom #(
        .WIDTH(WIDTH - 1),
        .DEPTH(NUM + 1)
    ) rom_inst (
        .addr_sig(addr_sig),
        .q_sig   (carrier_reg)
    );

    always @(posedge clk_sig) begin
        if (!rst_n) begin
            state_reg   <= I_QURTER;
            addr_sig    <= 0;
            carrier_sig <= 0;
        end else begin
            case (state_reg)
                I_QURTER: begin
                    if (flag_sig) begin
                        state_reg <= II_QURTER;
                    end
                    carrier_sig <= {1'b0, carrier_reg};
                    addr_sig    <= {flag_sig, counter_sig};
                end
                II_QURTER: begin
                    if (flag_sig) begin
                        state_reg <= III_QURTER;
                    end
                    carrier_sig <= {1'b0, carrier_reg};
                    addr_sig    <= NUM - {flag_sig, counter_sig};
                end
                III_QURTER: begin
                    if (flag_sig) begin
                        state_reg <= IV_QURTER;
                    end
                    carrier_sig <= ~{1'b0, carrier_reg} + 1'b1;
                    addr_sig    <= {flag_sig, counter_sig};
                end
                IV_QURTER: begin
                    if (flag_sig) begin
                        state_reg <= I_QURTER;
                    end
                    carrier_sig <= ~{1'b0, carrier_reg} + 1'b1;
                    addr_sig    <= NUM - {flag_sig, counter_sig};
                end
                default: begin
                    state_reg <= I_QURTER;
                end
            endcase
        end
    end

endmodule
