package FIFO_Config_Obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_Config_Obj extends uvm_object;
`uvm_object_utils(FIFO_Config_Obj)


virtual FIFO_IF fifo_if;
uvm_active_passive_enum is_active;

function new (string name = "FIFO_Config_Obj");
    super.new(name);
endfunction

endclass
endpackage