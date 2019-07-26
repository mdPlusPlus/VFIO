FROM mdplusplus/dpkg-buildpackage_libvirt-python_ubuntu

MAINTAINER mdPlusPlus

SHELL ["/bin/bash", "-c"]

VOLUME ["/root/out"]

##########################################
# Proven to work with virt-manager 2.2.1 #
##########################################

# install build-dependencies
RUN \
	cd /root/upstream/ && \
	apt install -y \
		./libvirt-daemon_*\.deb \
		./python3-libvirt_*\.deb \
		./qemu-kvm_*\.deb \
		./qemu-system-data_*\.deb \
		./qemu-system-gui_*\.deb \
		./qemu-system-x86_*\.deb

RUN \
	apt build-dep -y virt-manager

RUN \
	cd /root/repo && \
	apt source virt-manager

## TODO: MAYBE: don't execute everything as root

# upstream preparation
RUN \
	cd /root/upstream && \
	echo "https://virt-manager.org$(curl -s https://virt-manager.org/download/ | grep \.tar\.gz | grep -Po '(?<=href=")[^"]*' | grep virt-manager-)" |  wget -i - && \
	tar xf virt-manager-*.tar.gz && \
	cd virt-manager-*/ && \
	LOGNAME=mdPlusPlus USER=mdPlusPlus dh_make -y -s -f ../virt-manager-*.tar.gz && \
	cp debian/changelog ..

# replace upstream/debian with repo/debian and fix changelog
RUN \
	cd /root/upstream && \
	cd virt-manager-*/ && \
	rm -r debian && \
	cp -r ../../repo/virt-manager-*/debian . && \
	mv debian/changelog debian/changelog.orig && \
	mv ../changelog debian/changelog && \
	echo "" >> debian/changelog && \
	cat debian/changelog.orig >> debian/changelog && \
	rm debian/changelog.orig

# fix epoch, example: (2.2.1) -> (1:2.2.1)
RUN \
	sed  -i '0,/(/{s//(1:/}' /root/upstream/virt-manager-*/debian/changelog

## TODO replace maintainers in debian/control

# remove patches
RUN \
	cd /root/upstream && \
	cd virt-manager-*/ && \
	rm -r debian/patches

# remove virtcli
RUN \
	cd /root/upstream && \
	cd virt-manager-*/ && \
	sed -i 's/usr\/share\/virt-manager\/virtcli/# usr\/share\/virt-manager\/virtcli/g' debian/virtinst.install
	#EDITOR="/bin/true" dpkg-source --commit . virtcli.patch

RUN \
	cd /root/upstream && \
	cd virt-manager-*/ && \
	sed -i "s/^\#\!\/usr\/bin\/env python3/#!\/usr\/bin\/python3/g" virt-install setup.py tests/magicuri virt-xml virt-manager virt-clone virt-convert && \
	EDITOR="/bin/true" dpkg-source --commit . python3.patch

# mark gir1.2-gtksource-4 as runtime dependency
RUN \
	sed -i $'s/ virtinst (>= ${binary:Version}),/ virtinst (>= ${binary:Version}),\\\n gir1.2-gtksource-4,/g' /root/upstream/virt-manager-*/debian/control

# build packages
RUN \
	cd /root/upstream/virt-manager-*/ && \
	dpkg-buildpackage -us -uc

# move files to /root/out
CMD \
	cd /root/upstream/ && \
	mv \
		./virt-manager_*\.deb \
		./virtinst_*\.deb \
		/root/out
