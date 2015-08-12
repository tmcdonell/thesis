#include <accelerate_cuda.h>
static TexFloat arrIn0_2;
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
extern "C" __global__ void map(const Int64 shIn0_0, const Int64 shOut_0, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const float x2 = indexArray(arrIn0_2, ix);
const float x1 = indexArray(arrIn0_1, ix);
const float x0 = indexArray(arrIn0_0, ix);
const float v0 = 0.3f * sqrtf(x0);
const float v1 = x1 * expf(-(2.0e-2f * x0));
const float v2 = (logf(x2 / x1) + 6.5e-2f * x0) / v0;
const float v3 = 1.0f / (1.0f + 0.2316419f * fabsf(v2));
const float v4 = 0.3989423f * expf(-(0.5f * v2 * v2)) * (v3 * (0.31938154f + v3 * (-0.35656378f + v3 * (1.7814779f + v3 * (-1.8212559f + 1.3302745f * v3)))));
const Word8 v5 = v2 > 0.0f;
const float v6 = v5 ? 1.0f - v4 : v4;
const float v7 = v2 - v0;
const float v8 = 1.0f / (1.0f + 0.2316419f * fabsf(v7));
const float v9 = 0.3989423f * expf(-(0.5f * v7 * v7)) * (v8 * (0.31938154f + v8 * (-0.35656378f + v8 * (1.7814779f + v8 * (-1.8212559f + 1.3302745f * v8)))));
const Word8 v10 = v7 > 0.0f;
const float v11 = v10 ? 1.0f - v9 : v9;

arrOut_1[ix] = x2 * v6 - v1 * v11;
arrOut_0[ix] = v1 * (1.0f - v11) - x2 * (1.0f - v6);
}
}
