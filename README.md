# javelin-ebpf-agent

eBPF LSM agent for process security telemetry.

## Overview

Monitors kernel security events via LSM hooks and tracepoints:
- Memory protection changes (W->X transitions)
- Debugger attachment via ptrace
- Kernel module loading
- `/proc/kallsyms` access
- Foreign eBPF program loading
- Timer anomalies (speed hack detection)

Emits events only. Does not block or modify kernel state.

## Building

```bash
make vmlinux
make
sudo ./build/javelin-loader build/javelin_monitor.bpf.o $(pidof <target>)
```

### Requirements

- Linux kernel 5.15+
- `CONFIG_BPF=y`, `CONFIG_BPF_LSM=y`, `CONFIG_DEBUG_INFO_BTF=y`
- clang, libbpf-dev, bpftool, linux-headers

### Distro Notes

- Ubuntu 22.04 ships libbpf 0.5 (too old). Use PPA or build from source.
- Fedora 43: works out of box.
- SteamOS 3.5: BTF available; bpftool must be installed separately.

## Performance

Run `make bench && ./build/memscan_benchmark` for local measurements.

Example results (ASUS ROG Zephyrus G16, Bazzite 43, kernel 6.17.7):
- Memory scan: 4,800–10,600 MB/s (block-size dependent)
- Syscall latency: 0.3–0.5 ms
- eBPF overhead: <1 µs per event

## License

GPL-2.0
