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
  dir_create(dirname(to))
  ok <- file.copy(from, to, overwrite = TRUE, copy.date = TRUE)

  if (!ok) {
    stop("Failed to copy ", from, " to ", to, call. = FALSE)
  }
}

write_lines <- function(path, lines) {
  dir_create(dirname(path))
  writeLines(lines, path)
}

skip_names <- c(
  ".DS_Store",
  ".git",
  ".quarto",
  ".Rproj.user",
  ".claude",
  ".artifacts",
  "_freeze",
  "private",
  "planning",
  "teaching-scratch",
  "util_docs"
)

should_skip <- function(path) {
  name <- basename(path)

  name %in% skip_names ||
    grepl("_cache$", name) ||
    grepl("_files$", name) ||
    grepl("[.]knit[.]md$", name) ||
    grepl("[.]utf8[.]md$", name) ||
    grepl("^framework[.]db", name)
}

copy_clean_dir <- function(from, to) {
  if (!dir.exists(from)) {
    return(invisible(FALSE))
  }

  dir_create(to)
  entries <- list.files(from, all.files = TRUE, no.. = TRUE, full.names = TRUE)
  entries <- entries[!vapply(entries, should_skip, logical(1))]

  for (entry in entries) {
    destination <- p(to, basename(entry))

    if (dir.exists(entry)) {
      copy_clean_dir(entry, destination)
    } else {
      copy_file(entry, destination)
    }
  }

  invisible(TRUE)
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

write_student_gitignore <- function(path) {
  write_lines(path, c(
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
    "data/private/",
    "**/private/",
    "practice/work/*",
    "!practice/work/",
    "!practice/work/README.md"
  ))
}

write_practice_readme <- function() {
  write_lines(p(target_root, "practice", "work", "README.md"), c(
    "# Practice Work",
    "",
    "Save your own notebooks, scripts, and notes here.",
    "",
    "Course updates should not overwrite files in this folder."
  ))
}

manifest_path <- p(source_root, "student_repo", "export-manifest.yml")

if (!is_file(manifest_path)) {
  stop("Missing student export manifest: student_repo/export-manifest.yml", call. = FALSE)
}

if (!is_file(p(source_root, "course_docs", "syllabus.qmd"))) {
  stop("Run this script from the AI course source repository root.", call. = FALSE)
}

export_manifest <- read_simple_manifest(manifest_path)
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
student_updater <- p(source_root, "student_repo", "updater.R")

if (!is_file(student_readme)) {
  stop("Missing student README template: student_repo/README.md", call. = FALSE)
}

if (!is_file(student_updater)) {
  stop("Missing student updater script: student_repo/updater.R", call. = FALSE)
}

managed_paths <- c(
  "assignments",
  "course_docs",
  "data",
  "demos",
  "docs",
  "modules",
  "output",
  "slides",
  "index.qmd",
  "_quarto.yml",
  "scaffold.R",
  "settings.yml",
  "render.sh",
  "README.md",
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
copy_file(student_updater, p(target_root, "updater.R"))
write_student_gitignore(p(target_root, ".gitignore"))

root_files <- c(
  "_quarto.yml",
  "index.qmd",
  "scaffold.R",
  "settings.yml",
  "render.sh",
  "ai-tools-course.Rproj",
  "ai-tools-course.code-workspace"
)

for (file in root_files) {
  source_file <- p(source_root, file)
  if (is_file(source_file)) {
    copy_file(source_file, p(target_root, file))
  }
}

for (directory in c("assignments", "course_docs", "data", "demos", "docs", "modules", "output", "slides")) {
  copy_clean_dir(p(source_root, directory), p(target_root, directory))
}

write_practice_readme()

validate_manifest_paths(export_manifest$must_exist_after_export, should_exist = TRUE)
validate_manifest_paths(export_manifest$must_not_exist_after_export, should_exist = FALSE)

message("Student repo exported to: ", target_root)
