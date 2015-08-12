#include <accelerate_cuda.h>
static TexInt64 arrIn0_0;
extern "C" __global__ void scanr(const Int64 shIn0_0, const Int64 shOut_0, Int64* __restrict__ arrOut_0, const Int64 shBlk_0, Int64* __restrict__ arrBlk_0, Int64* __restrict__ arrSum_0)
{
extern volatile __shared__ Int64 sdata0[];
Int64 x0;
Int64 y0;
Int64 z0;
const Int64 sh0 = shBlk_0;
const int shapeSize = sh0;
const int intervalSize = (shapeSize + gridDim.x - 1) / gridDim.x;
int carryIn = 0;

if (threadIdx.x == 0) {
if (gridDim.x > 1) {
z0 = arrBlk_0[blockIdx.x];
} else {
z0 = (Int64) 0;
}
}

const int start = blockIdx.x * intervalSize;
const int end = min(start + intervalSize, shapeSize);
const int numElements = end - start;
int seg;

for (seg = threadIdx.x; seg < numElements; seg += blockDim.x) {
const int ix = end - seg - 1;

x0 = arrBlk_0[ix];
if (threadIdx.x == 0) {
x0 = z0 + x0;
}
sdata0[threadIdx.x] = x0;
__syncthreads();
if (blockDim.x > 1) {
if (threadIdx.x >= 1) {
y0 = sdata0[threadIdx.x - 1];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 2) {
if (threadIdx.x >= 2) {
y0 = sdata0[threadIdx.x - 2];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 4) {
if (threadIdx.x >= 4) {
y0 = sdata0[threadIdx.x - 4];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 8) {
if (threadIdx.x >= 8) {
y0 = sdata0[threadIdx.x - 8];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 16) {
if (threadIdx.x >= 16) {
y0 = sdata0[threadIdx.x - 16];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 32) {
if (threadIdx.x >= 32) {
y0 = sdata0[threadIdx.x - 32];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 64) {
if (threadIdx.x >= 64) {
y0 = sdata0[threadIdx.x - 64];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 128) {
if (threadIdx.x >= 128) {
y0 = sdata0[threadIdx.x - 128];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 256) {
if (threadIdx.x >= 256) {
y0 = sdata0[threadIdx.x - 256];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (blockDim.x > 512) {
if (threadIdx.x >= 512) {
y0 = sdata0[threadIdx.x - 512];
x0 = y0 + x0;
}
__syncthreads();
sdata0[threadIdx.x] = x0;
__syncthreads();
}
if (1) {
if (threadIdx.x == 0) {
x0 = z0;
} else {
x0 = sdata0[threadIdx.x - 1];
}
}
arrOut_0[ix] = x0;
if (threadIdx.x == 0) {
const int last = min(numElements - seg, blockDim.x) - 1;

z0 = sdata0[last];
}
}
if (threadIdx.x == 0 && blockIdx.x == 0) {
arrSum_0[0] = z0;
}
}
