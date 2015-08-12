#include <accelerate_cuda.h>
static TexFloat arrIn0_1;
static TexInt64 arrIn0_0;
extern "C" __global__ void generate(const Int64 shIn0_1, const Int64 shIn0_0, const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_0)
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
const Int64 v1 = sh1 * shIn0_0 + sh0;
const float v2 = indexArray(arrIn0_1, v1);
const Int64 v3 = indexArray(arrIn0_0, v1);
const Int64 v4 = (Int64) 0;
const Int64 v5 = (Int64) -1;
const Int64 v6 = (Int64) -1 + shIn0_0;
const Int64 v7 = (Int64) -1 + shIn0_1;
const Word8 v8 = v3 < (Int64) 255;
const Int64 v9 = v8 ? v5 : v4;
const Int64 v10 = (Int64) 128;
const Word8 v11 = v3 > v10;
const Word8 v12 = v3 < v10;
const Int64 v13 = v11 ? v5 : v12 ? v0 : v4;
const Int64 v14 = min(max(v4, sh1 + v9), v7) * shIn0_0 + min(max(v4, sh0 + v13), v6);
const Int64 v15 = min(max(v4, sh1 - v9), v7) * shIn0_0 + min(max(v4, sh0 - v13), v6);

arrOut_0[ix] = 0.5f * (float) ((Int64) !(v4 == v3 || (v2 < 50.0f || (v2 < indexArray(arrIn0_1, v14) || v2 < indexArray(arrIn0_1, v15)))) * (v0 + (Int64) (v2 >= 100.0f)));
}
}
