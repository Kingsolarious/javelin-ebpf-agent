# Benchmarks

ASUS ROG Zephyrus G16 GU605MY, Bazzite 43, kernel 6.17.7, GCC 15.2.1.

Nick's machine. Run these yourself. Your numbers will differ.

## Memory scan

| Test | Size | Result |
|------|------|--------|
| Self-read | 4 MB | 10,631 MB/s |
| Self-read | 16 MB | 6,196 MB/s |
| Self-read | 64 MB | 4,833 MB/s |
| Chunked 4 KB | 64 MB | 1,622 MB/s |
| Chunked 64 KB | 64 MB | 1,611 MB/s |

## Syscall latency

| Test | Size | Latency |
|------|------|---------|
| process_vm_readv | 4 MB | 0.37 ms |
| process_vm_readv | 16 MB | 2.58 ms |
| process_vm_readv | 64 MB | 13.2 ms |
| mprotect toggle | 4 MB | 0.44 µs |
| mprotect toggle | 64 MB | 0.52 µs |

## eBPF overhead

The programs fire on security events only:
- mprotect exec
- ptrace attach
- module load
- kallsyms access
- foreign eBPF load

These are rare in normal gaming. Per-event execution is <1 µs
(verifier-enforced).

Estimated FPS impact: below measurement threshold on our hardware.

## Reproduce

```bash
make bench
./build/memscan_benchmark
```

Requires Linux 5.15+ with CONFIG_CROSS_MEMORY_ATTACH=y.
