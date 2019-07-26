FROM ubuntu:rolling
#FROM ubuntu:disco

MAINTAINER mdPlusPlus

SHELL ["/bin/bash", "-c"]

VOLUME ["/root/out"]

###############################
# Proven to work with 4.1-rc1 #
###############################

RUN \
	sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN \
	apt update

RUN \
	apt install -y \
		dpkg-dev \
		curl \
		wget \
		dh-make 

# required by QEMU, but not listed as build-dependency
RUN \
	apt install -y \
		bison \
		flex

RUN \
	apt build-dep -y qemu

## TODO: add flex + bison to build-dependencies in debian/control

RUN \
	cd /root && \
	mkdir repo upstream

RUN \
	cd /root/repo && \
	apt source qemu

RUN \
	useradd mdPlusPlus

## TODO: MAYBE: don't execute everything as root

# upstream preparation
RUN \
	cd /root/upstream && \
	curl -s "https://www.qemu.org/download/#source" | grep https://download.qemu.org/qemu- | grep -Po '(?<=href=")[^"]*' | grep -v \.sig | sort -Vru | head -n 1 | wget -i - && \
	tar xf qemu-*.tar.xz && \
	cd qemu-*/ && \
	LOGNAME=mdPlusPlus USER=mdPlusPlus dh_make -y -s -f ../qemu-*.tar.xz && \
	cp debian/changelog ..

# replace upstream/debian with repo/debian and fix changelog
RUN \
	cd /root/upstream && \
	cd qemu-*/ && \
	rm -r debian && \
	cp -r ../../repo/qemu-*/debian . && \
	mv debian/changelog debian/changelog.orig && \
	mv ../changelog debian/changelog && \
	echo "" >> debian/changelog && \
	cat debian/changelog.orig >> debian/changelog && \
	rm debian/changelog.orig

# fix epoch, example: (2.2.1) -> (1:2.2.1)
RUN \
	sed  -i '0,/(/{s//(1:/}' /root/upstream/qemu-*/debian/changelog

## TODO: replace maintainers with mdPlusPlus in debian/control

# fix patches
# RUN sed -i 's//#/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/use-fixed-data-path.patch/#use-fixed-data-path.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/do-not-link-everything-with-xen.patch/#do-not-link-everything-with-xen.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/usb-mtp-use-O_NOFOLLOW-and-O_CLOEXEC-CVE-2018-16872.patch/#usb-mtp-use-O_NOFOLLOW-and-O_CLOEXEC-CVE-2018-16872.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/bt-use-size_t-type-for-length-parameters-instead-of-int-CVE-2018-19665.patch/#bt-use-size_t-type-for-length-parameters-instead-of-int-CVE-2018-19665.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/hw_usb-fix-mistaken-de-initialization-of-CCID-state.patch/#hw_usb-fix-mistaken-de-initialization-of-CCID-state.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/scsi-generic-avoid-possible-oob-access-to-r-buf-CVE-2019-6501.patch/#scsi-generic-avoid-possible-oob-access-to-r-buf-CVE-2019-6501.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/slirp-check-data-length-while-emulating-ident-function-CVE-2019-6778.patch/#slirp-check-data-length-while-emulating-ident-function-CVE-2019-6778.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/i2c-ddc-fix-oob-read-CVE-2019-3812.patch/#i2c-ddc-fix-oob-read-CVE-2019-3812.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/enable-svm-by-default.patch/#ubuntu\/enable-svm-by-default.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/define-ubuntu-machine-types.patch/#ubuntu\/define-ubuntu-machine-types.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/pre-bionic-256k-ipxe-efi-roms.patch/#ubuntu\/pre-bionic-256k-ipxe-efi-roms.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1759509-qmp-query-current-machine-with-wakeup-suspend-suppor.patch/#ubuntu\/lp-1759509-qmp-query-current-machine-with-wakeup-suspend-suppor.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1759509-qga-update-guest-suspend-ram-and-guest-suspend-hybri.patch/#ubuntu\/lp-1759509-qga-update-guest-suspend-ram-and-guest-suspend-hybri.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1759509-qmp-hmp-Make-system_wakeup-check-wake-up-support-and.patch/#ubuntu\/lp-1759509-qmp-hmp-Make-system_wakeup-check-wake-up-support-and.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1790901-partial-SLOF-for-s390x-netboot.patch/#ubuntu\/lp-1790901-partial-SLOF-for-s390x-netboot.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/Revert-target-i386-kvm-add-VMX-migration-blocker.patch/#ubuntu\/Revert-target-i386-kvm-add-VMX-migration-blocker.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1812384-s390x-Return-specification-exception-for-unimplement.patch/#ubuntu\/lp-1812384-s390x-Return-specification-exception-for-unimplement.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1812384-s390x-Return-specification-exception-for-unimplement.patch/#ubuntu\/lp-1812384-s390x-Return-specification-exception-for-unimplement.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1812384-s390x-Return-specification-exception-for-unimplement.patch/#ubuntu\/lp-1812384-s390x-Return-specification-exception-for-unimplement.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/enable-md-clear.patch/#ubuntu\/enable-md-clear.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/enable-md-no.patch/#ubuntu\/enable-md-no.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/CVE-2018-20815.patch/#ubuntu\/CVE-2018-20815.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/CVE-2019-5008.patch/#ubuntu\/CVE-2019-5008.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/CVE-2019-9824.patch/#ubuntu\/CVE-2019-9824.patch/g' /root/upstream/qemu-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1830704-s390x-cpumodel-ignore-csske-for-expansion.patch/#ubuntu\/lp-1830704-s390x-cpumodel-ignore-csske-for-expansion.patch/g' /root/upstream/qemu-*/debian/patches/series

# fix "ERROR: unknown option --with-sdlabi=2.0"
RUN \
	cd /root/upstream/qemu-*/ && \
	sed -i 's/--with-sdlabi=2.0//g' debian/control-in

# disable user builds to fix "make[1]: *** No rule to make target 'subdir-i386-linux-user'.  Stop."
RUN \
	sed -i 's/enable_linux_user = $(if $(filter qemu-user,${BUILD_PACKAGES}),enable,disable)/enable_linux_user = disable/g' /root/upstream/qemu-*/debian/rules

# remove missing files
RUN \
	sed -i 's/pc-bios\/qemu-icon.bmp usr\/share\/qemu/#pc-bios\/qemu-icon.bmp usr\/share\/qemu/g' /root/upstream/qemu-*/debian/qemu-system-data.install && \
	sed -i 's/pc-bios\/qemu_logo_no_text.svg usr\/share\/qemu/#pc-bios\/qemu_logo_no_text.svg usr\/share\/qemu/g' /root/upstream/qemu-*/debian/qemu-system-data.install

RUN \
	sed -i 's/mv debian\/tmp\/usr\/share\/man\/man1\/qemu.1 debian\/tmp\/usr\/share\/man\/man1\/qemu-system.1/#mv debian\/tmp\/usr\/share\/man\/man1\/qemu.1 debian\/tmp\/usr\/share\/man\/man1\/qemu-system.1/g' /root/upstream/qemu-*/debian/rules

RUN \
	sed -i '/usr\/share\/man\/man1\/virtfs-proxy-helper.1 \\/d' /root/upstream/qemu-*/debian/rules

# remove all doc and man entries in all debian/*.install files?
RUN \
	sed -i '/\/man\//d' /root/upstream/qemu-*/debian/*.install && \
	sed -i '/\/doc\//d' /root/upstream/qemu-*/debian/*.install

# build packages
RUN \
	cd /root/upstream/qemu-*/ && \
	dpkg-buildpackage -us -uc

# move files to /root/out
CMD \
	cd /root/upstream/ && \
	mv \
		./qemu-block-extra_*\.deb \
		./qemu-kvm_*\.deb \
		./qemu-system-common_*\.deb \
		./qemu-system-data_*\.deb \
		./qemu-system-gui_*\.deb \
		./qemu-system-x86_*\.deb \
		./qemu-utils_*\.deb \
		/root/out
