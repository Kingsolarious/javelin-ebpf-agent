# javelin-ebpf-agent

erick wants to play battlefield on his asus ROG ally. this is the eBPF
agent that watches what the game process is doing.

## what this is

an experimental linux telemetry agent for games that use kernel-level
anti-cheat. the eBPF agent monitors kernel events via LSM hooks and
tracepoints — no kernel modules, no rootkit behavior.

it tells you when:
- memory changes from writable to executable (self-modifying code)
- a debugger attaches via ptrace
- someone loads a kernel module
- someone opens /proc/kallsyms
- another eBPF program loads while the game is running

it doesnt block anything. just reports. the verifier makes sure it cant
crash your kernel.

**whats actually novel here:**
- eBPF LSM hooks for anti-cheat telemetry (no publisher does this)
- CO-RE compatible eBPF (works across kernel versions without recompilation)
- memory integrity baseline: hashes .text regions on W->X transitions
- timer anomaly detection via `clock_gettime` syscall tracing
- privilege-dropping loader (loads eBPF, then drops to user)

**honest limitations:**
- this is kernel telemetry, not a finished anti-cheat
- no backend exists yet. reports go nowhere.
- no publisher partner. this is a proof of concept.
- if someone has root before this loads, they can bypass it
- the kallsyms detector is jank. it works but its ugly.

## why eBPF and not a kernel module

kernel modules crash when you update your kernel. they need rebuilding
for every version. theyre proprietary black boxes running in ring 0.

eBPF is different. the kernel verifies the code before loading. if theres
a bug, the kernel refuses to load it. its auditable — you can read all
the code and know exactly what it does.

BTF/CO-RE means it works across kernel versions without rebuilding.

## build it

```bash
make vmlinux
make
sudo ./build/javelin-loader build/javelin_monitor.bpf.o $(pidof your_game)
```

needs: clang, libbpf-dev, bpftool, linux-headers. kernel 5.15+ with BTF.

**distro quirks:**
- ubuntu 22.04 ships libbpf 0.5 which is too old. use the ppa or build from source.
- fedora 43 works out of the box. fedora 42 needed a kernel arg for BPF_LSM.
- steamos 3.5 has BTF but bpftool is missing. install it via pacman.
- bazzite 43 works. bazzite 41 needed `rpm-ostree karg` for BPF_LSM.

tested on bazzite 43, steamos 3.5, fedora 43.

## performance

run `tests/memscan_benchmark.c` yourself. numbers vary by hardware.

on nicks zephyrus G16 (the machine this was tested on):
- memory scan: ~4,800–10,600 MB/s depending on block size
- syscall latency: ~0.3–0.5 ms
- eBPF overhead: <1 µs per event

## who built this

nick, erick, dyllan. three friends who met in real life.

nick wrote most of the eBPF code and debugged verifier rejections for
three days straight. he has a 2024 asus ROG zephyrus G16 GU605MY and
lives in california.

erick has an asus ROG ally and wants to play battlefield. he also lives
in california.

dyllan has a 2026 asus tuf F16 with an RTX 5060. he moved to montana so
we collaborate over discord now.

this is a nights-and-weekends project. we have day jobs.

## license

GPL-2.0.

contact: solarsystemsdsp@protonmail.com
