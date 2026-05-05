# Security

Email vulnerabilities to: solarsystemsdsp@protonmail.com

We'll respond within 48 hours. Critical issues (kernel panic, privilege
escalation) get fixed within 72 hours.

## Scope

- eBPF program logic that could crash the kernel
- Loader privilege handling
- Ring buffer data exfiltration
- UNIX socket access control

## Design

The eBPF programs are read-only reporters. They cannot block syscalls,
modify kernel state, or access arbitrary memory. If you find a way to
violate these constraints, that's critical and we want to know.

## Audit

April 2026: Self-assessment completed. Zero critical/high findings. Two
medium issues fixed during review.

## Bug bounty

No paid program. Public acknowledgment and CVE credit for verified
reports.
