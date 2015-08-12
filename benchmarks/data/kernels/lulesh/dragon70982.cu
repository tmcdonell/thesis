#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64 shOut_2, const Int64 shOut_1, const Int64 shOut_0, double* __restrict__ arrOut_0)
{
const int shapeSize = shOut_2 * (shOut_1 * shOut_0);
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 tmp_2 = tmp_1 / shOut_1;
const Int64 sh2 = tmp_2 % shOut_2;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;
const Int64 v0 = (Int64) 0;
const Word8 v1 = v0 == sh2 && (v0 == sh1 && v0 == sh0);
double lv20;

if (v1) {
lv20 = 3.948746e7;
} else {
lv20 = 0.0;
}
arrOut_0[ix] = lv20;
}
}
