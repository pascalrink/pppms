StratifiedBootstrapSample <- function(true_labels) {
  idx_all <- seq_along(true_labels)
  idx0 <- idx_all[true_labels == 0]
  idx1 <- idx_all[true_labels == 1]
  
  boot <- c(
    sample(idx0, size = length(idx0), replace = TRUE),
    sample(idx1, size = length(idx1), replace = TRUE)
  )
  
  return(sample(boot))
}

MultidimBootstrap <- function(
    true_labels,
    pred_labels,
    B,
    seed = NA
) {
  if (!is.na(seed)) {
    set.seed(seed)
  }
  
  similar_mat <- (true_labels == pred_labels) * 1.0
  n <- nrow(similar_mat)
  k <- ncol(similar_mat)
  mu0 <- colMeans(similar_mat)
  
  t_mat <- matrix(NA_real_, nrow = B, ncol = k)
  freq_mat <- matrix(0, nrow = B, ncol = n)
  
  for (b in seq_len(B)) {
    idx <- StratifiedBootstrapSample(true_labels)
    freq_mat[b, ] <- tabulate(idx, nbins = n)
    
    similar_mat_b <- similar_mat[idx, , drop = FALSE]
    mu_b <- colMeans(similar_mat_b)
    std_err <- apply(similar_mat_b, 2, stats::sd) / sqrt(n)
    std_err[std_err == 0] <- 1 / sqrt(n) # avoid division by zero
    
    t_mat[b, ] <- (mu_b - mu0) / std_err
  }
  
  return(list(
    similar_mat = similar_mat,
    t_mat = t_mat,
    freq_mat = freq_mat
  ))
}