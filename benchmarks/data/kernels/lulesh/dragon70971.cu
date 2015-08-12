#include <accelerate_cuda.h>
extern "C" __global__ void fold1All(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_3, const double* __restrict__ arrIn0_2, const double* __restrict__ arrIn0_1, const double* __restrict__ arrIn0_0, const Int64 shIn1_2, const Int64 shIn1_1, const Int64 shIn1_0, const double* __restrict__ arrIn1_3, const double* __restrict__ arrIn1_2, const double* __restrict__ arrIn1_1, const double* __restrict__ arrIn1_0, const Int64 shOut_0, double* __restrict__ arrOut_0)
{
extern volatile __shared__ double sdata0[];
double x0;
double y0;
double z0;
const Int64 sh0 = min(shIn0_2, shIn1_2) * (min(shIn0_1, shIn1_1) * min(shIn0_0, shIn1_0));
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
const Int64 v15 = ({ assert(ix >= 0 && ix < min(shIn0_2, shIn1_2) * (min(shIn0_1, shIn1_1) * min(shIn0_0, shIn1_0))); ix; });
const Int64 v16_0 = v15;
const Int64 v16_1 = v16_0 / min(shIn0_0, shIn1_0);
const Int64 v16_2 = v16_1 / min(shIn0_1, shIn1_1);
const Int64 v17 = v16_2 % min(shIn0_2, shIn1_2);
const Int64 v18 = v16_1 % min(shIn0_1, shIn1_1);
const Int64 v19 = v16_0 % min(shIn0_0, shIn1_0);
const Int64 v20 = (v17 * shIn1_1 + v18) * shIn1_0 + v19;
const double v21 = arrIn1_1[v20];
const Word8 v22 = 0.0 == v21;
double lv290;

if (v22) {
lv290 = 1.0e20;
} else {
const Int64 v23 = (v17 * shIn1_1 + v18) * shIn1_0 + v19;
const double v24 = arrIn1_0[v23];

lv290 = v24 / sqrt(({
const Int64 v25 = (v17 * shIn0_1 + v18) * shIn0_0 + v19;
const double v26 = arrIn0_0[v25];

;
v26 * v26;
}) + ({
const Word8 v27 = v21 >= 0.0;
double lv280;

if (v27) {
lv280 = 0.0;
} else {
lv280 = 256.0 * v24 * v24 * v21 * v21;
}
;
lv280;
}));
}
y0 = lv290;
for (ix += gridSize; ix < shapeSize; ix += gridSize) {
const Int64 v15 = ({ assert(ix >= 0 && ix < min(shIn0_2, shIn1_2) * (min(shIn0_1, shIn1_1) * min(shIn0_0, shIn1_0))); ix; });
const Int64 v16_0 = v15;
const Int64 v16_1 = v16_0 / min(shIn0_0, shIn1_0);
const Int64 v16_2 = v16_1 / min(shIn0_1, shIn1_1);
const Int64 v17 = v16_2 % min(shIn0_2, shIn1_2);
const Int64 v18 = v16_1 % min(shIn0_1, shIn1_1);
const Int64 v19 = v16_0 % min(shIn0_0, shIn1_0);
const Int64 v20 = (v17 * shIn1_1 + v18) * shIn1_0 + v19;
const double v21 = arrIn1_1[v20];
const Word8 v22 = 0.0 == v21;
double lv290;

if (v22) {
lv290 = 1.0e20;
} else {
const Int64 v23 = (v17 * shIn1_1 + v18) * shIn1_0 + v19;
const double v24 = arrIn1_0[v23];

lv290 = v24 / sqrt(({
const Int64 v25 = (v17 * shIn0_1 + v18) * shIn0_0 + v19;
const double v26 = arrIn0_0[v25];

;
v26 * v26;
}) + ({
const Word8 v27 = v21 >= 0.0;
double lv280;

if (v27) {
lv280 = 0.0;
} else {
lv280 = 256.0 * v24 * v24 * v21 * v21;
}
;
lv280;
}));
}
x0 = lv290;
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
