# Javelin eBPF Agent — Build System
# Requires: clang, libbpf-dev, bpftool, linux-headers

CC        ?= gcc
CLANG     ?= clang
ARCH      := $(shell uname -m | sed 's/x86_64/x86/')
BPF_FLAGS  = -target bpf -D__TARGET_ARCH_$(ARCH) -g -O2

PREFIX    ?= /usr/local
BINDIR    ?= $(PREFIX)/bin
SYSTEMD_UNIT_DIR ?= /etc/systemd/system

# Paths
VMLINUX_H := src/vmlinux.h
BPF_OBJ   := build/javelin_monitor.bpf.o
LOADER    := build/javelin-loader
BENCH     := build/memscan_benchmark

# ---------------------------------------------------------------------------
# Default target
# ---------------------------------------------------------------------------
.PHONY: all clean install uninstall check vmlinux

all: $(BPF_OBJ) $(LOADER)

# ---------------------------------------------------------------------------
# vmlinux.h generation (one-time setup)
# ---------------------------------------------------------------------------
vmlinux:
	@echo "Generating vmlinux.h from running kernel BTF..."
	@mkdir -p src
	bpftool btf dump file /sys/kernel/btf/vmlinux format c > $(VMLINUX_H)
	@echo "Generated $(VMLINUX_H)"

# ---------------------------------------------------------------------------
# eBPF object
# ---------------------------------------------------------------------------
$(BPF_OBJ): src/javelin_monitor.bpf.c $(VMLINUX_H)
	@mkdir -p build
	$(CLANG) $(BPF_FLAGS) -c $< -o $@
	@echo "Built $@"

# Fallback: if vmlinux.h is missing, try to generate it automatically
src/javelin_monitor.bpf.c: $(VMLINUX_H)

$(VMLINUX_H):
	@if ! command -v bpftool >/dev/null 2>&1; then \
		echo "ERROR: bpftool not found. Install linux-tools or bpftool package."; \
		echo "Alternatively, download a pre-generated vmlinux.h for your distro."; \
		exit 1; \
	fi
	$(MAKE) vmlinux

# ---------------------------------------------------------------------------
# Userspace loader
# ---------------------------------------------------------------------------
$(LOADER): src/loader.c
	@mkdir -p build
	$(CC) -O2 -Wall -Wextra $< -o $@ -lbpf -lelf -lz
	@echo "Built $@"

# ---------------------------------------------------------------------------
# Benchmark (optional)
# ---------------------------------------------------------------------------
bench: $(BENCH)

$(BENCH): tests/memscan_benchmark.c
	@mkdir -p build
	$(CC) -O2 -Wall $< -o $@
	@echo "Built $@"

# ---------------------------------------------------------------------------
# Test
# ---------------------------------------------------------------------------
check: $(BPF_OBJ) $(LOADER)
	@echo "=== eBPF object verification ==="
	bpftool gen object $@.tmp.o $(BPF_OBJ) || true
	@rm -f $@.tmp.o
	@echo "=== Loader dry-run ==="
	$(LOADER) $(BPF_OBJ) 2>&1 || true
	@echo "=== Benchmark ==="
	$(MAKE) bench
	$(BENCH)

# ---------------------------------------------------------------------------
# Install
# ---------------------------------------------------------------------------
install: all
	install -Dm755 $(LOADER) $(DESTDIR)$(BINDIR)/javelin-loader
	install -Dm644 $(BPF_OBJ) $(DESTDIR)$(PREFIX)/lib/javelin/javelin_monitor.bpf.o
	install -Dm644 scripts/javelin-loader.service $(DESTDIR)$(SYSTEMD_UNIT_DIR)/javelin-loader.service || true
	@echo "Installed. Run 'systemctl enable --now javelin-loader' to start."

# ---------------------------------------------------------------------------
# Uninstall
# ---------------------------------------------------------------------------
uninstall:
	rm -f $(DESTDIR)$(BINDIR)/javelin-loader
	rm -rf $(DESTDIR)$(PREFIX)/lib/javelin
	rm -f $(DESTDIR)$(SYSTEMD_UNIT_DIR)/javelin-loader.service

# ---------------------------------------------------------------------------
# Clean
# ---------------------------------------------------------------------------
clean:
	rm -rf build/

# ---------------------------------------------------------------------------
# Development helpers
# ---------------------------------------------------------------------------
fmt:
	clang-format -i src/*.c src/*.h 2>/dev/null || true

lint:
	clang-tidy src/loader.c -- $(shell pkg-config --cflags libbpf 2>/dev/null) 2>/dev/null || true
