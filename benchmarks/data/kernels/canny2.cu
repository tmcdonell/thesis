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

if (__all(sh1 >= 1 && sh1 < shOut_1 - 1 && (sh0 >= 2 && sh0 < shOut_0 - 2))) {
const Int64 w3 = (sh1 + 0) * shStencil_0 + (sh0 + -2);
const Int64 w4 = (sh1 + 0) * shStencil_0 + (sh0 + -1);
const Int64 w5 = (sh1 + 0) * shStencil_0 + (sh0 + 1);
const Int64 w6 = (sh1 + 0) * shStencil_0 + (sh0 + 2);
const float x7 = indexArray(arrStencil_0, w3);
const float x6 = indexArray(arrStencil_0, w4);
const float x5 = indexArray(arrStencil_0, ix);
const float x4 = indexArray(arrStencil_0, w5);
const float x3 = indexArray(arrStencil_0, w6);

arrOut_0[ix] = x7 + 4.0f * x6 + 6.0f * x5 + 4.0f * x4 + x3;
} else {
const Int64 w3 = max((Int64) 0, min(sh1 + 0, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + -2, shStencil_0 - 1));
const Int64 w4 = max((Int64) 0, min(sh1 + 0, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + -1, shStencil_0 - 1));
const Int64 w5 = max((Int64) 0, min(sh1 + 0, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 1, shStencil_0 - 1));
const Int64 w6 = max((Int64) 0, min(sh1 + 0, shStencil_1 - 1)) * shStencil_0 + max((Int64) 0, min(sh0 + 2, shStencil_0 - 1));
const float x7 = indexArray(arrStencil_0, w3);
const float x6 = indexArray(arrStencil_0, w4);
const float x5 = indexArray(arrStencil_0, ix);
const float x4 = indexArray(arrStencil_0, w5);
const float x3 = indexArray(arrStencil_0, w6);

arrOut_0[ix] = x7 + 4.0f * x6 + 6.0f * x5 + 4.0f * x4 + x3;
}
}
}
