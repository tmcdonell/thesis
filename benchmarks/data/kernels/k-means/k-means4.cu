#include <accelerate_cuda.h>
static TexWord32 arrIn0_2;
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
extern "C" __global__ void generate(const Int64 shIn0_0, const Int64 shOut_0, Word32* __restrict__ arrOut_2, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 sh0 = ({ assert(ix >= 0 && ix < shOut_0); ix; });
const Word32 v0 = indexArray(arrIn0_2, sh0);
const float v1 = indexArray(arrIn0_1, sh0);
const float v2 = indexArray(arrIn0_0, sh0);

arrOut_2[ix] = (Word32) sh0;
arrOut_1[ix] = v1 / (float) v0;
arrOut_0[ix] = v2 / (float) v0;
}
}
