#include <accelerate_cuda.h>
static TexInt64 arrIn0_0;
static TexInt32 arrIn1_0;
extern "C" __global__ void map(const Int64 shIn1_0, const Int64 shOut_0, Int64* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int32 x0 = indexArray(arrIn1_0, ix);
const Int32 v0 = (Int32) 1;
const Int64 v1 = 0;
const Int64 v2 = indexArray(arrIn0_0, v1);
const Word8 v3 = (Int64) 31 == v2;

arrOut_0[ix] = v3 ? (Int64) (v0 & ((Int32) -2147483648 ^ x0) >> v2) : (Int64) (v0 & x0 >> v2);
}
}
