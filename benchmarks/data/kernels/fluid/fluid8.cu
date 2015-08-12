#include <accelerate_cuda.h>
static TexFloat arrStencil1_1;
static TexFloat arrStencil1_0;
static TexFloat arrStencil2_0;
extern "C" __global__ void stencil2(const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0, const Int64 shStencil1_1, const Int64 shStencil1_0, const Int64 shStencil2_1, const Int64 shStencil2_0)
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
const float x9 = indexArray(arrStencil1_1, ix);
const float x8 = indexArray(arrStencil1_0, ix);
const Int64 z1 = (sh1 + -1) * shStencil1_0 + (sh0 + 0);
const Int64 z3 = (sh1 + 0) * shStencil1_0 + (sh0 + -1);
const Int64 z4 = (sh1 + 0) * shStencil1_0 + (sh0 + 1);
const Int64 z6 = (sh1 + 1) * shStencil1_0 + (sh0 + 0);
const float y7 = indexArray(arrStencil2_0, z1);
const float y5 = indexArray(arrStencil2_0, z3);
const float y3 = indexArray(arrStencil2_0, z4);
const float y1 = indexArray(arrStencil2_0, z6);
const float v0 = y3 - y5;
const float v1 = y1 - y7;
const float v2 = 0.5f * v0;
const float v3 = 0.5f * v1;

arrOut_1[ix] = x9 - v2;
arrOut_0[ix] = x8 - v3;
} else {
const float x9 = indexArray(arrStencil1_1, ix);
const float x8 = indexArray(arrStencil1_0, ix);
const int z3 = ({ const Int64 _i = sh1 + -1;  _i >= 0 && _i < shStencil1_1; }) && ({ const Int64 _i = sh0 + 0;  _i >= 0 && _i < shStencil1_0; });
const Int64 z2 = (sh1 + -1) * shStencil1_0 + (sh0 + 0);
const int z7 = ({ const Int64 _i = sh1 + 0;  _i >= 0 && _i < shStencil1_1; }) && ({ const Int64 _i = sh0 + -1;  _i >= 0 && _i < shStencil1_0; });
const Int64 z6 = (sh1 + 0) * shStencil1_0 + (sh0 + -1);
const int z9 = ({ const Int64 _i = sh1 + 0;  _i >= 0 && _i < shStencil1_1; }) && ({ const Int64 _i = sh0 + 1;  _i >= 0 && _i < shStencil1_0; });
const Int64 z8 = (sh1 + 0) * shStencil1_0 + (sh0 + 1);
const int z13 = ({ const Int64 _i = sh1 + 1;  _i >= 0 && _i < shStencil1_1; }) && ({ const Int64 _i = sh0 + 0;  _i >= 0 && _i < shStencil1_0; });
const Int64 z12 = (sh1 + 1) * shStencil1_0 + (sh0 + 0);
const float y7 = z3 ? indexArray(arrStencil2_0, z2) : 0.0f;
const float y5 = z7 ? indexArray(arrStencil2_0, z6) : 0.0f;
const float y3 = z9 ? indexArray(arrStencil2_0, z8) : 0.0f;
const float y1 = z13 ? indexArray(arrStencil2_0, z12) : 0.0f;
const float v0 = y3 - y5;
const float v1 = y1 - y7;
const float v2 = 0.5f * v0;
const float v3 = 0.5f * v1;

arrOut_1[ix] = x9 - v2;
arrOut_0[ix] = x8 - v3;
}
}
}
