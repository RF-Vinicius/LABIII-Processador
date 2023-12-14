`timescale 1ns/1ns
module TestBench_2;

reg	clock;
reg	reset;
wire	wren;
wire	clock_ram;
wire	clock_rom;
wire	[4:0] a_ram;
wire	[4:0] a_rom;
wire	[5:0] i;
wire	[7:0] q_ram;
wire	[7:0] q_rom;

TesteMemo DUV (.clock(clock),.reset(reset),.wren(wren),.clock_ram(clock_ram),.clock_rom(clock_rom),.a_ram(a_ram),.a_rom(a_rom),.i(i),.q_ram(q_ram),.q_rom(q_rom));

reg	[7:0] memoria_ram [0:31];
reg	[7:0] memoria_rom [0:31];
integer escritas;

always #100 clock = !clock;

initial
begin
	//$monitor("tempo = %t clock = %b reset = %b wren = %b clock_ram = %b clock_rom = %b a_ram = %d a_rom = %d i = %d q_ram = %d q_rom = %d", $time, clock, reset, wren, clock_ram, clock_rom, a_ram, a_rom, i, q_ram, q_rom);
	clock = 0;
	reset = 0;
	# 50 reset = 1;
	# 100 reset = 0;
	Clonar_ROM;
	Clonar_RAM;
	if (Compara_Memos(1) == 1)
		$display("\n------------ Sucesso !!! Fui aprovado !!! ------------\n");
	else
		$display("\n------------ Acho que vou ter que refazer esta disciplina... ------------\n");
	# 100 $stop;
end

initial
begin
	# 60000 $display("\n------------ Alguma coisa deu errado, como sempre ------------\n");
	$stop;
end

initial
begin
	escritas = 0;
	repeat (40)
	begin
		@(posedge wren)
		escritas = escritas + 1;
		if (escritas > 32)
		begin
			$display("\n------------ Loop em escritas ------------\n");
			$stop;
		end
	end
end

task Clonar_ROM;
begin
	repeat (32)
	begin
		@(posedge clock_rom);
		# 50;
		memoria_rom[a_rom] = q_rom;
	end
end
endtask

task Clonar_RAM;
begin
	@(negedge wren);
	repeat (32)
	begin
		@(posedge clock_ram);
		# 50;
		memoria_ram[a_ram] = q_ram;
	end
end
endtask

function Compara_Memos;
input reg entrada;
integer j;
begin
	Compara_Memos = 1;
	for (j = 0; j < 32; j = j + 1)
	begin
		if (memoria_ram[j] != memoria_rom[31-j])
			Compara_Memos = 0;
	end
end
endfunction

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