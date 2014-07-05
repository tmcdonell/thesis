#include <accelerate_cuda.h>
static TexInt32 arrIn0_0;
extern "C" __global__ void scanlUp(const Int64 shIn0_0, const Int64 shOut_0, Int32* __restrict__ arrOut_0)
{
extern volatile __shared__ Int32 sdata0[];
Int32 x0;
Int32 y0;
const Int64 sh0 = shIn0_0;
const int shapeSize = sh0;
const int intervalSize = (shapeSize + gridDim.x - 1) / gridDim.x;
const int start = blockIdx.x * intervalSize;
const int end = min(start + intervalSize, shapeSize);
const int numElements = end - start;
int carryIn = 0;
int seg;

for (seg = threadIdx.x; seg < numElements; seg += blockDim.x) {
const int ix = start + seg;

x0 = indexArray(arrIn0_0, ix);
if (threadIdx.x == 0 && carryIn) {
x0 = y0 + x0;
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
if (threadIdx.x == 0) {
const int last = min(numElements - seg, blockDim.x) - 1;

y0 = sdata0[last];
}
carryIn = 1;
}
if (threadIdx.x == 0) {
arrOut_0[blockIdx.x] = y0;
}
}
