AHDC Wave 3C EMA Time Diagnostics
-----

**About the data**
This is responses to Ecological Momentary Assessment mini-surveys from smartphones
Responses are nested within *days* and within *individuals*
Data Downloaded as of <<dd_display: c(current_date)>>
<<dd_do:quietly>>		   
sum casetag
<</dd_do>>
Total N kids completed or in progress: <<dd_display: r(sum)>>
Total number of EMA Responses: <<dd_display: _N>>


**Time between Prompt at the Beginning of the Response**
Need to investigate how one person answered a trigger 135 minutes after the trigger was sent. 

~~~~
<<dd_do>>
sum trigelapsed, d
<</dd_do>>
~~~~

~~~~
<<dd_do: nooutput nocommands>>
histogram trigelapsed, percent
<</dd_do>>
~~~~
<<dd_graph>>


**Time between the beginning and the end of the EMA Response**
95% are less than 7 minutes. But top 1% is 20-30 minutes. 
3 submissions are 60-75 minutes, which is problematic

~~~~
<<dd_do>>
sum  subtime, d
<</dd_do>>
~~~~


**Number of Responses per day**
should be between 1-5
One day with 6 responses

~~~~
<<dd_do>>
tab emadnum if daytag
<</dd_do>>
~~~~

**Timeblock of Response**
Distribution of Responses by time of day 
Not surprisingly, fewer in the morning, more in the afternoon

~~~~
<<dd_do>>
tab timeblock
<</dd_do>>
~~~~

Check for duplicates within timeblock each day
Since youth should only be able to respond to one EMA per time block
There are 7 sets of duplicates, so we'll have to decide if we throw out the second one
or use both sets of responses

~~~~
<<dd_do>>
tab tbtag
<</dd_do>>
~~~~

**Analysis**
Now let's look at one analysis we might be interested in. 
In what percent of EMA reports does the youth report wearing a mask **right now**?
Does that differ by whether they are at home or not?

~~~~
<<dd_do:nocommands>>
tabulate facemask q5home, markdown
<</dd_do>>
~~~~

And here's what it looks like if we make it into a bar chart with the percent. 
~~~~
<<dd_do:nocommands>>
graph bar (percent), over(q5home) over(facemask) asyvars
<</dd_do>>
~~~~
<<dd_graph>>

I recoded the missing categories from facemask, switched to using non-home location =1, and run a logistic regresion of non-home on facemask. I could use quietly in the code below to suppress all the output, but I want to compare the as-is logit output to the esttab output. From my brief readings, regression results in dyndoc are harder to handle.  

~~~~
<<dd_ignore>>
<<dd_do>>
logit masknomiss q5nonhome, or
est sto m1
<</dd_do>>
<</dd_ignore>>
~~~~

~~~~
<<dd_do>>
logit masknomiss q5nonhome, or
est sto m1
<</dd_do>>
~~~~

Direct from Stata, the rows are too wide for Word. Could change margins to narrow to fix, but I have another idea. This is what the results look like from esttab (user written wrapper): Much nicer!
Probably other solutions to this problem, as well. 
~~~~
<<dd_do:nocommands>>
esttab m1, b se wide eform
<</dd_do>>
~~~~