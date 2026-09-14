transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/kt336/Desktop/ece\ 550/alu {C:/Users/kt336/Desktop/ece 550/alu/cla_32bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/kt336/Desktop/ece\ 550/alu {C:/Users/kt336/Desktop/ece 550/alu/cla_16bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/kt336/Desktop/ece\ 550/alu {C:/Users/kt336/Desktop/ece 550/alu/cla_4bit.v}
vlog -vlog01compat -work work +incdir+C:/Users/kt336/Desktop/ece\ 550/alu {C:/Users/kt336/Desktop/ece 550/alu/alu.v}

vlog -vlog01compat -work work +incdir+C:/Users/kt336/Desktop/ece\ 550/alu {C:/Users/kt336/Desktop/ece 550/alu/alu_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  alu_tb

add wave *
view structure
view signals
run -all
