# Multiplicity-adjusted bootstrap tilting confidence limit

Computes a lower confidence limit for prediction performance after
selecting the empirically best-performing candidate model.

## Usage

``` r
MabtCI(true_labels, pred_labels, alpha = 0.05, B = 10000, seed = NA)
```

## Arguments

- true_labels:

  A numeric vector of true binary class labels coded as 0 and 1.

- pred_labels:

  A matrix of predicted class labels. Rows correspond to observations,
  columns to candidate prediction rules or models.

- alpha:

  Significance level for the lower confidence limit.

- B:

  Number of bootstrap replications.

- seed:

  Optional random seed. Use `NA` to leave the random number generator
  unchanged.

## Value

A list with components:

- bound:

  Estimated lower confidence limit for the selected model.

- tau:

  Estimated tilting parameter.

- t0:

  Observed performance of the selected model.

- selected_idx:

  Column index of the selected model.

## Details

The function implements a multiplicity-adjusted bootstrap tilting
procedure for lower confidence bounds on prediction performance after
model selection.

## Examples

``` r
y <- c(0, 0, 1, 1, 0, 1)
preds <- cbind(
  model1 = c(0, 0, 1, 1, 1, 1),
  model2 = c(0, 1, 1, 0, 0, 1)
)
if (FALSE) { # \dontrun{
MabtCI(y, preds, B = 200, seed = 1)
} # }
```
