package FIFO_Directed_Sequence_pkg;
import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
`include "uvm_macros.svh"

class FIFO_Directed_Sequence extends uvm_sequence #(FIFO_Sequence_Item);
`uvm_object_utils(FIFO_Directed_Sequence)

FIFO_Sequence_Item fifo_sequence_item;


function new (string name = "FIFO_Directed_Sequence");
    super.new(name);
endfunction

task body();

    fifo_sequence_item = FIFO_Sequence_Item::type_id::create("fifo_sequence_item");
    start_item(fifo_sequence_item);
   
    //Needed to achieve 100% code coverage and functional coverage
    fifo_sequence_item.wr_en = 0; //Force wr_en to 0
    fifo_sequence_item.rd_en = 0;
    fifo_sequence_item.rst_n = 1;

    finish_item(fifo_sequence_item);

endtask

endclass

endpackage