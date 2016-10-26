#' 'e2d3' HTML Dependencies
#'
#' @return htmltools::htmlDependency
#' @export
#'
#' @example inst/examples/prototype.R
e2d3_dep <- function(){
  htmltools::htmlDependency(
    name = "e2d3",
    version = "0.6.4",
    src = c(
      file = system.file("htmlwidgets/lib/e2d3/dist", package="e2d3R")
    ),
    script = "e2d3full.js"
  )
}
