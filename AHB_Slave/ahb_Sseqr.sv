class ahb_Sseqr extends uvm_sequencer #(ahb_Sxtn);

// Factory registration using `uvm_component_utils
        `uvm_component_utils(ahb_Sseqr)

// Standard UVM Methods:
        extern function new(string name = "ahb_Sseqr",uvm_component parent);

endclass
//-----------------  constructor new method  -------------------//
function ahb_Sseqr::new(string name="ahb_Sseqr",uvm_component parent);
                super.new(name,parent);
endfunction
