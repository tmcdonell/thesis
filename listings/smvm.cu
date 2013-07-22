#include <accelerate_cuda.h>
extern "C" __global__ void foldSeg
(
    const DIM1 shIn0,
    const Int32* __restrict__ arrIn0_a0,
    const DIM1 shIn1,
    const float* __restrict__ arrIn1_a0,
    const DIM1 shIn2,
    const Int32* __restrict__ arrIn2_a1,
    const float* __restrict__ arrIn2_a0,
    const DIM1 shOut,
    float* __restrict__ arrOut_a0)
{
    const int vectors_per_block = blockDim.x / warpSize;
    const int num_vectors = vectors_per_block * gridDim.x;
    const int thread_id = blockDim.x * blockIdx.x + threadIdx.x;
    const int vector_id = thread_id / warpSize;
    const int thread_lane = threadIdx.x & warpSize - 1;
    const int vector_lane = threadIdx.x / warpSize;
    const int num_segments = indexHead(shOut);
    const int total_segments = size(shOut);
    int seg;
    int ix;
    extern volatile __shared__ int s_ptrs[][2];
    volatile float* sdata0 = (float*) &s_ptrs[vectors_per_block][2];
    float x0;
    float y0;
    const Int64 sh0 = shIn2;

    for (seg = vector_id; seg < total_segments; seg += num_vectors) {
        const int s = seg % num_segments;
        const int base = seg / num_segments * sh0;

        if (thread_lane < 2) {
            const int v8 = s + thread_lane;

            s_ptrs[vector_lane][thread_lane] = arrIn0_a0[v8];
        }

        const int start = base + s_ptrs[vector_lane][0];
        const int end = base + s_ptrs[vector_lane][1];
        const int num_elements = end - start;

        if (num_elements > warpSize) {
            ix = start - (start & warpSize - 1) + thread_lane;
            if (ix >= start) {
                const Int64 v3 = ix;
                const int v4 = toIndex(shIn2, shape(v3));
                const int v5 = toIndex(shIn1, shape((Int64) arrIn2_a1[v4]));
                const int v6 = toIndex(shIn2, shape(v3));

                y0 = arrIn1_a0[v5] * arrIn2_a0[v6];
            }
            if (ix + warpSize < end) {
                const Int64 v3 = ix + warpSize;
                const int v4 = toIndex(shIn2, shape(v3));
                const int v5 = toIndex(shIn1, shape((Int64) arrIn2_a1[v4]));
                const int v6 = toIndex(shIn2, shape(v3));

                x0 = arrIn1_a0[v5] * arrIn2_a0[v6];
                if (ix >= start) {
                    y0 = x0 + y0;
                } else {
                    y0 = x0;
                }
            }
            for (ix += 2 * warpSize; ix < end; ix += warpSize) {
                const Int64 v3 = ix;
                const int v4 = toIndex(shIn2, shape(v3));
                const int v5 = toIndex(shIn1, shape((Int64) arrIn2_a1[v4]));
                const int v6 = toIndex(shIn2, shape(v3));

                x0 = arrIn1_a0[v5] * arrIn2_a0[v6];
                y0 = x0 + y0;
            }
        } else if (start + thread_lane < end) {
            const Int64 v3 = start + thread_lane;
            const int v4 = toIndex(shIn2, shape(v3));
            const int v5 = toIndex(shIn1, shape((Int64) arrIn2_a1[v4]));
            const int v6 = toIndex(shIn2, shape(v3));

            y0 = arrIn1_a0[v5] * arrIn2_a0[v6];
        }
        ix = min(num_elements, warpSize);
        sdata0[threadIdx.x] = y0;
        if (thread_lane + 32 < ix) {
            x0 = sdata0[threadIdx.x + 32];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (thread_lane + 16 < ix) {
            x0 = sdata0[threadIdx.x + 16];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (thread_lane + 8 < ix) {
            x0 = sdata0[threadIdx.x + 8];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (thread_lane + 4 < ix) {
            x0 = sdata0[threadIdx.x + 4];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (thread_lane + 2 < ix) {
            x0 = sdata0[threadIdx.x + 2];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (thread_lane + 1 < ix) {
            x0 = sdata0[threadIdx.x + 1];
            y0 = y0 + x0;
            sdata0[threadIdx.x] = y0;
        }
        if (thread_lane == 0) {
            if (num_elements > 0) {
                x0 = 0.0f;
                y0 = x0 + y0;
            } else {
                y0 = 0.0f;
            }
            arrOut_a0[seg] = y0;
        }
    }
}
