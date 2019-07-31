FROM mdplusplus/dpkg-buildpackage_qemu_ubuntu

MAINTAINER mdPlusPlus

SHELL ["/bin/bash", "-c"]

VOLUME ["/root/out"]

#########################################
# Proven to work with edk2-stable201905 #
#########################################

RUN \
	apt install -y unzip

RUN \
	cd /root/upstream && \
	apt install -y \
		./qemu-block-extra_*\.deb \
		./qemu-system-common_*\.deb \
		./qemu-system-data_*\.deb \
		./qemu-system-x86_*\.deb \
		./qemu-utils_*\.deb

RUN \
	apt build-dep -y edk2

RUN \
	cd /root/repo && \
	apt source edk2

# edk2 requires openssl, versions above openssl-1.1.1b seem to break edk2 building
RUN \
	export VERSION="1.1.1b" && \
	cd /root/upstream && \
	wget "https://www.openssl.org/source/openssl-${VERSION}.tar.gz" && \
	tar xf openssl-*\.tar\.gz

# edk2 requres Berkely SoftFloat3
RUN \
	cd /root/upstream && \
	echo "http://www.jhauser.us/arithmetic/$(curl -s http://www.jhauser.us/arithmetic/SoftFloat.html | grep -Po '(?<=HREF=")[^"]*' | grep \.zip | head -n 1)" | wget -i - && \
	unzip SoftFloat-*\.zip
	

## TODO: MAYBE: don't execute everything as root

# upstream preparation #example name: edk2-0~20190309.89910a39
RUN \
	cd /root/upstream && \
	export RELEASE="$(curl -s https://api.github.com/repos/tianocore/edk2/releases/latest)" && \
	export RELEASE_NAME="$(echo "${RELEASE}" | grep tag_name | cut -d '"' -f 4)" && \
	export RELEASE_SHA_LONG="$(curl -s https://api.github.com/repos/tianocore/edk2/git/refs/tags/"${RELEASE_NAME}" | grep sha | cut -d '"' -f 4)" && \
	export RELEASE_SHA="${RELEASE_SHA_LONG:0:8}" && \
	export RELEASE_DATE="$(echo "${RELEASE}" | grep created_at | head -n 1 | cut -d '"' -f 4 | cut -d 'T' -f 1 | tr -d '-')" && \
	export NAME="edk2-0~${RELEASE_DATE}.${RELEASE_SHA}" && \
	echo "${RELEASE}" | grep tarball_url | cut -d '"' -f 4 | wget -i - -O "${NAME}.tar.gz" && \
	tar xf "${NAME}.tar.gz" && \
	mv tianocore-edk2-* "${NAME}" && \
	cd edk2-*/ && \
	LOGNAME=mdPlusPlus USER=mdPlusPlus dh_make -y -s -f ../edk2-*.tar.gz && \
	cp debian/changelog ..

# replace upstream/debian with repo/debian and fix changelog
RUN \
	cd /root/upstream && \
	cd edk2-*/ && \
	rm -r debian && \
	cp -r ../../repo/edk2-*/debian . && \
	mv debian/changelog debian/changelog.orig && \
	mv ../changelog debian/changelog && \
	echo "" >> debian/changelog && \
	cat debian/changelog.orig >> debian/changelog && \
	rm debian/changelog.orig

## TODO: replace maintainers with mdPlusPlus in debian/control

# fix patches
# RUN sed -i 's//#&/g' /root/upstream/edk2-*/debian/patches/series
RUN sed -i 's/enroll-default-keys.patch/#&/g' /root/upstream/edk2-*/debian/patches/series

# "install" openssl
RUN \
	cd /root/upstream && \
	cp -r openssl-*/* edk2-*/CryptoPkg/Library/OpensslLib/openssl/ && \
	cd edk2-*/ && \
	EDITOR="/bin/true" dpkg-source --commit . openssl.patch

# "install" SoftFloat3
RUN \
	cd /root/upstream && \
	cp -r SoftFloat-*/* edk2-*/ArmPkg/Library/ArmSoftFloatLib/berkeley-softfloat-3/ && \
	cd edk2-*/ && \
	EDITOR="/bin/true" dpkg-source --commit . softfloat.patch

# we only care about ovmf and ARM is throwing errors
#RUN sed -i 's/override_dh_auto_build: build-qemu-efi-aarch64 build-qemu-efi-arm build-ovmf/override_dh_auto_build: build-ovmf/g' /root/upstream/edk2-*/debian/rules

## remove ovmf-vars generation, since newer versions of edk2 come with their own key enrollment
##      python3 debian/ovmf-vars-generator --qemu-binary /usr/bin/qemu-system-x86_64 \
##              --disable-smm \
##              --skip-testing \
##              --ovmf-binary ovmf/OVMF_CODE.fd \
##              --ovmf-template-vars ovmf/OVMF_VARS.fd \
##              --uefi-shell-iso ovmf/UefiShell.iso \
##              ovmf/OVMF_VARS.ms.fd
RUN \
	sed -i '/python3 debian\/ovmf-vars-generator/,+6d' /root/upstream/edk2-*/debian/rules

# build packages
RUN \
	cd /root/upstream/edk2-*/ && \
	dpkg-buildpackage -us -uc
		
# move files to /root/out
CMD \
	cd /root/upstream/ && \
	mv \
		./ovmf_*\.deb \
		/root/out
