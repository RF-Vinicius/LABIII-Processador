`timescale 1ns/1ns
module TestBench;

reg	clock;
reg	reset;
wire	[4:0] a_rom;
wire	clock_rom;
wire	wren;
wire	[4:0] a_ram;
wire	clock_ram;
wire	[5:0] i;
wire	[7:0] q_rom;
wire	[7:0] q_ram;

TesteMemo DUV (.clock(clock),.reset(reset),.a_rom(a_rom),.clock_rom(clock_rom),.wren(wren),.a_ram(a_ram),.clock_ram(clock_ram),.i(i),.q_rom(q_rom),.q_ram(q_ram));

always #100 clock = !clock;

initial
begin
	$monitor("tempo = %t clock = %b reset = %b wren = %b clock_ram = %b clock_rom = %b a_ram = %d a_rom = %d i = %d q_ram = %d q_rom = %d", $time, clock, reset, wren, clock_ram, clock_rom, a_ram, a_rom, i, q_ram, q_rom);
	clock = 0;
	reset = 0;
	# 50 reset = 1;
	# 100 reset = 0;
	# 60000 $stop;
end

parameter	Inicio = 4'b0000,
		Config_enderecos = 4'b0001,
		Ler_ROM = 4'b0010,
		Escrever_RAM = 4'b0011,
		Decrementar_i = 4'b0100,
		Config_RAM = 4'b0101,
		Ler_RAM = 4'b0110,
		Incrementar_i = 4'b0111,
		Encerrar = 4'b1000;

reg [16*8:1] Estado;

always @ (DUV.b2v_inst.estado_atual)
begin
	case (DUV.b2v_inst.estado_atual)
		Inicio: Estado = "Inicio";
		Config_enderecos: Estado = "Config_enderecos";
		Ler_ROM: Estado = "Ler_ROM";
		Escrever_RAM: Estado = "Escrever_RAM";
		Decrementar_i: Estado = "Decrementar_i";
		Config_RAM: Estado = "Config_RAM";
		Ler_RAM: Estado = "Ler_RAM";
		Incrementar_i: Estado = "Incrementar_i";
		Encerrar: Estado = "Encerrar";
	endcase
end

endmodule 