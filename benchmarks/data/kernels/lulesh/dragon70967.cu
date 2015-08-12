#include <accelerate_cuda.h>
extern "C" __global__ void map(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_3, const double* __restrict__ arrIn0_2, const double* __restrict__ arrIn0_1, const double* __restrict__ arrIn0_0, const Int64 shOut_2, const Int64 shOut_1, const Int64 shOut_0, double* __restrict__ arrOut_0)
{
const int shapeSize = shOut_2 * (shOut_1 * shOut_0);
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
const double x3 = arrIn0_3[ix];
const Word8 v0 = fabs(-1.0 + x3) < 1.0e-7;
double lv10;

if (v0) {
lv10 = 1.0;
} else {
lv10 = x3;
}
arrOut_0[ix] = lv10;
}
}
