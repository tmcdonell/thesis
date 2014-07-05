#include <accelerate_cuda.h>
static TexFloat arrIn0_0;
static TexInt64 arrIn1_0;
static TexInt64 arrIn2_0;
extern "C" __global__ void permute(const Int64 shIn0_1, const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shIn2_0, const Int64 shOut_0, Int64* __restrict__ arrOut_0)
{
const Int64 shIn0 = shIn0_1 * shIn0_0;
const int shapeSize = shIn0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 sh0 = ({ assert(ix >= 0 && ix < shIn0); ix; });
const Word8 v0 = (Int64) 0 == indexArray(arrIn2_0, sh0);
const Int64 sh_0 = v0 ? (Int64) -1 : indexArray(arrIn1_0, sh0);

if (!(sh_0 == -1)) {
Int64 y0;
Int64 _y0;
const Int64 jx0 = sh_0;
const Int64 v3 = ({ assert(ix >= 0 && ix < shIn0_1 * shIn0_0); ix; });
const Int64 x0 = (Int64) ({ assert(v3 >= 0 && v3 < shIn0_1 * shIn0_0); v3; });

arrOut_0[jx0] = x0;
}
}
}
