# Javelin vs Existing Linux Anti-Cheat

## Correction

Earlier versions of this doc incorrectly stated that EAC and BattlEye
Linux use kernel modules. They do not. They are userspace-based. That
was our mistake — we confused the Windows kernel-driver architecture
with the Linux port.

This doc has been corrected.

## Architecture

| | EAC Linux | BattlEye Linux | Javelin |
|---|---|---|---|
| Kernel interface | Userspace + some kernel access | Userspace + some kernel access | eBPF LSM hooks |
| Auditable | No | No | Yes (open source) |
| Community trust | Low | Low | Higher (auditable) |
| Steam Deck | Whitelisted titles | Whitelisted titles | Universal (if adopted) |

## User Experience

| | EAC / BattlEye | Javelin |
|---|---|---|
| First launch | Game-bundled installer | Package manager or systemd |
| Kernel updates | May break | BTF/CO-RE portable |
| Uninstall | May leave residue | Package remove |

## What we actually do differently

EAC and BattlEye Linux are closed-source userspace anti-cheat solutions.
They work fine for whitelisted titles. We are not trying to replace them.

Javelin is an open-source eBPF telemetry agent. It does not block
cheats. It reports security events (memory changes, debuggers, module
loads) to a backend that decides what to do with them.

Whether this is better or worse than EAC/BattlEye is not the point. The
point is: no publisher currently uses eBPF for anti-cheat telemetry, and
we think it's worth exploring.

## Honest limitations

- No publisher partner yet
- No backend integration yet
- No signing infrastructure yet
- Pre-boot compromise detection requires Secure Boot (not enforced on
  most Linux gaming distros)

## Bottom line

We built this because we want Battlefield on Steam Deck. EAC and
BattlEye don't support it. We're exploring whether eBPF telemetry could
fill that gap. That's it.
