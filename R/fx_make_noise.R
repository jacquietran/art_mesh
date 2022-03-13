make_noise <- function(
  seed_num, colours, frequency,
  noise_type = c(
    "value", "perlin", "cubic", "simplex", "waves", "white", "worley",
    "checkerboard", "spheres")){
  
  # Requires {grDevices}, {ambient}, and {dplyr}
  
  noise_gradient <- (grDevices::colorRampPalette(colours))(50)
  
  set.seed(seed_num)
  noise <- ambient::long_grid(
    x = seq(-5, 15, length.out = 2000),
    y = seq(-5, 15, length.out = 2000)) |>
    dplyr::mutate(
      noise_type = noise_type,
      noise = dplyr::case_when(
        noise_type == "value" ~ ambient::fracture(
          ambient::gen_value, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "perlin" ~ ambient::fracture(
          ambient::gen_perlin, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "checkerboard" ~ ambient::fracture(
          ambient::gen_checkerboard, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "cubic" ~ ambient::fracture(
          ambient::gen_cubic, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "simplex" ~ ambient::fracture(
          ambient::gen_simplex, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "spheres" ~ ambient::fracture(
          ambient::gen_spheres, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "waves" ~ ambient::fracture(
          ambient::gen_waves, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "white" ~ ambient::fracture(
          ambient::gen_white, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y),
        noise_type == "worley" ~ ambient::fracture(
          ambient::gen_worley, ambient::fbm, octaves = 8,
          frequency = frequency, x = x, y = y)))
  
  return(
    list(
      "noise_gradient" = noise_gradient,
      "noise" = noise))
  
}