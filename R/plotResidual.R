#' @title Plot Residuals vs Observed, Fitted or Variable Values
#'
#' @description A plot of residuals against fitted values, observed values or any variable.
#'
#' @param object An object of class modelAudit or modelResiduals.
#' @param ... Other modelAudit objects to be plotted together.
#' @param variable Only for modelAudit object. Name of model variable to order residuals. If value is NULL data order is taken. If value is "Predicted response" or "Fitted values" then data is ordered by fitted values. If value is "Observed response" the data is ordered by a vector of actual response (\code{y} parameter passed to the \code{\link{audit}} function).
#' @param points Logical, indicates whenever observations should be added as points.
#' @param lines Logical, indicates whenever smoothed lines should be added.
#' @param std.residuals Logical, indicates whenever standardized residuals should be used.
#' @param nlabel Number of observations with the biggest Cook's distances to be labeled.
#'
#' @examples
#' library(car)
#' lm_model <- lm(prestige~education + women + income, data = Prestige)
#' lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
#' plotResidual(lm_au)
#'
#' library(randomForest)
#' rf_model <- randomForest(prestige~education + women + income, data = Prestige)
#' rf_au <- audit(rf_model, data = Prestige, y = Prestige$prestige)
#' plotResidual(lm_au, rf_au)
#'
#' @seealso \code{\link{plot.modelAudit}}
#'
#' @import ggplot2
#' @importFrom ggrepel geom_text_repel
#'
#' @export
plotResidual <- function(object, ..., variable=NULL, points = TRUE, lines = FALSE,
                         std.residuals = FALSE, nlabel = 0){
  if(!("modelResiduals" %in% class(object) || "modelAudit" %in% class(object))) stop("The function requires an object created with audit() or modelResiduals().")
  if("modelResiduals" %in% class(object)) variable <- object$variable[1]
  if(!("modelResiduals" %in% class(object))) object <- modelResiduals(object, variable)


  res <- std.res <- val <- label <- index <- NULL

  ylabel <- ifelse(std.residuals == TRUE, "standardized residuals", "residuals")
  df <- object

  dfl <- list(...)
  if (length(dfl) > 0) {
    for (resp in dfl) {
      if("modelAudit" %in% class(resp)) df <- rbind( df, modelResiduals(resp, variable) )
      if("modelResiduals" %in% class(resp)) df <- rbind(df, resp)
    }
  }

  maybe_points <- if (points == TRUE) df else df[0, ]
  maybe_lines <- if (lines == TRUE) df else df[0, ]
  maybe_labels <- df[order(abs(df$res), decreasing = TRUE),][0:nlabel, ]

  if(is.na(df$variable[1])) variable <- NULL

  if (is.null(variable)) {
    title <- "Residuals"
  } else {
    title <- paste0("Residuals vs ", variable)
  }

  if(std.residuals == TRUE) {p <- ggplot(df, aes(val, std.res, color = label))}
  else {p <- ggplot(df, aes(val, res, color = label))}

  p + geom_point(data = maybe_points, alpha = 1, stroke=0) +
      geom_smooth(data = maybe_lines, method = "loess", se = FALSE, size = 2) +
      geom_text_repel(data = maybe_labels, aes(label = as.character(index)),
                hjust=-0.2,vjust=-0.2, show.legend = FALSE) +
      xlab(variable) +
      ylab(ylabel) +
      ggtitle(title) +
      theme_light()
}


