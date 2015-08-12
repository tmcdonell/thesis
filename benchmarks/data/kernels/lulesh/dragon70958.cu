#include <accelerate_cuda.h>
extern "C" __global__ void generate(const Int64 shIn0_2, const Int64 shIn0_1, const Int64 shIn0_0, const double* __restrict__ arrIn0_0, const Int64 shIn1_2, const Int64 shIn1_1, const Int64 shIn1_0, const double* __restrict__ arrIn1_23, const double* __restrict__ arrIn1_22, const double* __restrict__ arrIn1_21, const double* __restrict__ arrIn1_20, const double* __restrict__ arrIn1_19, const double* __restrict__ arrIn1_18, const double* __restrict__ arrIn1_17, const double* __restrict__ arrIn1_16, const double* __restrict__ arrIn1_15, const double* __restrict__ arrIn1_14, const double* __restrict__ arrIn1_13, const double* __restrict__ arrIn1_12, const double* __restrict__ arrIn1_11, const double* __restrict__ arrIn1_10, const double* __restrict__ arrIn1_9, const double* __restrict__ arrIn1_8, const double* __restrict__ arrIn1_7, const double* __restrict__ arrIn1_6, const double* __restrict__ arrIn1_5, const double* __restrict__ arrIn1_4, const double* __restrict__ arrIn1_3, const double* __restrict__ arrIn1_2, const double* __restrict__ arrIn1_1, const double* __restrict__ arrIn1_0, const Int64 shIn2_2, const Int64 shIn2_1, const Int64 shIn2_0, const double* __restrict__ arrIn2_2, const double* __restrict__ arrIn2_1, const double* __restrict__ arrIn2_0, const double* __restrict__ arrIn3_0, const Int64 shOut_2, const Int64 shOut_1, const Int64 shOut_0, double* __restrict__ arrOut_2, double* __restrict__ arrOut_1, double* __restrict__ arrOut_0)
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
const Int64 v0 = (sh2 * shIn2_1 + sh1) * shIn2_0 + sh0;
const double v1 = arrIn2_2[v0];
const double v2 = arrIn2_1[v0];
const double v3 = arrIn2_0[v0];
const Int64 v4 = (Int64) 0;
const Int64 v5 = (Int64) -1 + sh1;
const Int64 v6 = (Int64) -1 + sh2;
const Word8 v7 = v4 <= v6 && (v6 < shIn1_0 && (v4 <= v5 && (v5 < shIn1_0 && (v4 <= sh0 && sh0 < shIn1_0))));
double lv90;
double lv91;
double lv92;

if (v7) {
const Int64 v8 = (v6 * shIn1_1 + v5) * shIn1_0 + sh0;

lv92 = arrIn1_2[v8];
lv91 = arrIn1_1[v8];
lv90 = arrIn1_0[v8];
} else {
lv92 = 0.0;
lv91 = 0.0;
lv90 = 0.0;
}

const Int64 v10 = (Int64) -1 + sh0;
const Int64 v11 = (Int64) -1 + sh1;
const Int64 v12 = (Int64) -1 + sh2;
const Word8 v13 = v4 <= v12 && (v12 < shIn1_0 && (v4 <= v11 && (v11 < shIn1_0 && (v4 <= v10 && v10 < shIn1_0))));
double lv150;
double lv151;
double lv152;

if (v13) {
const Int64 v14 = (v12 * shIn1_1 + v11) * shIn1_0 + v10;

lv152 = arrIn1_5[v14];
lv151 = arrIn1_4[v14];
lv150 = arrIn1_3[v14];
} else {
lv152 = 0.0;
lv151 = 0.0;
lv150 = 0.0;
}

const Int64 v16 = (Int64) -1 + sh0;
const Int64 v17 = (Int64) -1 + sh2;
const Word8 v18 = v4 <= v17 && (v17 < shIn1_0 && (v4 <= sh1 && (sh1 < shIn1_0 && (v4 <= v16 && v16 < shIn1_0))));
double lv200;
double lv201;
double lv202;

if (v18) {
const Int64 v19 = (v17 * shIn1_1 + sh1) * shIn1_0 + v16;

lv202 = arrIn1_8[v19];
lv201 = arrIn1_7[v19];
lv200 = arrIn1_6[v19];
} else {
lv202 = 0.0;
lv201 = 0.0;
lv200 = 0.0;
}

const Int64 v21 = (Int64) -1 + sh2;
const Word8 v22 = v4 <= v21 && (v21 < shIn1_0 && (v4 <= sh1 && (sh1 < shIn1_0 && (v4 <= sh0 && sh0 < shIn1_0))));
double lv240;
double lv241;
double lv242;

if (v22) {
const Int64 v23 = (v21 * shIn1_1 + sh1) * shIn1_0 + sh0;

lv242 = arrIn1_11[v23];
lv241 = arrIn1_10[v23];
lv240 = arrIn1_9[v23];
} else {
lv242 = 0.0;
lv241 = 0.0;
lv240 = 0.0;
}

const Int64 v25 = (Int64) -1 + sh1;
const Word8 v26 = v4 <= sh2 && (sh2 < shIn1_0 && (v4 <= v25 && (v25 < shIn1_0 && (v4 <= sh0 && sh0 < shIn1_0))));
double lv280;
double lv281;
double lv282;

if (v26) {
const Int64 v27 = (sh2 * shIn1_1 + v25) * shIn1_0 + sh0;

lv282 = arrIn1_14[v27];
lv281 = arrIn1_13[v27];
lv280 = arrIn1_12[v27];
} else {
lv282 = 0.0;
lv281 = 0.0;
lv280 = 0.0;
}

const Int64 v29 = (Int64) -1 + sh0;
const Int64 v30 = (Int64) -1 + sh1;
const Word8 v31 = v4 <= sh2 && (sh2 < shIn1_0 && (v4 <= v30 && (v30 < shIn1_0 && (v4 <= v29 && v29 < shIn1_0))));
double lv330;
double lv331;
double lv332;

if (v31) {
const Int64 v32 = (sh2 * shIn1_1 + v30) * shIn1_0 + v29;

lv332 = arrIn1_17[v32];
lv331 = arrIn1_16[v32];
lv330 = arrIn1_15[v32];
} else {
lv332 = 0.0;
lv331 = 0.0;
lv330 = 0.0;
}

const Word8 v34 = v4 <= sh2 && (sh2 < shIn1_0 && (v4 <= sh1 && (sh1 < shIn1_0 && (v4 <= sh0 && sh0 < shIn1_0))));
double lv360;
double lv361;
double lv362;

if (v34) {
const Int64 v35 = (sh2 * shIn1_1 + sh1) * shIn1_0 + sh0;

lv362 = arrIn1_23[v35];
lv361 = arrIn1_22[v35];
lv360 = arrIn1_21[v35];
} else {
lv362 = 0.0;
lv361 = 0.0;
lv360 = 0.0;
}

const Int64 v37 = (Int64) -1 + sh0;
const Word8 v38 = v4 <= sh2 && (sh2 < shIn1_0 && (v4 <= sh1 && (sh1 < shIn1_0 && (v4 <= v37 && v37 < shIn1_0))));
double lv400;
double lv401;
double lv402;

if (v38) {
const Int64 v39 = (sh2 * shIn1_1 + sh1) * shIn1_0 + v37;

lv402 = arrIn1_20[v39];
lv401 = arrIn1_19[v39];
lv400 = arrIn1_18[v39];
} else {
lv402 = 0.0;
lv401 = 0.0;
lv400 = 0.0;
}

const double v41 = lv362 + lv402;
const double v42 = lv361 + lv401;
const double v43 = lv360 + lv400;
const double v44 = v41 + lv332;
const double v45 = v42 + lv331;
const double v46 = v43 + lv330;
const double v47 = v44 + lv282;
const double v48 = v45 + lv281;
const double v49 = v46 + lv280;
const double v50 = v47 + lv242;
const double v51 = v48 + lv241;
const double v52 = v49 + lv240;
const double v53 = v50 + lv202;
const double v54 = v51 + lv201;
const double v55 = v52 + lv200;
const double v56 = v53 + lv152;
const double v57 = v54 + lv151;
const double v58 = v55 + lv150;
const double v59 = v56 + lv92;
const double v60 = v57 + lv91;
const double v61 = v58 + lv90;
const Int64 v62 = (sh2 * shIn0_1 + sh1) * shIn0_0 + sh0;
const double v63 = arrIn0_0[v62];
const double v64 = v59 / v63;
const double v65 = v60 / v63;
const double v66 = v61 / v63;
const Word8 v67 = v4 == sh0;
double lv680;

if (v67) {
lv680 = 0.0;
} else {
lv680 = v64;
}

const Word8 v69 = v4 == sh1;
double lv700;

if (v69) {
lv700 = 0.0;
} else {
lv700 = v65;
}

const Word8 v71 = v4 == sh2;
double lv720;

if (v71) {
lv720 = 0.0;
} else {
lv720 = v66;
}

const Int64 v73 = 0;
const double v74 = arrIn3_0[v73];
const double v75 = lv680 * v74;
const double v76 = lv700 * v74;
const double v77 = lv720 * v74;
const double v78 = v1 + v75;
const double v79 = v2 + v76;
const double v80 = v3 + v77;
const Word8 v81 = fabs(v78) < 1.0e-7;
double lv820;

if (v81) {
lv820 = 0.0;
} else {
lv820 = v78;
}

const Word8 v83 = fabs(v79) < 1.0e-7;
double lv840;

if (v83) {
lv840 = 0.0;
} else {
lv840 = v79;
}

const Word8 v85 = fabs(v80) < 1.0e-7;
double lv860;

if (v85) {
lv860 = 0.0;
} else {
lv860 = v80;
}
arrOut_2[ix] = lv820;
arrOut_1[ix] = lv840;
arrOut_0[ix] = lv860;
}
}
