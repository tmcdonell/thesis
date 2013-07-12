#include <accelerate_cuda.h>
extern "C" __global__ void foldAll(const DIM1 shIn0, const float* __restrict__ arrIn0_a0, const DIM1 shIn1, const float* __restrict__ arrIn1_a0, const DIM0 shOut, float* __restrict__ arrOut_a0)
{
    extern volatile __shared__ float sdata0[];
    float x0;
    float y0;
    const Int64 sh0 = min((Int64) shIn0, (Int64) shIn1);
    const int shapeSize = sh0;
    const int gridSize = blockDim.x * gridDim.x;
    int ix = blockDim.x * blockIdx.x + threadIdx.x;

    if (ix < shapeSize) {
        const Int64 v2 = ix;
        const int v3 = toIndex(shIn0, shape(v2));
        const int v4 = toIndex(shIn1, shape(v2));

        y0 = arrIn0_a0[v3] * arrIn1_a0[v4];
        for (ix += gridSize; ix < shapeSize; ix += gridSize) {
            const Int64 v2 = ix;
            const int v3 = toIndex(shIn0, shape(v2));
            const int v4 = toIndex(shIn1, shape(v2));

            x0 = arrIn0_a0[v3] * arrIn1_a0[v4];
            y0 = x0 + y0;
        }
    }
    sdata0[threadIdx.x] = y0;
    __syncthreads();
    ix = min(shapeSize - blockIdx.x * blockDim.x, blockDim.x);
    if (threadIdx.x + 512 < ix) {
        x0 = sdata0[threadIdx.x + 512];
        y0 = y0 + x0;
        sdata0[threadIdx.x] = y0;
    }
    __syncthreads();
    if (threadIdx.x + 256 < ix) {
        x0 = sdata0[threadIdx.x + 256];
        y0 = y0 + x0;
        sdata0[threadIdx.x] = y0;
    }
    __syncthreads();
    if (threadIdx.x + 128 < ix) {
        x0 = sdata0[threadIdx.x + 128];
        y0 = y0 + x0;
        sdata0[threadIdx.x] = y0;
    }
    __syncthreads();
    if (threadIdx.x + 64 < ix) {
        x0 = sdata0[threadIdx.x + 64];
        y0 = y0 + x0;
        sdata0[threadIdx.x] = y0;
    }
    __syncthreads();
    if (threadIdx.x < 32) {
        if (threadIdx.x + 32 < ix) {
            x0 = sdata0[threadIdx.x + 32];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (threadIdx.x + 16 < ix) {
            x0 = sdata0[threadIdx.x + 16];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (threadIdx.x + 8 < ix) {
            x0 = sdata0[threadIdx.x + 8];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (threadIdx.x + 4 < ix) {
            x0 = sdata0[threadIdx.x + 4];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (threadIdx.x + 2 < ix) {
            x0 = sdata0[threadIdx.x + 2];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (threadIdx.x + 1 < ix) {
            x0 = sdata0[threadIdx.x + 1];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
    }
    if (threadIdx.x == 0) {
        if (shapeSize > 0) {
            if (gridDim.x == 1) {
                x0 = 0.0f;
                y0 = x0 + y0;
            }
            arrOut_a0[blockIdx.x] = y0;
        } else {
            arrOut_a0[blockIdx.x] = 0.0f;
        }
    }
}
