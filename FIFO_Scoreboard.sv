package FIFO_Scoreboard_pkg;

import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
import FIFO_Shared_pkg::*;
`include "uvm_macros.svh"


class FIFO_Scoreboard extends uvm_scoreboard;
`uvm_component_utils(FIFO_Scoreboard)

logic [FIFO_WIDTH-1:0] data_out_ref;
logic wr_ack_ref,overflow_ref;

//Generate the number of bits needed for accessing the entire FIFO memory
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

//FIFO memory array
logic [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];

//Pointers to track the read and write positions in the FIFO
logic [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;

//Count to track the number of elements in the FIFO
logic [max_fifo_addr:0] count_ref;

// Analysis port for the scoreboard
uvm_analysis_export #(FIFO_Sequence_Item) sb_export; 

// FIFO for the scoreboard
uvm_tlm_analysis_fifo #(FIFO_Sequence_Item) sb_fifo; 

int correct_count=0,error_count=0;

FIFO_Sequence_Item fifo_sequence_item;


function new (string name = "FIFO_Scoreboard", uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    sb_fifo = new("sb_fifo", this); // Create the FIFO
    sb_export = new("sb_export", this); // Create the analysis export

endfunction

function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export); // Connect the analysis export to the FIFO

endfunction

task run_phase(uvm_phase phase);

    super.run_phase(phase);
    forever begin
        sb_fifo.get(fifo_sequence_item); // Get the sequence item from the FIFO
        `uvm_info("run_phase",fifo_sequence_item.convert2string(),UVM_MEDIUM); // Log the sequence item
        
        ref_model(fifo_sequence_item); // Call the reference model to check the output

        if(fifo_sequence_item.data_out != data_out_ref) begin
            `uvm_error("Scoreboard", $sformatf("Output mismatch detected! Expected: %0d, Got: %0d", data_out_ref, fifo_sequence_item.data_out));
            error_count++;
        end 
        else correct_count++;
        
    end
endtask

task ref_model(FIFO_Sequence_Item fifo_sequence_item);

    if(!fifo_sequence_item.rst_n) begin
            // Treat the FIFO as empty when reset is asserted
            wr_ptr_ref = 0;
            rd_ptr_ref = 0;
            count_ref = 0;
            overflow_ref = 0;
            wr_ack_ref = 0;
        end 

        //If both write and read are enabled :
        else if(fifo_sequence_item.wr_en && fifo_sequence_item.rd_en) begin 

            //If FIFO is empty, only write is allowed
            if(count_ref == 0) begin 
                mem_ref[wr_ptr_ref] = fifo_sequence_item.data_in;
                wr_ack_ref = 1;
                wr_ptr_ref++;
                count_ref++;
            end

            //If FIFO is full, only read is allowed
            else if(count_ref == FIFO_DEPTH) begin 
                data_out_ref = mem_ref[rd_ptr_ref];
                rd_ptr_ref++;
                count_ref--;
            end
            
            else begin
                mem_ref[wr_ptr_ref] = fifo_sequence_item.data_in;
                wr_ack_ref = 1;
                wr_ptr_ref++;
                data_out_ref = mem_ref[rd_ptr_ref];
                rd_ptr_ref++;
            end
        end
        //If one of the write or read is only enabled:
        else if(fifo_sequence_item.wr_en || fifo_sequence_item.rd_en) begin
            
            //If only write is enabled:
            if(fifo_sequence_item.wr_en && !fifo_sequence_item.rd_en && count_ref < FIFO_DEPTH) begin 
                mem_ref[wr_ptr_ref] = fifo_sequence_item.data_in;
                wr_ack_ref = 1;
                wr_ptr_ref++;
                count_ref++;
            end 
            else begin //If write is not enabled or FIFO is full
                
                if ((count_ref == FIFO_DEPTH) && fifo_sequence_item.wr_en) begin
                    wr_ack_ref = 0;
                    overflow_ref = 1;
                end else begin
                    wr_ack_ref = 1;
                    overflow_ref = 0;
                end
            end

            //If only read is enabled:
            if(fifo_sequence_item.rd_en && !fifo_sequence_item.wr_en && count_ref > 0) begin
                data_out_ref = mem_ref[rd_ptr_ref];
                rd_ptr_ref++;
                count_ref--;
            end 
        end 

endtask

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Correct Count: %0d, Error Count: %0d", correct_count, error_count), UVM_MEDIUM);
endfunction

endclass


endpackage