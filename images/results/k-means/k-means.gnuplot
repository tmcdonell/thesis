# vim: filetype=gnuplot
#
# NOTES:
#  * This is implemented as a multiplot so that the legend is bottom justified,
#    with the first column having fewer elements.
#  * As a consequence, we need to make sure that the title, labels, and tic
#    marks are only drawn [in the foreground colour] once.
#

set terminal pdf size 3,2.2
set output "k-means.pdf"

set title "K-Means Clustering"          textcolor bgnd
set ylabel "Run Time / Iteration (ms)"  textcolor bgnd
set xlabel "Points"                     textcolor bgnd
set xtics  ("5k" 5000, "15k" 15000, "25k" 25000, "40k" 40000, "60k" 60000, "80k" 80000, "100k" 100000) textcolor bgnd
set ytics textcolor bgnd

set logscale x
set xrange [4500:110000]

set logscale y
set yrange [0.01:100]

set multiplot
set key on
set key bottom left

plot    'k-means.dat' using ($1):($3)                           \
                title "Accelerate"                              \
                ls 1  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($4)                           \
                title "... +sharing"                            \
                ls 2  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($5)                           \
                title "... +fusion"                             \
                ls 3  lw 4 with linespoints,                    \

set title  textcolor black
set xlabel textcolor black
set ylabel textcolor black
set xtics  textcolor black
set ytics  textcolor black

set key bottom right
plot    'k-means.dat' using ($1):($6)                           \
                title "Eval"                                    \
                ls 4  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($7)                           \
                title "MonadPar"                                \
                ls 5   lw 4 with linespoints,                   \
        'k-means.dat' using ($1):($9)                           \
                title "Eval (divide \\& conquer)"                 \
                ls 6  lw 4 with linespoints,                    \
        'k-means.dat' using ($1):($8)                           \
                title "MonadPar (divide \\& conquer)"             \
                ls 7  lw 4 with linespoints

unset multiplot

