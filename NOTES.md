# random notes

## shit that broke

- verifier rejected `bpf_probe_read_user_str` with stack array. had to use a map.
- `vmlinux.h` is 50k lines and takes 3 seconds to generate. we commit it anyway.
- `MAP_FIXED_NOREPLACE` doesn't exist on kernels < 4.17. we don't care.
- libbpf 1.0 changed the API. had to rewrite the loader. nick was angry.
- ROG ally kernel has BTF but `bpftool` isn't installed by default. had to use distrobox.

## things we still need to do

- [ ] actually test on a real game (we don't have bf6 dev build lol)
- [ ] figure out how to sign the shim without ea's help
- [ ] write a better kallsyms detector (current one is jank)
- [ ] add timer anomaly detection (speed hacks)
- [ ] get a real domain instead of protonmail
- [ ] dyllan wants to add a gui. we told him no.

## random numbers

bench on nicks zephyrus G16 (2026-04-28):
self-read 64mb: 4833 mb/s
mprotect 4mb: 0.44 us

run it yourself. your numbers will be different.

## people who helped

- some guy on r/ebpf pointed out we forgot `bpf_object__close` on error path
- stackoverflow user "kalevk" for the process_vm_readv chunking code
- the cilium ebpf docs, genuinely the best resource

## people who were dicks

- some guy on discord who said "this is ai slop" without reading the code
- another guy who said "ea will never care" as if we didn't already know that

## what we want

1. battlefield on ROG ally
2. ea sports fc on ROG ally
3. maybe madden if we're being greedy
4. a cease and desist from ea would also be funny
