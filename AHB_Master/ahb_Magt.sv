class ahb_Magt extends uvm_agent;

        `uvm_component_utils(ahb_Magt)

        ahb_Mcfg ahb_Mcfgh;
        ahb_Mmon monh;
        ahb_Mdrv drvh;
        ahb_Mseqr seqrh;

        // Standard UVM Methods:
       extern function new(string name = "ahb_Magt", uvm_component parent);
       extern function void build_phase(uvm_phase phase);
       extern function void connect_phase(uvm_phase phase);
endclass

//-----------------------new-----------------------------------------
function ahb_Magt::new(string name = "ahb_Magt",uvm_component parent);
         super.new(name, parent);
endfunction

//-------------------------build_phase()-----------------------------
function void ahb_Magt::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(ahb_Mcfg)::get(this,"","ahb_Mcfg",ahb_Mcfgh))
                `uvm_fatal("CONFIG","cannot get() ahb_Mcfgh from uvm_config_db. Have you set() it?")
        monh = ahb_Mmon::type_id::create("monh", this);

        if(ahb_Mcfgh.is_active == UVM_ACTIVE)
        begin

                drvh = ahb_Mdrv::type_id::create("drvh",this);
                seqrh = ahb_Mseqr::type_id::create("seqrh",this);
        end
endfunction

//-------------------------connect() phase-----------------------------
function void ahb_Magt::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(ahb_Mcfgh.is_active == UVM_ACTIVE)
        begin
        drvh.seq_item_port.connect(seqrh.seq_item_export);
        end
endfunction
