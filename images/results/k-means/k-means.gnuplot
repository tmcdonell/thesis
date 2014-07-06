# vim: filetype=gnuplot

set title "K-Means Clustering"

set terminal pdf size 3,2.2
set output "k-means.pdf"

set key on
set key bottom

set xlabel "Points"
set logscale x
set xrange [4500:110000]
set xtics  ("5k" 5000, "15k" 15000, "25k" 25000, "40k" 40000, "60k" 60000, "80k" 80000, "100k" 100000)

set ylabel "Run Time (ms)"
set logscale y


plot    'k-means.dat' using ($1):($4)                           \
                title "Accelerate (whole program)"              \
                ls 2  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($3)                           \
                title "Accelerate (just GPU kernels)"           \
                ls 10  lw 4 with linespoints,                   \
        'k-means.dat' using ($1):($5)                           \
                title "Eval"                                    \
                ls 4  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($6)                           \
                title "MonadPar"                                \
                ls 3  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($8)                           \
                title "Eval (divide & conquer)"                 \
                ls 1  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($7)                           \
                title "MonadPar (divide & conquer)"             \
                ls 7  lw 4 with linespoints
