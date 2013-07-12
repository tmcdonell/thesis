/*
 * 1.73:cc: entry function 'generate' used 34 registers, 0 bytes smem, 0 bytes lmem, 0 bytes cmem
 *      ... multiprocessor occupancy 79.7% : 1632 threads over 51 warps in 3 blocksbenchmarking mandelbrot
 *
 * collecting 100 samples, 1 iterations each, in estimated 162.7669 s
 * mean: 16.46181 ms, lb 15.81836 ms, ub 17.53077 ms, ci 0.950
 * std dev: 4.200961 ms, lb 2.716338 ms, ub 6.127911 ms, ci 0.950
 * found 6 outliers among 100 samples (6.0%)
 *   5 (5.0%) high severe
 * variance introduced by outliers: 96.774%
 * variance is severely inflated by outliers
 *
 *
 * After changing the type of booleans to Word32 to avoid a single cvt.u8.u32 in
 * the inner loop:
 *
 * benchmarking mandelbrot
 * collecting 100 samples, 1 iterations each, in estimated 161.6304 s
 * mean: 12.82615 ms, lb 12.51806 ms, ub 13.14113 ms, ci 0.950
 * std dev: 1.593406 ms, lb 1.439425 ms, ub 1.792564 ms, ci 0.950
 * variance introduced by outliers: 85.251%
 * variance is severely inflated by outliers
 */
#include <accelerate_cuda.h>
typedef DIM2 DimOut;
extern "C" __global__ void generate(const DIM0 shIn0, const float* __restrict__ arrIn0_a3, const float* __restrict__ arrIn0_a2, const float* __restrict__ arrIn0_a1, const float* __restrict__ arrIn0_a0, const DIM2 shOut, Word32* __restrict__ arrOut_a0)
{
    const int shapeSize = size(shOut);
    const int gridSize = blockDim.x * gridDim.x;
    int ix;

    for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
        const DimOut sh = fromIndex(shOut, ix);
        const Int64 v0 = (Int64) 255;
        const int v1 = toIndex(shIn0, shape());
        const float v2 = arrIn0_a3[v1];
        const float v3 = arrIn0_a2[v1];
        const float v4 = arrIn0_a1[v1];
        const float v5 = arrIn0_a0[v1];
        const Int64 v6 = sh.a1;
        const Int64 v7 = sh.a0;
        const float v8 = v2 + (float) v7 * (v4 - v2) / 800.0f;
        const float v9 = v3 + (float) v6 * (v5 - v3) / 600.0f;
        const int v13 = (Int64) 255;
        float v10 = v8;
        float v11 = v9;
        Int64 v12 = (Int64) 0;

        for (int v19 = 0; v19 < v13; ++v19) {
            const float v14 = v10 * v10 - v11 * v11;
            const float v15 = v10 * v11 + v11 * v10;
            const float v16 = v8 + v14;
            const float v17 = v9 + v15;
            const Word32 v18 = v16 * v16 + v17 * v17 > 4.0f;    // change meeeee

            v10 = v18 ? v10 : v16;
            v11 = v18 ? v11 : v17;
            v12 = v18 ? v12 : (Int64) 1 + v12;
        }

        const Int64 v20 = (Int64) v12;
        const Word32 v21 = v0 == v20;                           // change meeeee
        const Int64 v22 = v0 - v20;
        const Word8 v23 = (Word8) 0;
        const Word8 v24 = (Word8) ((Int64) 7 * v22);
        const Word8 v25 = (Word8) ((Int64) 5 * v22);
        const Word8 v26 = (Word8) ((Int64) 3 * v22);

        arrOut_a0[ix] = v21 ? (Word32) 4278190080 : (Word32) 4294967295 - ((Word32) v23 + (Word32) 256 * (Word32) v24 + (Word32) 65536 * (Word32) v25 + (Word32) 16777216 * (Word32) v26);
    }
}
