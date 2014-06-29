#include <cusp/array1d.h>
#include <cusp/array2d.h>
#include <cusp/csr_matrix.h>
#include <cusp/multiply.h>
#include <cusp/print.h>
#include <cusp/io/matrix_market.h>

#include <stdlib.h>
#include <stdint.h>

#include <Timing.h>

int main(int argc, char **argv)
{
    char* mtx_file = NULL;

    if (argc < 2) {
        printf("usage: smvm <matrix.mtx>");
        exit(1);
    } else {
        mtx_file = argv[1];
    }

    // read matrix stored in file into CSR matrix
    std::cout << "Reading matrix..." << std::endl;

    cusp::csr_matrix<int32_t, float, cusp::device_memory> A;
    cusp::io::read_matrix_market_file(A, mtx_file);
    // cusp::print(A);

    std::cout << mtx_file
              << " <" << A.num_rows << ", " << A.num_cols << "> with "
              << A.num_entries << " entries" << std::endl;

    // Generate a random vector. This seems like a really dumb way to do it, but
    // let's hope cusp/thrust isn't just copying each element individually.
    std::cout << "Generating random vector..." << std::endl;

    cusp::array1d<float, cusp::device_memory> x(A.num_rows);
    srand(1234);
    for (int i = 0; i < x.size(); ++i) {
        x[i] = static_cast<float>(rand()) / static_cast<float>(RAND_MAX);
    }
    // cusp::print(x);

    // Do the matrix multiply operation a bunch of times. We should get each
    // time individually to get standard deviation and stuff, but whatevs...
    std::cout << "beginning benchmark..." << std::endl;
    cusp::array1d<float, cusp::device_memory> y(A.num_rows);

    struct benchtime* bt = bench_begin();

    for (int i = 0; i < 100; ++i) {
        cusp::multiply(A, x, y);
    }
    //cusp::print(y);

    bench_end(bt);
    bench_done(bt);

    return 0;
}

