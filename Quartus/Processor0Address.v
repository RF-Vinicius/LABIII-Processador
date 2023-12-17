// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Sun Dec 17 00:33:37 2023"

module Processor0Address(
	clk,
	reset
);


input wire	clk;
input wire	reset;

wire	[15:0] SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[4:0] SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	[4:0] SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;





Processor	b2v_inst(
	.clk(clk),
	.reset(reset),
	.instruction(SYNTHESIZED_WIRE_0),
	.memory_data_in(SYNTHESIZED_WIRE_1),
	.read_data_enable(SYNTHESIZED_WIRE_7),
	.write_data_enable(SYNTHESIZED_WIRE_6),
	.address_memory_data(SYNTHESIZED_WIRE_3),
	.address_memory_inst(SYNTHESIZED_WIRE_5),
	.memory_data_out(SYNTHESIZED_WIRE_4));


MemoryData	b2v_inst4(
	.wren(SYNTHESIZED_WIRE_2),
	.clock(clk),
	.address(SYNTHESIZED_WIRE_3),
	.data(SYNTHESIZED_WIRE_4),
	.q(SYNTHESIZED_WIRE_1));


MemoryInstruction	b2v_inst6(
	.clock(clk),
	.address(SYNTHESIZED_WIRE_5),
	.q(SYNTHESIZED_WIRE_0));

assign	SYNTHESIZED_WIRE_2 = SYNTHESIZED_WIRE_6 | SYNTHESIZED_WIRE_7;


endmodule
