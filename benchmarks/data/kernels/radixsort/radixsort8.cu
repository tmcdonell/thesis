#include <accelerate_cuda.h>
static TexInt64 arrIn0_0;
static TexInt64 arrIn1_0;
static TexInt64 arrIn2_0;
static TexInt32 arrIn3_0;
extern "C" __global__ void permute(const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shIn2_0, const Int64 shIn3_0, const Int64 shOut_0, Int32* __restrict__ arrOut_0)
{
const Int64 shIn0 = shIn3_0;
const int shapeSize = shIn0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 sh0 = ({ assert(ix >= 0 && ix < shIn0); ix; });
const Int64 v0 = indexArray(arrIn1_0, sh0);
const Int64 v1 = (Int64) -1 + shIn3_0 - indexArray(arrIn0_0, sh0);
const Word8 v2 = (Int64) 0 == indexArray(arrIn2_0, sh0);
const Int64 sh_0 = v2 ? v0 : v1;

if (!(sh_0 == -1)) {
Int32 y0;
Int32 _y0;
const Int64 jx0 = sh_0;
const Int32 x0 = indexArray(arrIn3_0, ix);

arrOut_0[jx0] = x0;
}
}
}
