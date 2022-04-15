<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
<i class="fa fa-camera-retro"></i> fa-camera-retro
Time series data visualisation made easy for Excel users and R programmers. <img src='man/figures/nicerplot-hex-logo.png' align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/data-science-made-easy/nicerplot/workflows/R-CMD-check/badge.svg)](https://github.com/data-science-made-easy/nicerplot/actions)
<!-- badges: end -->

# Content
- [Installation](#installation)
- [Hello World example](#hello-world-example)
  * [Change the layout](#change-the-layout)
- [Manual with more examples](#manual-with-more-examples)
- [Details](#details)

# Installation
1. Download [RStudio](https://www.rstudio.com) or [R](https://cran.r-project.org/).
2. Open RStudio or R, and install the package `devtools` if you don't have it already:
   ``` R
   install.packages("devtools", repos = "http://cran.us.r-project.org")
   ```
3. With the `devtools` package you can install `nicerplot` directly from github.
   ``` R
   devtools::install_github("data-science-made-easy/nicerplot")                   # for latest and greatest
   ```

Congratulations, you now have the cutting-edge development version of `nicerplot`!

In some cases, *e.g.* if you want work on common version together with others, you may prefer to install a [stable release](https://github.com/data-science-made-easy/nicerplot/releases). In that case you can add `ref = <tag>`, to the above `install_github` command. You can find a `<tag>` left of the [release](https://github.com/data-science-made-easy/nicerplot/releases) (*e.g.* `ref = 'v0.1.1'`).

# Hello World example
Define a `data.frame` (or, e.g., a `matrix`, `mts`, `ts`, 'path/to/a-file.xlsx', or a combination in a `list`):
``` R
x <- 0:6
d <- data.frame(x, first = (6 - x)^2, second = x^2)
```

Step 2: plot the data given some parameters:
``` R
nicerplot::nplot(d, title = 'Hello World', x_title = 'x', y_title = 'y', footnote = "just an example")
```

This generates a figure in`./generated/hello-world.png` in your working directory (see: `getwd()`), which looks like this:

<img src="./inst/extdata/examples/png/Hello-World.png" width = 400>

## Change the layout
Instead of lines you can plot 'stacked bars' by using parameter `type = 'bar='` (use `type = 'bar--` for shouldered bars):

``` R
library(nicerplot) # this exports function 'nplot()'
nplot(d, title = 'Shouldered bars', x_title = 'x', y_title = 'y', type = 'bar--', file = 'Hello-World-shouldered-bars')
nplot(d, title = 'Stacked bars', x_title = 'x', y_title = 'y', footnote = 'with turn = TRUE', type = 'bar=', file = 'Hello-World-stacked-bars', turn = TRUE)
```

<img src="./inst/extdata/examples/png/Hello-World-shouldered-bars.png" width = 400> <img src="./inst/extdata/examples/png/Hello-World-stacked-bars.png" width = 400>

# Manual with more examples
The <a href="https://htmlpreview.github.io/?https://github.com/data-science-made-easy/nicerplot/blob/master/inst/extdata/nicerplot-manual.html" target="_blank">official manual</a> provides many other examples. Below each figure in this manual you can find the R-code to reproduce that figure. Please ignore the file paths in the manual.

# Details
The default

- font is 'RijksoverheidSansText'. If that font is unavailable, 'sans' will be selected.
- language is Dutch, so the decimal (thousand) separator is a comma (point). Use `style = 'english'` to swap those two separators.

