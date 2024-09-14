#!/bin/sh

type cmake >/dev/null 2>&1 || {
    echo "Can't find cmake. Would you like to install it using Homebrew? (yes/no)"
    read -r response
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
    if [ "$response" = "y" ] || [ "$response" = "ye" ] || [ "$response" = "yes" ]; then
        brew install cmake
    else
        echo "Cmake is required for compile (rek)."
        exit 1
    fi
}

BUILD_DIR="$(uname)-$(uname -m)"
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../..

if [ -z "$1" ]; then
    make
else
    make -j"$1"
fi


BUILD_DIR="$(uname)-$(uname -m)"
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

cmake -G "Unix Makefiles" ../..

if [ -z "$1" ]; then
    make
else
    make -j"$1"
fi

codesign --force --deep --sign - "./eternaljk.arm64.app"

mkdir -p "./eternaljk.arm64.app/Contents/MacOS/EternalJK"
mkdir -p "./EternalJK"
mkdir -p "./EternalJK/EternalJK"
# mkdir -p "./EternalJK/base"

cp "./codemp/cgame/cgamearm64.dylib" "./eternaljk.arm64.app/Contents/MacOS/EternalJK"
cp "./codemp/game/jampgamearm64.dylib" "./eternaljk.arm64.app/Contents/MacOS/EternalJK"
cp "./codemp/ui/uiarm64.dylib" "./eternaljk.arm64.app/Contents/MacOS/EternalJK"
cp "./codemp/rd-vulkan/rd-vulkan_arm64.dylib" "./eternaljk.arm64.app/Contents/MacOS/"
cp "./codemp/rd-vanilla/rd-eternaljk_arm64.dylib" "./eternaljk.arm64.app/Contents/MacOS/"

cp -r "./eternaljk.arm64.app" "./EternalJK/eternaljk.arm64.app"
cp "./eternaljkded.arm64" "./EternalJK/eternaljkded.arm64"
cp "./codemp/japro-assets.pk3" "./EternalJK/EternalJK"

cd .. 

rm -rf ./eternaljk-mac_arm64
mkdir ./eternaljk-mac_arm64

mv Darwin-arm64/EternalJK/* ./eternaljk-mac_arm64 && rm -rf Darwin-arm64
echo " "
echo "**************** naisuuuuuuuuu *****************"
echo " "
cd eternaljk-mac_arm64
open .
