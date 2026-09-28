UVM_HOME ?=
TOP       = tb_top
TEST      = debouncer_test
DEBOUNCER_SIZE ?= 8
FRAME_LENGTH   ?= 1000

ifeq ($(UVM_HOME),)
$(error UVM_HOME is not set. Point it at a checkout of Accellera's uvm-core)
endif

VERILATOR_FLAGS = \
	--binary \
	--timing \
	-sv \
	-j 0 \
	+define+UVM_NO_DPI \
	--coverage \
	+incdir+$(UVM_HOME)/src \
	$(UVM_HOME)/src/uvm_pkg.sv \
	-f files.f \
	--top-module $(TOP) \
	+define+VIF_TYPE="virtual debouncer_if" \
	+define+DEBOUNCER_SIZE=$(DEBOUNCER_SIZE) \
	+define+FRAME_LENGTH=$(FRAME_LENGTH)

.PHONY: all sim clean

all: sim

sim:
	verilator $(VERILATOR_FLAGS)
	obj_dir/V$(TOP) +UVM_TESTNAME=$(TEST)

clean:
	rm -rf obj_dir
