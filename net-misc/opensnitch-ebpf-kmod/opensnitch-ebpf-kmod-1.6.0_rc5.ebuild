# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dist-kernel-utils linux-mod toolchain-funcs

DESCRIPTION="GNU/Linux application firewall"
HOMEPAGE="https://github.com/evilsocket/opensnitch"
# For some reason, they number their RC releases with a dot before the number,
# so this is explicit.
SRC_URI="
	https://github.com/evilsocket/opensnitch/archive/refs/tags/v1.6.0-rc.5.tar.gz
	-> ${PN}-${PV}.tar.gz
"
S=${WORKDIR}/opensnitch-1.6.0-rc.5

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
	systemd
"
EBPF_S="${WORKDIR}/opensnitch-1.6.0-rc.5/ebpf_prog"
KERNEL_PATH="${WORKDIR}/linux"
KERNEL_EBPF_PATH="${KERNEL_PATH}/samples/bpf"

BDEPEND="
	app-alternatives/bc
	sys-devel/clang
	sys-devel/llvm
	net-misc/rsync
"

DEPEND="
	sys-kernel/gentoo-kernel:=
	systemd? ( sys-apps/systemd )
	!systemd? ( sys-apps/openrc )
"

RDEPEND="
	${DEPEND}
"

pkg_setup() {
	# see https://github.com/evilsocket/opensnitch/issues/774
	# and https://github.com/evilsocket/opensnitch/tree/master/ebpf_prog
	CONFIG_CHECK="
		DEBUG_FS
		FTRACE
		CGROUP_BPF
		BPF
		BPF_SYSCALL
		BPF_EVENTS
		KPROBES
		KPROBES_ON_FTRACE
		HAVE_KPROBES
		HAVE_KPROBES_ON_FTRACE
		KPROBE_EVENTS
		HAVE_SYSCALL_TRACEPOINTS
		FTRACE_SYSCALLS
		UPROBE_EVENTS
	"

	kernel_is -ge 5 8 || die "Linux 5.8 or newer required"

	linux-mod_pkg_setup
}

src_prepare() {
	local link_contents kernel_dir
	default

	mkdir -p "${KERNEL_PATH}" || die
	link_contents=$(readlink /usr/src/linux)
	kernel_dir="/usr/src/${link_contents}"
	rsync -a "${kernel_dir}/" "${KERNEL_PATH}" --exclude arch/x86/boot || die
	#patch -b "${KERNEL_PATH}"/tools/lib/bpf/bpf_helpers.h < "${EBPF_S}"/file.patch || die

	local MY_SRC=(
		"${EBPF_S}/opensnitch.c"
		"${EBPF_S}/opensnitch-dns.c"
		"${EBPF_S}/opensnitch-procs.c"
		"${EBPF_S}/Makefile"
	)
	cd "${KERNEL_EBPF_PATH}"
	cp "${MY_SRC[@]}" . || die
}

src_configure() {
	set_arch_to_kernel
	yes "" | emake -C "${KERNEL_PATH}" oldconfig
	#emake -C "${KERNEL_PATH}" prepare
}

src_compile() {
	set_arch_to_kernel

	#emake -C "${KERNEL_PATH}"

	#emake -C "${KERNEL_PATH}" headers_install

	emake -C "${KERNEL_EBPF_PATH}"

	llvm-strip -g "${KERNEL_EBPF_PATH}"/opensnitch.o
}

src_install(){
	insinto /usr/lib/opensnitchd/ebpf/
	doins "${KERNEL_EBPF_PATH}"/opensnitch.o
	doins "${KERNEL_EBPF_PATH}"/opensnitch-dns.o
	doins "${KERNEL_EBPF_PATH}"/opensnitch-procs.o
}

pkg_postinst() {
	linux-mod_pkg_postinst

	set_arch_to_pkgmgr
	dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"

	#patch -R "${KERNEL_PATH}"/tools/lib/bpf/bpf_helpers.h
}
