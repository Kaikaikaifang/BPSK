// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/05/24
// Design Name: BPSK
// Module Name: rom.v
// Tool versions: VsCode
// Description: This is the rom module.
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module rom #(
    parameter WIDTH = 8,
    parameter DEPTH = 256
) (
    input  [$clog2(DEPTH - 1):0] addr_sig,
    output [          WIDTH-1:0] q_sig
);
    reg [WIDTH-1:0] mem_reg[0:DEPTH-1];

    initial begin
        $readmemh("assets/sources/sin_hex.hex", mem_reg);
    end

    assign q_sig = mem_reg[addr_sig[$clog2(DEPTH-1):0]];

endmodule
