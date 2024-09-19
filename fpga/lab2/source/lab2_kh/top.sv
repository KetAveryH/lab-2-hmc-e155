// Ket Hollingsworth
// khollingsworth@g.hmc.edu
// 9/18/2023
// Summary: TODO

module Hz_blink(input logic reset, output logic [1:0] switch);
	logic int_osc;
	logic [24:0] counter;
	logic first;
	
	// Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	always_ff @(posedge int_osc) begin
	  if(reset == 0 || !first) begin
		  switch <= 2'b01;
		  counter <= 0;
		  first <= 1;
		 end
		 
	  if(counter >= 10_000_000) begin 
		      counter <= 0;
		      switch <= ~switch;
	  end
	  
	  else    counter <= counter + 25'd1;
	end
endmodule

module led_comb(input logic [3:0] s,
			   output logic [1:0] led);

	always_comb
	  case(s[1:0])
		  2'd0: led[0] = 0;
		  2'd1: led[0] = 1;
		  2'd2: led[0] = 1;
		  2'd3: led[0] = 0;
	endcase
	
	always_comb
	  case(s[3:2])
		  2'd0: led[1] = 0;
		  2'd1: led[1] = 0;
		  2'd2: led[1] = 0;
		  2'd3: led[1] = 1;
	endcase
			   
endmodule

module seven_seg_display(input logic [3:0] s,
						 //input logic [1:0] switch,
						 output logic [6:0] seg); 
	always_comb
	  case(s)
		  //		 	     abc defg
		4'h0:		seg = 7'b000_0001;
		4'h1:		seg = 7'b100_1111;
		4'h2:		seg = 7'b001_0010;
		4'h3:		seg = 7'b000_0110;
		4'h4:		seg = 7'b100_1100;
		4'h5:		seg = 7'b010_0100;
		4'h6:		seg = 7'b010_0000;
		4'h7:		seg = 7'b000_1111;
		4'h8:		seg = 7'b000_0000;
		4'h9:		seg = 7'b000_1100;
		4'hA:		seg = 7'b000_1000;
		4'hB:		seg = 7'b110_0000;
		4'hC:		seg = 7'b011_0001;
		4'hD:		seg = 7'b100_0010;
		4'hE:		seg = 7'b011_0000;
		4'hF:		seg = 7'b011_1000;
		default: 	seg = 7'b111_1111;
	endcase
endmodule

module lab1_kh(input logic reset,
			   input logic [3:0] s,
			   output logic [2:0] led,
			   output logic [1:0] switch,
			   output logic [6:0] seg);

	
	Hz_blink u1 (
		.reset(reset),
		.switch(switch[1:0]) // switch alternates between 01 and 10
	);
	
	led_comb u2 (
		.s(s),
		.led(led[1:0])
	);
	
	seven_seg_display u3 (
		.s(s),
		.seg(seg)
		//,
		//.switch(switch)
	);
	
	
	
	
endmodule