vlib work
vlog -f src_files.list +cover
vsim -sv_seed random -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
coverage save FIFO_Top.ucdb -onexit

run 0

add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/error_count 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/correct_count 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/count_ref 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/rd_ptr_ref 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/wr_ptr_ref 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/mem_ref 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/overflow_ref 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/wr_ack_ref 
add wave /uvm_root/uvm_test_top/fifo_env/scoreboard/data_out_ref

add wave /top/fifo_if/*

add wave /top/dut/*
add wave /top/dut/mem

run -all

