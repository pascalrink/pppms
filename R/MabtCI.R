#' Multiplicity-adjusted bootstrap tilting confidence limit
#'
#' Computes a lower confidence limit for prediction performance after
#' selecting the empirically best-performing candidate model.
#'
#' @param true_labels A numeric vector of true binary class labels coded as 0 and 1.
#' @param pred_labels A matrix of predicted class labels. Rows correspond to observations,
#'   columns to candidate prediction rules or models.
#' @param alpha Significance level for the lower confidence limit.
#' @param B Number of bootstrap replications.
#' @param seed Optional random seed. Use `NA` to leave the random number generator unchanged.
#'
#' @return A list with components:
#' \describe{
#'   \item{bound}{Estimated lower confidence limit for the selected model.}
#'   \item{tau}{Estimated tilting parameter.}
#'   \item{t0}{Observed performance of the selected model.}
#'   \item{selected_idx}{Column index of the selected model.}
#' }
#'
#' @details
#' The function implements a multiplicity-adjusted bootstrap tilting procedure
#' for lower confidence bounds on prediction performance after model selection.
#'
#' @examples
#' y <- c(0, 0, 1, 1, 0, 1)
#' preds <- cbind(
#'   model1 = c(0, 0, 1, 1, 1, 1),
#'   model2 = c(0, 1, 1, 0, 0, 1)
#' )
#' \dontrun{
#' MabtCI(y, preds, B = 200, seed = 1)
#' }
#'
#' @export
MabtCI <- function(
    true_labels,
    pred_labels,
    alpha = 0.05,
    B = 10000,
    seed = NA
) {
  boot <- MultidimBootstrap(
    true_labels = true_labels,
    pred_labels = pred_labels,
    B = B,
    seed = seed
  )
  
  B_boot <- nrow(boot$freq_mat)
  
  t0_vec <- colMeans(boot$similar_mat)
  selected_idx <- which.max(t0_vec)
  t0 <- t0_vec[selected_idx]
  selected_vec <- boot$similar_mat[, selected_idx]
  emp_influence_vals <- selected_vec
  
  unif_transformed <- apply(
    boot$t_mat,
    2,
    function(x) rank(x, ties.method = "average") / B_boot
  )
  supp <- sort(apply(unif_transformed, 1, max))
  
  max_ecdf <- function(t) {
    findInterval(t, supp) / B_boot
  }
  
  root_fun <- function(tau) {
    FindTau(
      tau = tau,
      alpha = alpha,
      emp_influence_vals = emp_influence_vals,
      selected_vec = selected_vec,
      freq_mat = boot$freq_mat,
      t0 = t0,
      selected_idx = selected_idx,
      t_mat = boot$t_mat,
      max_ecdf = max_ecdf
    )
  }
  
  bracket <- FindBracket(root_fun)
  tau <- stats::uniroot(root_fun, interval = bracket)$root
  
  bound <- stats::weighted.mean(
    selected_vec,
    TiltingWeights(tau, emp_influence_vals)
  )
  
  tilt_result <- list(
    bound = bound, 
    tau = tau, 
    t0 = unname(t0), 
    selected_idx = unname(selected_idx)
  )
  return(tilt_result)
}