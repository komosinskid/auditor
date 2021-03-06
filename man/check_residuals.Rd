% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_residuals.R
\name{check_residuals}
\alias{check_residuals}
\title{Automated tests for model residuals}
\usage{
check_residuals(model, ...)
}
\arguments{
\item{model}{An object of class `modelAudit`}

\item{...}{other parameters that will be passed to further functions}
}
\value{
list with statistics for particualr checks
}
\description{
Currently three tests are performed
 - for outliers in residuals
 - for autocorrelation in target variable or in residuals
 - for trend in residuals as a function of target variable (detection of bias)
}
\examples{
library(car)
lm_model <- lm(prestige ~ education + women + income, data = Prestige)
lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
check_residuals(lm_au)
 \dontrun{
 library("DALEX2")
 dragons <- DALEX2::dragons
 library("ranger")
 rf_model <- ranger(life_length ~ ., data = dragons)
 predict_function <- function(m,x,...) predict(m, x, ...)$predictions
 rf_au <- audit(rf_model, data = dragons, y = dragons$life_length,
           predict.function = predict_function)
 check_residuals(rf_au)
}
}
