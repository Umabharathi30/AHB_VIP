class ahb_Mseqs extends uvm_sequence #(ahb_Mxtn);

  `uvm_object_utils(ahb_Mseqs)

  bit [2:0]  hsize;
  bit [1:0]  htrans;
  bit [31:0] hrdata;
  bit [31:0] hwdata;
  bit [31:0] haddr;
  bit        hwrite;
  int        len;
  bit [1:0]  hresp;
  bit        hready;
  bit [2:0]  hburst;
  //bit [9:0] length;

  extern function new(string name="ahb_Mseqs");

endclass

function ahb_Mseqs::new(string name="ahb_Mseqs");
        super.new(name);
endfunction

//-------------------SINGLE------------------------------
class sequence1 extends ahb_Mseqs;

  `uvm_object_utils(sequence1)

  extern function new(string name="sequence1");
  extern task body();

endclass

function sequence1::new(string name="sequence1");
    super.new(name);
endfunction

task sequence1::body();

    repeat(1)
    begin

      req = ahb_Mxtn::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {Htrans == 2'b10;
                                   Hburst == 3'b000;});

      finish_item(req);

    end

endtask

//-------------------INCR---------------------------
class sequence2 extends ahb_Mseqs;

  `uvm_object_utils(sequence2)

  extern function new(string name="sequence2");
  extern task body();

endclass

function sequence2::new(string name="sequence2");
    super.new(name);
endfunction

task sequence2::body();

    repeat(1)
    begin

      req = ahb_Mxtn::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {Hburst inside {3,5,7};
                                   Htrans == 2'b10;});

      uvm_config_db #(bit[9:0])::set(null,"*","length", req.length);

      finish_item(req);

      haddr  = req.Haddr;
      hwrite = req.Hwrite;
      hsize  = req.Hsize;
      hburst = req.Hburst;
      len = req.length;

      // req.valid_Hburst.constraint_mode(0);

      for(int i=0; i<len-1; i++)
      begin

        start_item(req);

        assert(req.randomize() with {Hwrite == hwrite;
                                     Hsize  == hsize;
                                     Hburst == hburst;
                                     Htrans == 2'b11;
                                     // length == len;
                                     Haddr  == (haddr + (2**hsize));});

        finish_item(req);

        haddr = req.Haddr;

      end

    end

endtask

//--------------------WRAP--------------------------
class sequence3 extends ahb_Mseqs;

  `uvm_object_utils(sequence3)

  bit [31:0] b_addr;
  bit [31:0] s_addr;

  extern function new(string name="sequence3");
  extern task body();

endclass

function sequence3::new(string name="sequence3");
    super.new(name);
endfunction

task sequence3::body();

    repeat(1)
    begin

      req = ahb_Mxtn::type_id::create("req");

      start_item(req);

      assert(req.randomize with {//Hwrite == 1'b1;
                                 Hburst inside {2,4,6};
                                 Htrans == 2'b10;});

      finish_item(req);

      haddr  = req.Haddr;
      hwrite = req.Hwrite;
      hsize  = req.Hsize;
      hburst = req.Hburst;
      len    = req.length;

      s_addr = int'((req.Haddr)/((2**req.Hsize)*req.length)) *((2**req.Hsize)*req.length);

      $display("Starting addr=%0h", s_addr);

      b_addr = s_addr + ((2**req.Hsize)*req.length);

      $display("Boundry addr=%0h", b_addr);

      haddr = req.Haddr + (2**hsize);

      for(int i=1; i<len; i++)
      begin

        if(haddr == b_addr)
           haddr = s_addr;

        start_item(req);

        assert(req.randomize with {Hwrite == hwrite;
                                   Hsize  == hsize;
                                   Hburst == hburst;
                                   length == len;
                                   Htrans == 2'b11;
                                   Haddr  == haddr;});

        finish_item(req);

        haddr = req.Haddr + (2**hsize);

      end

    end

endtask
