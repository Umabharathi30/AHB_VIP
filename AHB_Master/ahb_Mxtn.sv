class ahb_Mxtn extends uvm_sequence_item;

  `uvm_object_utils(ahb_Mxtn)

  rand bit [1:0]  Htrans;
  rand bit [2:0]  Hsize;
  rand bit [2:0]  Hburst;
  rand bit [31:0] Hwdata;
  rand bit [31:0] Haddr;
  rand bit        Hwrite;
  rand bit [9:0]  length;

  bit             Hready;
  bit [31:0]      HRdata;
  rand bit        Hresetn;

  constraint valid_size {Hsize inside {[0:2]};} //size constraint - 8,16,32 bit

  constraint valid_addr {(Hsize == 1) -> Haddr % 2 == 0;
                         (Hsize == 2) -> Haddr % 4 == 0;} //address alignment constraint

  constraint valid_hburst {if(Hburst == 0)
                                length == 1;

                           else if(Hburst == 2 || Hburst == 3)
                                length == 4;

                           else if(Hburst == 4 || Hburst == 5)
                                length == 8;

                           else if(Hburst == 6 || Hburst == 7)
                                length == 16;

                           else if(Hburst == 1)
                                length <= 1023;} // burst length constraint

  extern function new(string name = "ahb_Mxtn");
  extern function void do_print(uvm_printer printer);

endclass

function ahb_Mxtn::new(string name = "ahb_Mxtn");
    super.new(name);
endfunction


function void ahb_Mxtn::do_print(uvm_printer printer);
    super.do_print(printer);

    //                 string name      bitstream value        size   radix for printing

    printer.print_field("Resetn",       this.Hresetn,           1,      UVM_DEC);
    printer.print_field("Hready",       this.Hready,            1,      UVM_DEC);
    printer.print_field("Htrans",       this.Htrans,            2,      UVM_DEC);
    printer.print_field("Hwrite",       this.Hwrite,            1,      UVM_DEC);
    printer.print_field("Hsize",        this.Hsize,             8,      UVM_DEC);
    printer.print_field("Hburst",       this.Hburst,            8,      UVM_DEC);
    printer.print_field("Haddr",        this.Haddr,             32,     UVM_HEX);
    printer.print_field("Hwdata",       this.Hwdata,            32,     UVM_HEX);
    printer.print_field("HRdata",       this.HRdata,            32,     UVM_HEX);
    printer.print_field("Length",       this.length,            10,     UVM_DEC);

endfunction

