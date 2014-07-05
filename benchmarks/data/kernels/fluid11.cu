#include <accelerate_cuda.h>
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
static TexFloat arrIn1_0;
extern "C" __global__ void generate(const Int64 shIn0_1, const Int64 shIn0_0, const Int64 shIn1_1, const Int64 shIn1_0, const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;
const Int64 v0 = (Int64) 1;
const Int64 v1 = (Int64) 0;
const Int64 v2 = sh1 * shIn0_0 + sh0;
const float v3 = indexArray(arrIn0_1, v2);
const float v4 = indexArray(arrIn0_0, v2);
const float v5 = (float) shIn0_0;
const float v6 = fmaxf(-0.5f, fminf(0.5f + v5, (float) sh0 - 0.1f * v5 * v3));
const float v7 = (float) shIn0_1;
const float v8 = fmaxf(-0.5f, fminf(0.5f + v7, (float) sh1 - 0.1f * v7 * v4));
const Int64 v9 = (Int64) -1 + (Int64) truncf(1.0f + v6);
const Int64 v10 = (Int64) -1 + (Int64) truncf(1.0f + v8);
const float v11 = v6 - (float) v9;
const Int64 v12 = v0 + v10;
const float v13 = v8 - (float) v10;
const float v14 = 1.0f - v13;
const Word8 v15 = v10 < v1 || (v9 < v1 || (v10 >= shIn0_1 || v9 >= shIn0_0));
const Int64 v16 = v10 * shIn1_0 + v9;
const Word8 v17 = v12 < v1 || (v9 < v1 || (v12 >= shIn0_1 || v9 >= shIn0_0));
const Int64 v18 = v12 * shIn1_0 + v9;
const Int64 v19 = v0 + v9;
const Word8 v20 = v10 < v1 || (v19 < v1 || (v10 >= shIn0_1 || v19 >= shIn0_0));
const Int64 v21 = v10 * shIn1_0 + v19;
const Word8 v22 = v12 < v1 || (v19 < v1 || (v12 >= shIn0_1 || v19 >= shIn0_0));
const Int64 v23 = v12 * shIn1_0 + v19;

arrOut_0[ix] = (1.0f - v11) * (v14 * (v15 ? 0.0f : indexArray(arrIn1_0, v16)) + v13 * (v17 ? 0.0f : indexArray(arrIn1_0, v18))) + v11 * (v14 * (v20 ? 0.0f : indexArray(arrIn1_0, v21)) + v13 * (v22 ? 0.0f : indexArray(arrIn1_0, v23)));
}
}
