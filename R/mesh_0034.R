# Source custom functions ------------------------------------------------------

source(here::here("R/fx_apply_mesh.R"))
source(here::here("R/fx_make_noise.R"))
source(here::here("R/fx_draw_gridlines.R"))

# Set parameters ---------------------------------------------------------------

# General params
iteration_id <- "mesh_0034"
initial_seed <- 267734
bg_colour <- "#ffefd3"
panel_colour <- "#131313"

# For mesh
num_diag_lines <- 20

# For noise
starter_colours <- c("#000000", "#FFFFFF")
freq <- 3000
noise_type <- "value"

# For gridlines
n_gridlines <- 100
lower_limit <- -5
upper_limit <- 15

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

# Create gridlines
gridlines <- draw_gridlines(
  lower = lower_limit, upper = upper_limit, n_gridlines = n_gridlines)

# Build plot -------------------------------------------------------------------

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
    colour = bg_colour, size = 0.02) +
  # Mesh layer
  ggforce::geom_diagonal0(
    data = diags,
    ggplot2::aes(x, y, xend = xend, yend = yend),
    strength = end_points$strength, size = end_points$size,
    colour = bg_colour) +
  ggplot2::scale_colour_identity() +
  ggplot2::coord_equal(xlim = c(-5,12), ylim = c(-2,15), expand = FALSE) +
  ggplot2::theme_void() +
  ggplot2::theme(
    legend.position = "none",
    panel.background = ggplot2::element_rect(
      fill = panel_colour, colour = panel_colour),
    plot.background = ggplot2::element_rect(
      fill = bg_colour, colour = bg_colour),
    plot.margin = ggplot2::margin(40,40,40,40, unit = "pt"))

# Export to file ---------------------------------------------------------------

ggplot2::ggsave(
  here::here(glue::glue("img/{`iteration_id`}.png")),
  ggplot2::last_plot(), width = 4000, height = 4000, units = "px", dpi = 600,
  device = ragg::agg_png)

beepr::beep(2)
