#include <accelerate_cuda.h>
extern "C" __global__ void map(const double* __restrict__ arrIn0_1, const double* __restrict__ arrIn0_0, double* __restrict__ arrOut_0)
{
const int shapeSize = 1;
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
const double x1 = arrIn0_1[ix];

arrOut_0[ix] = x1;
}
}
