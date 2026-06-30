`timescale 1ns/10ps

module top;

import pkg::*;

import uvm_pkg::*;

bit clock;

ahb_if in(clock);

always #5 clock=!clock;


initial
begin


        uvm_config_db #(virtual ahb_if)::set(null,"*","in",in);

        run_test();


end
endmodule
