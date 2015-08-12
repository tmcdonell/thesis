#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64* __restrict__ arrIn0_0, const double* __restrict__ arrIn1_0, Word8* __restrict__ arrOut_0)
{
const int shapeSize = 1;
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
arrOut_0[ix] = ({
const Int64 v0 = 0;

;
arrIn1_0[v0];
}) < 1.0e-2 && ({
const Int64 v1 = 0;

;
arrIn0_0[v1];
}) < (Int64) 9999999;
}
}
