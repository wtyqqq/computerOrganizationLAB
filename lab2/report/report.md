# 计算机组成原理实验2 定点乘法器

**日期：2022年5月8日**

**王天一 320200931301**

## 一、实验目的

1. 理解定点乘法的不同实现算法的原理，掌握基本实现算法。 

2. 熟悉并运用 verilog 语言进行电路设计。 

3. 为后续设计 cpu 的实验打下基础。

## 二、课设器材与设备

1. 装有 Xilinx Vivado 的计算机一台。 
2. LS-CPU-EXB-002 教学系统实验箱一套

## 三、课设分析与设计

1、课设原理

本例中设计的乘法部件实现的是迭代乘法算法，其原理图如下：

![img](report.assets/clip_image002.png)

图中参与运算的为两个乘数的绝对值，乘法结果也是绝对值，需要单独判断符号位后校正乘积。

迭代乘法是在模拟我们人算乘法的过程，乘数每次右移一位，根据最低位，判断是加被乘数移位后的值还是加0，不停地累加最后就得到乘积了。

可以看到迭代乘法是用多次加法完成乘法操作的，故需要多拍时间，其结束标志为乘数移位后为0，故对于32 位乘法，最多需要32 拍才能完成一次乘法。

2、端口设计

时钟clk、复位resetn、输入选择信号input_sel，乘法开始信号mult_begin，高电平时乘法器开始工作，输出信号mult_end，高电平时表示乘法结束。在乘法器内部设置两个32位的乘数输入信号，以及64位的乘法结果输出信号product。

3、设计框图   ![img](report.assets/clip_image004.jpg)

## 四、实际实现

### 1.实现代码

```verilog
module multiply(              // 乘法器
    input         clk,        // 时钟
    input         mult_begin, // 乘法开始信号
    input  [31:0] mult_op1,   // 乘法源操作数1
    input  [31:0] mult_op2,   // 乘法源操作数2
    output [63:0] product,    // 乘积
    output        mult_end    // 乘法结束信号
);

    //乘法正在运算信号和结束信号
    reg mult_valid;
    assign mult_end = mult_valid & ~(|multiplier); //乘法结束信号：乘数全0
    always @(posedge clk)
    begin
        if (!mult_begin || mult_end)
        begin
            mult_valid <= 1'b0;
        end
        else
        begin
            mult_valid <= 1'b1;
        end
    end

    //两个源操作取绝对值，正数的绝对值为其本身，负数的绝对值为取反加1
    wire        op1_sign;      //操作数1的符号位
    wire        op2_sign;      //操作数2的符号位
    wire [31:0] op1_absolute;  //操作数1的绝对值
    wire [31:0] op2_absolute;  //操作数2的绝对值
    assign op1_sign = mult_op1[31];
    assign op2_sign = mult_op2[31];
    assign op1_absolute = op1_sign ? (~mult_op1+1) : mult_op1;
    assign op2_absolute = op2_sign ? (~mult_op2+1) : mult_op2;

    //加载被乘数，运算时每次左移一位
    reg  [63:0] multiplicand;  //被乘数寄存器
    always @ (posedge clk)
    begin
        if (mult_valid)
        begin    // 如果正在进行乘法，则被乘数每时钟左移一位
            multiplicand <= {multiplicand[62:0],1'b0};
        end
        else if (mult_begin) 
        begin   // 乘法开始，加载被乘数，为乘数1的绝对值
            multiplicand <= {32'd0,op1_absolute};
        end
    end

    //加载乘数，运算时每次右移一位
    reg  [31:0] multiplier; //乘数寄存器
    always @ (posedge clk)
    begin
        if (mult_valid)
        begin   // 如果正在进行乘法，则乘数每时钟右移一位
            multiplier <= {1'b0,multiplier[31:1]}; 
        end
        else if (mult_begin)
        begin   // 乘法开始，加载乘数，为乘数2的绝对值
            multiplier <= op2_absolute; 
        end
    end
    
    // 部分积：乘数末位为1，由被乘数左移得到；乘数末位为0，部分积为0
    wire [63:0] partial_product; 
    assign partial_product = multiplier[0] ? multiplicand : 64'd0;
    
    //累加器
    reg [63:0] product_temp;
    always @ (posedge clk)
    begin
        if (mult_valid)
        begin
            product_temp <= product_temp + partial_product;
        end
        else if (mult_begin) 
        begin
            product_temp <= 64'd0;  // 乘法开始，乘积清零 
        end
    end 
     
    //乘法结果的符号位和乘法结果
    reg product_sign;
    always @ (posedge clk)  // 乘积
    begin
        if (mult_valid)
        begin
              product_sign <= op1_sign ^ op2_sign;
        end
    end 
    //若乘法结果为负数，则需要对结果取反+1
    assign product = product_sign ? (~product_temp+1) : product_temp;
endmodule
```

### 2.仿真及波形

![image-20220508104416198](report.assets/image-20220508104416198.png)

## 五、测试图片

## 六、附加问题
