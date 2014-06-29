#ifdef __cplusplus
extern "C" {
#endif

void read_matrix_market_file
(
    const char *filename,
    int *num_rows,
    int *num_cols,
    int *num_entries,
    int **row_indices,
    int **col_indices,
    float **vals
);

#ifdef __cplusplus
}
#endif

