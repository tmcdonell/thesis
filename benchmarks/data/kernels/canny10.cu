#include <accelerate_cuda.h>
static TexInt64 arrIn0_0;
extern "C" __global__ void generate(const Int64 shOut_0, Int64* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
arrOut_0[ix] = (Int64) 0;
}
}
