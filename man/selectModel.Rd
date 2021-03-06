% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compareModels.R
\name{selectModel}
\alias{selectModel}
\title{Select the best model from a list of trained \code{\link{MOFAmodel}} objects}
\usage{
selectModel(models, plotit = TRUE)
}
\arguments{
\item{models}{a list containing \code{\link{MOFAmodel}} objects.}

\item{plotit}{show a plot of the characteristics of the compared
\code{\link{MOFAmodel}} objects (ELBO value and number of inferred factors)?}
}
\value{
a single \code{\link{MOFAmodel}} with the best ELBO statistics from the provided list
}
\description{
Different trained objects of \code{\link{MOFAmodel}} are compared
 in terms of the final value of the ELBO statistics 
and the model with the highest ELBO value is selected.
}
\examples{
# Simulate Data
data <- makeExampleData()
# Create MOFA model
MOFAobject <- createMOFAobject(data)
# Prepare MOFA model
MOFAobject <- prepareMOFA(MOFAobject)
# Train several instances of MOFA models
n_inits <- 3 
MOFAlist <- lapply(1:n_inits, function(i) runMOFA(MOFAobject, outfile=tempfile()))
selectModel(MOFAlist)
}
