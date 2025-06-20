package FIFO_Random_Sequence_pkg;
import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
`include "uvm_macros.svh"

class FIFO_Random_Sequence extends uvm_sequence #(FIFO_Sequence_Item);
`uvm_object_utils(FIFO_Random_Sequence)

FIFO_Sequence_Item fifo_sequence_item;


function new (string name = "FIFO_Random_Sequence");
    super.new(name);
endfunction

task body();

repeat(10000) begin
    fifo_sequence_item = FIFO_Sequence_Item::type_id::create("fifo_sequence_item");

    //Randomize the input variables.
    start_item(fifo_sequence_item);
    assert(fifo_sequence_item.randomize());
    finish_item(fifo_sequence_item);

end

    

endtask

endclass

endpackage