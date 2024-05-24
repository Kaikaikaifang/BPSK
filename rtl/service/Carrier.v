// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/24
// Design Name: BPSK
// Module Name: Carrier.v
// Tool versions: VsCode
// Description: 
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
`include "rtl/common/counter.v"
`include "rtl/common/rom.v"
module Carrier (
    input wire clk_sig,
    input wire rst_n,

    output reg [15:0] carrier_sig
);
    wire [ 5:0] counter_sig;
    wire [ 0:0] flag_sig;
    wire [14:0] carrier_reg;

    reg  [ 6:0] addr_sig;
    reg  [ 1:0] state_reg;

    localparam [1:0] I_QURTER = 0;
    localparam [1:0] II_QURTER = 1;
    localparam [1:0] III_QURTER = 2;
    localparam [1:0] IV_QURTER = 3;

    counter #(
        .NUM(64)
    ) counter_inst (
        .clk_sig    (clk_sig),
        .reset_sig  (rst_n),
        .counter_sig(counter_sig),
        .carry_sig  (flag_sig)
    );

    rom #(
        .WIDTH(15),
        .DEPTH(65)
    ) rom_inst (
        .addr_sig(addr_sig),
        .q_sig   (carrier_reg)
    );

    always @(posedge clk_sig) begin
        if (!rst_n) begin
            state_reg <= I_QURTER;
            addr_sig  <= 0;
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
                    addr_sig    <= 7'd64 - {flag_sig, counter_sig};
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
                    addr_sig    <= 7'd64 - {flag_sig, counter_sig};
                end
                default: begin
                    state_reg <= I_QURTER;
                end
            endcase
        end
    end

endmodule
