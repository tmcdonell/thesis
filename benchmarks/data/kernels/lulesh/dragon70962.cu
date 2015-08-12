#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_0, const Int64 shIn1_2, const Int64 shIn1_1, const Int64 shIn1_0, const double* __restrict__ arrIn1_5, const double* __restrict__ arrIn1_4, const double* __restrict__ arrIn1_3, const double* __restrict__ arrIn1_2, const double* __restrict__ arrIn1_1, const double* __restrict__ arrIn1_0, const Int64 shIn2_2, const Int64 shIn2_1, const Int64 shIn2_0, const double* __restrict__ arrIn2_3, const double* __restrict__ arrIn2_2, const double* __restrict__ arrIn2_1, const double* __restrict__ arrIn2_0, const Int64 shOut_2, const Int64 shOut_1, const Int64 shOut_0, double* __restrict__ arrOut_1, double* __restrict__ arrOut_0)
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
const Word8 v1 = ({ const Int64 v0 = (sh2 * shIn2_1 + sh1) * shIn2_0 + sh0;  ; arrIn2_1[v0]; }) > 0.0;
double lv580;
double lv581;

if (v1) {
lv581 = 0.0;
lv580 = 0.0;
} else {
const double v5 = ({ const Int64 v2 = (sh2 * shIn0_1 + sh1) * shIn0_0 + sh0;  ; arrIn0_0[v2]; }) / (({ const Int64 v3 = (sh2 * shIn0_1 + sh1) * shIn0_0 + sh0;  ; arrIn0_0[v3]; }) * ({ const Int64 v4 = (sh2 * shIn2_1 + sh1) * shIn2_0 + sh0;  ; arrIn2_3[v4]; }));
const Int64 v6 = (sh2 * shIn1_1 + sh1) * shIn1_0 + sh0;
const double v7 = arrIn1_2[v6];
const double v8 = arrIn1_1[v6];
const double v9 = arrIn1_0[v6];
const Int64 v10 = (sh2 * shIn1_1 + sh1) * shIn1_0 + sh0;
const double v11 = arrIn1_5[v10];
const double v12 = arrIn1_4[v10];
const double v13 = arrIn1_3[v10];
const double v14 = v11 * v7;
const double v15 = v12 * v8;
const double v16 = v13 * v9;
const double v17 = fmin(0.0, v14);
const double v18 = fmin(0.0, v15);
const double v19 = fmin(0.0, v16);
const Int64 v20 = (Int64) 0;
const Int64 v21 = (Int64) 1;
const double v55 = fmin(2.0, fmax(0.0, ({ const double v22 = 1.0 / (1.0e-36 + v7); const double v27 = ({ const Int64 v23 = v21 + sh0; const Word8 v24 = v23 >= shIn0_0 || (sh1 >= shIn0_0 || sh2 >= shIn0_0); double lv260; double lv261; double lv262;  if (v24) { lv262 = 0.0; lv261 = 0.0; lv260 = 0.0; } else { const Int64 v25 = (max(v20, sh2) * shIn1_1 + max(v20, sh1)) * shIn1_0 + max(v20, v23);  lv262 = arrIn1_2[v25]; lv261 = arrIn1_1[v25]; lv260 = arrIn1_0[v25]; } ; lv262; }) * v22;  ; fmin(({ const double v32 = ({ const Int64 v28 = (Int64) -1 + sh0; const Word8 v29 = v28 >= shIn0_0 || (sh1 >= shIn0_0 || sh2 >= shIn0_0); double lv310; double lv311; double lv312;  if (v29) { lv312 = 0.0; lv311 = 0.0; lv310 = 0.0; } else { const Int64 v30 = (max(v20, sh2) * shIn1_1 + max(v20, sh1)) * shIn1_0 + max(v20, v28);  lv312 = arrIn1_2[v30]; lv311 = arrIn1_1[v30]; lv310 = arrIn1_0[v30]; } ; lv312; }) * v22;  ; fmin(v32, 0.5 * (v32 + v27)); }), v27); })));
const double v56 = fmin(2.0, fmax(0.0, ({ const double v33 = 1.0 / (1.0e-36 + v8); const double v38 = ({ const Int64 v34 = v21 + sh1; const Word8 v35 = sh0 >= shIn0_0 || (v34 >= shIn0_0 || sh2 >= shIn0_0); double lv370; double lv371; double lv372;  if (v35) { lv372 = 0.0; lv371 = 0.0; lv370 = 0.0; } else { const Int64 v36 = (max(v20, sh2) * shIn1_1 + max(v20, v34)) * shIn1_0 + max(v20, sh0);  lv372 = arrIn1_2[v36]; lv371 = arrIn1_1[v36]; lv370 = arrIn1_0[v36]; } ; lv371; }) * v33;  ; fmin(({ const double v43 = ({ const Int64 v39 = (Int64) -1 + sh1; const Word8 v40 = sh0 >= shIn0_0 || (v39 >= shIn0_0 || sh2 >= shIn0_0); double lv420; double lv421; double lv422;  if (v40) { lv422 = 0.0; lv421 = 0.0; lv420 = 0.0; } else { const Int64 v41 = (max(v20, sh2) * shIn1_1 + max(v20, v39)) * shIn1_0 + max(v20, sh0);  lv422 = arrIn1_2[v41]; lv421 = arrIn1_1[v41]; lv420 = arrIn1_0[v41]; } ; lv421; }) * v33;  ; fmin(v43, 0.5 * (v43 + v38)); }), v38); })));
const double v57 = fmin(2.0, fmax(0.0, ({ const double v44 = 1.0 / (1.0e-36 + v9); const double v49 = ({ const Int64 v45 = v21 + sh2; const Word8 v46 = sh0 >= shIn0_0 || (sh1 >= shIn0_0 || v45 >= shIn0_0); double lv480; double lv481; double lv482;  if (v46) { lv482 = 0.0; lv481 = 0.0; lv480 = 0.0; } else { const Int64 v47 = (max(v20, v45) * shIn1_1 + max(v20, sh1)) * shIn1_0 + max(v20, sh0);  lv482 = arrIn1_2[v47]; lv481 = arrIn1_1[v47]; lv480 = arrIn1_0[v47]; } ; lv480; }) * v44;  ; fmin(({ const double v54 = ({ const Int64 v50 = (Int64) -1 + sh2; const Word8 v51 = sh0 >= shIn0_0 || (sh1 >= shIn0_0 || v50 >= shIn0_0); double lv530; double lv531; double lv532;  if (v51) { lv532 = 0.0; lv531 = 0.0; lv530 = 0.0; } else { const Int64 v52 = (max(v20, v50) * shIn1_1 + max(v20, sh1)) * shIn1_0 + max(v20, sh0);  lv532 = arrIn1_2[v52]; lv531 = arrIn1_1[v52]; lv530 = arrIn1_0[v52]; } ; lv530; }) * v44;  ; fmin(v54, 0.5 * (v54 + v49)); }), v49); })));

lv581 = -(0.5 * v5 * (v17 * (1.0 - v55) + v18 * (1.0 - v56) + v19 * (1.0 - v57)));
lv580 = 0.6666666666666666 * v5 * (v17 * v17 * (1.0 - v55 * v55) + v18 * v18 * (1.0 - v56 * v56) + v19 * v19 * (1.0 - v57 * v57));
}
arrOut_1[ix] = lv581;
arrOut_0[ix] = lv580;
}
}
