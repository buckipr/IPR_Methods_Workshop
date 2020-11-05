# How to convert .Rmd to .pdf

This example depends on the `bookdown` package which is similar to the `rmarkdown` package, but with a few extentions.
In R, you can install this package with the following command (which will also install the `rmarkdown` and `knitr` packages):

```
install.packages('bookdown')
```

To create the PDF file, open `R_Markdown_example_PDF.Rmd` in R or R Studio, set your working directory to
the folder with the `.Rmd` file, 

```
getwd()  # prints your current working direcotry
setwd("/Path/to/Rmd/file/")
rmarkdown::render('R_Markdown_example_PDF.Rmd')
```

Alternatively, if you open an `.Rmd` file in R Studio and have installed the `knitr` package installed, then you can also click the
Knit button at the top of the source pane, or choose the menu options "File" &#8594; "Knit Document".
