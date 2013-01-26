# custom dependency rules for use with 'latexmk' build system. These just call
# 'make' with the appropriate target.
#
# vim: ft=perl
#

$pdf_previewer = "open -a skim %S";

add_cus_dep('mng', 'tex', 0, 'mng2tex');
sub mng2tex {
    system( "make", "$_[0].tex" );
};

add_cus_dep('ott', 'tex', 0, 'ott2tex');
sub ott2tex {
    system( "make", "$_[0].tex" );
};

