# `markstat`

This Stata command was contributed by Germ&aacute;n Rodr&iacute;guez, who hosts documentation at 
[https://data.princeton.edu/stata/markdown](https://data.princeton.edu/stata/markdown)

## Dependencies


* Stata version &ge; 14

* [Pandoc](https://pandoc.org/)  (note: you will need to know the path the `pandoc.exe`)

* LaTeX for creating PDF files (note: you will need to know the path to `pdflatex.exe`)
  - [MiKTeX](https://miktex.org/download) for Windows  
  - [MacTeX](http://www.tug.org/mactex/downloading.html) for Mac OS

## Getting Started

Within Stata, install `markstat` and the dependency `whereis` with the commands below.  You will
also need to use the `whereis` command (along with the paths to the programs) to tell Stata where
to find pandoc and pdflatex.

```
ssc install markstat
ssc install whereis
whereis pandoc "Path\to\pandoc.exe"
whereis pdflatex "Path\to\pdflatex.exe"
copy http://www.stata-journal.com/production/sjlatex/stata.sty stata.sty, replace
```

The final command downloads s LaTeX style file `stata.sty` which must be in the same folder as your
Stata markdown file (or in your TeX tree).  Here is a `whereis` example on Windows:

```
whereis pandoc "C:\Program Files (x86)\Pandoc\pandoc.exe"
whereis pdflatex "C:\Program Files\MiKTeX 2.9\miktex\bin\x64\pdflatex.exe"
copy http://www.stata-journal.com/production/sjlatex/stata.sty stata.sty, replace
```
