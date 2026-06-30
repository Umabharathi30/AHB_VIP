class base_test extends uvm_test;

        `uvm_component_utils(base_test)

        env envh;
        env_cfg e_cfgh;
        ahb_Mcfg ahb_Mcfgh;
        ahb_Scfg ahb_Scfgh;

        rand bit [9:0] length;
        rand bit [2:0] Hburst;

        int has_slave = 1;
        int has_master = 1;
        int has_sb     = 1;
        //int no_of_master = 1;
        //int no_of_slave = 1;

        constraint length_c {length inside {1,4,8,16};}
        constraint valid_hburst {if(Hburst == 0)
                                length == 1;

                           else if(Hburst == 2 || Hburst == 3)
                                length == 4;

                           else if(Hburst == 4 || Hburst == 5)
                                length == 8;

                           else if(Hburst == 6 || Hburst == 7)
                                length == 16;}

                           //else if(Hburst == 1)
                                //length <= 1023;} // burst length constraint


        //Methods
        extern function new(string name = "base_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void ctrl_randomize();
        extern function void  config_ahb();
        extern function void end_of_elaboration_phase(uvm_phase phase);

endclass
//--------------------constructor new method-----------------------//
function base_test::new(string name = "base_test" , uvm_component parent);
        super.new(name,parent);
endfunction

//--------------------config_ahb() method--------------------------//
function void base_test::config_ahb();

        if(has_master)
                begin
                        ahb_Mcfgh.is_active = UVM_ACTIVE;

                       if(!uvm_config_db #(virtual ahb_if)::get(this,"","in",ahb_Mcfgh.vif))
                          `uvm_fatal("VIF CONFIG","cannot get() interface vif from uvm_config_db. Have you set() it?")

                       e_cfgh.ahb_Mcfgh = ahb_Mcfgh;

                end

        if(has_slave)
                begin
                        ahb_Scfgh.is_active = UVM_ACTIVE;

                       if(!uvm_config_db #(virtual ahb_if)::get(this,"","in",ahb_Scfgh.vif))
                          `uvm_fatal("VIF CONFIG","cannot get() interface vif from uvm_config_db. Have you set() it?")

                       e_cfgh.ahb_Scfgh = ahb_Scfgh;

                end

        e_cfgh.has_sb   = has_sb;
        e_cfgh.has_master = has_master;
        e_cfgh.has_slave = has_slave;
        //e_cfgh.no_of_master = no_of_master;
        //e_cfgh.no_of_slave = no_of_slave;

endfunction

//---------------------build_phase()-----------------------------------//
function void base_test::build_phase(uvm_phase phase);

        e_cfgh = env_cfg::type_id::create("e_cfgh");

        if(has_master)

                 ahb_Mcfgh = ahb_Mcfg::type_id::create("ahb_Mcfgh");

        if(has_slave)

             ahb_Scfgh = ahb_Scfg::type_id::create("ahb_Scfgh");

        config_ahb();

        super.build_phase(phase);

        envh = env::type_id::create("envh",this);

        uvm_config_db #(env_cfg)::set(this,"*","env_cfg",e_cfgh);

endfunction

//---------------------------ctrl_randomize()--------------------------------//
function void base_test::ctrl_randomize();
        assert(this.randomize());
        e_cfgh.length = this.length;
endfunction

//--------------------- end_of_elaboration_phase-------------------------//
function void base_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology;

endfunction

//-----------------------------test1-single transfer--------------------------------------//
class test1 extends base_test;

  `uvm_component_utils(test1)

  //bit [9:0] l;
  sequence1 seq1;
  s1_to_m1 sseq1;

  extern function new(string name="test1", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function test1::new(string name="test1", uvm_component parent);
    super.new(name,parent);
endfunction


function void  test1::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task test1::run_phase(uvm_phase phase);
    super.run_phase(phase);

    seq1  = sequence1::type_id::create("seq1");
    sseq1 = s1_to_m1::type_id::create("sseq1");

    ctrl_randomize();

    uvm_config_db #(bit[9:0])::set(null,"*","length",length);
        $display("test length = %0d",length);

    //uvm_config_db #(bit[2:0])::set(null,"*","Hburst",Hburst);
            //$display("test Hburst = %0d",Hburst);

    phase.raise_objection(this);
        //ctrl_randomize();
    fork
      begin
        seq1.start(envh.ahb_Mtoph.agnth.seqrh);
      end

      begin

        repeat(3)
          sseq1.start(envh.ahb_Stoph.agnth.seqrh);
      end
    join

    #20;
    phase.drop_objection(this);

endtask

//--------------------------------INC----------------------------------
class test2 extends base_test;

  `uvm_component_utils(test2)

  //bit [9:0] l;
  sequence2 seq2;
  s1_to_m1 sseq1;

  extern function new(string name="test2", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function test2::new(string name="test2", uvm_component parent);
    super.new(name,parent);
endfunction

function void test2::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task test2::run_phase(uvm_phase phase);
    super.run_phase(phase);

    seq2  = sequence2::type_id::create("seq2");
    sseq1 = s1_to_m1::type_id::create("sseq1");

    ctrl_randomize();

    uvm_config_db #(bit[9:0])::set(null,"*","length",length);
        $display("test length = %0d",length);

    //uvm_config_db #(bit[2:0])::set(null,"*","Hburst",Hburst);
            //$display("test Hburst = %0d",Hburst);

    phase.raise_objection(this);

    fork
      begin
        seq2.start(envh.ahb_Mtoph.agnth.seqrh);
      end

      begin
        // if(!uvm_config_db #(bit[9:0])::get(this,"","Length",l))
        // begin
        //   `uvm_fatal(get_type_name(),"Wrong in test2")
        // end

        repeat(3)
          sseq1.start(envh.ahb_Stoph.agnth.seqrh);
      end
    join

    #20;
    phase.drop_objection(this);

endtask

//---------------------------------WRAP---------------------------------
class test3 extends base_test;

  `uvm_component_utils(test3)

  //bit [9:0] l;
  sequence3 seq3;
  s1_to_m1 sseq1;

  extern function new(string name="test3", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function test3::new(string name="test3", uvm_component parent);
    super.new(name,parent);
endfunction

function void  test3::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task test3::run_phase(uvm_phase phase);
    super.run_phase(phase);

    seq3  = sequence3::type_id::create("seq3");
    sseq1 = s1_to_m1::type_id::create("sseq1");

    ctrl_randomize();

    uvm_config_db #(bit[9:0])::set(null,"*","length",length);
        $display("test length = %0d",length);

    //uvm_config_db #(bit[2:0])::set(null,"*","Hburst",Hburst);
            //$display("test Hburst = %0d",Hburst);

    phase.raise_objection(this);

    fork
      begin
        seq3.start(envh.ahb_Mtoph.agnth.seqrh);
      end

      begin
        // if(!uvm_config_db #(bit[9:0])::get(this,"","Length",l))
        // begin
        //   `uvm_fatal(get_type_name(),"Wrong in test3")
        // end

        repeat(3)
          sseq1.start(envh.ahb_Stoph.agnth.seqrh);
      end
    join

    #20;
    phase.drop_objection(this);

endtask
