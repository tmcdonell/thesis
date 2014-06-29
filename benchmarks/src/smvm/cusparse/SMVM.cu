
#include <stdio.h>
#include <stdlib.h>

#include <cuda_runtime.h>
#include <cusparse.h>

#include "matrix.h"
#include "Timing.h"

#define CUDA_CHECK(action)                                                      \
    do {                                                                        \
        if ( cudaSuccess != action ) {                                          \
            printf("Failed: %s\n", #action);                                    \
            exit(1);                                                            \
        }                                                                       \
    } while (0)

#define CUSPARSE_CHECK(action)                                                  \
    do {                                                                        \
        if ( CUSPARSE_STATUS_SUCCESS != action ) {                              \
            printf("Failed: %s\n", #action);                                    \
            exit(1);                                                            \
        }                                                                       \
    } while (0)

int main(int argc, char **argv)
{
    int num_rows;
    int num_cols;
    int num_entries;
    int *row_indices;
    int *col_indices;
    float *vals;

    if (argc < 2) {
        printf("usage: smvm <matrix market file>\n");
        exit(1);
    }

    // Read in matrix market file
    printf("Reading matrix...");
    read_matrix_market_file(argv[1], &num_rows, &num_cols, &num_entries, &row_indices, &col_indices, &vals);

    printf("Matrix %s: <%d, %d> with %d entries\n", argv[1], num_rows, num_cols, num_entries);

//    for (int i = 0; i < num_entries; ++i) {
//        printf("%8d%8d%16.2f\n", row_indices[i], col_indices[i], vals[i]);
//    }

    // Copy matrix data to GPU
    printf("Copy data to GPU...\n");
    int *d_row_indices;
    int *d_col_indices;
    float *d_vals;

    CUDA_CHECK( cudaMalloc((void**) &d_row_indices, num_entries * sizeof(int)) );
    CUDA_CHECK( cudaMalloc((void**) &d_col_indices, num_entries * sizeof(int)) );
    CUDA_CHECK( cudaMalloc((void**) &d_vals,        num_entries * sizeof(int)) );

    CUDA_CHECK( cudaMemcpy(d_row_indices, row_indices, num_entries * sizeof(int), cudaMemcpyHostToDevice) );
    CUDA_CHECK( cudaMemcpy(d_col_indices, col_indices, num_entries * sizeof(int), cudaMemcpyHostToDevice) );
    CUDA_CHECK( cudaMemcpy(d_vals,        vals,        num_entries * sizeof(int), cudaMemcpyHostToDevice) );

    // generate random dense vector
    printf("Generate dense vector...\n");
    float *x    = (float*) malloc(num_cols * sizeof(float));
    float *d_x;

    srand(1234);
    for (int i = 0; i < num_cols; ++i) {
        x[i]    = static_cast<float>(rand()) / static_cast<float>(RAND_MAX);
    }

    CUDA_CHECK( cudaMalloc((void**) &d_x, num_cols * sizeof(float)) );
    CUDA_CHECK( cudaMemcpy(d_x, x, num_cols * sizeof(float), cudaMemcpyHostToDevice) );

    // Initialise CUSPARSE library and create matrix descriptor
    printf("Initialise CUDA sparse library...\n");
    cusparseHandle_t handle     = NULL;
    cusparseMatDescr_t descr    = NULL;

    CUSPARSE_CHECK( cusparseCreate(&handle) );
    CUSPARSE_CHECK( cusparseCreateMatDescr(&descr) );

    CUSPARSE_CHECK( cusparseSetMatType(descr, CUSPARSE_MATRIX_TYPE_GENERAL) );
    CUSPARSE_CHECK( cusparseSetMatIndexBase(descr, CUSPARSE_INDEX_BASE_ZERO) );

    // Convert matrix from COO format to CSR
    printf("Convert COO to CSR format...\n");
    int *d_offsets;
    CUDA_CHECK( cudaMalloc((void**) &d_offsets, (num_rows + 1) * sizeof(int)) );
    CUSPARSE_CHECK( cusparseXcoo2csr(handle, d_row_indices, num_entries, num_rows, d_offsets, CUSPARSE_INDEX_BASE_ZERO) );

    // Finally, do the matrix multiplication a bunch of times.
    printf("Running benchmark...\n");
    float *d_y;
    CUDA_CHECK( cudaMalloc((void**) &d_y, num_rows * sizeof(float)) );

    struct benchtime* bt = bench_begin();
    float zero = 0.0;
    float one  = 1.0;

    for (int i = 0; i < 100; ++i) {
        CUSPARSE_CHECK( cusparseScsrmv(handle, CUSPARSE_OPERATION_NON_TRANSPOSE,
                    num_rows, num_cols, num_entries,
                    &one, descr, d_vals,
                    d_offsets,
                    d_col_indices,
                    d_x,
                    &zero,
                    d_y) );
    }

    bench_end(bt);
    bench_done(bt);

    // Free memory
    free(row_indices);
    free(col_indices);
    free(vals);
    free(x);

    cudaFree(d_row_indices);
    cudaFree(d_col_indices);
    cudaFree(d_vals);
    cudaFree(d_x);
    cudaFree(d_y);
    cudaFree(d_offsets);

    cusparseDestroyMatDescr(descr);
    cusparseDestroy(handle);

    return 0;
}
