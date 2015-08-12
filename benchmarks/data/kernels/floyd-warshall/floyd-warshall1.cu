#include <accelerate_cuda.h>
static TexInt64 arrIn0_0;
static TexInt32 arrIn1_0;
extern "C" __global__ void generate(const Int64 shIn1_1, const Int64 shIn1_0, const Int64 shOut_1, const Int64 shOut_0, Int32* __restrict__ arrOut_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;
const Int64 v0 = sh1 * shIn1_0 + sh0;
const Int64 v1 = 0;
const Int64 v2 = indexArray(arrIn0_0, v1);
const Int64 v3 = sh1 * shIn1_0 + v2;
const Int64 v4 = v2 * shIn1_0 + sh0;

arrOut_0[ix] = min(indexArray(arrIn1_0, v0), indexArray(arrIn1_0, v3) + indexArray(arrIn1_0, v4));
}
}
