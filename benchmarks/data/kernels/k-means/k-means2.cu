#include <accelerate_cuda.h>
static TexWord32 arrIn0_2;
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
static TexWord32 arrIn1_2;
static TexFloat arrIn1_1;
static TexFloat arrIn1_0;
extern "C" __global__ void foldAll(const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shOut_0, Word8* __restrict__ arrOut_0, const Int64 shRec_0, const Word8* __restrict__ arrRec_0)
{
extern volatile __shared__ Word8 sdata0[];
Word8 x0;
Word8 y0;
const Int64 sh0 = shRec_0;
const int shapeSize = sh0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x;

if (ix < shapeSize) {
y0 = arrRec_0[ix];
for (ix += gridSize; ix < shapeSize; ix += gridSize) {
x0 = arrRec_0[ix];
y0 = x0 || y0;
}
}
sdata0[threadIdx.x] = y0;
ix = min(shapeSize - blockIdx.x * blockDim.x, blockDim.x);
__syncthreads();
if (threadIdx.x + 256 < ix) {
x0 = sdata0[threadIdx.x + 256];
y0 = y0 || x0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 128 < ix) {
x0 = sdata0[threadIdx.x + 128];
y0 = y0 || x0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 64 < ix) {
x0 = sdata0[threadIdx.x + 64];
y0 = y0 || x0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x < 32) {
if (threadIdx.x + 32 < ix) {
x0 = sdata0[threadIdx.x + 32];
y0 = y0 || x0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 16 < ix) {
x0 = sdata0[threadIdx.x + 16];
y0 = y0 || x0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 8 < ix) {
x0 = sdata0[threadIdx.x + 8];
y0 = y0 || x0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 4 < ix) {
x0 = sdata0[threadIdx.x + 4];
y0 = y0 || x0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 2 < ix) {
x0 = sdata0[threadIdx.x + 2];
y0 = y0 || x0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 1 < ix) {
x0 = sdata0[threadIdx.x + 1];
y0 = y0 || x0;
sdata0[threadIdx.x] = y0;
}
}
if (threadIdx.x == 0) {
if (shapeSize > 0) {
if (gridDim.x == 1) {
x0 = 0;
y0 = x0 || y0;
}
arrOut_0[blockIdx.x] = y0;
} else {
arrOut_0[blockIdx.x] = 0;
}
}
}
