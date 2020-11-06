*Dyndoc examples for IPR Workshop - October 1st 2020

*This file runs the script you generated with Markdown & Stata commands and saves the output as directed
*The actual markdown code is in a separate text file that I also generate within a Stata do-file editor and save it as a text or do-file 
*Run in Stata 16 to get integrated output in Word document options


*Set working directory (can also point directly to files in each command)
*I have the data file, this file, and the markdown file all in this same folder
*on-campus
cd "C:\Users\boettner.6\Box\IPR Admin\IPR Methods Workshop\Stata dyndoc"
*off
cd "C:\Users\boettner.6\Box Sync\IPR Admin\IPR Methods Workshop\Stata dyndoc"
* use data necessary for the code in the dyndoc text file
use w3c_example.dta, clear

*First, run whatever code needed to prepare the file for the dyndoc output if haven't already (re-coding, variable creation, etc)
*run setup.do /*to run setup do file without opening it separately*/

/* a few resources I have found helpful
https://www.stata.com/features/overview/markdown/
*this one reviews dyndoc & markstat a user-written command that also uses markdown to create output
https://www.ssc.wisc.edu/~hemken/Stataworkshops/dyndoc%20review/Review.html

Stata manuals:
https://www.stata.com/manuals/rptdyndoc.pdf
https://www.stata.com/manuals/rptdynamictags.pdf
Basic markdown rules:
https://www.markdownguide.org/basic-syntax/


**Basic Rules for markdown in stata
1) Use 4 tildes ~~~~ to mark start and end of code blocks
From Stata help: 
We use four tildes in a row, ~~~~, in our source file around parts of the document that we want to
appear in plain text, such as Stata commands and output. Without the ~~~~, Stata’s output would be
interpreted as HTML in the final document and would not look as it should. This applies regardless
of whether we are creating an HTML file or a Word document.

Beth's note: if something looks off- text or results not displaying- check for these tildes around each block of text to be run. 

2) Mark start and end of code that should be run and results shown in the final document with <<dd_do>> at beginning and a backslash at the end <</dd_do>> (these go inside your 4 tildes)
~~~~
<<dd_do>>
*code to run goes here
<</dd_do>>
~~~~

3) For Code that should be run quietly and not displayed, add ":quietly" to the <<dd_do>>
For example, this can be used to set up results to displayed within the next block of text (see #4)
~~~~
<<dd_do: quietly>>		   
*code goes here
<</dd_do>>
~~~~

4) Code to be run and have the results displayed in-line with the text is written as - no tildes needed
<<dd_display: code_goes_here >>

5) graphs can be displayed a number of ways, here's what has worked for me. You use approach in 2) to run the commands that generate the graph, then add another line to display the graph after <<ddgraph>> which saves the graph in the working directory and inserts it into your document. 
The options after dd_do suppress the command line and suppress the output (here the bins & width info provided by stata). These options can also be used with other types of code. 
~~~~
<<dd_do: nocommands nooutput>>
histogram x
<</dd_do>>
~~~~
<<dd_graph>>


6) Formatting - uses basic Markdown rules (same as R or html). use equal signs under text to make a large font header. use ** on either side of plain text to make it bold, single * for italics. 


This is heading 1
=================
This is heading 2
-----------------

# This is heading 1
## This is heading 2
### This is heading 3
#### This is heading 4
##### This is heading 5
##### This is heading 6

**Text to be in bold goes here**
*Text to be italicized goes in single asterisks*

I prefer the look of using one header, and then bold text. But that is personal preference. Using the headings also makes it easy to add a table to contents later in Word if needed. 


*/

*After you complete writing the dyndoc text file, then tell Stata to execute it and what to do with the output
*you can save it to an .html file, but I am using this specifically in Stata 16 so I can output it directly to Word

*to save as a Word file, use the doxc option after the command
*replace option - replaces the file with the new one just generated (can also append)
/* hardwrap specifies that hard wraps (actual line breaks) in the Markdown
        document be replaced with the <br> tag in the HTML file or with a
        line break in the Word (.docx) document if the docx option is
        specified.
*/

dyndoc dyndocsyntax.do, saving(output.docx) docx replace hardwrap

*save as HTML
dyndoc dyndocsyntax.do, saving(output.html) replace hardwrap

*no direct to PDF option, but I think there are translator/converter functions that could be added to convert the word or html to PDF automatically