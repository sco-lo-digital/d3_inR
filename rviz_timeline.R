library(devtools)
#devtools::install_github("ramnathv/htmlwidgets")
#devtools::install_github("timelyportfolio/timelineR")

library(timelineR)

# replicate example from http://kristw.github.io/d3kit-timeline/#
# define starwars release data used in all the examples
rviz_data <- data.frame(
    first_commit = c(
        "10-Apr-13",
        "1-Aug-10",
        "6-Nov-07",
        "30-Apr-13",
        "17-Jul-14",
        "14-May-01"
    ),
    
    name = c(
        'rCharts',
        'googleVis',
        'ggplot2',
        'ggvis',
        'htmlwidgets',
        'lattice'
    ),
    stringsAsFactors = FALSE
)

d3kit_timeline(
    rviz_data,
    direction = "right",
    # time is default but show as example of flexible argument types
    timeFn = ~first_commit,
    textFn = htmlwidgets::JS(
        "
        function(d){
        return new Date(d.first_commit).getFullYear() + ' - ' + d.name;
        }
        "
    ),
    width = 400,
    height = 250
    )