#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_2, const double* __restrict__ arrIn0_1, const double* __restrict__ arrIn0_0, const double* __restrict__ arrIn1_0, const Int64 shIn2_2, const Int64 shIn2_1, const Int64 shIn2_0, const double* __restrict__ arrIn2_2, const double* __restrict__ arrIn2_1, const double* __restrict__ arrIn2_0, const Int64 shOut_2, const Int64 shOut_1, const Int64 shOut_0, double* __restrict__ arrOut_2, double* __restrict__ arrOut_1, double* __restrict__ arrOut_0)
{
const int shapeSize = shOut_2 * (shOut_1 * shOut_0);
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 tmp_2 = tmp_1 / shOut_1;
const Int64 sh2 = tmp_2 % shOut_2;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;
const Int64 v0 = (sh2 * shIn2_1 + sh1) * shIn2_0 + sh0;
const double v1 = arrIn2_2[v0];
const double v2 = arrIn2_1[v0];
const double v3 = arrIn2_0[v0];
const Int64 v4 = (sh2 * shIn0_1 + sh1) * shIn0_0 + sh0;
const double v5 = arrIn0_2[v4];
const double v6 = arrIn0_1[v4];
const double v7 = arrIn0_0[v4];
const Int64 v8 = 0;
const double v9 = arrIn1_0[v8];
const double v10 = v5 * v9;
const double v11 = v6 * v9;
const double v12 = v7 * v9;

arrOut_2[ix] = v1 + v10;
arrOut_1[ix] = v2 + v11;
arrOut_0[ix] = v3 + v12;
}
}
