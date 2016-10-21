library(htmltools)

# some notes

# data in the original is
e2data <- read.csv("https://cdn.rawgit.com/e2d3/e2d3-contrib/master/dot-bar-chart/data.csv")
# and the column headings need to be the same
#  since currently not flexible
# if we want Titanic in similar format
#  we would do something like
library(dplyr)
library(tidyr)
data.frame(
  xtabs(Freq~Survived+Class,Titanic),
  stringsAsFactors = FALSE
) %>%
  spread(Survived,Freq) %>%
  mutate(Year = Class) %>%
  select(Year,everything()) %>%
  select(-Class)

e2d3 <- htmlDependency(
  name = "e2d3",
  version = "0.6.4",
  src = c(href = "https://cdn.rawgit.com/timelyportfolio/e2d3/master/dist/lib"),
  script = "e2d3.js"
)

# I thought we could do this but unfortunately not
#  since order is important
#  we paste the main.js in our tags$script below
#  but i'll fix this later
#  with htmlwidgets

e2d3_dotbar <- htmlDependency(
  name = "e2d3_dotbar",
  version = "0.1",
  src = c(href="https://cdn.rawgit.com/e2d3/e2d3-contrib/master/dot-bar-chart/main.js"),
  script = "main.js"
)

# make a function for now as convenience
#   to allow R data.frame in proper format
#   but eventually rewrite e2-dot-bar with arguments
#   to allow other column names for the hierarchy
e2d3_dot_builder <- function(data = NULL) {
browsable(
  attachDependencies(
    tagList(
      tags$div(
        id = "chart"
      ),
      tags$script(HTML(
sprintf(
"
var root = document.getElementById('chart');
var data = '%s';


%s


var dim = { width: 600, height: 400 };
var margin = { top: 30, bottom: 50, left: 50, right: 20 };
var inputHeight = 20;
var numberFormat = d3.format('.0f');
dim.graphWidth = dim.width - margin.left - margin.right;
dim.graphHeight = dim.height - margin.top - margin.bottom;

require(['e2d3model'],function(model){
  var rows = d3.csv.parseRows(data);
  update(new model.ChartDataTable(rows));
})

",
paste0(
  capture.output(write.csv(data, row.names=FALSE)),
  collapse="\\n"
),
paste0(
  readLines("C:\\\\Users\\KENT\\Dropbox\\development\\r\\e2d3-contrib\\dot-bar-chart\\main.js"),
  collapse="\n"
)
)
      ))
    ),
    list(e2d3)
  )
)
}

# recreate original with our e2data
e2d3_dot_builder(e2data)

# now do it with Titanic
data.frame(
  xtabs(Freq~Survived+Class,Titanic),
  stringsAsFactors = FALSE
) %>%
  spread(Survived,Freq) %>%
  mutate(Year = Class) %>%
  select(Year,everything()) %>%
  select(-Class) %>%
  e2d3_dot_builder()

