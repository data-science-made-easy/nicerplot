Time series data visualisation made easy for Excel users and R programmers.

# Content
- [Content](#content)
- [Installation](#installation)
- [Hello World example](#hello-world-example)
  * [Change the layout](#change-the-layout)
- [More examples](#more-examples)

# Installation
1. Download [RStudio](https://www.rstudio.com) or [R](https://cran.r-project.org/).
2. Open RStudio or R, and install the package `devtools`:
    ``` R
    install.packages("devtools", repos = "http://cran.us.r-project.org")
    ```
3. With the `devtools` package you can install `nicerplot` directly from github:
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

Step 2 produces a figure in`./generated/hello-world.png` in your workingdirectory (see: `getwd()`), which looks like this:

<img src="./inst/extdata/examples/png/Hello-World.png" width = 400>

## Change the layout
Instead of lines you can plot 'stacked bars' by using parameter `type = 'bar='` (use `type = 'bar--` for shoulderd bars):

``` R
plot(my_data, title = 'Shouldered bars', x_title = 'x', y_title = 'y', type = 'bar--', file = 'Hello-World-shouldered-bars')
plot(my_data, title = 'Stacked bars', x_title = 'x', y_title = 'y', footnote = 'with turn = TRUE', type = 'bar=', file = 'Hello-World-stacked-bars', turn = TRUE)
```

<img src="./inst/extdata/examples/png/Hello-World-shouldered-bars.png" width = 400> <img src="./inst/extdata/examples/png/Hello-World-stacked-bars.png" width = 400>

# More examples
The <a href="https://htmlpreview.github.io/?https://github.com/data-science-made-easy/nicerplot/blob/master/inst/extdata/nicerplot-manual.html" target="_blank">official manual</a> provides many other examples. Below each figure in this manual you can find the R-code to reproduce that figure. Please ignore the file paths in the manual.

# Details
The default

- font is 'RijksoverheidSansText'. If that font is unavailable, 'sans' will be selected.
- language is Dutch, so the decimal (thousand) separator is a comma (point). Use `style = 'english'` to swap those two separators.