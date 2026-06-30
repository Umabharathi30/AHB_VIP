package pkg;

//import uvm_pkg.sv
import uvm_pkg::*;

//include uvm_macros.sv
`include "uvm_macros.svh"

//`include "tb_defs.sv"

`include "ahb_Mcfg.sv"
`include "ahb_Scfg.sv"
`include "env_cfg.sv"

`include "ahb_Mxtn.sv"
`include "ahb_Mdrv.sv"
`include "ahb_Mmon.sv"

`include "ahb_Mseqr.sv"
`include "ahb_Magt.sv"
`include "ahb_Mtop.sv"

`include "ahb_Mseqs.sv"

`include "ahb_Sxtn.sv"
`include "ahb_Smon.sv"
`include "ahb_Sseqr.sv"

`include "ahb_Sseqs.sv"
`include "ahb_Sdrv.sv"
`include "ahb_Sagt.sv"

`include "ahb_Stop.sv"
`include "scoreboard.sv"

`include "env.sv"

`include "test.sv"

endpackage
