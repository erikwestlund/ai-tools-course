# Extract structural information from the real data.
# Run this in the real-data environment without AI assistance.

input_path <- "data/nhanes_2021_2023_analysis.csv"
output_dir <- "outputs"

if (!file.exists(input_path)) {
  stop("Missing input file: ", input_path, call. = FALSE)
}

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

data <- read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)

is_id_name <- function(name) {
  grepl("(^id$|_id$|identifier|record|participant|member|person)", name, ignore.case = TRUE)
}

infer_kind <- function(name, x) {
  non_missing <- x[!is.na(x)]

  if (is_id_name(name)) {
    return("identifier")
  }

  if (is.numeric(x) || is.integer(x)) {
    if (length(unique(non_missing)) <= 10) {
      return("categorical_numeric")
    }
    return("continuous")
  }

  if (is.logical(x) || is.factor(x)) {
    return("categorical")
  }

  if (is.character(x) && length(unique(non_missing)) > 30) {
    return("text_or_high_cardinality")
  }

  "categorical"
}

numeric_value <- function(x, fun) {
  non_missing <- x[!is.na(x)]
  if (!is.numeric(x) || length(non_missing) == 0) {
    return(NA_real_)
  }
  fun(non_missing)
}

dataset_info <- data.frame(
  file_name = basename(input_path),
  n_cases = nrow(data),
  n_variables = ncol(data),
  stringsAsFactors = FALSE
)

variable_info <- do.call(rbind, lapply(seq_along(data), function(i) {
  x <- data[[i]]
  data.frame(
    column_position = i,
    variable = names(data)[[i]],
    r_class = paste(class(x), collapse = ";"),
    inferred_kind = infer_kind(names(data)[[i]], x),
    n_missing = sum(is.na(x)),
    pct_missing = mean(is.na(x)),
    n_unique_non_missing = length(unique(x[!is.na(x)])),
    stringsAsFactors = FALSE
  )
}))

continuous_summary <- do.call(rbind, lapply(names(data), function(name) {
  x <- data[[name]]
  if (infer_kind(name, x) != "continuous") {
    return(data.frame())
  }

  data.frame(
    variable = name,
    min_value = numeric_value(x, min),
    q25_value = numeric_value(x, function(z) quantile(z, 0.25, names = FALSE)),
    median_value = numeric_value(x, median),
    mean_value = numeric_value(x, mean),
    q75_value = numeric_value(x, function(z) quantile(z, 0.75, names = FALSE)),
    max_value = numeric_value(x, max),
    sd_value = numeric_value(x, sd),
    stringsAsFactors = FALSE
  )
}))

categorical_distribution <- do.call(rbind, lapply(names(data), function(name) {
  x <- data[[name]]
  kind <- infer_kind(name, x)
  if (!(kind %in% c("categorical", "categorical_numeric"))) {
    return(data.frame())
  }

  non_missing <- as.character(x[!is.na(x)])
  counts <- table(non_missing)

  data.frame(
    variable = name,
    level = names(counts),
    count = as.integer(counts),
    proportion = as.numeric(counts) / length(non_missing),
    stringsAsFactors = FALSE
  )
}))

write.csv(dataset_info, file.path(output_dir, "dataset_info.csv"), row.names = FALSE)
write.csv(variable_info, file.path(output_dir, "variable_info.csv"), row.names = FALSE)
write.csv(continuous_summary, file.path(output_dir, "continuous_summary.csv"), row.names = FALSE)
write.csv(categorical_distribution, file.path(output_dir, "categorical_distribution.csv"), row.names = FALSE)

writeLines(
  c(
    "# Review Before Sharing",
    "",
    "These files are not automatically safe to share with AI tools.",
    "Review them for identifiers, free text, rare categories, small cells, exact dates, geography, or other disclosive values before copying anything to sim-data/metadata/."
  ),
  file.path(output_dir, "REVIEW_BEFORE_SHARING.md")
)

message("Wrote metadata files to ", output_dir)
