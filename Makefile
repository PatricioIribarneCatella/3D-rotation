# simulation
COMPONENT = 
SIMDIR = simul
SIMBIN = $(COMPONENT)_tb

# ghdl
GHDLCMD = ghdl

view:
	gunzip --stdout $(SIMDIR)/$(SIMBIN).vcdgz | gtkwave --vcd &

clean:
	rm -rf $(SIMDIR)/
	rm -rf scripts/__pycache__

lint:
	python3 -m vsg --fix -c .vsg_config.json

.PHONY: clean lint view
