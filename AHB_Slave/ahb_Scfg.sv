class ahb_Scfg extends uvm_object;

        `uvm_object_utils(ahb_Scfg)

        uvm_active_passive_enum is_active = UVM_ACTIVE;

        virtual ahb_if vif;
        extern function new(string name = "ahb_Scfg");

endclass

function ahb_Scfg::new(string name = "ahb_Scfg");
        super.new(name);
endfunction
