pppms: Confidence Limits for Prediction Performance
================

# pppms

`pppms` provides statistical methods for **confidence limits for
prediction performance after model selection**.

The package implements procedures based on **multiplicity-adjusted
bootstrap tilting** to obtain **lower confidence limits for the
prediction performance of the empirically best-performing model** among
a set of candidates.

The methods implemented in this package originate from the dissertation

> Rink, P. (2025). *Confidence Limits for Prediction Performance*.

The package is intended as a **methods package for post-selection
inference in predictive modeling**.

------------------------------------------------------------------------

## Motivation

In many predictive modeling workflows several candidate models are
trained and compared using the same evaluation data.

Typical workflow:

1.  Fit multiple candidate models  
2.  Estimate their prediction performance  
3.  Select the empirically best model  
4.  Report its estimated performance

However, this procedure ignores the uncertainty introduced by the
**model selection step**. Selecting the best model among several
candidates inflates the observed performance and can lead to overly
optimistic conclusions.

`pppms` provides **statistically valid lower confidence limits for
prediction performance that explicitly account for model selection**.

------------------------------------------------------------------------

## Installation

``` r
# install.packages("remotes")
remotes::install_github("pascalrink/pppms")
```

------------------------------------------------------------------------

## Example

``` r
library(pppms)

true_labels <- c(0,0,1,1,0,1)

pred_labels <- cbind(
  model1 = c(0,0,1,1,1,1),
  model2 = c(0,1,1,0,0,1)
)

res <- MabtCI(
  true_labels,
  pred_labels,
  B = 200,
  seed = 1
)

res
```

Returned values:

- **bound** – lower confidence limit for prediction performance  
- **tau** – estimated tilting parameter  
- **t0** – empirical performance of the selected model  
- **selected_idx** – index of the selected model

------------------------------------------------------------------------

## Methodological idea

The procedure combines two ideas:

**Multiplicity adjustment**  
Model selection creates a multiple comparison problem. The procedure
therefore uses a **max-type calibration** across candidate models.

**Bootstrap tilting**  
Bootstrap resampling is modified using weights

    w_i(tau) ∝ exp(tau * psi_i)

where `psi_i` is an empirical influence quantity and `tau` is a tilting
parameter chosen so that the bootstrap distribution matches the target
significance level.

------------------------------------------------------------------------

## Further details

For methodological background see

``` r
vignette("methodological-background", package = "pppms")
```

------------------------------------------------------------------------

## Reference

Rink, P. (2025).  
*Confidence Limits for Prediction Performance*.  
Doctoral thesis, University of Bremen.
