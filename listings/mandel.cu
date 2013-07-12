#include <accelerate_cuda.h>
typedef DIM2 DimOut;
extern "C" __global__ void generate(const DIM2 shIn0, const float* __restrict__ arrIn0_a1, const float* __restrict__ arrIn0_a0, const DIM2 shIn1, const float* __restrict__ arrIn1_a2, const float* __restrict__ arrIn1_a1, const Int64* __restrict__ arrIn1_a0, const DIM2 shOut, float* __restrict__ arrOut_a2, float* __restrict__ arrOut_a1, Int64* __restrict__ arrOut_a0)
{
    const int shapeSize = size(shOut);
    const int gridSize = blockDim.x * gridDim.x;
    int ix;

    for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
        const DimOut sh = fromIndex(shOut, ix);
        const int v0 = toIndex(shIn0, shape(sh.a1, sh.a0));
        const float v1 = arrIn0_a1[v0];
        const float v2 = arrIn0_a0[v0];
        const int v3 = toIndex(shIn1, shape(sh.a1, sh.a0));
        const float v4 = arrIn1_a2[v3];
        const float v5 = arrIn1_a1[v3];
        const Int64 v6 = arrIn1_a0[v3];
        const float v7 = v4 * v4 - v5 * v5;
        const float v8 = v4 * v5 + v5 * v4;
        const float v9 = v1 + v7;
        const float v10 = v2 + v8;
        const Word8 v11 = v9 * v9 + v10 * v10 > 4.0f;

        arrOut_a2[ix] = v11 ? v4 : v9;
        arrOut_a1[ix] = v11 ? v5 : v10;
        arrOut_a0[ix] = v11 ? v6 : (Int64) 1 + v6;
    }
}
