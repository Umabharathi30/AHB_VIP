class ahb_Stop extends uvm_env;

        `uvm_component_utils(ahb_Stop)
        ahb_Sagt agnth;
        env_cfg e_cfg;

        extern function new(string name = "ahb_Stop",uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass

function ahb_Stop::new(string name = "ahb_Stop",uvm_component parent);
        super.new(name,parent);
endfunction

function void ahb_Stop::build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnth = ahb_Sagt::type_id::create("agnth",this);

        if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
             `uvm_fatal("ENV","config not able get in env")

        uvm_config_db #(ahb_Scfg)::set(this,"*","ahb_Scfg",e_cfg.ahb_Scfgh);

endfunction

