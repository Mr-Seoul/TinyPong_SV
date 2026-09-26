UVM_HOME ?=
TOP       = tb_top
TEST     ?= vga_test

ifeq ($(UVM_HOME),)
$(error UVM_HOME is not set. Point it at a checkout of Accellera's uvm-core)
endif

VERILATOR_FLAGS = \
	--binary \
	--timing \
	-sv \
	-j 4 \
	--coverage \
	+define+UVM_NO_DPI \
	+incdir+$(UVM_HOME)/src \
	$(UVM_HOME)/src/uvm_pkg.sv \
	-f files.f \
	--top-module $(TOP) \
	+define+VIF_TYPE="virtual vga_if"

.PHONY: all sim clean

all: sim

sim:
	verilator $(VERILATOR_FLAGS)
	obj_dir/V$(TOP) +UVM_TESTNAME=$(TEST)

clean:
	rm -rf obj_dir
