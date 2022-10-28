module SRTdiv(CLK, DVD, DSR, Q, R);

input CLK;
input [63:0] DVD, DSR; // DVD = dividend; DSR = divisor
output reg signed [64:0] Q; //quotient
output reg [63:0] R; //remainder

reg signed [128:0] rq; //remainder/quotient register

reg signed [ 64:0] P, temp;

reg [ 5:0] i =  0; // cycle count
reg [63:0] N = 63; // getting first 1 bit location
reg [63:0] c =  0; // counting leading zeros
reg [ 3:0] b =  0; // top 4 bit equivalent in lookup table
reg signed [5:0] p;
reg signed [2:0] q;
reg [63:0] dsr;

reg rbit;

always @(posedge CLK & i <= 32)
begin
  if (i == 0) begin
    rbit <= DSR[N];
    case (rbit)
      1'b0 : begin
        N <= N - 1'b1; //locating the first 1'b1
        c <= c + 1'b1; //counter for lading 0s

        rq <= {{64{1'b0}}, DVD[63:0]}; // setting values
        dsr <= DSR;
        Q <= 0;
        temp <= {1'b0, DSR[63:0]};
      end
 
      1'b1 : begin
        i   <= i + 1;
        rq  <= rq << c - 1; //shift all reg by c-bits
        dsr <= dsr << c - 1;
      end
    endcase
  end
  
  else if (i == 32) begin
    if (rq[128] == 1'b1) begin
      rq <= rq + b;
      Q <= Q - 1;
    end
    
    rq <= rq >> c - 1;
    R <= rq[127:64];
    
    if(R > DSR) begin
      Q <= Q + 1;
      R <= R - DSR;
    end
  end
  
  else begin
    P <= rq[128:64];
    R <= rq[127:64];
    b <= dsr[63:60];
    p <= rq[127:123];
    
    case (b)
      4'b1000 : begin
        if      (p >= -12 && p <=  -7) q <= 3'b110; 
        else if (p >=  -6 && p <=  -3) q <= 3'b101;
        else if (p >=  -2 && p <=   1) q <= 3'b000;
        else if (p >=   2 && p <=   5) q <= 3'b001;
        else if (p >=   6 && p <=  11) q <= 3'b010;
      end
      4'b1001 : begin
        if      (p >= -14 && p <=  -8) q <= 3'b110; 
        else if (p >=  -7 && p <=  -3) q <= 3'b101;
        else if (p >=  -3 && p <=   2) q <= 3'b000;
        else if (p >=   2 && p <=   6) q <= 3'b001;
        else if (p >=   7 && p <=  13) q <= 3'b010;
      end 
      4'b1010 : begin
        if      (p >= -15 && p <=  -9) q <= 3'b110; 
        else if (p >=  -8 && p <=  -3) q <= 3'b101;
        else if (p >=  -3 && p <=   2) q <= 3'b000;
        else if (p >=   2 && p <=   7) q <= 3'b001;
        else if (p >=   8 && p <=  14) q <= 3'b010;
      end	
      4'b1011 : begin
        if      (p >= -16 && p <=  -9) q <= 3'b110; 
        else if (p >=  -9 && p <=  -3) q <= 3'b101;
        else if (p >=  -3 && p <=   2) q <= 3'b000;
        else if (p >=   2 && p <=   8) q <= 3'b001;
        else if (p >=   8 && p <=  15) q <= 3'b010;
      end
      4'b1100 : begin
        if      (p >= -18 && p <= -10) q <= 3'b110; 
        else if (p >= -10 && p <=  -4) q <= 3'b101;
        else if (p >=  -4 && p <=   3) q <= 3'b000;
        else if (p >=   3 && p <=   9) q <= 3'b001;
        else if (p >=   9 && p <=  17) q <= 3'b010;
      end
      4'b1101 : begin
        if      (p >= -19 && p <= -11) q <= 3'b110; 
        else if (p >= -10 && p <=  -4) q <= 3'b101;
        else if (p >=  -4 && p <=   3) q <= 3'b000;
        else if (p >=   3 && p <=   9) q <= 3'b001;
        else if (p >=  10 && p <=  18) q <= 3'b010;
      end
      4'b1110 : begin
        if      (p >= -20 && p <= -11) q <= 3'b110; 
        else if (p >= -11 && p <=  -4) q <= 3'b101;
        else if (p >=  -4 && p <=   3) q <= 3'b000;
        else if (p >=   3 && p <=   9) q <= 3'b001;
        else if (p >=  10 && p <=  18) q <= 3'b010;
      end	 
      4'b1111 : begin
        if      (p >= -22 && p <= -12) q <= 3'b110; 
        else if (p >= -12 && p <=  -4) q <= 3'b101;
        else if (p >=  -5 && p <=   4) q <= 3'b000;
        else if (p >=   3 && p <=  11) q <= 3'b001;
        else if (p >=  11 && p <=  21) q <= 3'b010;
      end	
      endcase
    
    rq <= rq << 2;
    rq <= rq - q*b;
    Q <= Q + q;
    Q <= Q << 2;
    
    i = i + 1;  
   // end 
  end
end
endmodule


module SRTdiv_tb();
reg CLK;
reg [63:0] DVD, DSR;
wire[63:0] Q, R;

SRTdiv dut(CLK, DVD, DSR, Q, R);
initial
begin
  CLK = 0; DVD=149; DSR=5;
  #1000 $stop;
end 
always #1 CLK = !CLK;
endmodule 




