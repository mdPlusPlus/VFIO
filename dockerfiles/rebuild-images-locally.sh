#!/bin/bash

NOCACHE="--no-cache"

LOCAL_PREFIX="local_"
NAME_QEMU="dpkg-buildpackage_qemu_ubuntu"
NAME_EDK2="dpkg-buildpackage_edk2_ubuntu"
NAME_LIBVIRT="dpkg-buildpackage_libvirt_ubuntu"
NAME_LIBVIRT_PYTHON="dpkg-buildpackage_libvirt-python_ubuntu"
NAME_VIRT_MANAGER="dpkg-buildpackage_virt-manager_ubuntu"

cat "${NAME_QEMU}/Dockerfile" \
	| docker build ${NOCACHE} -t "${LOCAL_PREFIX}${NAME_QEMU}" - && \
cat "${NAME_EDK2}/Dockerfile" \
	| sed "s/FROM mdplusplus\/${NAME_QEMU}/FROM ${LOCAL_PREFIX}${NAME_QEMU}/" \
	| docker build ${NOCACHE} -t "${LOCAL_PREFIX}${NAME_EDK2}" - && \
cat "${NAME_LIBVIRT}/Dockerfile" \
	| sed "s/FROM mdplusplus\/${NAME_QEMU}/FROM ${LOCAL_PREFIX}${NAME_QEMU}/"\
	| docker build ${NOCACHE} -t "${LOCAL_PREFIX}${NAME_LIBVIRT}" - && \
cat "${NAME_LIBVIRT_PYTHON}/Dockerfile" \
	| sed "s/FROM mdplusplus\/${NAME_LIBVIRT}/FROM ${LOCAL_PREFIX}${NAME_LIBVIRT}/" \
	| docker build ${NOCACHE} -t "${LOCAL_PREFIX}${NAME_LIBVIRT_PYTHON}" - && \
cat "${NAME_VIRT_MANAGER}/Dockerfile" \
	| sed "s/FROM mdplusplus\/${NAME_LIBVIRT_PYTHON}/FROM ${LOCAL_PREFIX}${NAME_LIBVIRT_PYTHON}/" \
	| docker build ${NOCACHE} -t "${LOCAL_PREFIX}${NAME_VIRT_MANAGER}" -
