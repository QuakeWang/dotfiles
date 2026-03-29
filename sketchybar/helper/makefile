HELPER_BIN ?= helper

.PHONY: helper

helper: $(HELPER_BIN)

$(HELPER_BIN): helper.c cpu.h sketchybar.h
	clang -std=c99 -O3 helper.c -o "$(HELPER_BIN)"
