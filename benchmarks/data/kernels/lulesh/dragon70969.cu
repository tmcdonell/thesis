#include <accelerate_cuda.h>
extern "C" __global__ void fold1All(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_3, const double* __restrict__ arrIn0_2, const double* __restrict__ arrIn0_1, const double* __restrict__ arrIn0_0, const Int64 shOut_0, double* __restrict__ arrOut_0)
{
extern volatile __shared__ double sdata0[];
double x0;
double y0;
double z0;
const Int64 sh0 = shIn0_2 * (shIn0_1 * shIn0_0);
const int shapeSize = sh0;
const int gridSize = blockDim.x * gridDim.x;
int ix = blockDim.x * blockIdx.x + threadIdx.x;

/*
         * Reduce multiple elements per thread. The number is determined by the
         * number of active thread blocks (via gridDim). More blocks will result in
         * a larger `gridSize', and hence fewer elements per thread
         *
         * The loop stride of `gridSize' is used to maintain coalescing.
         *
         * Note that we can't simply kill threads that won't participate in the
         * reduction, as exclusive reductions of empty arrays then won't be
         * initialised with their seed element.
         */
if (ix < shapeSize) {
const Int64 v12 = ({ assert(ix >= 0 && ix < shIn0_2 * (shIn0_1 * shIn0_0)); ix; });
const Int64 v13_0 = v12;
const Int64 v13_1 = v13_0 / shIn0_0;
const Int64 v13_2 = v13_1 / shIn0_1;
const Int64 v14 = v13_2 % shIn0_2;
const Int64 v15 = v13_1 % shIn0_1;
const Int64 v16 = v13_0 % shIn0_0;
const Int64 v17 = (v14 * shIn0_1 + v15) * shIn0_0 + v16;
const double v18 = arrIn0_3[v17];
const double v19 = arrIn0_2[v17];
const double v20 = arrIn0_1[v17];
const double v21 = arrIn0_0[v17];
const Word8 v22 = 0.0 == v20;
double lv230;

if (v22) {
lv230 = 1.0e20;
} else {
lv230 = 0.1 / (1.0e-20 + fabs(v20));
}
y0 = lv230;
for (ix += gridSize; ix < shapeSize; ix += gridSize) {
const Int64 v12 = ({ assert(ix >= 0 && ix < shIn0_2 * (shIn0_1 * shIn0_0)); ix; });
const Int64 v13_0 = v12;
const Int64 v13_1 = v13_0 / shIn0_0;
const Int64 v13_2 = v13_1 / shIn0_1;
const Int64 v14 = v13_2 % shIn0_2;
const Int64 v15 = v13_1 % shIn0_1;
const Int64 v16 = v13_0 % shIn0_0;
const Int64 v17 = (v14 * shIn0_1 + v15) * shIn0_0 + v16;
const double v18 = arrIn0_3[v17];
const double v19 = arrIn0_2[v17];
const double v20 = arrIn0_1[v17];
const double v21 = arrIn0_0[v17];
const Word8 v22 = 0.0 == v20;
double lv230;

if (v22) {
lv230 = 1.0e20;
} else {
lv230 = 0.1 / (1.0e-20 + fabs(v20));
}
x0 = lv230;
z0 = fmin(y0, x0);
y0 = z0;
}
}
sdata0[threadIdx.x] = y0;
ix = min(shapeSize - blockIdx.x * blockDim.x, blockDim.x);
__syncthreads();
if (threadIdx.x + 512 < ix) {
x0 = sdata0[threadIdx.x + 512];
z0 = fmin(y0, x0);
y0 = z0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 256 < ix) {
x0 = sdata0[threadIdx.x + 256];
z0 = fmin(y0, x0);
y0 = z0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 128 < ix) {
x0 = sdata0[threadIdx.x + 128];
z0 = fmin(y0, x0);
y0 = z0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 64 < ix) {
x0 = sdata0[threadIdx.x + 64];
z0 = fmin(y0, x0);
y0 = z0;
}
__syncthreads();
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x < 32) {
if (threadIdx.x + 32 < ix) {
x0 = sdata0[threadIdx.x + 32];
z0 = fmin(y0, x0);
y0 = z0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 16 < ix) {
x0 = sdata0[threadIdx.x + 16];
z0 = fmin(y0, x0);
y0 = z0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 8 < ix) {
x0 = sdata0[threadIdx.x + 8];
z0 = fmin(y0, x0);
y0 = z0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 4 < ix) {
x0 = sdata0[threadIdx.x + 4];
z0 = fmin(y0, x0);
y0 = z0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 2 < ix) {
x0 = sdata0[threadIdx.x + 2];
z0 = fmin(y0, x0);
y0 = z0;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 1 < ix) {
x0 = sdata0[threadIdx.x + 1];
z0 = fmin(y0, x0);
y0 = z0;
sdata0[threadIdx.x] = y0;
}
}
if (threadIdx.x == 0) {
arrOut_0[blockIdx.x] = y0;
}
}
