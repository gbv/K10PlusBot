.SUFFIXES: .ipynb .md .html

%.ipynb: %.md
	pandoc --filter ./pdnotebook.pl $< -o $@

%.html: %.md
	pandoc --filter ./pdnotebook.pl -s $< -o $@
