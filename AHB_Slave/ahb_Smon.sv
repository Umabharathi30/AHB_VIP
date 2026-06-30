class ahb_Smon extends uvm_monitor;

  `uvm_component_utils(ahb_Smon)

  ahb_Scfg ahb_Scfgh;
  virtual ahb_if.SMON_MP vif;
  ahb_Sxtn req;

  uvm_analysis_port #(ahb_Sxtn) monitor_port;

  extern function new(string name="ahb_Smon", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();

endclass

//------------------------constructor----------------------
function ahb_Smon::new(string name="ahb_Smon", uvm_component parent);
    super.new(name,parent);
        monitor_port = new("monitor_port",this);
endfunction

//-------------------------build_phase()---------------------
function void ahb_Smon::build_phase(uvm_phase phase);

        super.build_phase(phase);

    if(!uvm_config_db #(ahb_Scfg)::get(this,"","ahb_Scfg",ahb_Scfgh))
      `uvm_fatal("ahb_Smon","cfg_is_fail")

    req = ahb_Sxtn::type_id::create("req");

endfunction

//-----------------------connect_phase()------------------------
function void ahb_Smon::connect_phase(uvm_phase phase);

        super.connect_phase(phase);

    vif = ahb_Scfgh.vif;

endfunction

//-------------------------run_phase()------------------------
task ahb_Smon::run_phase(uvm_phase phase);

        super.run_phase(phase);

        forever
                begin
                  collect_data();
                end
endtask

//------------------------collect_data()-----------------------
task ahb_Smon::collect_data();

    wait(vif.smon_cb.Htrans == 2 || vif.smon_cb.Htrans == 3);

    req.Hresp      = vif.smon_cb.Hresp;
    req.HRdata   = vif.smon_cb.HRdata;
    req.Hready     = vif.smon_cb.Hready;
    //req.Hsel     = vif.smon_cb.Hsel;
    req.Haddr      = vif.smon_cb.Haddr;
    req.Htrans     = vif.smon_cb.Htrans;
    req.Hwrite     = vif.smon_cb.Hwrite;
    req.Hsize      = vif.smon_cb.Hsize;
    req.Hburst     = vif.smon_cb.Hburst;
    //req.Hprot      = vif.smon_cb.Hprot;
    //req.Hmaster    = vif.smon_cb.Hmaster;
    //req.Hmastlock  = vif.smon_cb.Hmastlock;

    @(vif.smon_cb);

    if(req.Hsel == 1)
      wait(vif.smon_cb.Hready);

    if(vif.smon_cb.Hwrite)
      req.Hwdata = vif.smon_cb.Hwdata;
    else
      req.HRdata = vif.smon_cb.HRdata;

        `uvm_info(get_type_name(),"***************SLAVE-MONITOR***************",UVM_LOW)

        monitor_port.write(req);

    req.print();

endtask
