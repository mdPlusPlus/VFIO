FROM mdplusplus/dpkg-buildpackage_qemu_ubuntu

MAINTAINER mdPlusPlus

SHELL ["/bin/bash", "-c"]

VOLUME ["/root/out"]

#####################################
# Proven to work with libvirt 5.5.0 #
#####################################

# install build-dependencies for libvirt
RUN \
	cd /root/upstream/ && \
	apt install -y \
		./qemu-block-extra_*\.deb \
		./qemu-system-common_*\.deb \
		./qemu-utils_*\.deb

RUN \
	apt build-dep -y libvirt

RUN \
	cd /root/repo && \
	apt source libvirt

## TODO: MAYBE: don't execute everything as root

# upstream preparation
RUN \
	cd /root/upstream && \
	echo "https://libvirt.org/sources/$(curl -s https://libvirt.org/sources/ | grep -Po '(?<=href=")[^"]*' | grep \.tar\.xz | grep -v \.asc | tail -n 1)" | wget -i - && \
	tar xf libvirt-*.tar.xz && \
	cd libvirt-*/ && \
	LOGNAME=mdPlusPlus USER=mdPlusPlus dh_make -y -s -f ../libvirt-*.tar.xz && \
	cp debian/changelog ..

# replace upstream/debian with repo/debian and fix changelog
RUN \
	cd /root/upstream && \
	cd libvirt-*/ && \
	rm -r debian && \
	cp -r ../../repo/libvirt-*/debian . && \
	mv debian/changelog debian/changelog.orig && \
	mv ../changelog debian/changelog && \
	echo "" >> debian/changelog && \
	cat debian/changelog.orig >> debian/changelog && \
	rm debian/changelog.orig

## TODO: replace maintainers with mdPlusPlus in debian/control

# fix patches
# RUN sed -i 's//#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/debian\/Debianize-systemd-service-files.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series # TODO: backport!
RUN sed -i 's/debian\/Don-t-enable-default-network-on-boot.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/Reduce-udevadm-settle-timeout-to-10-seconds.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/debian\/Use-upstreams-polkit-rule.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/Allow-libvirt-group-to-access-the-socket.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series # applies, but causes: "Test failure:test_libvirtd.aug:49.3-107.31:"
RUN sed -i 's/ubuntu\/daemon-augeas-fix-expected.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/ubuntu_machine_type.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/apibuild-skip-libvirt-common.h/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/dnsmasq-as-priv-user/#&/g' /root/upstream/libvirt-*/debian/patches/series # applies, but causes "nat-network-mtu" to not pass
RUN sed -i 's/ubuntu\/avoid-restarting-virtlog-socket.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/md-clear.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/0032-apparmor-libvirt-qemu-Allow-reading-charm-specific-c.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/0033-UBUNTU-only-apparmor-for-kvm.powerpc-LP-1680384.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/lp-1804766-virt-aa-helper-generate-rules-for-gl-enabled-graphic.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1771662-util-fixing-wrong-assumption-that-PF-has-to-have-net.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1771662-util-Code-simplification.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1771662-util-Fix-for-NULL-dereference.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1771662-util-Fixing-invalid-error-checking-from-virPCIGetNet.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/lp-1815452-virt-aa-helper-rule.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/lp-1815452-more-gl-rules.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/lp-1817943-nvidia-gl-rules.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu-aa\/lp-1817943-devices-in-sysfs.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1825195-qemu-do-not-define-known-no-op-features.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/ubuntu\/lp-1825195-qemuxml2argvtest-add-test-for-remove-cpu-features.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-3886-1.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-3886-2.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10132-1.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10132-2.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10132-3.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10161.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10166.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10167.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series
RUN sed -i 's/CVE-2019-10168.patch/#&/g' /root/upstream/libvirt-*/debian/patches/series

# disable broken commandtest, hangs at dpkg-buildpackage
RUN \
	sed -i 's/commandtest seclabeltest \\/seclabeltest \\/g' /root/upstream/libvirt-*/tests/Makefile.am && \
	cd /root/upstream/libvirt-*/ && \
	EDITOR="/bin/true" dpkg-source --commit . commandtest.patch

# fix path
RUN \
	sed -i 's/rm debian\/libvirt-wireshark\/usr\/lib\/\*\/wireshark\/plugins\/\*\/\*.la/rm debian\/libvirt-wireshark\/usr\/lib\/\*\/wireshark\/plugins\/\*\/\*\/\*.la/g' /root/upstream/libvirt-*/debian/rules

# build packages
RUN \
	cd /root/upstream/libvirt-*/ && \
	dpkg-buildpackage -us -uc

# move files to /root/out
CMD \
	cd /root/upstream/ && \
	mv \
		./libvirt-clients_*\.deb \
		./libvirt-daemon_*\.deb \
		./libvirt-daemon-driver-storage-rbd_*\.deb \
		./libvirt-daemon-system_*\.deb \
		./libvirt0_*\.deb \
		/root/out
