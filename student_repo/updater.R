# Update course materials while preserving your practice work.
#
# Run from the project root:
#   source("updater.R")
#
# What this does:
# 1. If this folder is a Git clone, run `git pull --ff-only`.
# 2. Ensure practice/work/ exists.
# 3. Leave existing files in practice/work/ alone.

run_git_pull <- function(project_root) {
  git_available <- nzchar(Sys.which("git"))

  if (!git_available) {
    message("Git is not available on this computer. Skipping Git update.")
    return(invisible(FALSE))
  }

  inside_work_tree <- suppressWarnings(system2(
    "git",
    c("rev-parse", "--is-inside-work-tree"),
    stdout = TRUE,
    stderr = TRUE
  ))

  if (length(inside_work_tree) == 0 || !identical(trimws(inside_work_tree[[1]]), "true")) {
    message("This folder is not a Git clone. Skipping Git update.")
    return(invisible(FALSE))
  }

  message("Updating instructor-owned course files with git pull --ff-only...")
  message("Files in practice/work/ are left alone by this script.")

  output <- suppressWarnings(system2(
    "git",
    c("pull", "--ff-only"),
    stdout = TRUE,
    stderr = TRUE
  ))
  status <- attr(output, "status")

  if (!is.null(status) && !identical(status, 0L)) {
    cat(output, sep = "\n")
    stop(
      "Git update failed. Your practice/work files are safe, but ask for help before continuing.",
      call. = FALSE
    )
  }

  if (length(output) > 0) {
    message(paste(output, collapse = "\n"))
  }

  invisible(TRUE)
}

ensure_practice_work <- function(project_root) {
  work_dir <- file.path(project_root, "practice", "work")
  dir.create(work_dir, recursive = TRUE, showWarnings = FALSE)

  readme <- file.path(work_dir, "README.md")
  if (!file.exists(readme)) {
    writeLines(c(
      "# Practice Work",
      "",
      "Save your own notebooks, scripts, and notes here.",
      "",
      "Course updates should not overwrite files in this folder."
    ), readme)
  }

  invisible(work_dir)
}

project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)

run_git_pull(project_root)
ensure_practice_work(project_root)

message("Update complete.")
