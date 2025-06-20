package FIFO_Test_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import FIFO_Random_Sequence_pkg::*;
import FIFO_Reset_Sequence_pkg::*;
import FIFO_Directed_Sequence_pkg::*;
import FIFO_WriteOnly_Loop_Sequence_pkg::*;
import FIFO_ReadOnly_Loop_Sequence_pkg::*;
import FIFO_ReadWrite_Sequence_pkg::*;
import FIFO_ReadOnly_Sequence_pkg::*;
import FIFO_Env_pkg::*;
import FIFO_Config_Obj_pkg::*;
import FIFO_Sequence_Item_pkg::*;

class FIFO_Test extends uvm_test;
`uvm_component_utils(FIFO_Test)


FIFO_Env fifo_env;
FIFO_Config_Obj fifo_config_obj;
FIFO_Random_Sequence fifo_random_sequence;
FIFO_Directed_Sequence fifo_directed_sequence;
FIFO_Reset_Sequence fifo_reset_sequence;
FIFO_ReadOnly_Loop_Sequence fifo_readonly_loop_sequence;
FIFO_WriteOnly_Loop_Sequence fifo_writeonly_loop_sequence;
FIFO_ReadOnly_Sequence fifo_readonly_sequence;
FIFO_ReadWrite_Sequence fifo_readwrite_sequence;

function new (string name = "FIFO_Test", uvm_component parent = null);
    super.new(name,parent); 
endfunction


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fifo_env = FIFO_Env::type_id::create("fifo_env",this);
    fifo_config_obj = FIFO_Config_Obj::type_id::create("fifo_config_obj",this);
    fifo_random_sequence = FIFO_Random_Sequence::type_id::create("fifo_random_sequence",this);
    fifo_directed_sequence = FIFO_Directed_Sequence::type_id::create("fifo_directed_sequence",this);
    fifo_reset_sequence = FIFO_Reset_Sequence::type_id::create("fifo_reset_sequence",this);
    fifo_readonly_loop_sequence = FIFO_ReadOnly_Loop_Sequence::type_id::create("fifo_readonly_loop_sequence",this);
    fifo_writeonly_loop_sequence = FIFO_WriteOnly_Loop_Sequence::type_id::create("fifo_writeonly_loop_sequence",this);
    fifo_readonly_sequence = FIFO_ReadOnly_Sequence::type_id::create("fifo_readonly_sequence",this);
    fifo_readwrite_sequence = FIFO_ReadWrite_Sequence::type_id::create("fifo_readwrite_sequence",this);
    
    if(!uvm_config_db #(virtual FIFO_IF) ::get(this, "", "FIFO_IF",fifo_config_obj.fifo_if)) begin
        `uvm_fatal("FIFO_IF","Virtual interface not found in the configuration database")
    end

    set_type_override_by_type(FIFO_Sequence_Item::get_type(), FIFO_Sequence_Item_Disable_Reset::get_type);
    fifo_config_obj.is_active = UVM_ACTIVE;
    // fifo_config_obj.is_active = UVM_PASSIVE;

    uvm_config_db#(FIFO_Config_Obj)::set(this,"*","fifo_config_obj",fifo_config_obj); //Set the virtual interface in the configuration database
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run phase","FIFO_1",UVM_LOW);
    fifo_reset_sequence.start(fifo_env.agent.sequencer);  // Start FIFO_1
    `uvm_info("run phase","FIFO_1 Finished",UVM_LOW);

    `uvm_info("run phase","FIFO_2",UVM_LOW);
    fifo_writeonly_loop_sequence.start(fifo_env.agent.sequencer); // Start FIFO_2
    `uvm_info("run phase","FIFO_2 Finished",UVM_LOW);

    `uvm_info("run phase","FIFO_3",UVM_LOW);
    fifo_readwrite_sequence.start(fifo_env.agent.sequencer); // Start FIFO_3
    `uvm_info("run phase","FIFO_3 Finished",UVM_LOW);

    `uvm_info("run phase","FIFO_4",UVM_LOW);
    fifo_readonly_loop_sequence.start(fifo_env.agent.sequencer); // Start FIFO_4
    `uvm_info("run phase","FIFO_4 Finished",UVM_LOW);

    `uvm_info("run phase","FIFO_5",UVM_LOW);
    fifo_readonly_sequence.start(fifo_env.agent.sequencer); // Start FIFO_5
    `uvm_info("run phase","FIFO_5 Finished",UVM_LOW);

    `uvm_info("run phase","FIFO_6",UVM_LOW);
    fifo_readwrite_sequence.start(fifo_env.agent.sequencer); // Start FIFO_6
    `uvm_info("run phase","FIFO_6 Finished",UVM_LOW);

    `uvm_info("run phase","FIFO_7",UVM_LOW);
    fifo_writeonly_loop_sequence.start(fifo_env.agent.sequencer); // Start FIFO_7
    `uvm_info("run phase","FIFO_7 Finished",UVM_LOW);

    fifo_directed_sequence.start(fifo_env.agent.sequencer);

    fifo_reset_sequence.start(fifo_env.agent.sequencer);

    `uvm_info("run phase","FIFO_8",UVM_LOW);
    fifo_random_sequence.start(fifo_env.agent.sequencer); // Start FIFO_8
    `uvm_info("run phase","FIFO_8 Finished",UVM_LOW);
    

    phase.drop_objection(this);
endtask

endclass
endpackage