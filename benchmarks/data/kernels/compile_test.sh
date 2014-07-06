#!/bin/bash

set -e

echo -e "\n\n ===== $1 =====\n"

NVCC_FLAGS="-O3 -m64 -cubin -arch=sm_13 --disable-warnings -I/home/tmcdonell/thesis/benchmarks/src/.cabal-sandbox/share/x86_64-linux-ghc-7.8.2/accelerate-cuda-0.15.0.0/cubits"

# time for i in `seq 1 10`; do for f in $1*.cu; do nvcc $NVCCFLAGS -o /dev/null $f; done; done

time for i in `seq 1 10`; do ./parallel -j 8 "nvcc $NVCC_FLAGS -o /dev/null" $1*.cu; done

