class env_cfg extends uvm_object;

        `uvm_object_utils(env_cfg)

        ahb_Mcfg ahb_Mcfgh;
        ahb_Scfg ahb_Scfgh;

        int has_master = 1;
        int has_slave = 1;
        int has_sb = 1;

        rand bit [9:0] length;

        uvm_active_passive_enum is_active = UVM_ACTIVE;

        extern function new(string name = "env_cfg");

endclass

function env_cfg::new(string name = "env_cfg");
        super.new(name);
endfunction
