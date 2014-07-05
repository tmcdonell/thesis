#include <accelerate_cuda.h>
static TexFloat arrIn0_0;
static TexFloat arrIn1_0;
static TexInt32 arrIn2_0;
static TexInt32 arrIn3_0;
extern "C" __global__ void foldSeg(const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shIn2_0, const Int64 shIn3_0, const Int64 shOut_0, float* __restrict__ arrOut_0)
{
const int vectors_per_block = blockDim.x / warpSize;
const int num_vectors = __umul24(vectors_per_block, gridDim.x);
const int thread_id = __umul24(blockDim.x, blockIdx.x) + threadIdx.x;
const int vector_id = thread_id / warpSize;
const int thread_lane = threadIdx.x & warpSize - 1;
const int vector_lane = threadIdx.x / warpSize;
const int num_segments = shOut_0;
const int total_segments = shOut_0;
int seg;
int ix;
extern volatile __shared__ int s_ptrs[][2];
volatile float* sdata0 = (float*) &s_ptrs[vectors_per_block][2];
float x0;
float y0;
const Int64 sh0 = min(shIn2_0, shIn1_0);

for (seg = vector_id; seg < total_segments; seg += num_vectors) {
const int s = seg % num_segments;
const int base = seg / num_segments * sh0;

if (thread_lane < 2) {
s_ptrs[vector_lane][thread_lane] = indexArray(arrIn3_0, s + thread_lane);
}

const int start = base + s_ptrs[vector_lane][0];
const int end = base + s_ptrs[vector_lane][1];
const int num_elements = end - start;

if (num_elements > warpSize) {
ix = start - (start & warpSize - 1) + thread_lane;
if (ix >= start) {
const Int64 v2 = ({ assert(ix >= 0 && ix < min(shIn2_0, shIn1_0)); ix; });
const Int64 v3 = (Int64) indexArray(arrIn2_0, v2);

y0 = indexArray(arrIn0_0, v3) * indexArray(arrIn1_0, v2);
}
if (ix + warpSize < end) {
const Int64 v2 = ({ assert(ix + warpSize >= 0 && ix + warpSize < min(shIn2_0, shIn1_0)); ix + warpSize; });
const Int64 v3 = (Int64) indexArray(arrIn2_0, v2);

x0 = indexArray(arrIn0_0, v3) * indexArray(arrIn1_0, v2);
if (ix >= start) {
y0 = x0 + y0;
} else {
y0 = x0;
}
}
for (ix += 2 * warpSize; ix < end; ix += warpSize) {
const Int64 v2 = ({ assert(ix >= 0 && ix < min(shIn2_0, shIn1_0)); ix; });
const Int64 v3 = (Int64) indexArray(arrIn2_0, v2);

x0 = indexArray(arrIn0_0, v3) * indexArray(arrIn1_0, v2);
y0 = x0 + y0;
}
} else if (start + thread_lane < end) {
const Int64 v2 = ({ assert(start + thread_lane >= 0 && start + thread_lane < min(shIn2_0, shIn1_0)); start + thread_lane; });
const Int64 v3 = (Int64) indexArray(arrIn2_0, v2);

y0 = indexArray(arrIn0_0, v3) * indexArray(arrIn1_0, v2);
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
arrOut_0[seg] = y0;
}
}
}
