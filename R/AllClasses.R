
##########################################################
## Define a general class to store a MOFA trained model ##
##########################################################

#' @title Class to store a Multi-Omics Factor Analysis (MOFA) model
#' @description
#' The \code{MOFAmodel} is an S4 class used to store all
#'  relevant data to analyse a MOFA model.

#' @slot InputData the input data before being parsed to Training Data. 
#'    Either a MultiAssayExperiment object or a list of matrices, one per view.
#' @slot TrainData the parsed data used to fit the MOFA model
#'    A list with one matrix per view.
#' @slot ImputedData the parsed data with the missing
#'  values imputed using the MOFA model. 
#'    A list with one matrix per view.
#' @slot Expectations expected values of the different
#'  variables of the model. A list of matrices, one per variable.
#'   The most relevant are "W" for weights and "Z" for factors.
#' @slot TrainStats list with training statistics such as evidence lower bound (ELBO),
#'  number of active factors, etc.
#' @slot DataOptions list with the data processing options such as
#'  whether to center or scale the data.
#' @slot TrainOptions list with the training options such as
#'  maximum number of iterations, tolerance for convergence, etc.
#' @slot ModelOptions list with the model options such as
#'  likelihoods, number of factors, etc.
#' @slot FeatureIntercepts list with the feature-wise intercepts. 
#' Only used internally.
#' @slot Dimensions list with the relevant dimensionalities of the model.
#'  N for the number of samples, M for the number of views, 
#'  D for the number of features of each view and K for the number of infered latent factors.
#' @slot Status Auxiliary variable indicating whether the model has been trained.
#' @name MOFAmodel
#' @rdname MOFAmodel
#' @aliases MOFAmodel-class
#' @exportClass MOFAmodel
setClass("MOFAmodel", slots=c(
  InputData = "MultiAssayExperiment", TrainData = "list", ImputedData = "list",
  Expectations = "list", TrainStats = "list", Dimensions = "list",
  DataOptions = "list", TrainOptions = "list", ModelOptions = "list", FeatureIntercepts = "list",
  Status = "character")
)

# Printing method
setMethod("show", "MOFAmodel", function(object) {
  
  if(!.hasSlot(object,"Dimensions") | length(object@Dimensions) == 0)
    stop("Error: Dimensions not defined")
  if(!.hasSlot(object,"Status") | length(object@Status) == 0)
    stop("Error: Status not defined")
  
  if (object@Status == "trained") {
    # check whether the intercept was learnt (depreciated, included for compatibility with old models)
    if(is.null(object@ModelOptions$learnIntercept)) {
      learnIntercept <- FALSE
      } else {
        learnIntercept <- object@ModelOptions$learnIntercept
      }
    nfactors <- object@Dimensions[["K"]]
    if (learnIntercept) { nfactors <- nfactors-1 }
    cat(sprintf("Trained MOFA model with the following characteristics:
  Number of views: %d \n View names: %s 
  Number of features per view: %s 
  Number of samples: %d 
  Number of factors: %d ",
                object@Dimensions[["M"]], paste(viewNames(object),collapse=" "),
                paste(as.character(object@Dimensions[["D"]]),collapse=" "),
                object@Dimensions[["N"]], nfactors))
  } else {
    cat(sprintf("Untrained MOFA model with the following characteristics: 
  Number of views: %d 
  View names: %s 
  Number of features per view: %s
  Number of samples: %d ",
                object@Dimensions[["M"]], paste(viewNames(object),collapse=" "),
                paste(as.character(object@Dimensions[["D"]]),collapse=" "),
                object@Dimensions[["N"]]))
    cat("\n")
  }
})
