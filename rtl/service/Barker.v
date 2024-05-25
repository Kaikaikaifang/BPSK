// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/25
// Design Name: BPSK
// Module Name: Barker.v
// Tool versions: VsCode
// Description: 7 bits 巴克码 发生器
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module Barker #(
    parameter barker_code = 7'b1110010
) (
    input wire clk_sig,
    input wire rst_n,
    input wire en_p,

    output wire barker_sig
);
    localparam WIDTH = $clog2(barker_code);
    reg [WIDTH-1:0] barker_reg;

    always @(posedge clk_sig) begin
        if (!rst_n) begin
            barker_reg <= barker_code;
        end else if (en_p) begin
            barker_reg <= {barker_reg[WIDTH-2:0], barker_reg[WIDTH-1]};
        end
    end

    assign barker_sig = barker_reg[WIDTH-1];
endmodule
