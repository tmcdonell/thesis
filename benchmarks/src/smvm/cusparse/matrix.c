#include <stdio.h>
#include <stdlib.h>

#include "mmio.h"
#include "matrix.h"


void read_matrix_market_file
(
    const char *filename,
    int *num_rows,
    int *num_cols,
    int *num_entries,
    int **row_indices,
    int **col_indices,
    float **vals
)
{
    FILE *fp;
    MM_typecode matcode;

    if ((fp = fopen(filename, "r")) == NULL) {
        printf("could not read file \"%s\"\n", filename);
        exit(1);
    }

    // Read matrix banner
    if (mm_read_banner(fp, &matcode) != 0) {
        printf("Could not process Matrix Market banner\n");
        exit(1);
    }

    // Find out the size of the matrix
    if (mm_read_mtx_crd_size(fp, num_rows, num_cols, num_entries) != 0) {
        printf("could not determine matrix size");
        exit(1);
    }

    // Reserve memory for the matrices
    *row_indices        = (int*)   malloc(*num_entries * sizeof(int));
    *col_indices        = (int*)   malloc(*num_entries * sizeof(int));

    // Read in the values
    int i;
    if (mm_is_complex(matcode)) {
        *vals           = (float*) malloc(*num_entries * 2 * sizeof(float));

        for (i = 0; i < *num_entries; ++i) {
            int r = fscanf(fp, "%d %d %g %g\n",
                               &((*row_indices)[i]),
                               &((*col_indices)[i]),
                               &((*vals)[i]),
                               &((*vals)[i+*num_entries]));

            if (r != 4) {
                printf("Failed reading complex market at row %d\n", i);
                exit(1);
            }
            (*col_indices)[i]--;
            (*row_indices)[i]--;
        }
    }
    else if (mm_is_real(matcode)) {
        *vals           = (float*) malloc(*num_entries * sizeof(float));

        for (i = 0; i < *num_entries; ++i) {
            int r = fscanf(fp, "%d %d %g\n",
                               &((*row_indices)[i]),
                               &((*col_indices)[i]),
                               &((*vals)[i]));

            if (r != 3) {
                printf("Failed reading real market at row %d\n", i);
                exit(1);
            }
            (*col_indices)[i]--;
            (*row_indices)[i]--;
        }
    }
    else if (mm_is_pattern(matcode)) {
        *vals           = (float*) malloc(*num_entries * sizeof(float));

        for (i = 0; i < *num_entries; ++i) {
            int r = fscanf(fp, "%d %d\n",
                               &((*row_indices)[i]),
                               &((*col_indices)[i]));

            if (r != 2) {
                printf("Failed reading pattern market at row %d\n", i);
                exit(1);
            }
            (*col_indices)[i]--;
            (*row_indices)[i]--;
            (*vals)[i] = 1.0;
        }
    }
    else {
        printf("Unsupported matrix type\n");
        exit(1);
    }
}

