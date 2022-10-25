module SRTdiv (CLK, DVD, DSR, Q, R);

input CLK;
input [63:0] DVD, DSR;
output reg [31:0] Q, R;

reg [63:0] rq;
reg [63:0] out;
reg [ 5:0] dsr;
reg [57:0] unconnected;
reg [ 3:0] counter;
reg flag;


always @(posedge CLK)
begin
  rq <= out[63:0];
  R  <= out[63:32];
  Q  <= out[31:0];
  if (counter == 0) begin
    //initialization of values
      out <= DVD;
      dsr <= {unconnected, DSR};
      counter <= counter + 1;
      flag <= 0;
  end
  else begin
    //Shift Left R/Q
      {out} <= {out[62:0], 1'b0};
    //RQ = RQ-Div
      rq <= rq - dsr;
    if (rq[0] == 0) begin
      out[0] <= 1;
    end
    if (counter == 6) begin
      flag <= 1;
      counter <= 0;
    end  
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
  #500 $stop;
end 
always #1 CLK = !CLK;
endmodule 
