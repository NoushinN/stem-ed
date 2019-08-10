#' Add roxygen comments by
#' # bind two factors
#' # this is called the 'description':
#' Add roxygen comments by putting cursor inside function and go to
#' code -> insert roxygen skeleton
#'
#' @param a A factor.
#' @param b A factor.
#'
#' @return A factor.
#' @export
#'
#' @examples
#' #(a <- factor(c("character", "hits", "your", "eyeballs")))
#> [1] character hits your eyeballs
#> Levels: character eyeballs hits your
#(b <- factor(c("but", "integer", "where it", "counts")))
#> [1] but integer where it counts
#> Levels: but counts integer where it
#c(a, b)


fbind <- function(a,b) {
  factor(c(as.character(a), as.character(b)))
}

