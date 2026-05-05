# Notes

## Known Issues

- Verifier rejects `bpf_probe_read_user_str` with stack arrays on some kernels. Character-by-character unrolling required.
- `vmlinux.h` generation requires bpftool and `/sys/kernel/btf/vmlinux`.
- `MAP_FIXED_NOREPLACE` unavailable on kernels < 4.17. Falls back to `MAP_FIXED`.
- libbpf 1.0+ API changes require loader updates on older distributions.
- Steam Deck LCD lacks `CONFIG_BPF_LSM`. Steam Deck OLED includes it.
- Fedora 42 verifier stricter than Bazzite 43 on identical kernel versions.

## TODO

- [ ] Test with real game process
- [ ] Shim signing strategy
- [ ] Improved kallsyms detector
- [ ] Domain migration from protonmail

## Benchmarks

2026-04-28 — ASUS ROG Zephyrus G16:
- Self-read 64 MB: 4,833 MB/s
- mprotect toggle 4 MB: 0.44 µs
