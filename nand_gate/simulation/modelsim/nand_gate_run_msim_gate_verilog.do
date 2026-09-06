transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {nand_gate_7_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/kt336/Desktop/ece\ 550/nand_gate {C:/Users/kt336/Desktop/ece 550/nand_gate/nand_gate_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  nand_gate_tb

add wave *
view structure
view signals
run -all
