# vim: filetype=gnuplot

set title "Black-Scholes"

set terminal pdf size 3,2.2
set output "black-scholes.pdf"

set key on
set key left

set xlabel "Options (millions)"
set logscale x
set xrange [1.5:25]

set xtics (2, 4, 6, 8, 10, 12, 14, 16, 18, 20)

set ylabel "Run Time (ms)"
set logscale y
set yrange [0.4:150]

plot    'black-scholes.dat' using ($1):($3)                                     \
                title "Accelerate -sharing"  ls 7   lw 4 with linespoints,      \
        'black-scholes.dat' using ($1):($2)                                     \
                title "... +sharing"         ls 10  lw 4 with linespoints,      \
        'black-scholes.dat' using ($1):($4)                                     \
                title "CUDA"                 ls 1   lw 4 with linespoints

