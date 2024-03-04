if {[file exists work]} {
	vdel -lib work -all
}
vlib work
vmap work work

vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/old/PCK_CRC32_D32.vhd
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/old/types_pack_old.vhd
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/old/types_pack.vhd
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/old/test_pack.vhd
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/old/test_pack_2008.vhd
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/ips/synchronizing.vhdl
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/ips/sizing.vhdl
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/ips/memory.vhdl
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/ips/fifos.vhdl
vcom -work work +cover=sbcefx -coversub -2008 -autoorder ../sources_vhdl/l2_network_encryptor.vhd
vcom -work work +cover=sbcefx -coversub -2008 -autoorder test.vhd

vsim -L work -coverenhanced test

do wave.do
