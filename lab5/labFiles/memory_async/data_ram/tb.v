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
    reg clk;
    reg  [ 4:0] addr;
    reg  [31:0] wdata;
    reg  [ 3:0] wen;
    wire [31:0] rdata;
    reg  [ 4:0] test_addr;
    wire [31:0] test_data;  

    data_ram data_ram_module(
        .clk   (clk   ),
        .wen   (wen   ),
        .addr  (addr),
        .wdata (wdata ),
        .rdata (rdata ),
        .test_addr(test_addr),
        .test_data(test_data)
    );
    
    initial begin
        clk = 0;
        addr = 0;

        #10;
        clk = 1;
        wen = 4'hf;
        wdata = 0;
        
        #10;
        clk = 0;
        
        #10;
        clk = 1;
        wen = 4'b0001;
        wdata = 32'HFFFFFFFF;
    end
endmodule
