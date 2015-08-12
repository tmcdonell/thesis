#include <accelerate_cuda.h>
static TexWord32 arrIn0_0;
extern "C" __global__ void map(const Int64 shIn0_1, const Int64 shIn0_0, const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Word32 x0 = indexArray(arrIn0_0, ix);
const Word32 v0 = (Word32) 255;

arrOut_0[ix] = 255.0f * ((0.3f * (float) (v0 & x0) + 0.59f * (float) (v0 & idiv(x0, (Word32) 256)) + 0.11f * (float) (v0 & idiv(x0, (Word32) 65536))) / 255.0f);
}
}
