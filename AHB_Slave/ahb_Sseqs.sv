class ahb_Sseqs extends uvm_sequence #(ahb_Sxtn);

  `uvm_object_utils(ahb_Sseqs)

  ahb_Sxtn  req;
  bit [9:0] length;

  extern function new(string name="ahb_Sseqs");
  extern task body();

endclass

//----------------constructor------------------------------
function ahb_Sseqs::new(string name="ahb_Sseqs");
    super.new(name);
endfunction

//----------------body()-----------------------------------
task ahb_Sseqs::body();

    if(!uvm_config_db #(bit[9:0])::get(null,get_full_name(),"length",length))
      `uvm_fatal("base_seq","get will fail to get length")

    $display("**************** %0d ****************", length);

endtask

//---------------------sequence------------------------
class s1_to_m1 extends ahb_Sseqs;

  `uvm_object_utils(s1_to_m1)

  extern function new(string name="s1_to_m1");
  extern task body();

endclass

function s1_to_m1::new(string name="s1_to_m1");
    super.new(name);
endfunction

task s1_to_m1::body();

    super.body();

    req = ahb_Sxtn::type_id::create("s1_to_m1");

    repeat(1)
    begin

      repeat(length)
      begin

        start_item(req);


        assert(req.randomize() with {delay_cycle == 0;
                                     resp == 0;
                                     Hresp == 2'b0;
                                     Hready == 1'b1;});


        /*
        assert(req.randomize() with {delay_cycle inside {[3:10]};
                                     resp == 1;
                                     Hresp == 2'b0;
                                     Hready == 1'b1;});
        */

        /*
        assert(req.randomize() with {delay_cycle == 0;
                                     resp == 2;
                                     // Hresp == 2'b0;
                                     // Hready == 1'b1;});
        */

        assert(req.randomize() with {// if(resp==0 || resp==2) {delay_cycle==0;}
                                    resp inside {[0:1]};
                                    HRdata inside {[0:200]};});

        finish_item(req);

      end

    end

endtask
