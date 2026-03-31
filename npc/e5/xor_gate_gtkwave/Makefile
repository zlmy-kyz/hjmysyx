TOP_NAME := top
CPP_NAME := sim_main.cpp


all:
	@echo "Write this Makefile by your self."

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	verilator --cc --trace-fst --exe --build -j 0 -Wall -Ivsrc csrc/$(CPP_NAME) vsrc/$(TOP_NAME).v
	./obj_dir/V$(TOP_NAME)
	gtkwave top.fst

clean:
	rm -rf obj_dir
	rm -rf $(TOP_NAME).fst
include ../../Makefile