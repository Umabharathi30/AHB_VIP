class ahb_Mseqr extends uvm_sequencer #(ahb_Mxtn);

// Factory registration using `uvm_component_utils
        `uvm_component_utils(ahb_Mseqr)

// Standard UVM Methods:
        extern function new(string name = "ahb_Mseqr",uvm_component parent);

endclass
//-----------------  constructor new method  -------------------//
function ahb_Mseqr::new(string name="ahb_Mseqr",uvm_component parent);
                super.new(name,parent);
endfunction
