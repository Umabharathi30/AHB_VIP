class ahb_Mdrv extends uvm_driver #(ahb_Mxtn);

  `uvm_component_utils(ahb_Mdrv)

  ahb_Mcfg ahb_Mcfgh;
  virtual ahb_if.MDRV_MP vif;

  extern function new(string name="ahb_Mdrv",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(ahb_Mxtn xtn);

endclass

//----------------------------new()---------------------------------
function ahb_Mdrv::new(string name="ahb_Mdrv",uvm_component parent);
    super.new(name,parent);
  endfunction

//---------------------build_phase()----------------------------------
function void ahb_Mdrv::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(ahb_Mcfg)::get(this,"","ahb_Mcfg",ahb_Mcfgh))
      `uvm_fatal(get_type_name(),"Wrong in the master driver")

endfunction

//-----------------------connect_phase()---------------------------
function void ahb_Mdrv::connect_phase(uvm_phase phase);

    super.connect_phase(phase);
    vif= ahb_Mcfgh.vif;

endfunction

//-----------------run_phase()-------------------------------------
task ahb_Mdrv::run_phase(uvm_phase phase);
    super.run_phase(phase);

    @(vif.mdrv_cb);
    vif.mdrv_cb.Hresetn<=1'b0;
    @(vif.mdrv_cb);
    vif.mdrv_cb.Hresetn<=1'b1;

    forever
    begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
endtask

//----------------------send_to_dut()-----------------------------
task ahb_Mdrv::send_to_dut(ahb_Mxtn xtn);

    wait(vif.mdrv_cb.Hready)
     // @(vif.mdrv_cb);

    $display("-------------------------------");

    vif.mdrv_cb.Haddr  <= xtn.Haddr;
    vif.mdrv_cb.Hwrite <= xtn.Hwrite;
    vif.mdrv_cb.Htrans <= xtn.Htrans;
    vif.mdrv_cb.Hsize  <= xtn.Hsize;
    vif.mdrv_cb.Hburst <= xtn.Hburst;
    vif.mdrv_cb.length <= xtn.length;

    //2nd clk cycle Data Phase
    @(vif.mdrv_cb);
    while(vif.mdrv_cb.Hready==1'b0)
      @(vif.mdrv_cb);

    if(xtn.Hwrite==1)
      vif.mdrv_cb.Hwdata <=xtn.Hwdata;

    else
      vif.mdrv_cb.Hwdata<=32'b0;

    `uvm_info(get_type_name(),"MASTER-DRIVER",UVM_LOW)
    xtn.print();

endtask
