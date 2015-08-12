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

arrOut_0[ix] = ({
const Int64 v0 = (Int64) 0;
const Int64 v1 = (Int64) 30;

;
({
const Word8 v2 = v0 <= sh2 && (sh2 < v1 && (v0 <= sh1 && (sh1 < v1 && (v0 <= sh0 && sh0 < v1))));
double lv30;

if (v2) {
lv30 = 5.2734375e-5;
} else {
lv30 = 0.0;
}
;
lv30;
}) + ({
const Word8 v5 = v0 <= sh2 && (sh2 < v1 && (v0 <= sh1 && (sh1 < v1 && ({ const Int64 v4 = (Int64) -1 + sh0;  ; v0 <= v4 && v4 < v1; }))));
double lv60;

if (v5) {
lv60 = 5.2734375e-5;
} else {
lv60 = 0.0;
}
;
lv60;
}) + ({
const Word8 v9 = v0 <= sh2 && (sh2 < v1 && ({ const Int64 v7 = (Int64) -1 + sh1;  ; v0 <= v7 && (v7 < v1 && ({ const Int64 v8 = (Int64) -1 + sh0;  ; v0 <= v8 && v8 < v1; })); }));
double lv100;

if (v9) {
lv100 = 5.2734375e-5;
} else {
lv100 = 0.0;
}
;
lv100;
}) + ({
const Word8 v12 = v0 <= sh2 && (sh2 < v1 && ({ const Int64 v11 = (Int64) -1 + sh1;  ; v0 <= v11 && (v11 < v1 && (v0 <= sh0 && sh0 < v1)); }));
double lv130;

if (v12) {
lv130 = 5.2734375e-5;
} else {
lv130 = 0.0;
}
;
lv130;
}) + ({
const Int64 v14 = (Int64) -1 + sh2;
const Word8 v15 = v0 <= v14 && (v14 < v1 && (v0 <= sh1 && (sh1 < v1 && (v0 <= sh0 && sh0 < v1))));
double lv160;

if (v15) {
lv160 = 5.2734375e-5;
} else {
lv160 = 0.0;
}
;
lv160;
}) + ({
const Int64 v17 = (Int64) -1 + sh2;
const Word8 v19 = v0 <= v17 && (v17 < v1 && (v0 <= sh1 && (sh1 < v1 && ({ const Int64 v18 = (Int64) -1 + sh0;  ; v0 <= v18 && v18 < v1; }))));
double lv200;

if (v19) {
lv200 = 5.2734375e-5;
} else {
lv200 = 0.0;
}
;
lv200;
}) + ({
const Int64 v21 = (Int64) -1 + sh2;
const Word8 v24 = v0 <= v21 && (v21 < v1 && ({ const Int64 v22 = (Int64) -1 + sh1;  ; v0 <= v22 && (v22 < v1 && ({ const Int64 v23 = (Int64) -1 + sh0;  ; v0 <= v23 && v23 < v1; })); }));
double lv250;

if (v24) {
lv250 = 5.2734375e-5;
} else {
lv250 = 0.0;
}
;
lv250;
}) + ({
const Int64 v26 = (Int64) -1 + sh2;
const Word8 v28 = v0 <= v26 && (v26 < v1 && ({ const Int64 v27 = (Int64) -1 + sh1;  ; v0 <= v27 && (v27 < v1 && (v0 <= sh0 && sh0 < v1)); }));
double lv290;

if (v28) {
lv290 = 5.2734375e-5;
} else {
lv290 = 0.0;
}
;
lv290;
});
}) / 8.0;
}
}
