#!/bin/bash

OUTPUT_DIR=~/deb/

mkdir "${OUTPUT_DIR}"

docker run -v "${OUTPUT_DIR}":/root/out/ local_dpkg-buildpackage_qemu_ubuntu
docker run -v "${OUTPUT_DIR}":/root/out/ local_dpkg-buildpackage_edk2_ubuntu
docker run -v "${OUTPUT_DIR}":/root/out/ local_dpkg-buildpackage_libvirt_ubuntu
docker run -v "${OUTPUT_DIR}":/root/out/ local_dpkg-buildpackage_libvirt-python_ubuntu
docker run -v "${OUTPUT_DIR}":/root/out/ local_dpkg-buildpackage_virt-manager_ubuntu


