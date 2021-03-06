#' @title Create Model Performance Explainer
#'
#' @description  Creates observationInfluence object to be plotted.
#'
#' @param object An object of class ModelAudit.
#' @param scores Vector of score names to be plotted.
#' @param new.score A named list of functions that take one argument: object of class ModelAudit and return a numeric value. The measure calculated by the function should have the property that lower score value indicates better model.
#' @param ... other parameters.
#'
#'
#' @examples
#' library(MASS)
#' model.glm <- glm(Postwt ~ Prewt + Treat + offset(Prewt), family = gaussian, data = anorexia)
#' audit.glm <- audit(model.glm)
#'
#' mp.glm <- modelPerformance(audit.glm)
#'
#'
#' @export
modelPerformance <- function(object, scores = c("MAE", "MSE", "REC", "RROC"), new.score = NULL){
  if(!("modelAudit" %in% class(object))) stop("The function requires an object created with audit().")


    df <- data.frame(score = score(object, type = scores[1])$score, label = object$label, name = scores[1])

    if(length(scores) > 1){
      for(i in 2:length(scores)){
        df <- rbind(df, data.frame(score = score(object, type = scores[i])$score, label = object$label, name = scores[i]))
      }
    }

    if(!is.null(new.score)){
      if (class(new.score) == "function"){
        df <- rbind(df, data.frame(score = new.score(object), label = object$label, name = as.character(substitute(new.score))))
      }
      if(class(new.score) == "list") {
        for(i in names(new.score)){
          df <- rbind(df, data.frame(score = new.score[[i]](object), label = object$label, name = i))
        }
      }
    }
  result <- df
  class(result) <- c("modelPerformance", "data.frame")

  return(result)
}
