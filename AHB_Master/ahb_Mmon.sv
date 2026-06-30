class ahb_Mmon extends uvm_monitor;

  `uvm_component_utils(ahb_Mmon)

  ahb_Mcfg ahb_Mcfgh;

  virtual ahb_if.MMON_MP vif;

  ahb_Mxtn xtn;

  uvm_analysis_port #(ahb_Mxtn) monitor_port;

  extern function new(string name="ahb_Mmon", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();

endclass

//---------------------------new method------------------------------
function ahb_Mmon::new(string name="ahb_Mmon", uvm_component parent);
    super.new(name,parent);

    monitor_port = new("monitor_port",this);
endfunction

//---------------------------build_phase-----------------------------
function void  ahb_Mmon::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(ahb_Mcfg)::get(this,"","ahb_Mcfg",ahb_Mcfgh))
      `uvm_fatal(get_type_name(),"Wrong in the master monitor")

endfunction

//-------------------------connect_phase-----------------------------
function void ahb_Mmon:: connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    vif = ahb_Mcfgh.vif;

endfunction

//-----------------------run_phase---------------------------------
task ahb_Mmon::run_phase(uvm_phase phase);

    super.run_phase(phase);

    forever
    begin
      collect_data();
    end

endtask

//--------------------collect_data------------------------------------
task ahb_Mmon::collect_data();

    xtn = ahb_Mxtn::type_id::create("xtn");

    wait(vif.mmon_cb.Htrans==2'b10 || vif.mmon_cb.Htrans==2'b11);

    //1st clk cycle
    wait(vif.mmon_cb.Hready==1'b1);
    //@(vif.master_mon_cb);
    xtn.Haddr   = vif.mmon_cb.Haddr;
    xtn.Hwrite  = vif.mmon_cb.Hwrite;
    xtn.Htrans  = vif.mmon_cb.Htrans;
    xtn.Hsize   = vif.mmon_cb.Hsize;
    xtn.Hburst  = vif.mmon_cb.Hburst;
    xtn.length  = vif.mmon_cb.length;
    xtn.Hresetn = vif.mmon_cb.Hresetn;

    //2nd clk cycle
    @(vif.mmon_cb);
    wait(vif.mmon_cb.Hready==1'b1);
    if(vif.mmon_cb.Hwrite)
      xtn.Hwdata = vif.mmon_cb.Hwdata;
    else
      xtn.HRdata = vif.mmon_cb.HRdata;

    `uvm_info(get_type_name(),"***************MASTER-MONITOR***************",UVM_LOW)

        monitor_port.write(xtn);

    xtn.print();


endtask
