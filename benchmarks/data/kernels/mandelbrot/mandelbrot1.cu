#include <accelerate_cuda.h>
static TexFloat arrIn0_3;
static TexFloat arrIn0_2;
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
extern "C" __global__ void generate(const Int64 shOut_1, const Int64 shOut_0, Word32* __restrict__ arrOut_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;
const Int32 v0 = (Int32) 255;
const Int64 v1 = 0;
const float v2 = indexArray(arrIn0_3, v1);
const float v3 = indexArray(arrIn0_2, v1);
const float v4 = indexArray(arrIn0_1, v1);
const float v5 = indexArray(arrIn0_0, v1);
const float v6 = v2 + (float) sh0 * (v4 - v2) / 1600.0f;
const float v7 = v3 + (float) sh1 * (v5 - v3) / 1200.0f;
Int32 lv80 = (Int32) 0;
float lv81 = v7;
float lv82 = v6;
Word8 lv90;

lv90 = lv80 < v0 && lv82 * lv82 + lv81 * lv81 < 4.0f;
while (lv90) {
float lv102;
float lv101;
Int32 lv100;
const float v11 = lv82 * lv82 - lv81 * lv81;
const float v12 = lv82 * lv81 + lv81 * lv82;

lv102 = v6 + v11;
lv101 = v7 + v12;
lv100 = (Int32) 1 + lv80;
lv82 = lv102;
lv81 = lv101;
lv80 = lv100;
lv90 = lv80 < v0 && lv82 * lv82 + lv81 * lv81 < 4.0f;
}

const Word8 v13 = v0 == lv80;
const Int32 v14 = v0 - lv80;
const Word8 v15 = (Word8) 0;
const Word8 v16 = (Word8) ((Int32) 7 * v14);
const Word8 v17 = (Word8) ((Int32) 5 * v14);
const Word8 v18 = (Word8) ((Int32) 3 * v14);

arrOut_0[ix] = v13 ? (Word32) 4278190080 : (Word32) 4294967295 - ((Word32) v15 + (Word32) 256 * (Word32) v16 + (Word32) 65536 * (Word32) v17 + (Word32) 16777216 * (Word32) v18);
}
}
