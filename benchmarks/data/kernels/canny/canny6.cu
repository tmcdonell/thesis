#include <accelerate_cuda.h>
static TexFloat arrIn0_0;
extern "C" __global__ void map(const Int64 shIn0_0, const Int64 shOut_0, Int64* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const float x0 = indexArray(arrIn0_0, ix);

arrOut_0[ix] = (Int64) (1.0f == x0);
}
}
