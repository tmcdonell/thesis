#include <accelerate_cuda.h>
static TexFloat arrStencil_0;
extern "C" __global__ void stencil(const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_0, const Int64 shStencil_1, const Int64 shStencil_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;

if (__all(sh1 >= 2 && sh1 < shOut_1 - 2 && (sh0 >= 1 && sh0 < shOut_0 - 1))) {
const Int64 w1 = (sh1 + -2) * shStencil_0 + (sh0 + 0);
const Int64 w4 = (sh1 + -1) * shStencil_0 + (sh0 + 0);
const Int64 w9 = (sh1 + 1) * shStencil_0 + (sh0 + 0);
const Int64 w12 = (sh1 + 2) * shStencil_0 + (sh0 + 0);
const float x13 = indexArray(arrStencil_0, w1);
const float x10 = indexArray(arrStencil_0, w4);
const float x7 = indexArray(arrStencil_0, ix);
const float x4 = indexArray(arrStencil_0, w9);
const float x1 = indexArray(arrStencil_0, w12);

arrOut_0[ix] = 3.90625e-3f * x13 + 1.5625e-2f * x10 + 2.34375e-2f * x7 + 1.5625e-2f * x4 + 3.90625e-3f * x1;
} else {
const Int64 w1 = max((Int64) 0, min(sh1 + -2, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 0, shStencil_0 - 1));
const Int64 w4 = max((Int64) 0, min(sh1 + -1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 0, shStencil_0 - 1));
const Int64 w9 = max((Int64) 0, min(sh1 + 1, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 0, shStencil_0 - 1));
const Int64 w12 = max((Int64) 0, min(sh1 + 2, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 0, shStencil_0 - 1));
const float x13 = indexArray(arrStencil_0, w1);
const float x10 = indexArray(arrStencil_0, w4);
const float x7 = indexArray(arrStencil_0, ix);
const float x4 = indexArray(arrStencil_0, w9);
const float x1 = indexArray(arrStencil_0, w12);

arrOut_0[ix] = 3.90625e-3f * x13 + 1.5625e-2f * x10 + 2.34375e-2f * x7 + 1.5625e-2f * x4 + 3.90625e-3f * x1;
}
}
}
