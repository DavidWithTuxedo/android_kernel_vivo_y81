#!/bin/bash

TOOL="gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz"

echo "Installing Dependencies!"
sudo apt install -yq bc flex bison python3 make gcc 

if [ -d aarch64-linux-gnu-6.3 ]
then
	echo "Toolchain Detected!"
else
	echo "Downloading Toolchain..."
	wget https://releases.linaro.org/components/toolchain/binaries/6.3-2017.02/aarch64-linux-gnu/${TOOL} -q
	echo "Unpacking Toolchain..."
	tar xf ${TOOL}
	mv gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu aarch64-linux-gnu-6.3
	rm -f ${TOOL} && ls aarch64-linux-gnu-6.3
fi


if [ -z ${ARCH}${CROSS_COMPILE} ]
then
	export ARCH=arm64
	export CROSS_COMPILE=$(pwd)/aarch64-linux-gnu-6.3/bin/aarch64-linux-gnu-
fi

git clone --depth=1 https://github.com/DavidWithTuxedo/android_kernel_vivo_y81 -b unsafe src && cd src
make PD1732_stock_defconfig
make -j$(nproc --all) 2>&1 | tee build.log
grep -i error -A 16 -B 16 build.log >> error.log
tar -zvcf logcat.tgz build.log error.log
