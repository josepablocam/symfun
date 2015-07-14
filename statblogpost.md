
#Data's portrait
Data can come in many shapes and forms, with an equally large amount of ways to describe them.
Most people have dealt with averages and standard deviation. These are in effect *shorthand*
for that description. Sometimes we might want more information, more perspective into that
data's profile. In a situation like that we might look at other measures, such as [skewness](to link) and [kurtosis](to link). However, sometimes we can provide a much neater description
for data by stating it comes from a given distribution, which not only tells us things
like the average value that we should expect, but effectively gives us the data's "recipe" so that we can compute all sorts of neat information from it. 

Armed with this information we can go out in the world and try our hand at many tasks: we can
perform anomaly detection by analyzing the likelihood of any new values under that distribution; we can seek to better understand natural phenomena by analyzing their statistical properties; we can validate our modeling logic and improve our ability to model processes; the opportunities are endless.

#Innocent until proven guilty (read: null until proven not!)
We might have various distributions that we think fit our data. For example, we might have just fit a linear regression to a dataset, and believe that our residuals are white noise (i.e. standard normal), and we would now like some assurance that this is the case and we're not missing some important features in our model. Or we might have measured the wait time for the 6 train in NYC (protip: it's forever...just come to terms with that) and we'd like to model this using an exponential distribution. We now have the task of testing whether our empirical data actually follow these theoretical distributions.

It is often difficult to conclude that a given hypothesis is correct. However, the converse, concluding that a given hypothesis is wrong, is actually much simpler. This idea might initially seem a bit counterintuitive, but a simple example can clear things up. Let's say a bad back is a common (clearly not professional!) diagnosis for back pain. If I have back pain, it is possible that I might have a bad back. It is also possible that I simply sat for too long. However, if I don't have back pain, it is fairly certain that I don't have a bad back. This drives the underlying intuition behind the concept of a null hypothesis and statistical test for that hypothesis.

We can use this hammer and nail, a statistic and a hypothesis test, to do something similar with our potential distributions. In fact, there are various standard statistical tests that allow us to analyze whether a given sample might come from a given theoretical distribution (or alternatively, whether 2 samples come from the same, unknown, distribution). We'll discuss 2 of these in depth in this blog post: Kolmogorov-Smirnov test, and Anderson-Darling test. While "passing" the test doesn't guarantee that the data comes from that distribution, failing it is a pretty surefire way to demonstrate that it does not.

#Statistics: Goodness-of-Fit tests
##Kolmogorov-Smirnov
This might be one of the most popular goodness-of-fit tests for continuous data out there, with implementation in pretty much every popular analytics platform. The intuition behind the test centers around comparing the largest deviation between the cumulative distribution at a given value X under the theoretical distribution and the empirical cumulative distribution.

TODO: ADD LATEX FORMULA

TODO: add a graph showing the distance at a given point labeling it

One of the main appeals of this test centers around the fact that the test is distribution-agnostic. By that we mean that the statistic can be calculated and compared the same way regardless of the theoretical distribution we are interested in comparing against (or the actual distributions of the 1 or 2 samples, depending on the test variant being performed).

##Anderson-Darling
Anderson-Darling is often proposed as an alternative to the Kolmogorov-Smirnov statistic, with the advantage that it is better suited to identify departures from the theoretical distribution at the tails, and is more robust towards the nuances associated with estimating the distribution's parameters directly from the sample that we're trying to test.

In contrast to the Kolmogorov-Smirnov test, the Anderson-Darling test for 1-sample has critical values (i.e. the reference points that we will use to accept or dismiss our null hypothesis) that depend on the distribution we are testing against.

TODO: add latex formula

#Implementations
##Distilling distributed distribution (statistics) (now say that three times fast...)
Calculating both of these statistics is extremely straightforward when performed in memory. If we have all our data, we can simply traverse it as needed and calculate what we need at each point. Performing the same calculations in a distributed setting can take a bit more craftiness.

Cloudera has contributed distributed implementations of these tests to MLlib. You can now find in the Statistics object: the 1-sample, 2-sided Kolmogorov-Smirnov test; the 2-sample, 2-sided, Kolmogorov-Smirnov test; the 1-sample Anderson-Darling test; and the k-sample Anderson-Darling test.

The remainder of this blog focuses on explaining the implementation details, along with some use-case examples for 2 of these tests: the 2-sample Kolmogorov-Smirnov test, and the 1-sample Anderson-Darling test. We've chosen these two as they arguably provide the most interesting implementations.

### Locals and Globals
Intuition: we can find globals by looking locally.


###2-sample Kolmogorov-Smirnov test
The 2-sample variant of the KS test allows us to test the hypothesis that both samples stem from the same distribution. It's definition is a nice, straightforward extension of the 1-sample variant: we are looking for the largest distance between the 2 empirical CDF curves. We create the 2 curves by calculating the empirical CDF for the combined sample under sample 1 and 2, respectively.

TODO: add examples.


TODO: add link to prior graph

Now, let's think about implementing this in a distributed fashion. We are going to have to combine the data and sort it. There is no way for us to get around that. Once we have that, however, we'd like to minimize the amount of unnecessary shuffles (recall, this requires writing out data to task, which is expensive) and jobs necessary (which isn't quite a shuffle, but still consumes resources). We can arrive at a distributed implementation by acknowleding the following fact:

TODO: add fact and visual example

The general strategy will aid us well in other implementations and the gist of it can be summarized as: calculate as much as you can within each partition and communicate as little as you can so that you can adjust at then end.

TODO: add tikz graphic showing how this works (what gets communicated etc.)


TODO: add an example here.


Note that the test is meant for continuous distributions, so any ties in ranking will affect the test's power.


###1-sample Anderson-Darling test
The implementation of the 1-sample Anderson-Darling test provides yet another productive strategy: algebraic transformations that isolate global vs local components can be useful in maximizing how much we can calculate locally and how much information we need to carry to adjust globally later.



TODO: add algebraic transform
TODO: add example


While in this blog post we have used the Scala API, all these tests have also been made available in PySpark, allowing data scientists to calculate familiar statistics on big-date sized samples. As usual, all feedback is welcome. Happy hypothesis-testing!

		