class ahb_Sxtn extends uvm_sequence_item;

  `uvm_object_utils(ahb_Sxtn)

  rand bit [1:0]  Hresp;
  rand bit [31:0] HRdata;
  rand bit        Hready;

  rand enum {okay, okay_wait, error} resp;
  rand bit [3:0] delay_cycle;

  bit        Hsel;
  bit [31:0] Haddr;
  bit [1:0]  Htrans;
  bit        Hwrite;
  bit [2:0]  Hsize;
  bit [2:0]  Hburst;
  bit [3:0]  Hprot;
  bit [3:0]  Hmaster;
  bit        Hmastlock;
  bit [31:0] Hwdata;

  constraint c1 { soft HRdata < 100; }
  constraint c2 { soft delay_cycle inside {[3:10]};}

  extern function new(string name = "ahb_Sxtn");
  extern function void do_print(uvm_printer printer);

endclass

function ahb_Sxtn::new(string name = "ahb_Sxtn");
    super.new(name);
endfunction

function void ahb_Sxtn::do_print(uvm_printer printer);

    printer.print_string("---------------------SLAVE----------------------","");

    printer.print_field("Hresp:", this.Hresp, 2, UVM_BIN);

    printer.print_string("----------------control signal----------------","");

    printer.print_field("Hsel:",       this.Hsel,      1, UVM_BIN);
    printer.print_field("Htrans:",     this.Htrans,    2, UVM_BIN);
    printer.print_field("Hwrite:",     this.Hwrite,    1, UVM_BIN);
    printer.print_field("Hsize:",      this.Hsize,     3, UVM_BIN);
    printer.print_field("Hburst:",     this.Hburst,    3, UVM_BIN);
    printer.print_field("Hprot:",      this.Hprot,     4, UVM_BIN);
    printer.print_field("Hmastlock:",  this.Hmastlock, 1, UVM_DEC);
    printer.print_field("Hmaster:",    this.Hmaster,   4, UVM_DEC);

    printer.print_string("----------------pipeline signal----------------","");

    printer.print_field("Haddr:",  this.Haddr,  32, UVM_DEC);
    printer.print_field("Hwdata:", this.Hwdata, 32, UVM_DEC);

    printer.print_string("----------------slave signal----------------","");

    printer.print_field("delay_cycle:", this.delay_cycle, 4, UVM_DEC);
    printer.print_field("HRdata:",      this.HRdata,      32,UVM_DEC);
    printer.print_field("Hresp:",       this.Hresp,       2, UVM_BIN);
    printer.print_field("Hready:",      this.Hready,      1, UVM_BIN);

    printer.print_generic("resp:", "enum", $bits(resp), resp.name);

endfunction
