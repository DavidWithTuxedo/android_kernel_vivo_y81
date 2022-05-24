#!/bin/bash

TOOL="gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu.tar.xz"

echo "Installing Dependencies!"
apt install -yq bc flex bison python3 make gcc 

if [ -d aarch64-linux-gnu-4.9 ]
then
	echo "Toolchain Detected!"
else
	echo "Downloading Toolchain..."
	wget https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/aarch64-linux-gnu/${TOOL} -q
	echo "Unpacking Toolchain..."
	tar xf ${TOOL}
	mv gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu aarch64-linux-gnu-4.9
	rm -f ${TOOL} && ls aarch64-linux-gnu-4.9
fi


if [ -z ${ARCH}${CROSS_COMPILE} ]
then
	export ARCH=arm64
	export CROSS_COMPILE=$(pwd)/aarch64-linux-gnu-4.9/bin/aarch64-linux-gnu-
fi

git clone https://github.com/DavidWithTuxedo/android_kernel_vivo_y81
cd android_kernel_vivo_y81
make PD1732_k62v1_64_bsp_debug_defconfig
make -j6 2>&1 | tee build.log
grep -i -A 5 -B 5 error build.log
