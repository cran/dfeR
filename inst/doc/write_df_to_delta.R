## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7, fig.height = 5
)

plot_pkgs <- c("ggplot2", "scales", "purrr")
can_plot <- all(vapply(plot_pkgs, requireNamespace, logical(1), quietly = TRUE))

if (can_plot) {
  library(ggplot2)
  library(dplyr)
  library(scales)
  library(purrr)
}

## ----echo = FALSE, eval = !can_plot, results = "asis"-------------------------
# cat("_Figures omitted: ggplot2, scales and purrr are not installed._")

## ----basic_usage, include = TRUE, eval = FALSE--------------------------------
# library(dfeR)
# library(DBI)
# library(odbc)
# 
# # Establish your connection
# con <- DBI::dbConnect(odbc::databricks(),
#                       httpPath = Sys.getenv("DATABRICKS_SQL_PATH"))
# 
# # Upload data frame to Delta Lake
# # The volume_dir is the path to your staging Volume in Unity Catalog
# write_df_to_delta(
#   df = my_data,
#   target_table = "catalog.schema.my_table",
#   db_conn = con,
#   volume_dir = "/Volumes/catalog/schema",
#   overwrite_table = TRUE
# )

## ----arrow_schema, include = TRUE, eval = FALSE-------------------------------
# library(arrow)
# 
# my_custom_schema <- schema(
#   transaction_id = int64(),
#   amount = decimal128(precision = 18, scale = 2)
# )
# 
# write_df_to_delta(
#   df = financial_data,
#   target_table = "finance.audit.transactions",
#   db_conn = con,
#   volume_dir = "/Volumes/main/default/staging/",
#   schema = my_custom_schema
# )

## ----chunk_size, include = TRUE, eval = FALSE---------------------------------
# write_df_to_delta(
#   df = my_data,
#   target_table = "catalog.schema.my_table",
#   db_conn = con,
#   volume_dir = "/Volumes/main/default/staging/",
#   chunk_size = 1 * 1024^3  # 1 GB in bytes
# )

## ----benchmarks_plot, echo = FALSE, eval = can_plot, message = FALSE, warning = FALSE, fig.cap = "Figure 1: Performance comparison between DBI and dfeR across increasing row counts."----
# 1. Clean and Prepare Benchmark Data
summary_df <- imap_dfr(readRDS("write_df_to_delta_benchmarks.rds"), ~ {
  as.data.frame(.x) |>
    group_by(expr) |>
    summarise(
      median = median(time) / 1e9,
      lq = quantile(time, 0.25) / 1e9,
      uq = quantile(time, 0.75) / 1e9,
      .groups = "drop"
    ) |>
    mutate(rows = as.numeric(.y))
})

# 2. Define the colours
corporate_colors <- c(
  "DBI::dbWriteTable" = "#d4351c",       # Red for the 'standard' method
  "dfeR::write_df_to_delta" = "#003078" # DfE Blue for our tool
)

# 3. Create the Plot
plot_log_log <- ggplot(summary_df, aes(x = rows, y = median, color = expr,
                                       group = expr)) +
  # Add error bars to show the 25th-75th percentile range (lq and uq)
  geom_errorbar(aes(ymin = lq, ymax = uq), width = 0.05, alpha = 0.5) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  # X-axis: Log scale with standard numeric labels
  scale_x_log10(
    breaks = c(100, 1000, 10000, 100000, 1000000),
    labels = label_number(scale_cut = cut_short_scale())
  ) +
  # Y-axis: Log scale with your custom "Human Time" labels
  scale_y_log10(
    breaks = c(1, 5, 10, 60, 600, 1800),
    labels = c("1s", "5s", "10s", "1m", "10m", "30m")
  ) +
  scale_color_manual(values = corporate_colors) +
  labs(
    title = "Structural Efficiency: Log-Log Scale",
    subtitle = "DBI execution time is directly proportional to volume;
    dfeR maintains a high-efficiency baseline",
    x = "Data Volume (Rows)",
    y = "Execution Time (Log Scale)",
    color = "Function"
  ) +
  theme_bw() +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold")
  )

# Display the plot
print(plot_log_log)

## ----stress_test_plot, echo = FALSE, eval = can_plot, message = FALSE, warning = FALSE, fig.cap = "Figure 2: Performance resiliency testing from 100 to 1 billion rows, showing stable execution times."----
# 1. Process the Stress Test data
# Using your exact logic, just pointing to the saved benchmark results
plot_df <- purrr::imap_dfr(readRDS("write_df_to_delta_stress_test.rds"),
                           function(bm, n) {
                                            df <- as.data.frame(bm)
                                            df$row_count <- as.numeric(n)
                                            df }) |>
  mutate(
    seconds = time / 1e9,
    # Ensure levels are numeric to sort correctly on the X-axis
    row_label = factor(row_count,
                       levels = 10^(2:9),
                       labels = c("100", "1K", "10K", "100K", "1M", "10M",
                                  "100M", "1B"))
  )

# 2. Render the Boxplot
plot_performance <- ggplot(plot_df, aes(x = row_label, y = seconds)) +
  # Using DfE Blue for consistency
  geom_boxplot(fill = "#003078", outlier.color = "#d4351c", alpha = 0.6) +
  scale_y_log10(
    breaks = c(1, 10, 60, 600, 1800, 3600),
    labels = c("1s", "10s", "1m", "10m", "30m", "1h")
  ) +
  labs(
    title = "Performance Resiliency: 100 to 1 Billion Rows",
    subtitle = "Consistent scaling with high-volume variance reflecting network
    fault-tolerance",
    x = "Number of Rows",
    y = "Execution Time (Log Scale)"
  ) +
  theme_bw() +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold")
  )

print(plot_performance)

