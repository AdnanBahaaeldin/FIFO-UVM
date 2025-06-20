package FIFO_Coverage_pkg;

import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
`include "uvm_macros.svh"

class FIFO_Coverage extends uvm_component;
`uvm_component_utils(FIFO_Coverage)
uvm_analysis_export #(FIFO_Sequence_Item) cov_export;

uvm_tlm_analysis_fifo #(FIFO_Sequence_Item) cov_fifo;
FIFO_Sequence_Item fifo_sequence_item;



covergroup cover_group;

    //Create cover point for each control signal of the FIFO
    WRITE_ENABLE: coverpoint fifo_sequence_item.wr_en {}
    READ_ENABLE: coverpoint fifo_sequence_item.rd_en {}
    WRITE_ACK: coverpoint fifo_sequence_item.wr_ack {}
    OVERFLOW: coverpoint fifo_sequence_item.overflow {}
    UNDERFLOW: coverpoint fifo_sequence_item.underflow {}
    FULL: coverpoint fifo_sequence_item.full {}
    EMPTY: coverpoint fifo_sequence_item.empty {}
    ALMOSTFULL: coverpoint fifo_sequence_item.almostfull {}
    ALMOSTEMPTY: coverpoint fifo_sequence_item.almostempty {}
   
    
    //Cross covergroup between write, read and different output signals 
    WRITE_READ_ACK_CROSS: cross WRITE_ENABLE, READ_ENABLE, WRITE_ACK {}

    WRITE_READ_OVERFLOW_CROSS: cross WRITE_ENABLE, READ_ENABLE, OVERFLOW {
        ignore_bins bins_ignore1 = binsof(WRITE_ENABLE) intersect {0} && binsof(READ_ENABLE) intersect {0}
        && binsof(OVERFLOW) intersect{1};

        ignore_bins bins_ignore2 = binsof(WRITE_ENABLE) intersect {0} && binsof(READ_ENABLE) intersect {1}
        && binsof(OVERFLOW) intersect{1};
    }

    WRITE_READ_UNDERFLOW_CROSS: cross WRITE_ENABLE, READ_ENABLE, UNDERFLOW {

        ignore_bins bins_ignore1 = binsof(WRITE_ENABLE) intersect {0} && binsof(READ_ENABLE) intersect {0}
        && binsof(UNDERFLOW) intersect{1};

        ignore_bins bins_ignore2 = binsof(WRITE_ENABLE) intersect {1} && binsof(READ_ENABLE) intersect {0}
        && binsof(UNDERFLOW) intersect{1};
    }

    WRITE_READ_FULL_CROSS: cross WRITE_ENABLE, READ_ENABLE, FULL {

        ignore_bins bins_ignore1 = binsof(WRITE_ENABLE) intersect {0} && binsof(READ_ENABLE) intersect {1}
        && binsof(FULL) intersect{1};

        ignore_bins bins_ignore2 = binsof(WRITE_ENABLE) intersect {1} && binsof(READ_ENABLE) intersect {1}
        && binsof(FULL) intersect{1};
    }

    WRITE_READ_EMPTY_CROSS: cross WRITE_ENABLE, READ_ENABLE, EMPTY {}

    WRITE_READ_ALMOSTFULL_CROSS: cross WRITE_ENABLE, READ_ENABLE, ALMOSTFULL {
        ignore_bins bins_ignore1 = binsof(WRITE_ENABLE) intersect {0} && binsof(READ_ENABLE) intersect {0}
        && binsof(ALMOSTFULL) intersect{1};

        ignore_bins bins_ignore2 = binsof(WRITE_ENABLE) intersect {0} && binsof(READ_ENABLE) intersect {1}
        && binsof(ALMOSTFULL) intersect{1};
    }

    WRITE_READ_ALMOSTEMPTY_CROSS: cross WRITE_ENABLE, READ_ENABLE, ALMOSTEMPTY {}

endgroup

function new (string name = "FIFO_Coverage", uvm_component parent = null);
    super.new(name,parent);
    cover_group = new();
endfunction


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
       cov_fifo.get(fifo_sequence_item); // Get the sequence item from the FIFO
       cover_group.sample();
    end
endtask

endclass
endpackage