#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;

arrOut_0[ix] = fmaxf(0.0f, cosf(10.0f * (-50.0f + (float) sh0) / 100.0f) * cosf(10.0f * (-50.0f + (float) sh1) / 100.0f));
}
}
