#include <accelerate_cuda.h>
static TexFloat arrStencil_0;
extern "C" __global__ void stencil(const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_1, Int64* __restrict__ arrOut_0, const Int64 shStencil_1, const Int64 shStencil_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;

if (__all(sh1 >= 1 && sh1 < shOut_1 - 1 && (sh0 >= 1 && sh0 < shOut_0 - 1))) {
const Int64 w0 = (sh1 + -1) * shStencil_0 + (sh0 + -1);
const Int64 w1 = (sh1 + -1) * shStencil_0 + (sh0 + 0);
const Int64 w2 = (sh1 + -1) * shStencil_0 + (sh0 + 1);
const Int64 w3 = (sh1 + 0) * shStencil_0 + (sh0 + -1);
const Int64 w4 = (sh1 + 0) * shStencil_0 + (sh0 + 1);
const Int64 w5 = (sh1 + 1) * shStencil_0 + (sh0 + -1);
const Int64 w6 = (sh1 + 1) * shStencil_0 + (sh0 + 0);
const Int64 w7 = (sh1 + 1) * shStencil_0 + (sh0 + 1);
const float x8 = indexArray(arrStencil_0, w0);
const float x7 = indexArray(arrStencil_0, w1);
const float x6 = indexArray(arrStencil_0, w2);
const float x5 = indexArray(arrStencil_0, w3);
const float x3 = indexArray(arrStencil_0, w4);
const float x2 = indexArray(arrStencil_0, w5);
const float x1 = indexArray(arrStencil_0, w6);
const float x0 = indexArray(arrStencil_0, w7);
const float v0 = x6 + 2.0f * x3 + x0 - x8 - 2.0f * x5 - x2;
const float v1 = x8 + 2.0f * x7 + x6 - x2 - 2.0f * x1 - x0;
const float v2 = 1.2732395f * (-0.3926991f + atan2f(v1, v0));

arrOut_1[ix] = sqrtf(v0 * v0 + v1 * v1);
arrOut_0[ix] = (Int64) !(fabsf(v0) <= 50.0f && fabsf(v1) <= 50.0f) * min((Int64) 255, (Int64) 64 * ((Int64) 1 + mod((Int64) floorf(v2 + 8.0f * (float) (Int64) (v2 <= 0.0f)), (Int64) 4)));
} else {
const Int64 w0 = max((Int64) 0, min(sh1 + -1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + -1, shStencil_0 - 1));
const Int64 w1 = max((Int64) 0, min(sh1 + -1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 0, shStencil_0 - 1));
const Int64 w2 = max((Int64) 0, min(sh1 + -1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 1, shStencil_0 - 1));
const Int64 w3 = max((Int64) 0, min(sh1 + 0, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + -1, shStencil_0 - 1));
const Int64 w4 = max((Int64) 0, min(sh1 + 0, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 1, shStencil_0 - 1));
const Int64 w5 = max((Int64) 0, min(sh1 + 1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + -1, shStencil_0 - 1));
const Int64 w6 = max((Int64) 0, min(sh1 + 1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 0, shStencil_0 - 1));
const Int64 w7 = max((Int64) 0, min(sh1 + 1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 1, shStencil_0 - 1));
const float x8 = indexArray(arrStencil_0, w0);
const float x7 = indexArray(arrStencil_0, w1);
const float x6 = indexArray(arrStencil_0, w2);
const float x5 = indexArray(arrStencil_0, w3);
const float x3 = indexArray(arrStencil_0, w4);
const float x2 = indexArray(arrStencil_0, w5);
const float x1 = indexArray(arrStencil_0, w6);
const float x0 = indexArray(arrStencil_0, w7);
const float v0 = x6 + 2.0f * x3 + x0 - x8 - 2.0f * x5 - x2;
const float v1 = x8 + 2.0f * x7 + x6 - x2 - 2.0f * x1 - x0;
const float v2 = 1.2732395f * (-0.3926991f + atan2f(v1, v0));

arrOut_1[ix] = sqrtf(v0 * v0 + v1 * v1);
arrOut_0[ix] = (Int64) !(fabsf(v0) <= 50.0f && fabsf(v1) <= 50.0f) * min((Int64) 255, (Int64) 64 * ((Int64) 1 + mod((Int64) floorf(v2 + 8.0f * (float) (Int64) (v2 <= 0.0f)), (Int64) 4)));
}
}
}
