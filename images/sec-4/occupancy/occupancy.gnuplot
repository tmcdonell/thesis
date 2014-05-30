# vim: filetype=gnuplot
# vim: nospell

# set title "Impact of Varying Block Size"

set terminal pdf size 3,2.2
set output "occupancy.pdf"

set key on
set key bottom

set xlabel "Threads/Block"
set xrange [32:1536]
set xtics 0, 128

set ylabel "Occupancy (%)"

NonZero(x)=(x>0 ? x : 1/0)

plot    'occupancy.dat' using ($1 <= 1024 ? $1:1/0):(NonZero($2)) title "Compute 1.3" ls 1 lw 4 with linespoints, \
        'occupancy.dat' using ($1):(NonZero($3)) title "Compute 2.1" ls 2 lw 4 with linespoints, \
        'occupancy.dat' using ($1):(NonZero($4)) title "Compute 3.5" ls 3 lw 4 with linespoints, \
        'occupancy.dat' using ($1):(NonZero($5)) title "Compute 5.0" ls 11 lw 4 with linespoints

