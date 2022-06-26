`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Target Device:  
// Tool versions:  
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;
    reg  [4:0] addr;
    wire [31:0] inst;

    inst_rom inst_rom_module(
        .addr  (addr),
        .inst  (inst      )
    );
    
    integer i;
    initial begin
        addr = 0;
        for(i=1;i<20;i=i+1) begin
            #10;
            addr = addr + 5'd1;
        end
    end
endmodule
