# vim: filetype=gnuplot nospell

set title "LULESH"

set terminal pdf size 3,2.2
set output "lulesh.pdf"

set key on
set key bottom

set xlabel "Problem Size (total elements)"
set logscale x
set xrange [100:100000]
set xtics  ("100" 100, "1k" 1000, "10k" 10000, "100k" 100000)

set ylabel "Run Time / Iteration (ms)"
set logscale y

plot    'lulesh.dat' using ($1*$1*$1):($3)                      \
                title "Accelerate (+sharing)"                   \
                ls 2  lw 4 with linespoints,                    \
        'lulesh.dat' using ($1*$1*$1):($4)                      \
                title "... +fusion"                             \
                ls 3  lw 4 with linespoints,                    \
        'lulesh.dat' using ($1*$1*$1):($5)                      \
                title "CUDA"                                    \
                ls 4  lw 4 with linespoints
