class ahb_Mtop extends uvm_env;

        `uvm_component_utils(ahb_Mtop)

        ahb_Magt agnth;
        env_cfg e_cfg;

        extern function new(string name = "ahb_Mtop",uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass

//------------------------constructor new method----------------------
function ahb_Mtop::new(string name = "ahb_Mtop",uvm_component parent);
        super.new(name,parent);
endfunction

//--------------------build_phase------------------------------------
function void ahb_Mtop::build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnth = ahb_Magt::type_id::create("agnth",this);

        if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
             `uvm_fatal("ENV","config not able get in env")

        uvm_config_db #(ahb_Mcfg)::set(this,"*","ahb_Mcfg",e_cfg.ahb_Mcfgh);

endfunction
