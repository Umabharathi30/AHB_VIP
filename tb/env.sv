class env extends uvm_env;

        `uvm_component_utils(env)

        ahb_Mtop ahb_Mtoph;
        ahb_Stop ahb_Stoph;
        scoreboard sb;
        env_cfg e_cfg;

        extern function new(string name = "env",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass

function env::new(string name = "env",uvm_component parent);
        super.new(name,parent);
endfunction

function void env::build_phase(uvm_phase phase);
        super.build_phase(phase);
        ahb_Mtoph = ahb_Mtop::type_id::create("ahb_Mtoph",this);
        ahb_Stoph = ahb_Stop::type_id::create("ahb_Stoph",this);
        sb = scoreboard::type_id::create("sb",this);

        if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
                `uvm_fatal("ENV","config not able get in env")

endfunction

function void env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ahb_Mtoph.agnth.monh.monitor_port.connect(sb.fifo_m.analysis_export);
        ahb_Stoph.agnth.monh.monitor_port.connect(sb.fifo_s.analysis_export);

endfunction
