package FIFO_Monitor_pkg;

import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
`include "uvm_macros.svh"

class FIFO_Monitor extends uvm_monitor;
    `uvm_component_utils(FIFO_Monitor)
    virtual FIFO_IF fifo_if;
    FIFO_Sequence_Item fifo_sequence_item;
    uvm_analysis_port #(FIFO_Sequence_Item) mon_ap;

function new (string name = "FIFO_Monitor", uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap",this);
endfunction


task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        fifo_sequence_item = FIFO_Sequence_Item::type_id::create("fifo_sequence_item");
        @(negedge fifo_if.clk);
        fifo_sequence_item.data_in = fifo_if.data_in;
        fifo_sequence_item.rst_n = fifo_if.rst_n;
        fifo_sequence_item.wr_en = fifo_if.wr_en;
        fifo_sequence_item.rd_en = fifo_if.rd_en;
        fifo_sequence_item.data_out = fifo_if.data_out; 
        fifo_sequence_item.wr_ack = fifo_if.wr_ack; 
        fifo_sequence_item.full = fifo_if.full; 
        fifo_sequence_item.empty = fifo_if.empty; 
        fifo_sequence_item.almostfull = fifo_if.almostfull;
        fifo_sequence_item.almostempty = fifo_if.almostempty; 
        fifo_sequence_item.underflow = fifo_if.underflow; 
        fifo_sequence_item.overflow = fifo_if.overflow; 
        mon_ap.write(fifo_sequence_item);
        `uvm_info("run_phase",fifo_sequence_item.convert2string(),UVM_MEDIUM);
    end
endtask


endclass

endpackage