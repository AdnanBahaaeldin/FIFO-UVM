package FIFO_Reset_Sequence_pkg;
import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;

`include "uvm_macros.svh"

class FIFO_Reset_Sequence extends uvm_sequence #(FIFO_Sequence_Item);
`uvm_object_utils(FIFO_Reset_Sequence)

FIFO_Sequence_Item fifo_sequence_item;

function new (string name = "FIFO_Reset_Sequence");
    super.new(name);
endfunction

task body();

    fifo_sequence_item = FIFO_Sequence_Item::type_id::create("fifo_sequence_item");
    start_item(fifo_sequence_item);
    fifo_sequence_item.rst_n = 0;
    finish_item(fifo_sequence_item);
    fifo_sequence_item.rst_n = 1;
endtask

endclass

endpackage