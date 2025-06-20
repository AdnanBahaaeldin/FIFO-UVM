import FIFO_Sequence_Item_pkg::*;
import FIFO_Shared_pkg::*;
import uvm_pkg::*;
module FIFO_Assertions(FIFO_IF.DUT fifo_if);


//Assertions to check FIFO functionality

property reset_check;
@(posedge fifo_if.clk) 
(!fifo_if.rst_n) |=> ((dut.rd_ptr == 1'b0) && (dut.wr_ptr  == 1'b0) && (dut.count == 1'b0) && (fifo_if.wr_ack == 0) && (fifo_if.overflow == 0));
endproperty

check_reset_assertion:assert property (reset_check) else $error("Assertion reset_check failed!");
cover property (reset_check);

property fifo_write_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
((fifo_if.wr_en==1'b1) && (fifo_if.full == 1'b0)) |=> (fifo_if.wr_ack == 1'b1);
endproperty

check_fifo_write_assertion: assert property (fifo_write_check) else $error("Assertion fifo_write_check failed!");
cover property (fifo_write_check);

property fifo_overflow_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
((fifo_if.wr_en == 1'b1) && (fifo_if.full == 1'b1)) |=> (fifo_if.overflow == 1'b1);
endproperty

check_fifo_overflow_assertion: assert property (fifo_overflow_check) else $error("Assertion fifo_overflow_check failed!");
cover property (fifo_overflow_check);

property fifo_underflow_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
((fifo_if.rd_en == 1'b1) && (fifo_if.empty == 1'b1)) |-> (fifo_if.underflow == 1'b1);
endproperty

check_fifo_underflow_assertion: assert property (fifo_underflow_check) else $error("Assertion fifo_underflow_check failed!");
cover property (fifo_underflow_check);


property fifo_empty_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
(dut.count == 0) |-> (fifo_if.empty == 1'b1);
endproperty

check_fifo_empty_assertion: assert property (fifo_empty_check) else $error("Assertion fifo_empty_check failed!");
cover property (fifo_empty_check);


property fifo_full_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
(dut.count == FIFO_DEPTH) |-> (fifo_if.full == 1'b1);
endproperty

check_fifo_full_assertion: assert property (fifo_full_check) else $error("Assertion fifo_full_check failed!");
cover property (fifo_full_check);


property fifo_almostfull_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
(dut.count == FIFO_DEPTH-1) |-> (fifo_if.almostfull == 1'b1);
endproperty

check_fifo_almostfull_assertion: assert property (fifo_almostfull_check) else $error("Assertion fifo_almostfull_check failed!");
cover property (fifo_almostfull_check);


property fifo_almostempty_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
(dut.count == 1) |-> (fifo_if.almostempty == 1'b1);
endproperty

check_fifo_almostempty_assertion: assert property (fifo_almostempty_check) else $error("Assertion fifo_almostempty_check failed!");
cover property (fifo_almostempty_check);


property read_ptr_wraparound_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
((dut.rd_ptr == (FIFO_DEPTH-1)) && (fifo_if.rd_en == 1'b1) && (fifo_if.empty == 1'b0)) |=> (dut.rd_ptr == 0);
endproperty

check_read_ptr_wraparound_assertion: assert property (read_ptr_wraparound_check) else $error("Assertion read_ptr_wraparound_check failed!");
cover property (read_ptr_wraparound_check);


property write_ptr_wraparound_check;
@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
((dut.wr_ptr == (FIFO_DEPTH-1)) && (fifo_if.wr_en == 1'b1) && (fifo_if.full == 1'b0)) |=> (dut.wr_ptr == 0);
endproperty

check_write_ptr_wraparound_assertion: assert property (write_ptr_wraparound_check) else $error("Assertion write_ptr_wraparound_check failed!");
cover property (write_ptr_wraparound_check);


property count_wraparound_check;
@(posedge fifo_if.clk)
((fifo_if.rst_n == 1'b0) && ($past(fifo_if.rst_n) == 1'b1) && ($past(dut.count) == 8)) |=> dut.count == 0;
endproperty

check_count_wraparound_assertion: assert property (count_wraparound_check) else $error("Assertion count_wraparound_check failed!");
cover property (count_wraparound_check);


property fifo_ptr_check;
@(posedge fifo_if.clk)
((dut.rd_ptr < FIFO_DEPTH) && (dut.wr_ptr < FIFO_DEPTH));
endproperty

check_fifo_ptr_assertion: assert property (fifo_ptr_check) else $error("Assertion fifo_ptr_check failed!");
cover property (fifo_ptr_check);

endmodule