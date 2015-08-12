#include <accelerate_cuda.h>
extern "C" __global__ void generate(const double* __restrict__ arrIn0_0, const double* __restrict__ arrIn1_0, const double* __restrict__ arrIn2_0, const double* __restrict__ arrIn3_0, double* __restrict__ arrOut_1, double* __restrict__ arrOut_0)
{
const int shapeSize = 1;
const int gridSize = blockDim.x * gridDim.x;
int ix;

for (ix = blockDim.x * blockIdx.x + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 v0 = 0;
const double v1 = arrIn3_0[v0];
const double v17 = fmin(1.0e-2, ({ const Int64 v2 = 0; const double v3 = arrIn0_0[v2]; const Int64 v4 = 0; const double v5 = arrIn2_0[v4]; const Int64 v6 = 0; const double v7 = arrIn1_0[v6]; const Word8 v8 = v7 < 1.0e20; double lv90;  if (v8) { lv90 = 0.5 * v7; } else { lv90 = 1.0e20; }  const Word8 v10 = v5 < lv90; double lv110;  if (v10) { lv110 = 0.6666666666666666 * v5; } else { lv110 = lv90; }  const double v12 = lv110 / v3; const Word8 v13 = v12 >= 1.0 && v12 < 1.1; double lv160;  if (v13) { lv160 = v3; } else { const Word8 v14 = v12 >= 1.0 && v12 > 1.2; double lv150;  if (v14) { lv150 = 1.2 * v3; } else { lv150 = lv110; } lv160 = lv150; } ; lv160; }));
const double v21 = fmin(v17, ({ const double v18 = 1.0e-2 - v1; const Word8 v19 = v18 > v17 && v18 < 4.0 * v17 / 3.0; double lv200;  if (v19) { lv200 = 0.6666666666666666 * v17; } else { lv200 = v18; } ; lv200; }));

arrOut_1[ix] = v1 + v21;
arrOut_0[ix] = v21;
}
}
