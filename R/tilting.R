TiltingWeights <- function(tau, emp_influence_vals) {
  w <- exp(emp_influence_vals * tau)
  return(w / sum(w))
}

EstimPvalue <- function(
    tau,
    emp_influence_vals,
    selected_vec,
    freq_mat,
    t0,
    selected_idx,
    t_mat,
    max_ecdf
) {
  w <- TiltingWeights(tau, emp_influence_vals)
  xi <- stats::weighted.mean(selected_vec, w)
  t0_xi <- (t0 - xi) / stats::sd(selected_vec)
  
  # Compute importance weights in log space for numerical stability
  log_importance_weights <- as.vector(freq_mat %*% log(length(w) * w))
  log_importance_weights <- log_importance_weights - max(log_importance_weights)
  importance_weights <- exp(log_importance_weights)
  
  sorted_idx <- order(t_mat[, selected_idx])
  sorted_t <- t_mat[sorted_idx, selected_idx]
  sorted_imp_weights <- importance_weights[sorted_idx]
  
  cum_weights <- c(0, cumsum(sorted_imp_weights))
  
  tilt_ecdf <- function(z) {
    pos <- findInterval(z, sorted_t)
    cum_weights[pos + 1] / cum_weights[length(cum_weights)]
  }
  
  return(1 - max_ecdf(tilt_ecdf(t0_xi)))
}