#include <accelerate_cuda.h>
static TexFloat arrStencil_1;
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

if (__all(sh1 >= 1 && sh1 < shOut_1 - 1 && (sh0 >= 1 && sh0 < shOut_0 - 1))) {
const Int64 w1 = (sh1 + -1) * shStencil_0 + (sh0 + 0);
const Int64 w3 = (sh1 + 0) * shStencil_0 + (sh0 + -1);
const Int64 w4 = (sh1 + 0) * shStencil_0 + (sh0 + 1);
const Int64 w6 = (sh1 + 1) * shStencil_0 + (sh0 + 0);
const float x14 = indexArray(arrStencil_0, w1);
const float x11 = indexArray(arrStencil_1, w3);
const float x7 = indexArray(arrStencil_1, w4);
const float x2 = indexArray(arrStencil_0, w6);

arrOut_0[ix] = -(0.5f * (x7 - x11 + x2 - x14));
} else {
const int w3 = ({ const Int64 _i = sh1 + -1;  _i >= 0 && _i < shStencil_1; }) && ({ const Int64 _i = sh0 + 0;  _i >= 0 && _i < shStencil_0; });
const Int64 w2 = (sh1 + -1) * shStencil_0 + (sh0 + 0);
const int w7 = ({ const Int64 _i = sh1 + 0;  _i >= 0 && _i < shStencil_1; }) && ({ const Int64 _i = sh0 + -1;  _i >= 0 && _i < shStencil_0; });
const Int64 w6 = (sh1 + 0) * shStencil_0 + (sh0 + -1);
const int w9 = ({ const Int64 _i = sh1 + 0;  _i >= 0 && _i < shStencil_1; }) && ({ const Int64 _i = sh0 + 1;  _i >= 0 && _i < shStencil_0; });
const Int64 w8 = (sh1 + 0) * shStencil_0 + (sh0 + 1);
const int w13 = ({ const Int64 _i = sh1 + 1;  _i >= 0 && _i < shStencil_1; }) && ({ const Int64 _i = sh0 + 0;  _i >= 0 && _i < shStencil_0; });
const Int64 w12 = (sh1 + 1) * shStencil_0 + (sh0 + 0);
const float x14 = w3 ? indexArray(arrStencil_0, w2) : 0.0f;
const float x11 = w7 ? indexArray(arrStencil_1, w6) : 0.0f;
const float x7 = w9 ? indexArray(arrStencil_1, w8) : 0.0f;
const float x2 = w13 ? indexArray(arrStencil_0, w12) : 0.0f;

arrOut_0[ix] = -(0.5f * (x7 - x11 + x2 - x14));
}
}
}
