package FIFO_Agent_pkg;
import uvm_pkg::*;
import FIFO_Driver_pkg::*;
import FIFO_Monitor_pkg::*;
import FIFO_Config_Obj_pkg::*;
import FIFO_Sequence_Item_pkg::*;
import FIFO_Sequencer_pkg::*;
`include "uvm_macros.svh"

class FIFO_Agent extends uvm_agent;
`uvm_component_utils(FIFO_Agent)

FIFO_Driver driver;
FIFO_Sequencer sequencer;
FIFO_Monitor monitor;
FIFO_Config_Obj fifo_config_obj;
uvm_analysis_port #(FIFO_Sequence_Item) agt_ap;

function new (string name = "FIFO_Agent", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(FIFO_Config_Obj)::get(this, "","fifo_config_obj",fifo_config_obj)) begin
    `uvm_fatal("build_phase", "Agent- unable to get the config object");
end

if(fifo_config_obj.is_active == UVM_ACTIVE) begin
    sequencer = FIFO_Sequencer::type_id::create("sequencer",this);
    driver = FIFO_Driver::type_id::create("driver",this);
end

monitor = FIFO_Monitor::type_id::create("monitor",this);

agt_ap = new ("agt_ap",this);

endfunction

function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    if(fifo_config_obj.is_active == UVM_ACTIVE) begin
        driver.fifo_driver_vif = fifo_config_obj.fifo_if;
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    //Connect the driver virtual interface to the interface obtained from the configuration object
  

    //Connect the monitor virtual interface to the interface obtained from the configuration object
    monitor.fifo_if = fifo_config_obj.fifo_if;

  
    monitor.mon_ap.connect(agt_ap);

endfunction


endclass
endpackage