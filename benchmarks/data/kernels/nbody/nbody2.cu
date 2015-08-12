#include <accelerate_cuda.h>
static TexFloat arrIn0_0;
static TexFloat arrIn1_9;
static TexFloat arrIn1_8;
static TexFloat arrIn1_7;
static TexFloat arrIn1_6;
static TexFloat arrIn1_5;
static TexFloat arrIn1_4;
static TexFloat arrIn1_3;
static TexFloat arrIn1_2;
static TexFloat arrIn1_1;
static TexFloat arrIn1_0;
extern "C" __global__ void map(const Int64 shIn1_0, const Int64 shOut_0, float* __restrict__ arrOut_9, float* __restrict__ arrOut_8, float* __restrict__ arrOut_7, float* __restrict__ arrOut_6, float* __restrict__ arrOut_5, float* __restrict__ arrOut_4, float* __restrict__ arrOut_3, float* __restrict__ arrOut_2, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const float x9 = indexArray(arrIn1_9, ix);
const float x8 = indexArray(arrIn1_8, ix);
const float x7 = indexArray(arrIn1_7, ix);
const float x6 = indexArray(arrIn1_6, ix);
const float x5 = indexArray(arrIn1_5, ix);
const float x4 = indexArray(arrIn1_4, ix);
const float x3 = indexArray(arrIn1_3, ix);
float lv00 = 0.0f;
float lv01 = 0.0f;
float lv02 = 0.0f;
Int64 lv03 = (Int64) 0;
Word8 lv10;

lv10 = lv03 < shIn1_0;
while (lv10) {
Int64 lv23;
float lv22;
float lv21;
float lv20;
const float v3 = indexArray(arrIn1_9, lv03);
const float v4 = indexArray(arrIn1_8, lv03);
const float v5 = indexArray(arrIn1_7, lv03);
const float v6 = indexArray(arrIn1_6, lv03);
const float v7 = v3 - x9;
const float v8 = v4 - x8;
const float v9 = v5 - x7;
const float v10 = 1.0f / sqrtf(2500.0f + (v7 * v7 + v8 * v8 + v9 * v9));
const float v11 = v6 * (v10 * v10 * v10);
const float v12 = v11 * v7;
const float v13 = v11 * v8;
const float v14 = v11 * v9;

lv23 = (Int64) 1 + lv03;
lv22 = lv02 + v12;
lv21 = lv01 + v13;
lv20 = lv00 + v14;
lv03 = lv23;
lv02 = lv22;
lv01 = lv21;
lv00 = lv20;
lv10 = lv03 < shIn1_0;
}

const Int64 v15 = 0;
const float v16 = indexArray(arrIn0_0, v15);
const float v17 = x6 * lv02;
const float v18 = x6 * lv01;
const float v19 = x6 * lv00;
const float v20 = v16 * x5;
const float v21 = v16 * x4;
const float v22 = v16 * x3;
const float v23 = v16 * v17;
const float v24 = v16 * v18;
const float v25 = v16 * v19;

arrOut_9[ix] = x9 + v20;
arrOut_8[ix] = x8 + v21;
arrOut_7[ix] = x7 + v22;
arrOut_6[ix] = x6;
arrOut_5[ix] = x5 + v23;
arrOut_4[ix] = x4 + v24;
arrOut_3[ix] = x3 + v25;
arrOut_2[ix] = v17;
arrOut_1[ix] = v18;
arrOut_0[ix] = v19;
}
}

