FindTau <- function(
    tau,
    alpha,
    emp_influence_vals,
    selected_vec,
    freq_mat,
    t0,
    selected_idx,
    t_mat,
    max_ecdf
) {
  p <- EstimPvalue(
    tau = tau,
    emp_influence_vals = emp_influence_vals,
    selected_vec = selected_vec,
    freq_mat = freq_mat,
    t0 = t0,
    selected_idx = selected_idx,
    t_mat = t_mat,
    max_ecdf = max_ecdf
  ) 
  return(p - alpha)
}

FindBracket <- function(f, lower = -10, upper = 0, steps = 200) {
  vals <- seq(lower, upper, length.out = steps)
  f_vals <- vapply(vals, f, numeric(1))
  
  sign_changes <- which(diff(sign(f_vals)) != 0)
  
  if (length(sign_changes) == 0) {
    stop("No sign change found in the search interval.")
  }
  
  i <- sign_changes[1]
  return(c(vals[i], vals[i + 1]))
}