onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/uut/clk
add wave -noupdate /testbench/uut/reset
add wave -noupdate -label instruction /testbench/uut/SYNTHESIZED_WIRE_0
add wave -noupdate -label memory_data_in /testbench/uut/SYNTHESIZED_WIRE_1
add wave -noupdate -label wren /testbench/uut/SYNTHESIZED_WIRE_2
add wave -noupdate -label address_memory_data /testbench/uut/SYNTHESIZED_WIRE_3
add wave -noupdate -label memory_data_out /testbench/uut/SYNTHESIZED_WIRE_4
add wave -noupdate -label address_memory_inst /testbench/uut/SYNTHESIZED_WIRE_5
add wave -noupdate -label write_data_enable /testbench/uut/SYNTHESIZED_WIRE_6
add wave -noupdate -label read_data_enable /testbench/uut/SYNTHESIZED_WIRE_7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
