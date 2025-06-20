package FIFO_ReadWrite_Sequence_pkg;

import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
`include "uvm_macros.svh"

class FIFO_ReadWrite_Sequence extends uvm_sequence #(FIFO_Sequence_Item);
`uvm_object_utils(FIFO_ReadWrite_Sequence)

FIFO_Sequence_Item fifo_sequence_item;


function new (string name = "FIFO_ReadWrite_Sequence");
    super.new(name);
endfunction


task body();
    fifo_sequence_item = FIFO_Sequence_Item::type_id::create("fifo_sequence_item");
    start_item(fifo_sequence_item);
    fifo_sequence_item.rd_en = 1; //Force rd_en to 1
    fifo_sequence_item.wr_en = 1; //Force wr_en to 1
    fifo_sequence_item.data_in = 3; 
    finish_item(fifo_sequence_item);
    
endtask
endclass
endpackage
