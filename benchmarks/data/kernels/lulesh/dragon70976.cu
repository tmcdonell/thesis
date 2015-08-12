#include <accelerate_cuda.h>
extern "C" __global__ void map(const Int64* __restrict__ arrIn0_0, Int64* __restrict__ arrOut_0)
{
const int shapeSize = 1;
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 x0 = arrIn0_0[ix];

arrOut_0[ix] = (Int64) 1 + x0;
}
}
