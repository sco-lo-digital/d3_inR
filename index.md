---
title       : Using d3 in R
subtitle    : Create visualizations that use d3, with R
author      : Scott Jacobs

output      : ioslides_presentation
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---

## Overview of Options

> 1. **htmlwidgets**
    - < 1 yr old, very popular, maintained by Rstudio, used by Plotly
> 2. googleVis
    - Really cool but data and plot are hosted on their platform
> 3. rCharts
    - Predecessor to htmlwidgets
> 4. ggvis
    - ggplot2 authors, based on old javascript library

##d3kit_timeline - Static implementation of non-stdrd viz
<style>
iframe {
  width: 900px;
  height: 500px;
  background: #AA0000;
}
</style>
<style>iframe.nvd3{height: 600px;width: 1000px}</style>

```{r timeline, cache = F, echo = F, results = 'asis', comment = NA, message = F}
library(devtools)
#devtools::install_github("ramnathv/htmlwidgets")
#devtools::install_github("timelyportfolio/timelineR")
library(htmlwidgets)
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
        "14-May-01",
        "1-Apr-97"
    ),
    
    name = c(
        'rCharts',
        'googleVis',
        'ggplot2',
        'ggvis',
        'htmlwidgets',
        'lattice',
        'base'
    ),
    stringsAsFactors = FALSE
)

m1 <- d3kit_timeline(
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
    width = 800,
    height = 400
    )
saveWidget(m1, 'diagram.html')
cat('<iframe src="diagram.html" width=100% height=100% allowtransparency="true" style="background: #FFCCFF;"> </iframe>')

#saveWidget(m1, 'index.html')
#m1
#m1$show('iframesrc')
```



## d3radarR - explore multivariates across classes
```{r radar, cache = F, echo = F, results = 'asis', comment = NA, message = F}
# devtools::install_github("timelyportfolio/d3radarR")

library(d3radarR)

# use data from demo
#   https://github.com/TennisVisuals/updating-radar-chart/blob/master/radarDemo.js
json_data = jsonlite::fromJSON(
'
  [  
    {  
      "key":"Nokia Smartphone",
      "values":[  
        {  "axis":"Battery Life", "value":0.26 }, {  "axis":"Brand", "value":0.10 },
        {  "axis":"Contract Cost", "value":0.30 }, {  "axis":"Design And Quality", "value":0.14 },
        {  "axis":"Have Internet Connectivity", "value":0.22 }, {  "axis":"Large Screen", "value":0.04 },
        {  "axis":"Price Of Device", "value":0.41 }, {  "axis":"To Be A Smartphone", "value":0.30 }
        ]
    },
    {  
      "key":"Samsung",
      "values":[  
        {  "axis":"Battery Life", "value":0.27 }, {  "axis":"Brand", "value":0.16 },
        {  "axis":"Contract Cost", "value":0.35 }, {  "axis":"Design And Quality", "value":0.13 },
        {  "axis":"Have Internet Connectivity", "value":0.20 }, {  "axis":"Large Screen", "value":0.13 },
        {  "axis":"Price Of Device", "value":0.35 }, {  "axis":"To Be A Smartphone", "value":0.38 }
        ]
    },
    {  
      "key":"iPhone",
      "values":[  
        {  "axis":"Battery Life", "value":0.22 }, {  "axis":"Brand", "value":0.28 },
        {  "axis":"Contract Cost", "value":0.29 }, {  "axis":"Design And Quality", "value":0.17 },
        {  "axis":"Have Internet Connectivity", "value":0.22 }, {  "axis":"Large Screen", "value":0.02 },
        {  "axis":"Price Of Device", "value":0.21 }, {  "axis":"To Be A Smartphone", "value":0.50 }
        ]
    }
  ]
',
  simplifyDataFrame = FALSE
)

m2 <- d3radar(json_data, width = 800, height = 400)


saveWidget(m2, 'diagram2.html')
cat('<iframe src="diagram2.html" width=100% height=100% allowtransparency="true" style="background: #FFCCFF;"> </iframe>')


```



## d3sunburst - visualize event data

```{r sunburst, cache = F, echo = F, results = 'asis', comment = NA, message = F}
library(TraMineR)
library(sunburstR)
library(pipeR)

# use example from TraMineR vignette
data("mvad")
mvad.alphab <- c(
  "employment", "FE", "HE", "joblessness",
  "school", "training"
)
mvad.seq <- seqdef(mvad, 17:86, xtstep = 6, alphabet = mvad.alphab)

# to make this work, we'll compress the sequences with seqdss
#   could also aggregate with dply later
m3 <- seqtab( seqdss(mvad.seq), tlim = 0, format = "SPS" ) %>>%
  attr("freq") %>>%
  (
    data.frame(
      # appending "-end" is necessary for this to work
      sequence = paste0(
        gsub(
          x = names(.$Freq)
          , pattern = "(/[0-9]*)"
          , replacement = ""
          , perl = T
        )
        ,"-end"
      )
      ,freq = as.numeric(.$Freq)
      ,stringsAsFactors = FALSE
    )
    
  ) %>>%
  sunburst(width = 550, height = 450)

saveWidget(m3, 'diagram3.html')
cat('<iframe src="diagram3.html" width=100% height=100% allowtransparency="true" style="background: #FFCCFF;"> </iframe>')


```

##Taucharts - a wide array of options for classic charts

```{r Taucharts, cache = F, echo = F, comment = NA, message = F}
# devtools::install_github("hrbrmstr/taucharts")
library(taucharts)

CO2 %>%
  tauchart( ) %>%
  tau_point( "conc", c("Treatment","uptake"), "Plant" ) %>%
  tau_tooltip( ) %>%
  tau_trendline( )

```


## Many Thanks To

> - **Kenton Russell** - timelyportfolio
> - **Ramnath Vaidyanathan** and **RStudio** for htmlwidgets
> - Learn more at www.buildingwidgets.com
