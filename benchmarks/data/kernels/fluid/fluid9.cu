#include <accelerate_cuda.h>
static TexFloat arrIn0_1;
static TexFloat arrIn0_0;
extern "C" __global__ void generate(const Int64 shIn0_1, const Int64 shIn0_0, const Int64 shOut_1, const Int64 shOut_0, float* __restrict__ arrOut_1, float* __restrict__ arrOut_0)
{
const int shapeSize = shOut_1 * shOut_0;
const int gridSize = __umul24(blockDim.x, gridDim.x);
int ix;

for (ix = __umul24(blockDim.x, blockIdx.x) + threadIdx.x; ix < shapeSize; ix += gridSize) {
const Int64 tmp_0 = ix;
const Int64 tmp_1 = tmp_0 / shOut_0;
const Int64 sh1 = tmp_1 % shOut_1;
const Int64 sh0 = tmp_0 % shOut_0;
const Int64 v0 = (Int64) 0;
const Int64 v1 = (Int64) 1;
const Int64 v2 = sh1 * shIn0_0 + sh0;
const float v3 = indexArray(arrIn0_1, v2);
const float v4 = indexArray(arrIn0_0, v2);
const float v5 = (float) shIn0_0;
const float v6 = fmaxf(-0.5f, fminf(0.5f + v5, (float) sh0 - 0.1f * v5 * v3));
const float v7 = (float) shIn0_1;
const float v8 = fmaxf(-0.5f, fminf(0.5f + v7, (float) sh1 - 0.1f * v7 * v4));
const Int64 v9 = (Int64) -1 + (Int64) truncf(1.0f + v6);
const Int64 v10 = (Int64) -1 + (Int64) truncf(1.0f + v8);
const float v11 = v6 - (float) v9;
const float v12 = v8 - (float) v10;
const Int64 v13 = v1 + v10;
const float v14 = 1.0f - v12;
const float v15 = 1.0f - v11;
const Word8 v16 = v10 < v0 || (v9 < v0 || (v10 >= shIn0_1 || v9 >= shIn0_0));
const Int64 v17 = v10 * shIn0_0 + v9;
const float v18 = v16 ? 0.0f : indexArray(arrIn0_1, v17);
const float v19 = v16 ? 0.0f : indexArray(arrIn0_0, v17);
const float v20 = v14 * v18;
const float v21 = v14 * v19;
const Word8 v22 = v13 < v0 || (v9 < v0 || (v13 >= shIn0_1 || v9 >= shIn0_0));
const Int64 v23 = v13 * shIn0_0 + v9;
const float v24 = v22 ? 0.0f : indexArray(arrIn0_1, v23);
const float v25 = v22 ? 0.0f : indexArray(arrIn0_0, v23);
const float v26 = v12 * v24;
const float v27 = v12 * v25;
const float v28 = v20 + v26;
const float v29 = v21 + v27;
const float v30 = v15 * v28;
const float v31 = v15 * v29;
const Int64 v32 = v1 + v9;
const Word8 v33 = v10 < v0 || (v32 < v0 || (v10 >= shIn0_1 || v32 >= shIn0_0));
const Int64 v34 = v10 * shIn0_0 + v32;
const float v35 = v33 ? 0.0f : indexArray(arrIn0_1, v34);
const float v36 = v33 ? 0.0f : indexArray(arrIn0_0, v34);
const float v37 = v14 * v35;
const float v38 = v14 * v36;
const Word8 v39 = v13 < v0 || (v32 < v0 || (v13 >= shIn0_1 || v32 >= shIn0_0));
const Int64 v40 = v13 * shIn0_0 + v32;
const float v41 = v39 ? 0.0f : indexArray(arrIn0_1, v40);
const float v42 = v39 ? 0.0f : indexArray(arrIn0_0, v40);
const float v43 = v12 * v41;
const float v44 = v12 * v42;
const float v45 = v37 + v43;
const float v46 = v38 + v44;
const float v47 = v11 * v45;
const float v48 = v11 * v46;

arrOut_1[ix] = v30 + v47;
arrOut_0[ix] = v31 + v48;
}
}
