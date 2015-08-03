# vim: filetype=gnuplot

set title "Floyd-Warshall"

set terminal pdf size 3,2.2
set output "floyd-warshall.pdf"

set key on
set key bottom

set xlabel "Nodes"
set logscale x
set xrange [90:1100]

set xtics ("100" 100, "200" 200, "300" 300, "400" 400, "" 500, "600" 600, "" 700, "800" 800, "" 900, "1000" 1000)

set ylabel "Run Time (s)"
set logscale y
# set yrange [0.05:100]

set colorsequence classic

plot    'floyd-warshall.dat' using ($1):($5)                                    \
                title "MonadPar"                                                \
                ls 6  lw 4 with linespoints,                                    \
        'floyd-warshall.dat' using ($1):($4)                                    \
                title "Repa"                                                    \
                ls 3  lw 4 with linespoints,                                    \
        'floyd-warshall.dat' using ($1):($2)                                    \
                title "Accelerate (+sharing)"                                   \
                ls 7  lw 4 with linespoints,                                    \
        'floyd-warshall.dat' using ($1):($3)                                    \
                title "Accelerate (+fusion)"                                    \
                ls 2  lw 4 with linespoints,                                    \

#        'floyd-warshall.dat' using ($1):($7)                                    \
#                title "NDP2GPU"            ls 4  lw 4 with linespoints,         \
