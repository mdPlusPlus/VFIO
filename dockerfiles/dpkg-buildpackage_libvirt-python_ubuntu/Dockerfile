FROM mdPlusPlus/dpkg-buildpackage_libvirt_ubuntu

MAINTAINER mdPlusPlus

SHELL ["/bin/bash", "-c"]

VOLUME ["/root/out"]

############################################
# Proven to work with libvirt-python 5.5.0 #
############################################

# install build-dependencies for libvirt-python (and virt-manager)
RUN \
	cd /root/upstream/ && \
	apt install -y \
		./libvirt0_*\.deb \
		./libvirt-dev_*\.deb

RUN \
	apt build-dep -y libvirt-python

RUN \
	cd /root/repo && \
	apt source libvirt-python
	
## TODO: MAYBE: don't execute everything as root

# upstream preparation
RUN \
	cd /root/upstream && \
	echo "https://libvirt.org/sources/python/$(curl -s https://libvirt.org/sources/python/ | grep -Po '(?<=href=")[^"]*' | grep \.tar\.gz | grep -v \.asc | tail -n 1)" | wget -i - && \
	tar xf libvirt-python-*\.tar\.gz && \
	cd libvirt-python-*/ && \
	LOGNAME=mdPlusPlus USER=mdPlusPlus dh_make -y -s -f ../libvirt-python-*.tar.gz && \
	cp debian/changelog ..

# replace upstream/debian with repo/debian and fix changelog
RUN \
	cd /root/upstream && \
	cd libvirt-python-*/ && \
	rm -r debian && \
	cp -r ../../repo/libvirt-python-*/debian . && \
	mv debian/changelog debian/changelog.orig && \
	mv ../changelog debian/changelog && \
	echo "" >> debian/changelog && \
	cat debian/changelog.orig >> debian/changelog && \
	rm debian/changelog.orig

## TODO: replace maintainers with mdPlusPlus in debian/control

# build packages
RUN \
	cd /root/upstream/libvirt-python-*/ && \
	dpkg-buildpackage -us -uc

# move files to /root/out
CMD \
	cd /root/upstream/ && \
	mv \
		./python3-libvirt_*\.deb \
		/root/out
