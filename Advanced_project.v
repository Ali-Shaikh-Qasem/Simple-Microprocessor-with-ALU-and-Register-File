 
// Name: Ali Shaikh Qasem, id = 1212171	   

module alu (opcode, a, b, result );
	
    input [5:0]  opcode;  
    input signed [31:0] a, b;      
    output reg signed [31:0] result; 	  
	
	always @(*)
		begin
			case (opcode)
				6'b000110 : result = a + b;	//a+b 
				6'b001000 : result = a - b;	//a-b 	
				6'b001010 : begin 			//|a|
					          if(a >= 0)
								  result = a;
							  else
								  result = -a;	 
						    end
							
				6'b001100 : result = -a; //-a 	
				6'b001110 : begin 		//max(a,b)	
					          if(a > b)
								  result = a;
							  else
								  result = b;
						    end
				
			    6'b001011 : begin 		//min(a,b)	
					          if(a < b)
								  result = a;
							  else
								  result = b; 
						    end
				
				6'b001101 : result = (a + b) / 2; //avg(a,b)				
				6'b001111 : result = ~a;  //not a				
				6'b000010 : result = a | b; // a or b
				6'b000011 : result = a & b;	// a and b
				6'b001001 : result = a ^ b;	// a xor b
				default: result = 32'bx; 	
		 	endcase
	     end
endmodule  

/* ************************************************************************************************************** */

module reg_file (clk, valid_opcode, addr1, addr2, addr3, in , out1, out2);
	
	//defining inputs and outputs
    input clk; 
    input valid_opcode; 
    input [4:0] addr1, addr2, addr3;  
    input [31:0] in;      
    output reg [31:0] out1, out2;
	//definining the register file slots
	reg [31:0] reg_slots [0:31];
	
	//initializing the values in the register file
	initial 
		begin
			reg_slots [0] = 32'h0; reg_slots [1] = 32'h3ABA;  reg_slots [2] = 32'h2296;	 reg_slots [3] = 32'hAA;
			reg_slots [4] = 32'h1C3A; reg_slots [5] = 32'h1180;	reg_slots [6] = 32'h22E0;  reg_slots [7] = 32'h1C86;  
			reg_slots [8] = 32'h22DA; reg_slots [9] = 32'h414; reg_slots [10] = 32'h1A32; reg_slots [11] = 32'h102;
			reg_slots [12] = 32'h1CBA; reg_slots [13] = 32'hCDE; reg_slots [14] = 32'h3994; reg_slots [15] = 32'h1984;
			reg_slots [16] = 32'h28C4; reg_slots [17] = 32'h2E7C; reg_slots [18] = 32'h3966; reg_slots [19] = 32'h227E;
			reg_slots [20] = 32'h2208; reg_slots [21] = 32'h11B4; reg_slots [22] = 32'h237C; reg_slots [23] = 32'h360E;
			reg_slots [24] = 32'h2722; reg_slots [25] = 32'h500; reg_slots [26] = 32'h16B6; reg_slots [27] = 32'h29E;
			reg_slots [28] = 32'h2280; reg_slots [29] = 32'h3B52; reg_slots [30] = 32'h11A0; reg_slots [31] = 32'h0;	
		end	
	
	always @ (posedge clk) 
		begin
			if(valid_opcode)
				begin
					out1 <= reg_slots [addr1];
					out2 <= reg_slots [addr2]; 
					reg_slots [addr3] <= in;
				end
		end
endmodule 
 
/* ************************************************************************************************************** */

module mp_top (clk, instruction , result ); 
	
	input clk; 
    input [31:0] instruction;       
    output signed [31:0] result;	
	wire valid_opcode_result;
	wire [31:0] out1,out2; 
	
	//defining the registers that hold the instruction and the opcode
	reg [31:0] reg_32_out;
	reg [5:0] opcode;
	
	//clocking the instruction register and opcode, this is to ensure the opcode reaches the alu with the register values.
	always @(posedge clk) 
		begin
		  reg_32_out <= instruction;
		  opcode <= reg_32_out [5:0];  
		end 
	
	// instantiate the required modules
	valid_opcode v1 ( reg_32_out [5:0], valid_opcode_result);	
	reg_file rg1 (clk, valid_opcode_result, reg_32_out [10:6] , reg_32_out [15:11], reg_32_out [20:16], result , out1, out2);
	alu a1 (opcode, out1, out2, result );	
	
	task valid_opcode ;	// defining a task to check if the provided opcode is valid or not
	   input opcode;
	   output reg valid; 
	   
	   //checking if the opcode is valid based on my id corresponding opcodes
	   if(opcode==6 || opcode== 8 ||opcode==10||opcode==12 || opcode==14 || opcode==11 || opcode==13 || opcode==15 || opcode==2 || opcode==3 || opcode== 9)
				valid = 1;
			else
				valid = 0;	 
	endtask
	
endmodule 

/* ************************************************************************************************************* */

module mp_test ();
	
	reg [31:0] instruction;
	reg clk;
	wire signed [31:0] result;	
	// definig the array of instructions, it includes 11 instructions, that means an instruction for every opcode.
	reg [31:0] instructions [0:10]	= '{32'h00142006, 32'h001508C8, 32'h0016054A, 32'h0017014C, 32'h0018398E, 32'h00192B4B,
	32'h001A7B8D, 32'h001B044F, 32'h00281842, 32'h001D4B03, 32'h001E9089};	
	// defining the array pf expected values for the written instructions
	reg [31:0] expected_values [0:10] = '{32'h1C3A, 32'hFFFFC5F0, 32'h3A10, 32'hFFFFEE80, 32'h22E0, 32'h0CDE, 32'h298C, 32'hFFFFD183,
	32'h3ABA, 32'h0410, 32'h1BF0};
	
	int flag = 0;  // 0 means pass and 1 means fail.
	
	
	mp_top m1 (clk, instruction , result );
	
	initial
		begin 
			$display("   Instruction        Result       status ");
			$display("   -------------------------------------------");
			
			clk = 0;
			instruction = instructions[0];
			#20ns // to execute the first instruction
			if(result == expected_values[0])
			    $display("   0x%0h           %0d          pass ", instruction, result);
			else
				begin
					$display(" 0x%0h         %0d          fail ", instruction, result);
					flag = 1;
				end
							
			for(int i=1 ; i<=10 ; i=i+1)
				begin 
					instruction = instructions[i]; 	
					#35ns; // 3 cycles, two for executing the instruction and one for storing the result in the destination	
					if(result == expected_values[i])
					   $display("   0x%0h           %0d          pass ", instruction, result);	
					else
						begin
							$display("   0x%0h           %0d          fail ", instruction, result);
							flag = 1;
						end
					
				end	
			// determine if the test fails or passes	
			if(flag == 1)
				$display("The test fails");
			else
				$display("The test passes");
						
		end
		
		
	always #5ns
		clk = ~clk;
		
endmodule
	
	