TOP_MODULE := top
SIM_CPP := sim_main.cpp

all:
	@echo "Write this Makefile by your self."

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	verilator --cc --trace-fst --exe --build -j 0 -Wall csrc/$(SIM_CPP) vsrc/$(TOP_MODULE).v
	./obj_dir/V$(TOP_MODULE)
	gtkwave $(TOP_MODULE).fst
 
include ../Makefile