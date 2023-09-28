.PHONY: all clean

#.PRECIOUS: da40.tex

all: c172s.pdf maneuver.pdf da40.pdf planning.pdf all-print.pdf c172s-print.pdf da40-print.pdf
clean:
	rm -f *.pdf *.aux *.log

xwind.tex:

%.tex: %.rst
	rst2latex --no-doc-title --documentclass article --documentoptions 10pt --stylesheet=./clipboard-v2.tex $< > $@
	sed -i '/^\\begin{document}.*/a \\\\begin{multicols*}{3}' $@
	sed -i '/^\\end{document}.*/i \\\\end{multicols*}' $@
	sed -i ':a;/\\item/s/\(.*\) - \(.*\)/\1{}\\mydotfill{}\2/g;ta' $@

planning.tex: planning.rst
	rst2latex --no-doc-title --documentclass article --documentoptions 10pt --stylesheet=./clipboard-v2.tex $< > $@
	sed -i '/^\\begin{document}.*/a \\\\begin{multicols*}{2}' $@
	sed -i '/^\\end{document}.*/i \\\\end{multicols*}' $@

%.pdf: %.tex ./clipboard-v2.tex
	lualatex $<
	lualatex $<
	lualatex $<

%-print.tex: %.pdf
	echo '\documentclass[letterpaper]{article}\usepackage[final]{pdfpages}' \
		'\begin{document}' \
		'\includepdf[pages=-,nup=1x2,landscape,booklet=true]{$<}' \
		'\end{document}' > $@


all.pdf: da40.pdf planning.pdf c172s.pdf
	pdftk A=da40.pdf B=c172s.pdf C=planning.pdf cat A B C output $@
