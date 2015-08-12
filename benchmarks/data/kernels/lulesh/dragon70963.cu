#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_0, const Int64 shIn1_2, const Int64 shIn1_1, const Int64 shIn1_0, const double* __restrict__ arrIn1_0, const Int64 shIn2_2, const Int64 shIn2_1, const Int64 shIn2_0, const double* __restrict__ arrIn2_1, const double* __restrict__ arrIn2_0, const Int64 shIn3_2, const Int64 shIn3_1, const Int64 shIn3_0, const double* __restrict__ arrIn3_0, const Int64 shIn4_2, const Int64 shIn4_1, const Int64 shIn4_0, const double* __restrict__ arrIn4_3, const double* __restrict__ arrIn4_2, const double* __restrict__ arrIn4_1, const double* __restrict__ arrIn4_0, const Int64 shOut_2, const Int64 shOut_1, const Int64 shOut_0, double* __restrict__ arrOut_3, double* __restrict__ arrOut_2, double* __restrict__ arrOut_1, double* __restrict__ arrOut_0)
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
const double v1 = fmax(1.0e-9, fmin(1.0e9, ({ const Int64 v0 = (sh2 * shIn4_1 + sh1) * shIn4_0 + sh0;  ; arrIn4_3[v0]; })));
const double v2 = 0.6666666666666666 * (1.0 + (-1.0 + 1.0 / v1));
const Int64 v3 = (sh2 * shIn2_1 + sh1) * shIn2_0 + sh0;
const double v4 = arrIn2_0[v3];
const Int64 v5 = (sh2 * shIn2_1 + sh1) * shIn2_0 + sh0;
const double v6 = arrIn2_1[v5];
const Int64 v7 = (sh2 * shIn0_1 + sh1) * shIn0_0 + sh0;
const double v8 = arrIn0_0[v7];
const Int64 v9 = (sh2 * shIn1_1 + sh1) * shIn1_0 + sh0;
const double v10 = arrIn1_0[v9];
const Int64 v11 = (sh2 * shIn4_1 + sh1) * shIn4_0 + sh0;
const double v12 = arrIn4_2[v11];
const Word8 v13 = v12 > 0.0;
const double v15 = fmax(-1.0e15, ({ const Int64 v14 = (sh2 * shIn3_1 + sh1) * shIn3_0 + sh0;  ; arrIn3_0[v14]; }) - 0.5 * v12 * (v8 + v10));
const double v16 = -1.0 + 1.0 / (v1 - 0.5 * v12);
const double v17 = 0.6666666666666666 * (1.0 + v16);
const double v21 = fmax(0.0, ({ const double v18 = v17 * v15; const Word8 v19 = fabs(v18) < 1.0e-7 || v1 >= 1.0e9; double lv200;  if (v19) { lv200 = 0.0; } else { lv200 = v18; } ; lv200; }));
double lv260;

if (v13) {
lv260 = 0.0;
} else {
lv260 = ({
const double v23 = 0.6666666666666666 * v15 + ({ const double v22 = 1.0 / (1.0 + v16);  ; v22 * v22; }) * v21 * v17;
const Word8 v24 = v23 <= 1.111111e-36;
double lv250;

if (v24) {
lv250 = 3.33333e-19;
} else {
lv250 = sqrt(v23);
}
;
lv250;
}) * v6 + v4;
}

const double v27 = v15 + 0.5 * v12 * (3.0 * (v8 + v10) - 4.0 * (v21 + lv260));
const Word8 v28 = fabs(v27) < 1.0e-7;
double lv290;

if (v28) {
lv290 = 0.0;
} else {
lv290 = fmax(-1.0e15, v27);
}

const double v38 = lv290 - 0.16666666666666666 * v12 * (7.0 * (v8 + v10) - 8.0 * (v21 + lv260) + ({ const double v33 = fmax(0.0, ({ const double v30 = v2 * lv290; const Word8 v31 = fabs(v30) < 1.0e-7 || v1 >= 1.0e9; double lv320;  if (v31) { lv320 = 0.0; } else { lv320 = v30; } ; lv320; }));  ; v33 + ({ double lv370;  if (v13) { lv370 = 0.0; } else { lv370 = ({ const double v34 = 0.6666666666666666 * lv290 + v1 * v1 * v33 * v2; const Word8 v35 = v34 <= 1.111111e-36; double lv360;  if (v35) { lv360 = 3.33333e-19; } else { lv360 = sqrt(v34); } ; lv360; }) * v6 + v4; } ; lv370; }); }));
const Word8 v39 = fabs(v38) < 1.0e-7;
double lv400;

if (v39) {
lv400 = 0.0;
} else {
lv400 = fmax(-1.0e15, v38);
}

const double v44 = fmax(0.0, ({ const double v41 = v2 * lv400; const Word8 v42 = fabs(v41) < 1.0e-7 || v1 >= 1.0e9; double lv430;  if (v42) { lv430 = 0.0; } else { lv430 = v41; } ; lv430; }));
const double v48 = ({ const double v45 = 0.6666666666666666 * lv400 + v1 * v1 * v44 * v2; const Word8 v46 = v45 <= 1.111111e-36; double lv470;  if (v46) { lv470 = 3.33333e-19; } else { lv470 = sqrt(v45); } ; lv470; }) * v6 + v4;
const Word8 v49 = fabs(v48) < 1.0e-7;
double lv500;

if (v49) {
lv500 = 0.0;
} else {
lv500 = v48;
}

const double v51 = 0.6666666666666666 * lv400 + v1 * v1 * v44 * v2;
const Word8 v52 = v51 <= 1.111111e-36;
double lv530;

if (v52) {
lv530 = 3.33333e-19;
} else {
lv530 = sqrt(v51);
}
arrOut_3[ix] = v44;
arrOut_2[ix] = lv400;
arrOut_1[ix] = lv500;
arrOut_0[ix] = lv530;
}
}
