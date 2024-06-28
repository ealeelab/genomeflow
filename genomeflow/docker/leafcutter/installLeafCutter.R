options(Ncpus = parallel::detectCores())
install.packages("matrixStats")
install.packages("loo")
install.packages(c("usethis","roxygen2"))

if (!require("devtools")) install.packages("devtools", repos='http://cran.us.r-project.org')


Sys.setenv(DOWNLOAD_STATIC_LIBV8=1)
install.packages("V8")

install.packages("rstan")
install.packages("BiocManager")
BiocManager::install("Biobase",update=TRUE,ask=FALSE)
BiocManager::install("DirichletMultinomial",update=TRUE,ask=FALSE)

install.packages("TailRank")

devtools::install_github("davidaknowles/leafcutter/leafcutter")
