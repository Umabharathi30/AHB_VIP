class scoreboard extends uvm_scoreboard;

        // Factory registration
         `uvm_component_utils(scoreboard)

        uvm_tlm_analysis_fifo #(ahb_Mxtn) fifo_m;
        uvm_tlm_analysis_fifo #(ahb_Sxtn) fifo_s;

        ahb_Mxtn xtn;
        ahb_Sxtn req;

        ahb_Mxtn ahb_M_cov;
        ahb_Sxtn ahb_S_cov;

        int data_verified_count;

        //COVERAGE
        covergroup ahb_M_cg;

                option.per_instance = 1;

                        HSIZE:  coverpoint ahb_M_cov.Hsize  {bins size = {[0:2]};}

                        HWRITE: coverpoint ahb_M_cov.Hwrite {bins write = {[0:1]};}

                        HADDR:  coverpoint ahb_M_cov.Haddr  {bins addr  = {[32'h0000_0000 : 32'hFFFF_FFFF]};}

                        HBURST: coverpoint ahb_M_cov.Hburst {bins burst  = {[0:7]};}

                        HTRANS: coverpoint ahb_M_cov.Htrans {bins trans = {[0:3]};}

                        HWDATA: coverpoint ahb_M_cov.Hwdata {bins wdata  = {[32'h0000_0000 : 32'hFFFF_FFFF]};}

                        HSIZEXHWRITE: cross HSIZE,HWRITE;

        endgroup

        covergroup ahb_S_cg;

                option.per_instance = 1;

                        HRDATA: coverpoint ahb_S_cov.HRdata {bins rdata = {[32'h0000_0000 : 32'hFFFF_FFFF]};}

                        HREADY: coverpoint ahb_S_cov.Hready {bins Hready = {[0:1]};}

                        HRESP:  coverpoint ahb_S_cov.Hresp {bins resp = {[0:1]};}

                        HRESPXHREADY: cross HREADY,HRESP;

        endgroup

        // Standard UVM Methods:
        extern function new(string name = "scoreboard",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task compare_data(ahb_Mxtn xtn,ahb_Sxtn req);
        extern function void report_phase(uvm_phase phase);

endclass

//-----------------constructor new method------------------------------------
function scoreboard::new(string name = "scoreboard",uvm_component parent);
        super.new(name,parent);

        ahb_M_cg = new();
        ahb_S_cg = new();

endfunction

//------------------build_phase()---------------------------------------------
function void scoreboard::build_phase(uvm_phase phase);

        super.build_phase(phase);
        fifo_m = new("fifo_m", this);
        fifo_s = new("fifo_s", this);

endfunction

//--------------------------------run_phase()------------------------------------
task scoreboard::run_phase(uvm_phase phase);

        fork
                forever begin
                        fifo_m.get(xtn);
                        `uvm_info("WRITE SB","write data",UVM_LOW)
                        ahb_M_cov = xtn;
                        ahb_M_cg.sample();
                //end
                //forever begin
                        fifo_s.get(req);
                        `uvm_info("READ SB","read data",UVM_LOW)
                        ahb_S_cov = req;
                        ahb_S_cg.sample();
                        compare_data(xtn,req);
                end

        join


endtask

//----------------------------compare_data()--------------------------------------
task scoreboard::compare_data(ahb_Mxtn xtn,ahb_Sxtn req);

        //Write transfer
        if(xtn.Hwrite)
                begin
                        if(xtn.Hwdata == req.Hwdata)
                        begin
                            `uvm_info("AHB_SB","DATA MATCHED SUCCESSFULLY",UVM_LOW)
                        end
                        else
                        begin
                            `uvm_info("AHB_SB","DATA MATCHING FAILED",UVM_LOW)
                        end
                end
        //read transfer
        else
                begin
                        if(xtn.HRdata == req.HRdata)
                        begin
                           `uvm_info("AHB_SB","DATA MATCHED SUCCESSFULLY",UVM_LOW)
                        end
                        else
                        begin
                           `uvm_info("AHB_SB","DATA MATCHING FAILED",UVM_LOW)
                        end
                end
        data_verified_count++;

endtask


//------------------------------report_phase()---------------------------------
function void scoreboard::report_phase(uvm_phase phase);

        `uvm_info(get_type_name() ,$sformatf("Report : Number of data verified in SB %0d",data_verified_count),UVM_LOW)

endfunction
