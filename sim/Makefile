#Makefile for AHB LITE UVM Testbench

# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = Questa

RTL      = ../rtl/*
WORK     = work
SVTB1    = ../tb/top.sv
SVTB2    = ../test/pkg.sv

INC      = +incdir+../tb \
           +incdir+../test \
           +incdir+../AHB_Master \
           +incdir+../AHB_Slave

VSIMOPT  = -vopt -voptargs=+acc
VSIMCOV  = -coverage -sva

VSIMBATCH1 = -c -do "log -r /* ; coverage save -onexit ahb_cov1 ; run -all ; exit"
VSIMBATCH2 = -c -do "log -r /* ; coverage save -onexit ahb_cov2 ; run -all ; exit"
VSIMBATCH3 = -c -do "log -r /* ; coverage save -onexit ahb_cov3 ; run -all ; exit"

UVM_VERB   = +UVM_VERBOSITY=UVM_MEDIUM

# -----------------------------------------------------------------------
# Phony targets
# -----------------------------------------------------------------------
.PHONY: help clean sv_cmp \
        run_test1 run_test2 run_test3 \
        view_wave1 view_wave2 view_wave3 \
        regress report cov

help:
        @echo "=============================================================================="
        @echo "  USAGE  --  make <target>"
        @echo "=============================================================================="
        @echo "  clean       =>  Remove logs, coverage, waveform, and work library."
        @echo "  sv_cmp      =>  Create library and compile all RTL + TB sources."
        @echo "  run_test1   =>  clean + compile + run test1  (single_write_read_test)."
        @echo "  run_test2   =>  clean + compile + run test2  (burst_write_read_test)."
        @echo "  run_test3   =>  clean + compile + run test3  (error_response_test)."
        @echo "  view_wave1  =>  Open waveform for test1 in QuestaSim."
        @echo "  view_wave2  =>  Open waveform for test2 in QuestaSim."
        @echo "  view_wave3  =>  Open waveform for test3 in QuestaSim."
        @echo "  regress     =>  Run all tests sequentially and merge coverage."
        @echo "  report      =>  Merge coverage databases and generate HTML report."
        @echo "  cov         =>  Open merged HTML coverage report in Firefox."
        @echo "=============================================================================="

# -----------------------------------------------------------------------
# Dispatcher – forwards each generic target to the simulator-specific one
# -----------------------------------------------------------------------
clean      : clean_$(SIMULATOR)
sv_cmp     : sv_cmp_$(SIMULATOR)
run_test1  : run_test1_$(SIMULATOR)
run_test2  : run_test2_$(SIMULATOR)
run_test3  : run_test3_$(SIMULATOR)
view_wave1 : view_wave1_$(SIMULATOR)
view_wave2 : view_wave2_$(SIMULATOR)
view_wave3 : view_wave3_$(SIMULATOR)
regress    : regress_$(SIMULATOR)
report     : report_$(SIMULATOR)
cov        : cov_$(SIMULATOR)

# -----------------------------------------------------------------------
# Mentor QuestaSim targets
# -----------------------------------------------------------------------

# --- Compile ---
sv_cmp_Questa:
        vlib $(WORK)
        vmap work $(WORK)
        vlog -work $(WORK) $(RTL) $(INC) $(SVTB2) $(SVTB1)

# --- Run tests ---
run_test1_Questa: clean_Questa sv_cmp_Questa
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) \
             -wlf wave_file1.wlf -l test1.log -sv_seed random \
             work.top $(UVM_VERB) +UVM_TESTNAME=test1
        vcover report -cvg -details -nocompactcrossbins \
                      -codeAll -assert -directive -html ahb_cov1

run_test2_Questa: clean_Questa sv_cmp_Questa
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2) \
             -wlf wave_file2.wlf -l test2.log -sv_seed random \
             work.top $(UVM_VERB) +UVM_TESTNAME=test2
        vcover report -cvg -details -nocompactcrossbins \
                      -codeAll -assert -directive -html ahb_cov2

run_test3_Questa: clean_Questa sv_cmp_Questa
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3) \
             -wlf wave_file3.wlf -l test3.log -sv_seed random \
             work.top $(UVM_VERB) +UVM_TESTNAME=test3
        vcover report -cvg -details -nocompactcrossbins \
                      -codeAll -assert -directive -html ahb_cov3

# --- View waveforms ---
view_wave1_Questa:
        vsim -view wave_file1.wlf

view_wave2_Questa:
        vsim -view wave_file2.wlf

view_wave3_Questa:
        vsim -view wave_file3.wlf

# --- Regression (all tests) ---
regress_Questa: clean_Questa \
                run_test1_Questa \
                run_test2_Questa \
                run_test3_Questa \
                report_Questa

# --- Coverage merge + HTML report ---
report_Questa:
        vcover merge ahb_cov ahb_cov1 ahb_cov2 ahb_cov3
        vcover report -cvg -details -nocompactcrossbins \
                      -codeAll -assert -directive -html ahb_cov

# --- Open coverage in browser ---
cov_Questa:
        firefox covhtmlreport/index.html &

# --- Clean ---
clean_Questa:
        rm -rf transcript* *.log fcover* covhtml* ahb_cov* *.wlf modelsim.ini $(WORK)
        clear
