#include <accelerate_cuda.h>
static TexFloat arrIn0_2;
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
static TexFloat arrIn1_0;
extern "C" __global__ void generate(const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shOut_0, float* __restrict__ arrOut_9, float* __restrict__ arrOut_8, float* __restrict__ arrOut_7, float* __restrict__ arrOut_6, float* __restrict__ arrOut_5, float* __restrict__ arrOut_4, float* __restrict__ arrOut_3, float* __restrict__ arrOut_2, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 sh0 = ({ assert(ix >= 0 && ix < shOut_0); ix; });
const float v0 = indexArray(arrIn0_2, sh0);
const float v1 = indexArray(arrIn0_1, sh0);
const float v2 = indexArray(arrIn0_0, sh0);
const float v3 = indexArray(arrIn1_0, sh0);
const float v4 = sqrtf(sqrtf(v0 * v0 + v1 * v1 + v2 * v2));
const float v5 = 1.0f / sqrtf(v0 * v0 + v1 * v1 + v2 * v2);
const float v6 = v5 * v0;
const float v7 = v5 * v1;
const float v8 = v5 * v2;
const float v9 = -v6;

arrOut_9[ix] = v0;
arrOut_8[ix] = v1;
arrOut_7[ix] = v2;
arrOut_6[ix] = v3;
arrOut_5[ix] = v4 * v7;
arrOut_4[ix] = v4 * v9;
arrOut_3[ix] = v4 * v8;
arrOut_2[ix] = 0.0f;
arrOut_1[ix] = 0.0f;
arrOut_0[ix] = 0.0f;
}
}
