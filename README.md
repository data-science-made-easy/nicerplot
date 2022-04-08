# Content
- [Nicer plot](#nicer-plot)
- [Installation](#installation)
  * [Download R](#download-r)
  * [Install the `nicerplot` package](#install-the--nicerplot--package)
- [Hello-World example](#hello-world-example)
- [More examples](#more-examples)

# Nicer plot
Time series data visualisation made easy for Excel users and R programmers.

# Installation
Step 1: download [RStudio](https://www.rstudio.com) or [R](https://cran.r-project.org/).

Step 2: open RStudio or R, and install the package `devtools`.
``` R
install.packages("devtools", repos = "http://cran.us.r-project.org")
```

Step 3: with the `devtools` package you can install `nicerplot` directly from github:
``` R
devtools::install_github("data-science-made-easy/nicerplot")
```

Congratulations, you now have the cutting-edge development version of `nicerplot`!

# Hello World example
Step 1: define a so-called data-frame (other data types, e.g., matrix, are fine as well):
``` R
x <- 0:6
my_data <- data.frame(x, first = (6 - x)^2, second = x^2)
```

Step 2: plot the data given some parameters:
``` R
library(nicerplot)
plot(my_data, title = 'Hello World', x_title = 'x', y_title = 'y', footnote = "just an example")
```

Please beware that `library(nicerplot)` overwrites R's default `plot` function for most data types. Alternatively, you may use `nicerplot::plot(...)` instead.

Step 2 produces a figure in`./generated/hello-world.png` in your workingdirectory (see: `getwd()`), which looks like this:

<img src="./inst/extdata/examples/png/Hello-World.png" width = 400>

# More examples
Below each figure in [the manual](https://htmlpreview.github.io/?https://github.com/data-science-made-easy/nicerplot/blob/master/inst/extdata/nicerplot-manual.html) you can find the R-code to reproduce that figure.

