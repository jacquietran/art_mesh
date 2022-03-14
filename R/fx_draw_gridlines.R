draw_gridlines <- function(lower, upper, n_gridlines){
  
  # Requires {tibble}
  
  gridlines <- tibble::tibble(
    x = c(
      seq(lower, upper, length.out = n_gridlines),
      rep(lower, times = n_gridlines)),
    xend = c(
      seq(lower, upper, length.out = n_gridlines),
      rep(upper, times = n_gridlines)),
    y = c(
      rep(lower, times = n_gridlines),
      seq(lower, upper, length.out = n_gridlines)),
    yend = c(
      rep(upper, times = n_gridlines),
      seq(lower, upper, length.out = n_gridlines)))
  
  return(gridlines)
  
}