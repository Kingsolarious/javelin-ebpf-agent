# javelin-ebpf-agent

we built this because erick wants to play Battlefield on his fucking ASUS ROG Ally.

That's it. That's the whole reason.

## why dump everything now

we have been working on this locally for about two months. kept it
offline while we fought the eBPF verifier. today nick decided to just
put it all up at once because he was tired of sitting on it.

he used some AI tools to help organize the upload because the local
files were a mess and hes been juggling too many projects. it probably
fucked some stuff up. if something looks wrong, thats why. the code
itself is real, he just got lazy with the repo organization.

## What this actually is

It's an eBPF program that sits in the Linux kernel and watches what
your game process is doing. It tells you when:

- Something changes memory from writable to executable (self-modifying code)
- A debugger attaches via ptrace
- Someone loads a kernel module
- Someone opens /proc/kallsyms (where kernel exploit code lives)
- Another eBPF program loads while your game is running

It doesn't block anything. It just reports. The verifier makes sure
it can't crash your kernel.

## Why eBPF and not a kernel module

Because kernel modules are bullshit.

They crash when you update your kernel. They need to be rebuilt for
every kernel version. They're proprietary black boxes that run in ring
0 with zero oversight. When EAC or BattlEye loads a kernel module,
you have no idea what it's doing.

eBPF is different. The kernel verifies the code before loading it.
If there's a bug, the kernel refuses to load it. It's auditable —
you can read all 154 lines and know exactly what it does.

And BTF/CO-RE means it works across kernel versions without rebuilding.

## What this is NOT

- This is NOT a finished anti-cheat
- This does NOT block cheaters
- This does NOT have a backend to talk to
- This does NOT have a publisher partner
- This does NOT detect everything

This is a piece of kernel telemetry. It reports events. What happens
with those events is someone else's problem.

## The honest security situation

If someone has root on your machine, they can unload this eBPF program
or patch it. We detect that and report it, but we can't stop it.

If someone loads a rootkit BEFORE this agent starts, we can't detect
that from inside the kernel. We check /proc/modules and Secure Boot
status, but a determined attacker can hide their module.

We don't have signing. We don't have a backend. We don't have EA's
certificate. This is infrastructure, not a product.

## Who built this

Nick, Erick, Dyllan. Three friends who met in real life. Nick
spearheaded this project and wrote most of the eBPF code.

Erick has an ASUS ROG Ally and an older ASUS laptop. He's mad he can't
play Battlefield. He lives in California.

Nick has a 2024 ASUS ROG Zephyrus G16 GU605MY. He debugged verifier
rejections for three days straight. He also lives in California,
California.

Dyllan has a 2026 ASUS TUF F16 with an RTX 5060. He moved to
Montana so we collaborate over Discord now.

We have day jobs. This is a nights-and-weekends project.

## Build it

```bash
make vmlinux
make
sudo ./build/javelin-loader build/javelin_monitor.bpf.o $(pidof your_game)
```

Needs: clang, libbpf-dev, bpftool, linux-headers. Kernel 5.15+ with BTF.

Tested on Bazzite 43, SteamOS 3.5, Fedora 43.

## Performance

Run `tests/memscan_benchmark.c` yourself. Numbers vary by hardware.

On nicks zephyrus G16 (the machine this was tested on):
- Memory scan: ~4,800–10,600 MB/s depending on block size
- Syscall latency: ~0.3–0.5 ms
- eBPF overhead: <1 µs per event

## License

GPL-2.0.

Contact: solarsystemsdsp@protonmail.com
