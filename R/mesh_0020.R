# Source custom functions ------------------------------------------------------

source(here::here("R/fx_apply_mesh.R"))
source(here::here("R/fx_make_noise.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "mesh_0020"
initial_seed <- 60520
bg_colour <- "#ffefd3"
panel_colour <- "#131313"

# For mesh
num_diag_lines <- 80

# For noise
starter_colours <- c("#000000", "#FFFFFF")
freq <- 2000
noise_type <- "value"

# Create data ------------------------------------------------------------------

# Apply mesh
mesh <- apply_mesh(
  seed_num = initial_seed, num_diag_lines = num_diag_lines)
end_points <- mesh$end_points
diags <- mesh$diags

# Create noise data
noise <- make_noise(
  seed_num = initial_seed, colours = starter_colours, frequency = freq,
  noise_type = noise_type)
noise_data <- noise$noise
noise_gradient <- noise$noise_gradient

# Build plot -------------------------------------------------------------------

# 4000x4000
p <- ggplot2::ggplot() +
  # Noise layer
  ggplot2::geom_raster(
    data = noise_data,
    ggplot2::aes(x, y, fill = noise),
    alpha = 0.15) +
  ggplot2::scale_fill_gradientn(colours = noise_gradient) +
  # Gridlines layer
  ggplot2::geom_segment(
    data = gridlines,
    ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
    colour = bg_colour, size = 0.02, alpha = 0.2) +
  # Mesh layer
  ggforce::geom_diagonal(
    data = diags,
    ggplot2::aes(x, y, xend = xend, yend = yend),
    strength = end_points$strength, size = end_points$size,
    colour = bg_colour, n = 500) +
  ggplot2::scale_colour_identity() +
  ggplot2::coord_equal(xlim = c(-2,10), ylim = c(-2,10), expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    panel.background = ggplot2::element_rect(
      fill = panel_colour, colour = panel_colour),
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(40,40,40,40, unit = "pt"))

# 10000x10000
p_large <- ggplot2::ggplot() +
  # Noise layer
  ggplot2::geom_raster(
    data = noise_data,
    ggplot2::aes(x, y, fill = noise),
    alpha = 0.15) +
  ggplot2::scale_fill_gradientn(colours = noise_gradient) +
  # Gridlines layer
  ggplot2::geom_segment(
    data = gridlines,
    ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
    colour = bg_colour, size = 0.05, alpha = 0.2) +
  # Mesh layer
  ggforce::geom_diagonal(
    data = diags,
    ggplot2::aes(x, y, xend = xend, yend = yend),
    strength = end_points$strength, size = (end_points$size*2.5),
    colour = bg_colour, n = 1250) +
  ggplot2::scale_colour_identity() +
  ggplot2::coord_equal(xlim = c(-2,10), ylim = c(-2,10), expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    panel.background = ggplot2::element_rect(
      fill = panel_colour, colour = panel_colour),
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(100,100,100,100, unit = "pt"))

# Mesh layer only
p_mesh_only <- ggplot2::ggplot() +
  # Noise layer
  #ggplot2::geom_raster(
  #  data = noise_data,
  #  ggplot2::aes(x, y, fill = noise),
  #  alpha = 0.15) +
  #ggplot2::scale_fill_gradientn(colours = noise_gradient) +
  # Gridlines layer
  #ggplot2::geom_segment(
  #  data = gridlines,
  #  ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
  #  colour = bg_colour, size = 0.05, alpha = 0.2) +
# Mesh layer
ggforce::geom_diagonal(
  data = diags,
  ggplot2::aes(x, y, xend = xend, yend = yend),
  strength = end_points$strength, size = (end_points$size*2.5),
  colour = bg_colour, n = 1250) +
  # ggplot2::scale_colour_identity() +
  ggplot2::coord_equal(xlim = c(-2,10), ylim = c(-2,10), expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    #panel.background = ggplot2::element_rect(
    #  fill = panel_colour, colour = panel_colour),
    #plot.background = ggplot2::element_rect(
    #  fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(100,100,100,100, unit = "pt"))

# Export to file ---------------------------------------------------------------

# 4000x4000px
ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  p, width = 4000, height = 4000, units = "px", dpi = 600,
  device = ragg::agg_png)

# 10000x10000px
ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}_large.png")),
  p_large, width = 10000, height = 10000, units = "px", dpi = 600,
  device = ragg::agg_png)

# Mesh only, 10000x10000px
ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}_mesh_only.png")),
  p_mesh_only, width = 10000, height = 10000, units = "px", dpi = 600,
  device = ragg::agg_png)

beepr::beep(2)
