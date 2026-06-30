class ahb_Mcfg extends uvm_object;

        `uvm_object_utils(ahb_Mcfg)

        uvm_active_passive_enum is_active = UVM_ACTIVE;

        virtual ahb_if vif;
        extern function new(string name = "ahb_Mcfg");

endclass

function ahb_Mcfg::new(string name = "ahb_Mcfg");
        super.new(name);
endfunction
