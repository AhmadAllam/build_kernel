#!/bin/sh


# Some general variables
PHONE="alioth"
ARCH="arm64"
SUBARCH="arm64"
DEFCONFIG=vendor/alioth_defconfig
COMPILER=clang
LINKER="lld"
COMPILERDIR="/root/build/tools/proton-clang"
ANYKERNEL3_DIR=$PWD/AnyKernel3/
FINAL_KERNEL_ZIP=Result_v1.zip

# Basic build function
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'


# Cleanup output
echo "$red**** don't forget AnyKernel3  ****$nocol"
echo "$yellow**** Cleaning ****$nocol"
rm -rf out/*
rm -f .gitignore


# Export shits
export KBUILD_BUILD_USER=AhmadOo
export KBUILD_BUILD_HOST=pocof3
export ARCH=arm64
export SUBARCH=ARM64
export DTC_EXT=dtc

#def config
make O=out clean mrproper CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf OBJSIZE=llvm-size STRIP=llvm-strip HOSTCC=clang HOSTCXX=clang++ vendor/alioth_defconfig

#menu config
sleep 2
echo "$blue******* menu config will opening ******$nocol"
make CC=clang O=out menuconfig

echo "$blue******* copying config to stock location ******$nocol"
sleep 2
cd out/ && cp .config /root/build/kernel-src/arch/arm64/configs/vendor/alioth_defconfig
cd ..
make vendor/alioth_defconfig
make clean && make mrproper

echo "$blue******* build script starting ******$nocol"
# Speed up build process
MAKE="./makeparallel"


Build () {
PATH="${COMPILERDIR}/bin:${PATH}" \
make -j$(nproc --all) O=out \
ARCH=${ARCH} \
LLVM=1 \
LLVM_IAS=1 \
CC=${COMPILER} \
CROSS_COMPILE=${COMPILERDIR}/bin/aarch64-linux-gnu- \
CROSS_COMPILE_COMPAT=${COMPILERDIR}/bin/arm-linux-gnueabi- \
LD_LIBRARY_PATH=${COMPILERDIR}/lib \
Image.gz-dtb dtbo.img
}

Build_lld () {
PATH="${COMPILERDIR}/bin:${PATH}" \
make -j$(nproc --all) O=out \
ARCH=${ARCH} \
LLVM=1 \
LLVM_IAS=1 \
CC=${COMPILER} \
CROSS_COMPILE=${COMPILERDIR}/bin/aarch64-linux-gnu- \
CROSS_COMPILE_COMPAT=${COMPILERDIR}/bin/arm-linux-gnueabi- \
LD=ld.${LINKER} \
AR=llvm-ar \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip \
ld-name=${LINKER} \
KBUILD_COMPILER_STRING="Proton Clang" \
Image.gz-dtb dtbo.img
}


# Make defconfig

make O=out ARCH=${ARCH} ${DEFCONFIG}
if [ $? -ne 0 ]
then
   
    echo "$red******* Build failed ${DEFCONFIG} ******$nocol"
else
    echo "$yellow******* Made ${DEFCONFIG} ******$nocol"
fi

# Build starts here
if [ -z ${LINKER} ]
then
    Build
else
    echo | Build_lld
fi

if [ $? -ne 0 ]
then
    echo "$red******* Build failed ******$nocol"
    rm -rf out/*
else
    echo "$yellow****Build succesful***$nocol"
  fi

echo "$yellow**** Verify Image.gz-dtb & dtbo.img ****$nocol"
ls $PWD/out/arch/arm64/boot/Image.gz-dtb
ls $PWD/out/arch/arm64/boot/dtbo.img

echo "$yellow**** Verifying AnyKernel3 Directory ****$nocol"
ls $ANYKERNEL3_DIR

echo "$yellow**** Removing leftovers ****$nocol"
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf $ANYKERNEL3_DIR/dtbo.img
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP

echo "$yellow**** Copying Image.gz-dtb & dtbo.img ****$nocol"
cp $PWD/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL3_DIR/
cp $PWD/out/arch/arm64/boot/dtbo.img $ANYKERNEL3_DIR/

echo "$yellow**** Time to zip up! ****$nocol"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
cp $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP /root/build/$FINAL_KERNEL_ZIP

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo "$yellow**** Done, Good-by Ahmad ****$nocol"
