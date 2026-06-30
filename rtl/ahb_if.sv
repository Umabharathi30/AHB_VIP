`timescale 1ns/10ps

interface ahb_if(input logic HCLK);

    logic Hresetn;
    logic Hready;
    logic [1:0] Htrans;
    logic [2:0] Hburst;
    logic [2:0] Hsize;
    logic Hwrite;
    logic [31:0] Haddr;
    logic [31:0] Hwdata;
    logic [31:0] HRdata;
    logic [1:0] Hresp;
    logic [1:0] resp;
    logic [9:0] length;

    clocking mdrv_cb @(posedge HCLK);
        default input #1 output #0;

        output Htrans;
        output Hburst;
        output Hsize;
        output Hwrite;
        output Haddr;
        output Hresetn;
        output Hwdata;
        input  Hready;
        input  negedge Hresp;
        input  HRdata;
        output length;

    endclocking


    clocking mmon_cb @(posedge HCLK);
        default input #1 output #0;

        input Hresetn;
        input Htrans;
        input Hburst;
        input Hsize;
        input Hwrite;
        input Haddr;
        input Hwdata;
        input Hready;
        input Hresp;
        input HRdata;
        input length;

    endclocking


    clocking sdrv_cb @(posedge HCLK);
        default input #1 output #0;

        input  Htrans;
        input  Hburst;
        input  Hsize;
        input  Hwrite;
        input  Haddr;
        input  Hwdata;
        inout  Hready;
        output Hresp;
        output resp;
        output negedge HRdata;

    endclocking


    clocking smon_cb @(posedge HCLK);
        default input #1 output #0;

        input Htrans;
        input Hburst;
        input Hsize;
        input Hwrite;
        input Haddr;
        input Hwdata;
        input Hready;
        input Hresp;
        input resp;
        input HRdata;

    endclocking


    modport MDRV_MP(clocking mdrv_cb, input Hresetn);
    modport MMON_MP(clocking mmon_cb, input Hresetn);
    modport SDRV_MP(clocking sdrv_cb, input Hresetn);
    modport SMON_MP(clocking smon_cb, input Hresetn);


//----------
//SVA
//----------

property ahb_handshake_p;
  @(posedge HCLK)
  disable iff(!Hresetn)
  Hready == 0 |=> ($stable(Haddr)  && $stable(Htrans) && $stable(Hwrite) && $stable(Hsize)  && $stable(Hburst));

endproperty

AHB_HANDSHAKE_ASSERT: assert property(ahb_handshake_p);

endinterface
