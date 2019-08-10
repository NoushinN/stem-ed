
# Workshop Notes with Jenny Bryan at RLadies Vancouver (CodeCore) - July 18, 2019
## developing a package using R

# load dependencies
library(usethis)
library(roxygen2)
library(knitr)
library(testthat)
library(covr)
library(tidyverse)

# functions in the usethis package include:
create_package()
create_project()
create_from_github()
use_mit_license()
use_testthat()
use_vignette()
use_cran_badge()

# another very useful and necessary library for developing a package is devtools
library(devtools)
documen()
check()
install()


# to see what is your default package libraries:
## which libraries are searched for, and how many packages we have installed
## make a frequency table of package priority 
.Library
.libPaths()
installed.packages() 


installed.packages() %>%
  as_tibble()

fs::path_real(c(.Library, .libPaths()))


library(tidyverse)
ipt <- installed.packages() %>%
  as_tibble()

nrow(ipt)
View(ipt)

ipt %>% 
  count(LibPath, Priority)


#-------------------------------------------------------------------------------

# Create a package with usethis:
library(usethis)
usethis::create_package("~/Desktop/foofactors")
usethis::use_github()

# to see whether the package name has been chosen before or not
library(available)
available("foofactors")

## in the "foofactors" project instance, can run this: 
# to create a new function
(a <- factor(c("character", "hits", "your", "eyeballs")))
#> [1] character hits your eyeballs
#> Levels: character eyeballs hits your
(b <- factor(c("but", "integer", "where it", "counts")))
#> [1] but integer where it counts
#> Levels: but counts integer where it
c(a, b)


fbind <- function(a,b) {
  factor(c(as.character(a), as.character(b)))
}



# after devtools::load_all()
usethis::use_r("fbind")

fbind <- function(a,b) {
  factor(c(as.character(a), as.character(b)))
}

fbind(a, b)

devtools::load_all()

#-------------------------------------------------------------------------------

# can usethis to edit .rprofile as well!
# edit .rprofile and add the following warning options
usethis::use_devtools()
usethis::edit_r_profile()
usethis::use_partial_warnings()

# other useful tidbits
git_vaccinate()

#-------------------------------------------------------------------------------

# all packages that hit CRAN need to pass check() test 
devtools::check() # check for the warnings under build pane

#' Add roxygen comments by putting cursor inside function and go to
#' code -> insert roxygen skeleton
#' 
# document
devtools::document() # under build pane, more

# install the package or under build pane use instal and restart
devtools::install()

# e.g. license
use_mit_license("Noushin Nabavi")

# can create a readme
usethis::use_readme_rmd()



