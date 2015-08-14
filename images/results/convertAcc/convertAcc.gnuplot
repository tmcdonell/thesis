# vim: filetype=gnuplot

set title "Program optimisation"

set terminal pdf size 3,2.2
set output "convertAcc.pdf"

set key on
set key bottom

set xlabel "Nodes"
set logscale x
set xrange [0.8:310]

set xtics (1,2,4,8,16,32,64,128,256)

set ylabel "Run Time (s)"
set logscale y
# set yrange [0.05:100]

plot    'convertAcc.dat' using ($1):($2)                                        \
                title "Final"                   ls 4  lw 4 with linespoints,    \
        'convertAcc.dat' using ($1):($3)                                        \
                title "... -binder opt."        ls 5  lw 4 with linespoints,    \
        'convertAcc.dat' using ($1):($4)                                        \
                title "... -environment opt."   ls 6  lw 4 with linespoints

