package FIFO_Sequence_Item_pkg;


import uvm_pkg::*;
import FIFO_Shared_pkg::*;
`include "uvm_macros.svh"

class FIFO_Sequence_Item extends uvm_sequence_item;
`uvm_object_utils(FIFO_Sequence_Item)

rand logic [FIFO_WIDTH-1:0] data_in;
rand logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

integer RD_EN_ON_DIST=30,WR_EN_ON_DIST=70;


//Constructor with default values for the rd_en and  Wr_en FIFO signals
function new(string name = "FIFO_Sequence_Item");
    super.new(name);
endfunction


//Reset constraint
constraint rst_nCons{
    rst_n dist {0:=5,1:=95};
}

//Constraint for write enable signal
constraint wr_enCons{
    wr_en dist {
        0:=WR_EN_ON_DIST, 1:=100-WR_EN_ON_DIST
    };
}

//Constraint for read enable signal
constraint rd_enCons{
    rd_en dist {
        0:=RD_EN_ON_DIST, 1:=100-RD_EN_ON_DIST
    };
}


endclass

class FIFO_Sequence_Item_Disable_Reset extends FIFO_Sequence_Item;
`uvm_object_utils(FIFO_Sequence_Item_Disable_Reset)


constraint rst_nCons {
    rst_n == 1;
}

endclass


endpackage