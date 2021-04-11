ASM := nasm
VM := qemu-system-i386

SRC_DIR := src
OUT_DIR := _build

SRC := boot.s

ASM_SEARCH_PATH := $(SRC_DIR)

PROGRAM := $(OUT_DIR)/boot.img
PROGRAM_LIST := $(patsubst %.img,%.list,&(PROGRAM))

.PHONY: all
all: ;

.PHONY: run
run: test
	$(VM) -m size=256 -drive file=$(PROGRAM),format=raw -boot order=c -rtc base=localtime -nographic

.PHONY: test
test:
	$(MAKE) -B $(PROGRAM) PROJECT=$(SRC_DIR)

$(PROGRAM): $(foreach f,$(patsubst %.s,%.bin, $(SRC)),$(OUT_DIR)/$(f)) 
	cat $^ > $(PROGRAM)

$(OUT_DIR)/%.bin: $(PROJECT)/%.s
	$(ASM) $< -I$(ASM_SEARCH_PATH) \
	    -o $@ \
	    -l $(patsubst %.bin,%.list,$@) -I $(PROJECT)

.PHONY: clean
clean:
	@if [ ! -d $(OUT_DIR)]; then \
		echo "creating $(OUTDIR) directory..."; \
		mkdir $(OUTDIR); \
	fi
	rm $(OUT_DIR)/*

