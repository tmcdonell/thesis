# vim: filetype=gnuplot

set title "Ray tracer"

set terminal pdf size 3,2.2
set output "ray.pdf"

set key on
set key left

set xlabel "Image size (total pixels)"
set logscale x
set xrange [40000:30000000]
set xtics  ("64k" 65536, "256k" 262144, "1M" 1048576, "4M" 4194304, "16M" 16777216)

set ylabel "Run Time (ms)"
set logscale y

plot    'ray.dat' using ($1*$1):($2)                                    \
                title "Repa -N8"                                        \
                ls 7  lw 4 with linespoints,                            \
        'ray.dat' using ($1*$1):($3)                                    \
                title "Accelerate"                                      \
                ls 3  lw 4 with linespoints

