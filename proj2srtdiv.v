module Carson_Castro_Kempis_Proj2(clk, quo, rem); 
  
  input clk;
  output reg signed[64:0] quo;
  output reg[63:0] rem;
  
  // dvd = Dividend; dvd = Divisor
  
  reg[63:0] dvd, dvd, dvs_t;
  reg[3:0] shift_dvs;
  reg signed[64:0] P, dvs_t_signed;
  reg[5:0] n;
  reg signed[2:0] qb;
  reg signed[5:0] p_test; 

  integer init_shift;

  reg[128:0] add_Pdvd;
  
  initial
  begin
    init_shift = 0;
    n = 0;
  end
  
  always @ (posedge clk & n <= 32)
  begin

    if(n == 0)
    begin
      P = 0;
      dvd = 64'd987; // assign dividend
      dvs = 64'd6; // assign divisor
      
      dvs_t = dvd;
      quo = 0;
		  rem = 0;
      add_Pdvd = {P[64:0],dvd[63:0]};
      
      while(!dvs_t[63])
      begin
		    dvs_t = dvs_t << 1;
		    init_shift = init_shift + 1;
      end
      

      dvs_t_signed = {1'b0,dvs_t[63:0]};
      shift_dvs = dvs_t[63:60];
      add_Pdvd = add_Pdvd << init_shift;
      P = add_Pdvd[128:64];
      dvd = add_Pdvd[63:0];
      n = n + 1; 
    end
    
    
    else if(n==32)
    begin
    
      if(P[64])
      begin
        P = P + dvs_t;
        quo = quo - 1;    
      end
    
      
      P = {P[62:0], dvd[63:62]};
      P = P >> init_shift;
      rem = P[63:0];
      
      if(rem > dvd)
      begin
        quo = quo + 1;
        rem = rem - dvd;  
      end
    
    end
    
    else
    begin
    // Look-Up Table
    qb = 0;
    p_test = P[64:59];
    
    case(shift_dvs)
	  4'b1000:
	  begin
	    if(p_test>=-12 && p_test<=-7) qb=3'b110;
	    else if(p_test>=-6 && p_test<=-3) qb=3'b111;
	    else if(p_test>=-2 && p_test<=1) qb=3'b000;
	    else if(p_test>=2 && p_test<=5) qb=3'b001;
	    else if(p_test>=6 && p_test<=11) qb=3'b010;
	  end

	  4'b1001:
	  begin
		if(p_test>=-14 && p_test<=-8) qb=3'b110;
		else if(p_test>=-7 && p_test<=-3) qb=3'b111;
		else if(p_test>=-3 && p_test<=2) qb=3'b000;
		else if(p_test>=2 && p_test<=6) qb=3'b001;
		else if(p_test>=7 && p_test<=13) qb=3'b010;
	  end

	  4'b1010:
	  begin
		if(p_test>=-15 && p_test<=-9) qb=3'b110;
		else if(p_test>=-8 && p_test<=-3) qb=3'b111;
		else if(p_test>=-3 && p_test<=2) qb=3'b000;
		else if(p_test>=2 && p_test<=7) qb=3'b001;
		else if(p_test>=8 && p_test<=14) qb=3'b010;
	  end

	  4'b1011:
	  begin
		if(p_test>=-16 && p_test<=-9) qb=3'b110;
		else if(p_test>=-9 && p_test<=-3) qb=3'b111;
		else if(p_test>=-3 && p_test<=2) qb=3'b000;
		else if(p_test>=2 && p_test<=8) qb=3'b001;
		else if(p_test>=8 && p_test<=15) qb=3'b010;
	  end

	  4'b1100:
	  begin
		if(p_test>=-18 && p_test<=-10) qb=3'b110;
		else if(p_test>=-10 && p_test<=-4) qb=3'b111;
		else if(p_test>=-4 && p_test<=3) qb=3'b000;
		else if(p_test>=3 && p_test<=9) qb=3'b001;
		else if(p_test>=9 && p_test<=17) qb=3'b010;
	  end

	  4'b1101:
	  begin
		if(p_test>=-19 && p_test<=-11) qb=3'b110;
		else if(p_test>=-10 && p_test<=-4) qb=3'b111;
		else if(p_test>=-4 && p_test<=3) qb=3'b000;
		else if(p_test>=3 && p_test<=9) qb=3'b001;
		else if(p_test>=10 && p_test<=18) qb=3'b010;
	  end

	  4'b1110:
	  begin
		if(p_test>=-20 && p_test<=-11) qb=3'b110;
		else if(p_test>=-11 && p_test<=-4) qb=3'b111;
		else if(p_test>=-4 && p_test<=3) qb=3'b000;
		else if(p_test>=3 && p_test<=10) qb=3'b001;
		else if(p_test>=10 && p_test<=19) qb=3'b010;
	  end

	  4'b1111:
	  begin
		if(p_test>=-22 && p_test<=-12) qb=3'b110;
		else if(p_test>=-12 && p_test<=-4) qb=3'b111;
		else if(p_test>=-5 && p_test<=4) qb=3'b000;
		else if(p_test>=3 && p_test<=11) qb=3'b001;
		else if(p_test>=11 && p_test<=21) qb=3'b010;
	  end

	endcase
    P = {P[62:0], dvd[63:62]};
    P = P - qb*dvs_t_signed;
    quo = quo + qb;
    dvd = dvd << 2;
    quo = quo << 2;
    n = n + 1;
    end
  end
  
endmodule  

// Test bench
module tb_srtDiv;  
  reg clk;  
  wire [63:0] quo, rem;
  Carson_Castro_Kempis_Proj2 uut (  
    .clk(clk),   
    .quo(quo),   
    .rem(rem)  
  );  
  initial begin  
	   clk = 0;  
	   forever #10 clk = ~clk;  
  end  
endmodule  
