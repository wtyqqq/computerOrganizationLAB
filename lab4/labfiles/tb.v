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

    reg   [11:0] alu_control;
    reg   [31:0] alu_src1;   
    reg   [31:0] alu_src2;   
    wire  [31:0] alu_result; 
    alu alu_module(
        .alu_control(alu_control),
        .alu_src1   (alu_src1   ),
        .alu_src2   (alu_src2   ),
        .alu_result (alu_result )
    );

    initial begin
        //加法操作
        alu_control = 12'b1000_0000_0000;
        alu_src1 = 32'd1;
        alu_src2 = 32'hffffffff;

        //减法操作
        #5;
        alu_control = 12'b0100_0000_0000;
        alu_src1 = 32'd1;
        alu_src2 = 32'd2;
        
        //有符号比较
        #5;
        alu_control = 12'b0010_0000_0000;
        alu_src1 = 32'd1;
        alu_src2 = 32'd2;
        
        //无符号比较
        #5;
        alu_control = 12'b0001_0000_0000;
        alu_src1 = 32'd1;
        alu_src2 = 32'd2;
        
        //按位与
        #5;
        alu_control = 12'b0000_1000_0000;
        alu_src1 = 32'h12345678;
        alu_src2 = 32'hf0f0f0f0;
        
        //按位或非
        #5;
        alu_control = 12'b0000_0100_0000;
        alu_src1 = 32'he;
        alu_src2 = 32'd1;

        //按位或
        #5;
        alu_control = 12'b0000_0010_0000;
        alu_src1 = 32'he;
        alu_src2 = 32'd1;
        
        //按位异或
        #5;
        alu_control = 12'b0000_0001_0000;
        alu_src1 = 32'b1010;
        alu_src2 = 32'b0101;
        
        //逻辑左移
        #5;
        alu_control = 12'b0000_0000_1000;
        alu_src1 = 32'd4;
        alu_src2 = 32'hf;
        
        //逻辑右移
        #5;
        alu_control = 12'b0000_0000_0100;
        alu_src1 = 32'd4;
        alu_src2 = 32'hf0;

        //算术右移        
        #5;
        alu_control = 12'b0000_0000_0010;
        alu_src1 = 32'd4;
        alu_src2 = 32'hf0000000;

        //高位加载    
        #5;
        alu_control = 12'b0000_0000_0001;
        alu_src2 = 32'hbfc0;
    end
endmodule

