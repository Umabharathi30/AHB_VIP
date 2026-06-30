class ahb_Sdrv extends uvm_driver #(ahb_Sxtn);

  `uvm_component_utils(ahb_Sdrv)

  ahb_Scfg ahb_Scfgh;
  virtual ahb_if.SDRV_MP vif;

  extern function new(string name="ahb_Sdrv", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(ahb_Sxtn xtn);

endclass

//-------------------------constructor--------------------------
function ahb_Sdrv::new(string name="ahb_Sdrv", uvm_component parent);
    super.new(name,parent);
endfunction

//-------------------------build_phase()------------------------
function void ahb_Sdrv::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(ahb_Scfg)::get(this,"","ahb_Scfg",ahb_Scfgh))
      `uvm_fatal(get_type_name(),"get fail to get vif")

endfunction

//------------------------connect_phase()------------------------
function void ahb_Sdrv:: connect_phase(uvm_phase phase);

        super.connect_phase(phase);

    vif = ahb_Scfgh.vif;

endfunction

//--------------------run_phase()------------------------------------
task ahb_Sdrv::run_phase(uvm_phase phase);

        super.run_phase(phase);

    forever
        begin
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        seq_item_port.item_done();
        end

endtask

//-------------------------send_to_dut---------------------------
task ahb_Sdrv::send_to_dut(ahb_Sxtn xtn);

    //---------------- okay ----------------

    vif.sdrv_cb.resp <= req.resp;

    if(req.resp == 0)
    begin
      vif.sdrv_cb.Hready  <= 1;      // 1st cycle
      // vif.sdrv_cb.Hresp <= req.Hresp;
      vif.sdrv_cb.Hresp <= 2'b0;

      if(vif.sdrv_cb.Hwrite == 0)
        vif.sdrv_cb.HRdata <= req.HRdata;

      @(vif.sdrv_cb);                   // 2nd cycle
    end

   //----------------okay_wait----------------

        else if(req.resp == 1)
        begin
                if(vif.sdrv_cb.Hwrite)
                begin
                        vif.sdrv_cb.Hready <= 0;
                        repeat(req.delay_cycle)
                                @(vif.sdrv_cb);
                        vif.sdrv_cb.Hready <= 1;
                        vif.sdrv_cb.Hresp <= 2'b0;

                        @(vif.sdrv_cb);
                end

                else
                begin
                        vif.sdrv_cb.Hready <= 0;
                        repeat(req.delay_cycle)
                                @(vif.sdrv_cb);
                        vif.sdrv_cb.Hready <= 1;
                        vif.sdrv_cb.Hready <= 2'b0;

                        // if(vif.sdrv_cb.Hready)
                                vif.sdrv_cb.HRdata <= req.HRdata;

                        @(vif.sdrv_cb);
                end
        end

        //----------------error----------------

        else if(req.resp == 2)
        begin
                if(vif.sdrv_cb.Hwrite)
                begin
                        // @(vif.sdrv_cb);

                        if(vif.sdrv_cb.Htrans == 2'b10)
                        begin
                                vif.sdrv_cb.Hready <= 1'b0;
                                vif.sdrv_cb.Hresp <=2'b01;

                                @(vif.sdrv_cb);

                                vif.sdrv_cb.Hready <= 1'b1;

                                @(vif.sdrv_cb);
                        end

        else
                        begin
                                vif.sdrv_cb.Hready <= 1'b1;
                                vif.sdrv_cb.Hresp <= 2'b0;
                                vif.sdrv_cb.HRdata <= 32'b0;

                                @(vif.sdrv_cb);
                        end
                end

        else if(vif.sdrv_cb.Hwrite == 0)
                begin
                        //@(vif.sdrv_cb);

                        if(vif.sdrv_cb.Htrans == 2'b10)
                        begin
                                vif.sdrv_cb.Hready <= 1'b0;
                                vif.sdrv_cb.Hresp <=2'b01;

                                @(vif.sdrv_cb);

                                vif.sdrv_cb.Hready <= 1'b1;

                                @(vif.sdrv_cb);

                                // vif.sdrv_cb.Hready <=1'b0;
                        end

                        else
                        begin
                                vif.sdrv_cb.Hready <= 1'b1;
                                vif.sdrv_cb.Hresp  <=2'b0;

                                @(vif.sdrv_cb);
                        end
                end
        end

         `uvm_info(get_type_name(),"SLAVE-DRIVER",UVM_LOW)
        req.print();

endtask
