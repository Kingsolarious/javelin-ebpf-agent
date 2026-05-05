# Security Notes

April 2026. We reviewed our own code because there's no budget for a
paid audit.

## What we checked

- Manual code review of all C and eBPF
- GCC 15.2.1 and Clang 21.1.8 builds
- clang-tidy static analysis
- Runtime testing with unit tests and benchmarks

## Issues we fixed

- Loader continued as root if `SUDO_UID` missing → now aborts
- `MAP_FIXED` without `NOREPLACE` → fixed
- NULL pointer dereferences in syscall proxy → added checks
- `prctl(PR_SET_DUMPABLE, 0)` failure ignored → now returns error

## What the eBPF verifier guarantees

- No unbounded loops
- No raw pointer arithmetic
- Cannot modify kernel state
- Reports only via ring buffer

## What we CANNOT guarantee

- **Pre-boot compromise:** If a rootkit loads before our agent, we
  can't detect it from inside the kernel. We check /proc/modules and
  Secure Boot status, but a determined attacker can hide their module.

- **eBPF subsystem compromise:** If the verifier or `bpf()` syscall is
  patched before our agent loads, our hash checks are meaningless.

- **Shim tampering:** The userland shim is open-source. An attacker can
  modify and recompile it. We don't have signing infrastructure yet.

- **No backend:** There is no game backend to verify reports. We built
  the client agent. Backend integration is a separate problem.

## What this protects against

- Casual cheaters unloading a kernel module
- Off-the-shelf cheat tools that use ptrace
- Self-modifying code (W→X transitions)

## What this does NOT protect against

- Determined attackers with root who patch the kernel first
- Nation-state level adversaries
- Hardware-level attacks

## If you're EA

Hire a real red team. Don't trust our self-review. This is a starting
point, not a finished product.
