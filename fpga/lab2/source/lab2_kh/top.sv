// Ket Hollingsworth
// khollingsworth@g.hmc.edu
// 9/18/2023
// Summary: TODO

module Hz_blink(input logic reset, output logic [1:0] display_select_c, output logic int_osc);
	//logic int_osc;
	logic [24:0] counter;
	logic switch;
	logic [1:0] display_select;
	
	// Internal high-speed oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	always_ff @(posedge int_osc) begin
	  if(reset == 0) begin
		  switch <= 0;
		  counter <= 0;
		 end
		 
	  if(counter >= 150_000) begin 
		      counter <= 0;
		      switch <= ~switch;
	  end else    
		  counter <= counter + 25'd1;
		  
	  if (switch == 0) 
		  display_select <= 2'b01;
	  else 
		  display_select <= 2'b10;
	end
	
	assign display_select_c = display_select;
	
endmodule

module led_comb(input logic [3:0] s1,
				input logic [3:0] s2,
			   output logic [4:0] led);

	logic [4:0] s3;
	
	always_comb begin
		s3 = s1 + s2;
	end

	assign led = s3;

	//always_comb
	  //case(s1[1:0])
		  //2'd0: led[0] = 0;
		  //2'd1: led[0] = 1;
		  //2'd2: led[0] = 1;
		  //2'd3: led[0] = 0;
	//endcase
	
	//always_comb
	  //case(s1[3:2])
		  //2'd0: led[1] = 0;
		  //2'd1: led[1] = 0;
		  //2'd2: led[1] = 0;
		  //2'd3: led[1] = 1;
	//endcase
			   
endmodule

module seven_seg_display(input logic  [3:0] s1,
						 input logic  [3:0] s2,
						 input logic  [1:0] display_select_c,
						 input logic       int_osc,
						 output logic [6:0] seg); 
	logic [3:0] s_select;
	
	always_ff @(posedge int_osc) begin
		if (display_select_c[1]) 
			s_select <= s1;
		else
			s_select <= s2;
	end
		
	always_comb
	  case(s_select)
		  //		 	     abc defg
		4'h00:		seg = 7'b000_0001;
		4'h01:		seg = 7'b100_1111;
		4'h02:		seg = 7'b001_0010;
		4'h03:		seg = 7'b000_0110;
		4'h04:		seg = 7'b100_1100;
		4'h05:		seg = 7'b010_0100;
		4'h06:		seg = 7'b010_0000;
		4'h07:		seg = 7'b000_1111;
		4'h08:		seg = 7'b000_0000;
		4'h09:		seg = 7'b000_1100;
		4'h0A:		seg = 7'b000_1000;
		4'h0B:		seg = 7'b110_0000;
		4'h0C:		seg = 7'b011_0001;
		4'h0D:		seg = 7'b100_0010;
		4'h0E:		seg = 7'b011_0000;
		4'h0F:		seg = 7'b011_1000;
		default: 	seg = 7'b111_1111;
		
	endcase
endmodule

module lab2_kh(input logic reset,
			   input  logic [3:0] s1,
			   //input  logic [3:0] s2,
			   output logic [3:0] led,
			   output logic [1:0] display_select_c,
			   output logic [6:0] seg);
	logic int_osc;
	logic [3:0] s2 = 4'b0001;

	
	
	Hz_blink u1 (
		.reset(reset),
		.display_select_c(display_select_c), // switch alternates between 01 and 10
		.int_osc(int_osc)
	);
	
	led_comb u2 (
		.s1(s1),
		.s2(s2),
		.led(led[3:0])
	);
	
	seven_seg_display u3 (
		.s1(s1),
		.s2(s2),
		.display_select_c(display_select_c),
		.seg(seg),
		.int_osc(int_osc)
	);
	
	
	
	
endmodule