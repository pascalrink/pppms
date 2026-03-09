test_that("MabtCI returns a valid bound", {
  
  y <- c(0,0,1,1,0,1)
  
  preds <- cbind(
    model1 = c(0,0,1,1,1,1),
    model2 = c(0,1,1,0,0,1)
  )
  
  res <- MabtCI(y, preds, B=200)
  
  expect_true(is.list(res))
  expect_true(res$bound <= 1)
  expect_true(res$bound >= 0)
  
})