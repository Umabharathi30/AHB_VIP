class ahb_Sagt extends uvm_agent;

        `uvm_component_utils(ahb_Sagt)

        ahb_Scfg ahb_Scfgh;
        ahb_Smon monh;
        ahb_Sdrv drvh;
        ahb_Sseqr seqrh;

        // Standard UVM Methods:
       extern function new(string name = "ahb_Sagt", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
endclass

//-----------------------new()----------------------------------------
function ahb_Sagt::new(string name = "ahb_Sagt",uvm_component parent);
         super.new(name, parent);
endfunction

//----------------------build_phase()-----------------------------------
function void ahb_Sagt::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(ahb_Scfg)::get(this, "", "ahb_Scfg", ahb_Scfgh))
            `uvm_fatal("AHB_SAGENT", "GET failed")

        monh=ahb_Smon::type_id::create("monh",this);

        if(ahb_Scfgh.is_active==UVM_ACTIVE)
         begin
                drvh=ahb_Sdrv::type_id::create("drvh",this);
                seqrh=ahb_Sseqr::type_id::create("seqrh",this);
          end
endfunction

//-------------------------connect() phase-----------------------------
function void ahb_Sagt::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(ahb_Scfgh.is_active == UVM_ACTIVE)
        begin
            drvh.seq_item_port.connect(seqrh.seq_item_export);
        end
endfunction
