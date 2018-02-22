#' @title Half-Normal plot
#'
#' @description Function \code{plotHalfNormal}...
#'
#' @param object ModelAudit object, fitted model object or numeric vector
#' @param score if TRUE score based on probability density function
#' @param quant.scale if TRUE values on avis are on quantile scale
#' @param main title of plot
#' @param xlab the text for the x axis
#' @param ylab the text for the y axis
#' @param ... extra arguments passed to \link[hnp]{hnp}.
#'
#' @details TO DO write about halfplots and scores.
#'
#' @return An object of class ggplot
#'
#' @importFrom hnp hnp
#' @importFrom ggplot2 ggplot aes geom_point geom_line xlab ylab annotate scale_x_continuous scale_y_continuous ggtitle coord_fixed
#' @importFrom fdrtool phalfnorm
#' @importFrom stats ecdf dnorm density
#'
#' @export

plotHalfNormal <- function(object, score=TRUE, quant.scale=FALSE,
                           xlab = "Half-Normal Quantiles", ylab = "Residuals",
                           main = "", ...){
  if(class(object)=="modelAudit") object <- object$model

  x <- residuals <- upper <- lower <- NULL
  hnpObject <- halfNormal(object,...)

  dataPlot <- datasetHalfNormalPlot(hnpObject, quant.scale)

  p <- ggplot(dataPlot, aes(x = x)) +
    geom_point(aes(y = residuals)) +
    geom_line(aes(y=upper))+
    geom_line(aes(y=lower))+
    geom_line(aes(y=median), linetype = 2) +
    scale_x_continuous(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    xlab(xlab) +
    ylab(ylab) +
    ggtitle(main) +
    theme_classic()

  if(quant.scale==TRUE) {
    p <- p +
      scale_x_continuous(limits=c(0,1)) +
      scale_y_continuous(limits=c(0,1)) +
      coord_fixed(ratio = 1)
  }
  if(score==TRUE) {
    envScore <- calculateScorePDF(hnpObject)
    p <- p + geom_text(x = -Inf, y = Inf, label = paste("Score:",round(envScore,2)), hjust = -1, vjust = 1)

   }
  return(p)
}


# Creating dataset for Half-Normal Plot
datasetHalfNormalPlot <- function(hnpObject, quant.scale){
  n <- length(hnpObject$residuals)

  if (quant.scale == FALSE) {
    dataPlot <- data.frame(x = hnpObject$x, lower = hnpObject$lower,
                           median = hnpObject$median, upper = hnpObject$upper,
                           residuals = hnpObject$residuals)
  } else {
    quantilesResiduals <-  seq(0,1,length.out = n)
    quantilesTheoretical <- phalfnorm(hnpObject$residuals)
    invQuantile <- ecdf(hnpObject$residuals)
    quantilesUpper <- invQuantile(hnpObject$upper)
    quantilesMedian <- invQuantile(hnpObject$median)
    quantilesLower <- invQuantile(hnpObject$lower)
    dataPlot <- data.frame(x = quantilesTheoretical, lower = quantilesLower,
                           median = quantilesMedian, upper = quantilesUpper,
                           residuals = quantilesResiduals)
  }
  return(dataPlot)
}

# Calculating Liklehood for each residual
calculateKDE <- function(res, simres){
  simres <- as.numeric(simres)
  (length(simres)/2 - abs(sum(res<=simres) - length(simres)/2))/(length(simres)/2)
}


# Calculating PDF score
calculateScorePDF <- function(hnpObject){
  res <- hnpObject$residuals
  simres <- as.data.frame(t(hnpObject$all.sim))
  n <- length(res)
  PDFs <- mapply(calculateKDE, res, simres)
  return(sum(PDFs))
}


# Calculating simulated residuals and envelope
halfNormal <- function(object, ...){
    trace(hnp::.makehnp, at = 13, print = FALSE,
           tracer = quote(simdata <- list(
           "x"=q.x,
           "lower"=t(env)[, 1],
           "median"=t(env)[, 2],
           "upper"=t(env)[, 3],
           "residuals"=res.original,
           "all.sim"=res) ) )

    hnpObject <- hnp(object, plot.sim=FALSE, ...)
}

