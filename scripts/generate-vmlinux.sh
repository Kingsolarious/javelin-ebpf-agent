#!/bin/bash
# Generate vmlinux.h from the running kernel's BTF.
# Run once per build machine (or download a pre-generated header).

set -euo pipefail

VMLINUX_H="${1:-src/vmlinux.h}"

if ! command -v bpftool >/dev/null 2>&1; then
    echo "ERROR: bpftool is required but not installed."
    echo "  Fedora: sudo dnf install bpftool"
    echo "  Ubuntu: sudo apt install linux-tools-common linux-tools-generic"
    echo "  Arch:   sudo pacman -S bpftool"
    exit 1
fi

if [ ! -f /sys/kernel/btf/vmlinux ]; then
    echo "ERROR: Kernel BTF not available at /sys/kernel/btf/vmlinux"
    echo "  Your kernel may need CONFIG_DEBUG_INFO_BTF=y"
    echo "  Most modern distros (Fedora 38+, Ubuntu 22.04+, Arch) enable this by default."
    exit 1
fi

echo "Generating ${VMLINUX_H} from $(uname -r)..."
mkdir -p "$(dirname "$VMLINUX_H")"
bpftool btf dump file /sys/kernel/btf/vmlinux format c > "$VMLINUX_H"
echo "Done. $(wc -l < "$VMLINUX_H") lines generated."
