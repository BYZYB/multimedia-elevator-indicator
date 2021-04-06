#!/bin/sh
build() {
    case "$1" in
    "build")
        if [ -f /bin/clang ]; then
            echo "[I] Building melecator with clang toolchains..."
            qmake -spec linux-clang
            make -j2
        else
            echo "[I] Building melecator with gcc toolchains..."
            qmake
            make -j2
        fi
        ;;
    "clean")
        echo "[I] Cleaning output and temporary files..."
        make clean
        rm -f ./.qmake.stash ./melecator ./Makefile
        ;;
    *)
        echo "[E] Unknown parameter \"$1\", please choose between \"build\" or \"clean\"."
        ;;
    esac
}

cd ./melecator/

if [ $1 ]; then
    build $1
else
    if [ -f ./melecator ]; then
        echo "[I] No need to build melecator, start the executable directly."
        ./melecator
    else
        echo "[W] Executable \"melecator\" not found, switch to normal build process."
        build "build"
        echo "[I] Build process finished, starting the executable..."
        ./melecator
    fi
fi

cd ../
