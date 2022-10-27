module SRTdiv(CLK, DVD, DSR, Q, R);

input CLK;
input [63:0] DVD, DSR;
output reg [63:0] Q, R;

reg [127:0] rq; //remainder/quotient register
reg [63:0] N = 63;
reg [63:0] c =  0;
reg [63:0] k =  0;
reg [63:0] dsr;

reg [63:0] temp;

integer i;

reg [63:0] out;
reg [57:0] unconnected;
reg [ 3:0] counter;
reg rbit, flag;

always @(posedge CLK)
begin
  rbit <= DSR[N];
  if (!rbit) begin
    N <= N - 1'b1; //locating the first 1'b1
    c <= c + 1'b1; //counter
  end
  
  else begin
    rq[127:0]   <= {DVD[N:0], {c{1'b0}}, {64{1'b0}}}; //shift all reg by c-bits
    dsr  <= {DSR[N:0], {c{1'b0}}};
    temp <= DSR;
	
    while (temp > 0) begin //determine no. of bits of divisor
      temp <= temp >> 1; // shift 1 bit right
      k <= k + 1'b1; // counts number of bits
    end
	
    for (i=0; i < k-1; i = i + 1) begin
      if (rq[127:125] == 3'b000 || rq[127:125] == 3'b111) begin
         rq <= {rq[126:1], 2'b00}; // case a
      end
      else begin
         rq <= {rq[126:0], 1'b1};
	 case (rq[127])
            1'b0 :  begin  //case b
              rq[0] <= -1;
              rq[127:64] <= rq[127:64] + dsr;
            end
            
            1'b1 :  begin  //case c
              rq[0] <= 1;
              rq[127:64] <= rq[127:64] - dsr;		  
            end		  
	 endcase
      end
    end
    
    if(rq[127] == 1'b1) begin
	rq[127:64] <= rq[127:64] + dsr;
	rq[63:0] <= rq[63:0] - 1'b1; 
    end 
  
    rq[127:64] <= {{c{1'b0}}, rq[127:63-c]};
    R <= rq[127:64];
    Q <= rq[63:0];
    
  end
end
endmodule


module SRTdiv_tb();
reg CLK;
reg [63:0] DVD, DSR;
wire[31:0] Q, R;

SRTdiv dut(CLK, DVD, DSR, Q, R);
initial
begin
  CLK = 0; DVD=74; DSR=21;
  #1000 $stop;
end 
always #1 CLK = !CLK;
endmodule 
