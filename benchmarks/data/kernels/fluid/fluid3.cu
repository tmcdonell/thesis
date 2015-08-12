#include <accelerate_cuda.h>
static TexInt64 arrIn0_1;
static TexInt64 arrIn0_0;
static TexFloat arrIn1_1;
static TexFloat arrIn1_0;
extern "C" __global__ void permute(const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
const Int64 shIn0 = shIn1_0;
const int shapeSize = shIn0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 sh0 = ({ assert(ix >= 0 && ix < shIn0); ix; });
const Int64 sh_1 = indexArray(arrIn0_1, sh0);
const Int64 sh_0 = indexArray(arrIn0_0, sh0);

if (!(sh_1 == -1 && sh_0 == -1)) {
float y1;
float y0;
float _y1;
float _y0;
const Int64 jx0 = sh_1 * shOut_0 + sh_0;
const float x1 = indexArray(arrIn1_1, ix);
const float x0 = indexArray(arrIn1_0, ix);

y1 = arrOut_1[jx0];
y0 = arrOut_0[jx0];
do {
_y1 = y1;
y1 = atomicCAS32(&arrOut_1[jx0], _y1, x1 + y1);
} while(y1 != _y1);
do {
_y0 = y0;
y0 = atomicCAS32(&arrOut_0[jx0], _y0, x0 + y0);
} while(y0 != _y0);
}
}
}
