# The auditor package - model verification, validation, and error analysis   
<img src="materials/auditor2.png" width="20%" align="right" />


[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/auditor)](https://cran.r-project.org/package=auditor)
[![Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/auditor)](http://cranlogs.r-pkg.org/badges/grand-total/auditor)
[![Build Status](https://travis-ci.org/MI2DataLab/auditor.svg?branch=master)](https://travis-ci.org/MI2DataLab/auditor)
[![Coverage Status](https://img.shields.io/codecov/c/github/mi2datalab/auditor/master.svg)](https://codecov.io/github/mi2datalab/auditor?branch=master)
[![Binder](https://mybinder.org/badge.svg)](https://hub.mybinder.org/user/mi2datalab-auditor-qzj1zvt8/notebooks/jupyter-notebooks/auditor_dragons_demo.ipynb)
[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=The%20auditor%20package%20is%20an%20easy%20to%20use%20unified%20interface%20for%20model-agnostic%20verification,%20validation,%20and%20error%20analysis.%0Ahttps://github.com/mi2datalab/auditor%0A&hashtags=rstats,erroranalysis,machinelearning,audit)


<img src="materials/auditorLogo.png" width="20%" /> 

## auditor's pipeline: *model %>% audit() %>% plot(type=...)*

<img src="materials/demo.png" width="800" align = "center" />

# Preprint

A [preprint of the article about auditor](https://arxiv.org/abs/1809.07763) is available on arxiv.

## Installation

### from GitHub

```
devtools::install_github("mi2datalab/auditor")
```
### and from CRAN 

```{r}
install.packages("auditor")
```

## [News](NEWS.md)

## [Reference Manual](https://mi2datalab.github.io/auditor/)

## DEMO

Run the code below or try the auditor by the online jupyter-notebook: [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/mi2datalab/auditor/master?filepath=jupyter-notebooks%2Fauditor-demo.ipynb)

```
library(auditor)
library(randomForest)
data(mtcars)

# fitting models
model_lm <- lm(mpg ~ ., data = mtcars)
set.seed(123)
model_rf <- randomForest(mpg ~ ., data = mtcars)

# creating a modelAudit object which contains all necessary components required for further processing
au_lm <- audit(model_lm)
au_rf <- audit(model_rf, label = "rf")

# generating plots
plot(au_lm, type = "Residual")
plot(au_lm, au_rf, type = "Residual")

plot(au_lm, au_rf, variable = "wt", type = "Prediction")

plot(au_lm, au_rf, type = "ModelCorrelation")
plot(au_lm, au_rf, variable = "wt", type = "ModelCorrelation")

# plots above are availible also via plotResidual(), plotPrediction() and plotModelCorrelation() functions
```
For more plot types and examples see *A Short Overview of Plots* section below.


## Cheatsheets

<img src="https://raw.githubusercontent.com/mi2datalab/auditor/master/materials/auditor_cheatsheet.png"/>
<img src="https://raw.githubusercontent.com/mi2datalab/auditor/master/materials/auditor_cheatsheet_ROC.png"/>

## A Short Overview of Plots

| Plot name                                             | Function                                                               | Regression | Classification | Examples                                                                                                                                                         |
|-------------------------------------------------------|------------------------------------------------------------------------|------------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Autocorrelation Function                              | `plotACF()` </br> `plot(..., type = "ACF")`                            |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotacf---autocorrelation-function-of-residuals)                             | 
| Autocorrelation                                       | `plotAutocorrelation()` </br> `plot(..., type = "Autocorrelation")`    |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotautocorrelation---autocorrelation-of-residuals)                          |
| Influence of observations                             | `plotCooksDistance()` </br> `plot(..., type = "CooksDistance")`        |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/observation_influence_audit.html#which-observations-are-outlyers)                                       |     
| Half-Normal                                           | `plotHalfNormal()` </br> `plot(..., type = "HalfNormal")`              |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_fit_audit.html)                                                                                   |
| LIFT Chart                                            | `plotLIFT()` </br> `plot(..., type = "LIFT")`                          |    no      |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_evaluation_audit.html#lift-chart)                                                                         |
| Model Correlation                                     | `plotModelCorrelation()` </br> `plot(..., type = "ModelCorrelation")`  |    yes     |    yes         | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotmodelcorrelation---correlation-of-models)                                |
| Principal Component Analysis of models                | `plotModelPCA()` </br> `plot(..., type = "ModelPCA")`                  |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotmodelpca---model-pca)                                                    |
| Model Ranking Plot                                    | `plotModelRanking()` </br> `plot(..., type = "ModelRanking")`          |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_performance_audit.html)                                                                           |
| Predicted Response vs Observed or Variable Values     | `plotPrediction()` </br> `plot(..., type = "Prediction")`              |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotpredition---observed-vs-predicted)                                       |
| Regression Error Characteristic Curves (REC)          | `plotREC()` </br> `plot(..., type = "REC")`                            |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotrec---regression-error-characteristic-rec-curve)                         |
| Plot Residuals vs Observed, Fitted or Variable Values | `plotResidual()` </br> `plot(..., type = "Residual")`                  |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_performance_audit.html#plotresidual---plot-residuals-vs-observed-fitted-or-variable-values)       |
| Residual Boxplot                                      | `plotResidualBoxplot()` </br> `plot(..., type = "ResidualBoxplot")`    |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_performance_audit.html#plotresidualboxplot---boxplot-of-residuals)                                |
| Residual Density                                      | `plotResidualDensity()` </br> `plot(..., type = "ResidualDensity")`    |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_performance_audit.html#plotresidualdensity---density-of-residuals)                                |
| Receiver Operating Characteristic (ROC)               | `plotROC()` </br> `plot(..., type = "ROC")`                            |    no      |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_evaluation_audit.html#receiver-operating-characteristic-roc)                                                                                   |
| Regression Receiver Operating Characteristic (RROC)   | `plotRROC()` </br> `plot(..., type = "RROC")`                          |    yes     |     yes        | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotrroc---regression-receiver-operating-characteristic-rroc)                |
| Scale-Location plot                                   | `plotScaleLocation()` </br> `plot(..., type = "ScaleLocation")`        |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plotscalelocation---scale-location-plot)                                     |
| Two-sided Cumulative Distribution Function            |  `plotTwoSidedECDF()` </br> `plot(..., type = "TwoSidedECDF")`         |    yes     |      yes       | [Examples](https://mi2datalab.github.io/auditor/articles/model_residuals_audit.html#plottwosidedecdf---two-sided-empirical-cumulative-distribution-function-ecdf) |

## Acknowledgments
Work on this package was financially supported by the ‘NCN Opus grant 2016/21/B/ST6/02176’.

## More

[Presentation during Knowledge Network Tech Meetup](https://slides.com/jusira/deck/fullscreen)
