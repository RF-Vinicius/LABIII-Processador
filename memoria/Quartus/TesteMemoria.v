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
// CREATED		"Wed Dec 13 23:45:34 2023"

module TesteMemoria(
	clock,
	reset,
	clock_rom,
	wren,
	clock_ram,
	a_ram,
	a_rom,
	i,
	q_RAM,
	q_ROM
);


input wire	clock;
input wire	reset;
output wire	clock_rom;
output wire	wren;
output wire	clock_ram;
output wire	[4:0] a_ram;
output wire	[4:0] a_rom;
output wire	[5:0] i;
output wire	[7:0] q_RAM;
output wire	[7:0] q_ROM;

wire	SYNTHESIZED_WIRE_0;
wire	[4:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[4:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_5;

assign	clock_rom = SYNTHESIZED_WIRE_0;
assign	wren = SYNTHESIZED_WIRE_2;
assign	clock_ram = SYNTHESIZED_WIRE_3;
assign	a_ram = SYNTHESIZED_WIRE_4;
assign	a_rom = SYNTHESIZED_WIRE_1;
assign	q_ROM = SYNTHESIZED_WIRE_5;




Controlador	b2v_inst(
	.clock(clock),
	.reset(reset),
	.clock_rom(SYNTHESIZED_WIRE_0),
	.wren(SYNTHESIZED_WIRE_2),
	.clock_ram(SYNTHESIZED_WIRE_3),
	.a_ram(SYNTHESIZED_WIRE_4),
	.a_rom(SYNTHESIZED_WIRE_1),
	.i(i));
	defparam	b2v_inst.Config_enderecos = 4'b0001;
	defparam	b2v_inst.Config_RAM = 4'b0101;
	defparam	b2v_inst.Decrementar_i = 4'b0100;
	defparam	b2v_inst.Encerrar = 4'b1000;
	defparam	b2v_inst.Escrever_RAM = 4'b0011;
	defparam	b2v_inst.Incrementar_i = 4'b0111;
	defparam	b2v_inst.Inicio = 4'b0000;
	defparam	b2v_inst.Ler_RAM = 4'b0110;
	defparam	b2v_inst.Ler_ROM = 4'b0010;


ROM	b2v_inst1(
	.clock(SYNTHESIZED_WIRE_0),
	.address(SYNTHESIZED_WIRE_1),
	.q(SYNTHESIZED_WIRE_5));


RAM	b2v_inst2(
	.wren(SYNTHESIZED_WIRE_2),
	.clock(SYNTHESIZED_WIRE_3),
	.address(SYNTHESIZED_WIRE_4),
	.data(SYNTHESIZED_WIRE_5),
	.q(q_RAM));


endmodule
