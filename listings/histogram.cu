#include <accelerate_cuda.h>
typedef DIM1 DimOut;
typedef DIM1 DimIn;
extern "C" __global__ void permute(const DIM1 shIn0, const float* __restrict__ arrIn0_a0, const DIM1 shOut, Int64* __restrict__ arrOut_a0)
{
    const Int64 sh0 = shIn0;
    const DimIn shIn = shape(sh0);
    const int shapeSize = sh0;
    const int gridSize = blockDim.x * gridDim.x;
    int ix;

    for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
        DimOut dst;
        const DimIn src = fromIndex(shIn, ix);
        const int v0 = toIndex(shIn0, shape(src));

        dst = (Int64) floorf(arrIn0_a0[v0] / 10.0f);
        if (!ignore(dst)) {
            Int64 y0;
            Int64 _y0;
            const int jx = toIndex(shOut, dst);
            const Int64 v1 = ix;
            const Int64 x0 = (Int64) 1;

            y0 = arrOut_a0[jx];
            do {
                _y0 = y0;
                y0 = atomicCAS64(&arrOut_a0[jx], _y0, x0 + y0);
            } while(y0 != _y0);
        }
    }
}
