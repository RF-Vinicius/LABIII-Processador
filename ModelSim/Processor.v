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
// CREATED		"Sun Dec 17 00:22:36 2023"

module Processor(
	clk,
	reset,
	instruction,
	memory_data_in,
	read_data_enable,
	write_data_enable,
	address_memory_data,
	address_memory_inst,
	memory_data_out
);


input wire	clk;
input wire	reset;
input wire	[15:0] instruction;
input wire	[15:0] memory_data_in;
output wire	read_data_enable;
output wire	write_data_enable;
output wire	[4:0] address_memory_data;
output wire	[4:0] address_memory_inst;
output wire	[15:0] memory_data_out;

wire	[4:0] SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;
wire	[15:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	[15:0] SYNTHESIZED_WIRE_7;
wire	[15:0] SYNTHESIZED_WIRE_8;
wire	[15:0] SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	[15:0] SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	[15:0] SYNTHESIZED_WIRE_15;





alu	b2v_Alu(
	.op_code(SYNTHESIZED_WIRE_0),
	.operand_a(SYNTHESIZED_WIRE_1),
	.operand_b(SYNTHESIZED_WIRE_2),
	.result(SYNTHESIZED_WIRE_7));
	defparam	b2v_Alu.WIDTH_DATA = 16;


cpu	b2v_inst(
	.clk(clk),
	.reset(reset),
	.stack_full_operations(SYNTHESIZED_WIRE_3),
	.stack_empty_operations(SYNTHESIZED_WIRE_4),
	.stack_full_subroutines(SYNTHESIZED_WIRE_5),
	.stack_empty_subroutines(SYNTHESIZED_WIRE_6),
	.instruction(instruction),
	.memory_data_in(memory_data_in),
	.result_alu(SYNTHESIZED_WIRE_7),
	.stack_data_out_operations(SYNTHESIZED_WIRE_8),
	.stack_data_out_subroutines(SYNTHESIZED_WIRE_9),
	.read_data_enable(read_data_enable),
	.write_data_enable(write_data_enable),
	.stack_push_operations(SYNTHESIZED_WIRE_10),
	.stack_pop_operations(SYNTHESIZED_WIRE_11),
	.stack_push_subroutines(SYNTHESIZED_WIRE_13),
	.stack_pop_subroutines(SYNTHESIZED_WIRE_14),
	.address_memory_data(address_memory_data),
	.address_memory_inst(address_memory_inst),
	.memory_data_out(memory_data_out),
	.op_ALU(SYNTHESIZED_WIRE_0),
	.operand_a(SYNTHESIZED_WIRE_1),
	.operand_b(SYNTHESIZED_WIRE_2),
	.stack_data_in_operations(SYNTHESIZED_WIRE_12),
	.stack_data_in_subroutines(SYNTHESIZED_WIRE_15));
	defparam	b2v_inst.AWIDTH = 5;
	defparam	b2v_inst.WIDTH_DATA = 16;


stack	b2v_stack_operations(
	.clk(clk),
	.reset(reset),
	.push(SYNTHESIZED_WIRE_10),
	.pop(SYNTHESIZED_WIRE_11),
	.data_in(SYNTHESIZED_WIRE_12),
	.full(SYNTHESIZED_WIRE_3),
	.empty(SYNTHESIZED_WIRE_4),
	.data_out(SYNTHESIZED_WIRE_8));
	defparam	b2v_stack_operations.DEPTH = 10;
	defparam	b2v_stack_operations.WIDTH_DATA = 16;


stack	b2v_stack_subroutines(
	.clk(clk),
	.reset(reset),
	.push(SYNTHESIZED_WIRE_13),
	.pop(SYNTHESIZED_WIRE_14),
	.data_in(SYNTHESIZED_WIRE_15),
	.full(SYNTHESIZED_WIRE_5),
	.empty(SYNTHESIZED_WIRE_6),
	.data_out(SYNTHESIZED_WIRE_9));
	defparam	b2v_stack_subroutines.DEPTH = 10;
	defparam	b2v_stack_subroutines.WIDTH_DATA = 16;


endmodule
