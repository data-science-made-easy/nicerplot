---
title: "James' manual"
author: "Dr. M. Dijkstra <[m.dijkstra@cpb.nl](mailto:m.dijkstra@cpb.nl)>"
date: "Version: **`r report$james_version`**"
output:
  html_document:
    number_sections: true
    css: ext/style/style.css
    keep_md: yes
    toc: true
    toc_depth: 3
    toc_float: true
---

# Nicer plot
Time series data visualisation made easy for Excel users and R programmers.

# Installation
## Download R
First download [RStudio](https://www.rstudio.com) or [R](https://cran.r-project.org/).

## Install the `nicerplot` package
Open RStudio or R, and install the package `devtools` if not yet done before.
``` R
if (!is.element("devtools", installed.packages())) install.packages("devtools", repos = "http://cran.us.r-project.org")
```

With the `devtools` package you can install `nicerplot` directly from github:
``` R
devtools::install_github("data-science-made-easy/nicerplot")
```

Congratulations, you now have the cutting-edge development version of `nicerplot`!

# Hello-World example
The following three steps create a first example.

Step 1: load the package:
``` R
library(nicerplot)
```

Step 2: define a so-called data-frame (other data types, e.g., matrix, are fine as well):
``` R
x <- 0:6
my_data <- data.frame(x, first = (6 - x)^2, second = x^2)
```

Step 3: plot the data given some parameters:
``` R
plot(my_data, title = 'Hello World', x_title = 'x', y_title = 'y', footnote = "just an example")
```

This results in the following figure `./generated/hello-world.png`:

<img src="./inst/extdata/examples/png/Hello-World.png" width = 400>

# More examples
Below each figure in [the manual](https://htmlpreview.github.io/?https://github.com/data-science-made-easy/nicerplot/blob/master/inst/extdata/nicerplot-manual.html) you can find the R-code to reproduce that figure.

