#include <accelerate_cuda.h>
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
static TexWord32 arrIn1_2;
static TexFloat arrIn1_1;
static TexFloat arrIn1_0;
extern "C" __global__ void fold1(const Int64 shIn0_0, const Int64 shIn1_0, const Int64 shOut_0, Word32* __restrict__ arrOut_2, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
extern volatile __shared__ Word32 sdata2[];
volatile float* sdata1 = (float*) &sdata2[blockDim.x];
volatile float* sdata0 = (float*) &sdata1[blockDim.x];
Word32 x2;
float x1;
float x0;
Word32 y2;
float y1;
float y0;
const Int64 sh1 = shIn1_0;
const Int64 sh0 = shIn0_0;
const int numIntervals = sh1;
const int intervalSize = sh0;
int ix;
int seg;

for (seg = blockIdx.x; seg < numIntervals; seg += gridDim.x) {
const int start = seg * intervalSize;
const int end = start + intervalSize;
const int n = min(end - start, blockDim.x);

if (threadIdx.x >= n)
return;

ix = start - (start & warpSize - 1);
if (ix == start || intervalSize > blockDim.x) {
ix += threadIdx.x;
if (ix >= start) {
const Int64 v13_0 = ix;
const Int64 v13_1 = v13_0 / shIn0_0;
const Int64 v14 = v13_1 % shIn1_0;
const Int64 v15 = v13_0 % shIn0_0;
const float v16 = indexArray(arrIn0_1, v15);
const float v17 = indexArray(arrIn0_0, v15);
float lv180 = 3.4028235e38f;
Word32 lv181 = (Word32) 4294967295;
Int64 lv182 = (Int64) 0;
Word8 lv190;

lv190 = lv182 < shIn1_0;
while (lv190) {
Int64 lv202;
Word32 lv201;
float lv200;
const Word32 v21 = indexArray(arrIn1_2, lv182);
const float v22 = indexArray(arrIn1_1, lv182);
const float v23 = indexArray(arrIn1_0, lv182);
const float v24 = v16 - v22;
const float v25 = v17 - v23;
const float v26 = v24 * v24 + v25 * v25;
const Word8 v27 = v26 < lv180;

lv202 = (Int64) 1 + lv182;
lv201 = v27 ? v21 : lv181;
lv200 = v27 ? v26 : lv180;
lv182 = lv202;
lv181 = lv201;
lv180 = lv200;
lv190 = lv182 < shIn1_0;
}

const Word8 v28 = lv181 == (Word32) v14;

y2 = v28 ? (Word32) 1 : (Word32) 0;
y1 = v28 ? indexArray(arrIn0_1, v15) : 0.0f;
y0 = v28 ? indexArray(arrIn0_0, v15) : 0.0f;
}
if (ix + blockDim.x < end) {
const Int64 v13_0 = ix + blockDim.x;
const Int64 v13_1 = v13_0 / shIn0_0;
const Int64 v14 = v13_1 % shIn1_0;
const Int64 v15 = v13_0 % shIn0_0;
const float v16 = indexArray(arrIn0_1, v15);
const float v17 = indexArray(arrIn0_0, v15);
float lv180 = 3.4028235e38f;
Word32 lv181 = (Word32) 4294967295;
Int64 lv182 = (Int64) 0;
Word8 lv190;

lv190 = lv182 < shIn1_0;
while (lv190) {
Int64 lv202;
Word32 lv201;
float lv200;
const Word32 v21 = indexArray(arrIn1_2, lv182);
const float v22 = indexArray(arrIn1_1, lv182);
const float v23 = indexArray(arrIn1_0, lv182);
const float v24 = v16 - v22;
const float v25 = v17 - v23;
const float v26 = v24 * v24 + v25 * v25;
const Word8 v27 = v26 < lv180;

lv202 = (Int64) 1 + lv182;
lv201 = v27 ? v21 : lv181;
lv200 = v27 ? v26 : lv180;
lv182 = lv202;
lv181 = lv201;
lv180 = lv200;
lv190 = lv182 < shIn1_0;
}

const Word8 v28 = lv181 == (Word32) v14;

x2 = v28 ? (Word32) 1 : (Word32) 0;
x1 = v28 ? indexArray(arrIn0_1, v15) : 0.0f;
x0 = v28 ? indexArray(arrIn0_0, v15) : 0.0f;
if (ix >= start) {
y2 = x2 + y2;
y1 = x1 + y1;
y0 = x0 + y0;
} else {
y2 = x2;
y1 = x1;
y0 = x0;
}
}
for (ix += 2 * blockDim.x; ix < end; ix += blockDim.x) {
const Int64 v13_0 = ix;
const Int64 v13_1 = v13_0 / shIn0_0;
const Int64 v14 = v13_1 % shIn1_0;
const Int64 v15 = v13_0 % shIn0_0;
const float v16 = indexArray(arrIn0_1, v15);
const float v17 = indexArray(arrIn0_0, v15);
float lv180 = 3.4028235e38f;
Word32 lv181 = (Word32) 4294967295;
Int64 lv182 = (Int64) 0;
Word8 lv190;

lv190 = lv182 < shIn1_0;
while (lv190) {
Int64 lv202;
Word32 lv201;
float lv200;
const Word32 v21 = indexArray(arrIn1_2, lv182);
const float v22 = indexArray(arrIn1_1, lv182);
const float v23 = indexArray(arrIn1_0, lv182);
const float v24 = v16 - v22;
const float v25 = v17 - v23;
const float v26 = v24 * v24 + v25 * v25;
const Word8 v27 = v26 < lv180;

lv202 = (Int64) 1 + lv182;
lv201 = v27 ? v21 : lv181;
lv200 = v27 ? v26 : lv180;
lv182 = lv202;
lv181 = lv201;
lv180 = lv200;
lv190 = lv182 < shIn1_0;
}

const Word8 v28 = lv181 == (Word32) v14;

x2 = v28 ? (Word32) 1 : (Word32) 0;
x1 = v28 ? indexArray(arrIn0_1, v15) : 0.0f;
x0 = v28 ? indexArray(arrIn0_0, v15) : 0.0f;
y2 = x2 + y2;
y1 = x1 + y1;
y0 = x0 + y0;
}
} else {
const Int64 v13_0 = start + threadIdx.x;
const Int64 v13_1 = v13_0 / shIn0_0;
const Int64 v14 = v13_1 % shIn1_0;
const Int64 v15 = v13_0 % shIn0_0;
const float v16 = indexArray(arrIn0_1, v15);
const float v17 = indexArray(arrIn0_0, v15);
float lv180 = 3.4028235e38f;
Word32 lv181 = (Word32) 4294967295;
Int64 lv182 = (Int64) 0;
Word8 lv190;

lv190 = lv182 < shIn1_0;
while (lv190) {
Int64 lv202;
Word32 lv201;
float lv200;
const Word32 v21 = indexArray(arrIn1_2, lv182);
const float v22 = indexArray(arrIn1_1, lv182);
const float v23 = indexArray(arrIn1_0, lv182);
const float v24 = v16 - v22;
const float v25 = v17 - v23;
const float v26 = v24 * v24 + v25 * v25;
const Word8 v27 = v26 < lv180;

lv202 = (Int64) 1 + lv182;
lv201 = v27 ? v21 : lv181;
lv200 = v27 ? v26 : lv180;
lv182 = lv202;
lv181 = lv201;
lv180 = lv200;
lv190 = lv182 < shIn1_0;
}

const Word8 v28 = lv181 == (Word32) v14;

y2 = v28 ? (Word32) 1 : (Word32) 0;
y1 = v28 ? indexArray(arrIn0_1, v15) : 0.0f;
y0 = v28 ? indexArray(arrIn0_0, v15) : 0.0f;
}
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 256 < n) {
x2 = sdata2[threadIdx.x + 256];
x1 = sdata1[threadIdx.x + 256];
x0 = sdata0[threadIdx.x + 256];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
}
__syncthreads();
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 128 < n) {
x2 = sdata2[threadIdx.x + 128];
x1 = sdata1[threadIdx.x + 128];
x0 = sdata0[threadIdx.x + 128];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
}
__syncthreads();
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x + 64 < n) {
x2 = sdata2[threadIdx.x + 64];
x1 = sdata1[threadIdx.x + 64];
x0 = sdata0[threadIdx.x + 64];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
}
__syncthreads();
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
__syncthreads();
if (threadIdx.x < 32) {
if (threadIdx.x + 32 < n) {
x2 = sdata2[threadIdx.x + 32];
x1 = sdata1[threadIdx.x + 32];
x0 = sdata0[threadIdx.x + 32];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 16 < n) {
x2 = sdata2[threadIdx.x + 16];
x1 = sdata1[threadIdx.x + 16];
x0 = sdata0[threadIdx.x + 16];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 8 < n) {
x2 = sdata2[threadIdx.x + 8];
x1 = sdata1[threadIdx.x + 8];
x0 = sdata0[threadIdx.x + 8];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 4 < n) {
x2 = sdata2[threadIdx.x + 4];
x1 = sdata1[threadIdx.x + 4];
x0 = sdata0[threadIdx.x + 4];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 2 < n) {
x2 = sdata2[threadIdx.x + 2];
x1 = sdata1[threadIdx.x + 2];
x0 = sdata0[threadIdx.x + 2];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
}
if (threadIdx.x + 1 < n) {
x2 = sdata2[threadIdx.x + 1];
x1 = sdata1[threadIdx.x + 1];
x0 = sdata0[threadIdx.x + 1];
y2 = y2 + x2;
y1 = y1 + x1;
y0 = y0 + x0;
sdata2[threadIdx.x] = y2;
sdata1[threadIdx.x] = y1;
sdata0[threadIdx.x] = y0;
}
}
if (threadIdx.x == 0) {
arrOut_2[seg] = y2;
arrOut_1[seg] = y1;
arrOut_0[seg] = y0;
}
}
}
