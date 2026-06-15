#!/usr/bin/env Rscript

source_root <- normalizePath(".", winslash = "/", mustWork = TRUE)

p <- function(...) {
  file.path(..., fsep = "/")
}

is_file <- function(path) {
  file.exists(path) && !dir.exists(path)
}

dir_create <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
}

write_lines <- function(path, lines) {
  dir_create(dirname(path))
  writeLines(lines, path)
}

read_simple_manifest <- function(path) {
  lines <- readLines(path, warn = FALSE)
  lines <- sub("[[:space:]]+#.*$", "", lines)
  lines <- lines[nzchar(trimws(lines))]

  out <- list()
  current_key <- NULL

  for (line in lines) {
    if (grepl("^[^[:space:]][^:]+:[[:space:]]*.*$", line)) {
      parts <- strsplit(line, ":", fixed = TRUE)[[1]]
      key <- trimws(parts[[1]])
      value <- trimws(paste(parts[-1], collapse = ":"))
      current_key <- key

      if (nzchar(value)) {
        out[[key]] <- value
      } else {
        out[[key]] <- character()
      }
    } else if (grepl("^[[:space:]]+-[[:space:]]+", line) && !is.null(current_key)) {
      value <- trimws(sub("^[[:space:]]+-[[:space:]]+", "", line))
      out[[current_key]] <- c(out[[current_key]], value)
    }
  }

  out
}

copy_file <- function(from, to) {
  if (!is_file(from)) {
    stop("Missing source file: ", from, call. = FALSE)
  }

  dir_create(dirname(to))
  ok <- file.copy(from, to, overwrite = TRUE, copy.date = TRUE)

  if (!ok) {
    stop("Failed to copy ", from, " to ", to, call. = FALSE)
  }

  invisible(TRUE)
}

copy_optional_file <- function(from, to) {
  if (is_file(from)) {
    copy_file(from, to)
  }
}

copy_clean_dir <- function(from, to, include = function(path) TRUE) {
  if (!dir.exists(from)) {
    return(invisible(FALSE))
  }

  files <- list.files(from, recursive = TRUE, full.names = TRUE, all.files = TRUE, no.. = TRUE)
  files <- files[!dir.exists(files)]
  files <- files[vapply(files, include, logical(1))]

  for (file in files) {
    relative <- substring(file, nchar(from) + 2)
    copy_file(file, p(to, relative))
  }

  invisible(TRUE)
}

source_qmd_path <- function(path) {
  source_path <- sub("[.]html$", ".qmd", path)

  if (path %in% c("syllabus.html", "git-workflow.html")) {
    source_path <- p("docs", source_path)
  }

  source_path
}

render_html_path <- function(path) {
  source_path <- source_qmd_path(path)
  source_file <- p(source_root, source_path)

  if (!is_file(source_file)) {
    stop("Missing source file for rendered output ", path, ": ", source_path, call. = FALSE)
  }

  path_parts <- strsplit(path, "/", fixed = TRUE)[[1]]
  top_level <- path_parts[[1]]

  output_dir <- if (top_level %in% c("assignments", "modules", "slides")) {
    p(target_root, top_level)
  } else {
    dirname(p(target_root, path))
  }

  if (identical(output_dir, ".")) {
    output_dir <- target_root
  }

  dir_create(output_dir)
  status <- system2(
    "quarto",
    c("render", source_file, "--output-dir", output_dir),
    stdout = "",
    stderr = ""
  )

  if (!identical(status, 0L)) {
    stop("Failed to render ", source_path, call. = FALSE)
  }

  if (!is_file(p(target_root, path))) {
    stop("Render completed but expected output is missing: ", path, call. = FALSE)
  }
}

copy_data_path <- function(path) {
  copy_file(p(source_root, "data", path), p(target_root, "data", path))
}

copy_manifest_entry <- function(source_base, target_base, relative_path, include = function(path) TRUE) {
  from <- p(source_base, relative_path)
  to <- p(target_base, relative_path)

  if (dir.exists(from)) {
    copy_clean_dir(from, to, include = include)
  } else if (is_file(from)) {
    copy_file(from, to)
  } else {
    stop("Missing export entry: ", from, call. = FALSE)
  }
}

validate_manifest_paths <- function(paths, should_exist) {
  if (is.null(paths) || length(paths) == 0) {
    return(invisible(NULL))
  }

  full_paths <- p(target_root, paths)
  exists <- file.exists(full_paths)

  if (should_exist && any(!exists)) {
    stop(
      "Export validation failed. Missing expected file(s):\n",
      paste(paths[!exists], collapse = "\n"),
      call. = FALSE
    )
  }

  if (!should_exist && any(exists)) {
    stop(
      "Export validation failed. Unexpected file(s) exist:\n",
      paste(paths[exists], collapse = "\n"),
      call. = FALSE
    )
  }

  invisible(NULL)
}

html_files_in <- function(directory) {
  files <- list.files(p(source_root, directory), pattern = "[.]qmd$", recursive = TRUE, full.names = FALSE)
  p(directory, sub("[.]qmd$", ".html", files))
}

day_definitions <- list(
  preclass = list(
    docs = c(
      "index.html",
      "syllabus.html",
      "git-workflow.html",
      "assignments/problem-set-1-data-visualization.html",
      "assignments/problem-set-2-statistical-modeling.html",
      "assignments/final-project-simulated-data-workflow.html",
      "slides/01-session-1.html",
      "slides/02-session-2.html",
      "slides/03-session-3.html"
    ),
    data = c("manifest.csv"),
    data_dirs = character()
  ),
  `day-01` = list(
    docs = character(),
    data = c(
      "synthetic/simulated_maternal_health_data.csv",
      "simulated/prams_messy_for_cleaning.csv",
      "simulated/new_parent_wellness_survey.csv",
      "simulated/neighborhood_health_survey_analysis.csv",
      "simulated/county_wellness_indicators_long.csv",
      "codebooks/simulated_prams_messy_for_cleaning.md",
      "codebooks/simulated_new_parent_wellness_survey.md",
      "codebooks/simulated_neighborhood_health_survey_analysis.md",
      "codebooks/simulated_county_wellness_indicators_long.md"
    ),
    data_dirs = character()
  ),
  `day-02` = list(
    docs = character(),
    data = c(
      "simulated/prams_messy_for_cleaning.csv",
      "codebooks/simulated_prams_messy_for_cleaning.md"
    ),
    data_dirs = character()
  ),
  `day-03` = list(
    docs = character(),
    data = character(),
    data_dirs = c("real", "simulated", "codebooks")
  )
)

manifest_path <- p(source_root, "student_repo", "export-manifest.yml")

if (!is_file(manifest_path)) {
  stop("Missing student export manifest: student_repo/export-manifest.yml", call. = FALSE)
}

if (!is_file(p(source_root, "docs", "syllabus.qmd"))) {
  stop("Run this script from the AI course source repository root.", call. = FALSE)
}

export_manifest <- read_simple_manifest(manifest_path)
published_days <- export_manifest$published_days

if (is.null(published_days) || length(published_days) == 0 || "all" %in% published_days) {
  published_days <- names(day_definitions)
}

unknown_days <- setdiff(published_days, names(day_definitions))

if (length(unknown_days) > 0) {
  stop(
    "Unknown published day(s) in student_repo/export-manifest.yml: ",
    paste(unknown_days, collapse = ", "),
    call. = FALSE
  )
}

args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 1) {
  stop("Usage: Rscript scripts/build-student-repo.R [/path/to/student-repo]", call. = FALSE)
}

target_arg <- if (length(args) == 1) {
  args[[1]]
} else {
  export_manifest$target_root_default
}

if (is.null(target_arg) || !nzchar(target_arg)) {
  stop("Missing target_root_default in student_repo/export-manifest.yml", call. = FALSE)
}

target_root <- normalizePath(path.expand(target_arg), winslash = "/", mustWork = FALSE)

if (identical(target_root, source_root) || startsWith(target_root, paste0(source_root, "/"))) {
  stop("Choose a target outside the source repository.", call. = FALSE)
}

student_readme <- p(source_root, "student_repo", "README.md")

if (!is_file(student_readme)) {
  stop("Missing student README template: student_repo/README.md", call. = FALSE)
}

managed_paths <- c(
  "assignments",
  "data",
  "demos",
  "docs",
  "modules",
  "output",
  "practice",
  "skills",
  "slides",
  "index.qmd",
  "_quarto.yml",
  "scaffold.R",
  "settings.yml",
  "render.sh",
  "README.md",
  "index.html",
  "syllabus.html",
  "syllabus.pdf",
  "git-workflow.html",
  "course-project.html",
  "updater.R",
  ".gitignore",
  "ai-tools-course.Rproj",
  "ai-tools-course.code-workspace",
  "ai-tools-for-data-science-and-statistics.Rproj",
  "ai-tools-for-data-science-and-statistics.code-workspace"
)

dir_create(target_root)

for (path in managed_paths) {
  unlink(p(target_root, path), recursive = TRUE, force = TRUE)
}

copy_file(student_readme, p(target_root, "README.md"))
copy_file(p(source_root, "student_repo", "updater.R"), p(target_root, "updater.R"))

copy_optional_file(p(source_root, "ai-tools-course.Rproj"), p(target_root, "ai-tools-course.Rproj"))
copy_optional_file(p(source_root, "ai-tools-course.code-workspace"), p(target_root, "ai-tools-course.code-workspace"))

write_lines(p(target_root, "_quarto.yml"), c(
  "project:",
  "  type: default",
  "  execute-dir: project",
  "",
  "format:",
  "  html:",
  "    theme: cosmo",
  "    toc: true",
  "    toc-depth: 3",
  "    embed-resources: true",
  "    highlight-style: github"
))

published <- day_definitions[published_days]
docs_to_copy <- unique(unlist(lapply(published, `[[`, "docs"), use.names = FALSE))
data_to_copy <- unique(unlist(lapply(published, `[[`, "data"), use.names = FALSE))
data_dirs_to_copy <- unique(unlist(lapply(published, `[[`, "data_dirs"), use.names = FALSE))

for (path in docs_to_copy) {
  render_html_path(path)
}

for (path in data_to_copy) {
  copy_data_path(path)
}

for (directory in data_dirs_to_copy) {
  copy_clean_dir(p(source_root, "data", directory), p(target_root, "data", directory))
}

copy_clean_dir(
  p(source_root, "skills"),
  p(target_root, "skills")
)

practice_export <- read_simple_manifest(p(source_root, "practice", "export.yml"))
module_export <- read_simple_manifest(p(source_root, "modules", "export.yml"))

for (entry in practice_export$copy) {
  copy_manifest_entry(
    p(source_root, "practice"),
    p(target_root, "practice"),
    entry,
    include = function(path) {
      !grepl("/[.]quarto(/|$)", path)
    }
  )
}

for (entry in module_export$copy) {
  copy_manifest_entry(
    p(source_root, "modules"),
    p(target_root, "modules"),
    entry,
    include = function(path) {
      !grepl("/[.]quarto(/|$)", path)
    }
  )
}

write_lines(p(target_root, "practice", "work", ".gitkeep"), character())
write_lines(p(target_root, "practice", "work", "README.md"), c(
  "# Practice Work",
  "",
  "Create and save your own notebooks, scripts, rendered HTML files, and notes here.",
  "",
  "Files in this folder are ignored by Git so `git pull` can update course materials without overwriting your work.",
  "",
  "Use `practice/tasks/` as project folders and `practice/prompts/` for prompts and instructions.",
  "",
  "If you use R or RStudio, run `source(\"updater.R\")` from the course project root to update the course and copy missing task starter files into this folder.",
  "",
  "Do not save your work in course-owned folders such as `practice/tasks/`, `modules/`, `assignments/`, `skills/`, or `data/`. Those folders may change during updates."
))

write_lines(p(target_root, ".gitignore"), c(
  ".DS_Store",
  ".Rhistory",
  ".RData",
  ".Ruserdata",
  ".Rproj.user/",
  ".quarto/",
  "_freeze/",
  "*_cache/",
  "*_files/",
  "*.knit.md",
  "*.utf8.md",
  ".env",
  ".Renviron",
  "protected-local-changes/",
  "data/private/",
  "**/private/",
  "practice/*",
  "!practice/tasks/",
  "!practice/tasks/**",
  "!practice/prompts/",
  "!practice/prompts/**",
  "!practice/work/",
  "practice/work/*",
  "!practice/work/.gitkeep",
  "!practice/work/README.md"
))

validate_manifest_paths(export_manifest$must_exist_after_export, should_exist = TRUE)
validate_manifest_paths(export_manifest$must_not_exist_after_export, should_exist = FALSE)

message("Student repository built at: ", target_root)
message("Published days: ", paste(published_days, collapse = ", "))
