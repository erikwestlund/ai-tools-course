# Update course materials and seed practice tasks into your work folder.
#
# Run from the project root:
#   source("updater.R")
#
# What this does:
# 1. If this folder is a Git clone, protect and stash local tracked changes.
# 2. Run `git pull --ff-only` to update instructor-owned course files.
# 3. Copy missing files from practice/tasks/<task>/ to practice/work/<task>/.
# 4. Leave existing files in practice/work/ alone.
#
# Git updates instructor-owned course files. That means files in folders such as
# modules/, slides/, assignments/, data/, skills/, and practice/tasks/ may be
# added, changed, renamed, or removed. Your own practice files belong in
# practice/work/.

safe_path_from_status <- function(status_line) {
  path <- substring(status_line, 4)

  if (grepl(" -> ", path, fixed = TRUE)) {
    path <- sub("^.* -> ", "", path)
  }

  gsub("^\"|\"$", "", path)
}

copy_local_changes_to_backup <- function(project_root, status_lines, backup_dir) {
  files_dir <- file.path(backup_dir, "files")
  dir.create(files_dir, recursive = TRUE, showWarnings = FALSE)

  copied <- character()
  not_copied <- character()

  for (status_line in status_lines) {
    relative_path <- safe_path_from_status(status_line)

    if (!nzchar(relative_path) || grepl("^protected-local-changes/", relative_path)) {
      next
    }

    source_path <- file.path(project_root, relative_path)
    destination_path <- file.path(files_dir, relative_path)

    if (!file.exists(source_path)) {
      not_copied <- c(not_copied, paste(status_line, "(file not present to copy)"))
      next
    }

    dir.create(dirname(destination_path), recursive = TRUE, showWarnings = FALSE)

    if (dir.exists(source_path)) {
      ok <- file.copy(
        source_path,
        dirname(destination_path),
        overwrite = TRUE,
        recursive = TRUE,
        copy.date = TRUE
      )
    } else {
      ok <- file.copy(source_path, destination_path, overwrite = TRUE, copy.date = TRUE)
    }

    if (isTRUE(ok)) {
      copied <- c(copied, relative_path)
    } else {
      not_copied <- c(not_copied, paste(status_line, "(copy failed)"))
    }
  }

  writeLines(status_lines, file.path(backup_dir, "git-status-before-update.txt"))
  writeLines(
    c(
      "# Protected Local Changes",
      "",
      "This folder was created by updater.R before running git pull.",
      "It contains copies of local files that had Git changes before the update.",
      "The same changes were also saved in a Git stash.",
      "",
      "Copied files:",
      if (length(copied) > 0) paste0("- ", copied) else "- none",
      "",
      "Not copied:",
      if (length(not_copied) > 0) paste0("- ", not_copied) else "- none"
    ),
    file.path(backup_dir, "README.md")
  )

  invisible(list(copied = copied, not_copied = not_copied))
}

move_backup_into_project <- function(project_root, backup_dir, timestamp) {
  protected_parent <- file.path(project_root, "protected-local-changes")
  protected_dir <- file.path(protected_parent, timestamp)

  dir.create(protected_parent, recursive = TRUE, showWarnings = FALSE)

  moved <- file.rename(backup_dir, protected_dir)

  if (!isTRUE(moved)) {
    dir.create(protected_dir, recursive = TRUE, showWarnings = FALSE)
    copied <- file.copy(
      list.files(backup_dir, full.names = TRUE, all.files = TRUE, no.. = TRUE),
      protected_dir,
      recursive = TRUE,
      copy.date = TRUE
    )
    unlink(backup_dir, recursive = TRUE, force = TRUE)

    if (!all(copied)) {
      warning("Could not copy all protected local changes into ", protected_dir, call. = FALSE)
    }
  }

  protected_dir
}

protect_and_stash_local_changes <- function(project_root) {
  status_output <- suppressWarnings(system2(
    "git",
    c("status", "--porcelain"),
    stdout = TRUE,
    stderr = TRUE
  ))

  status <- attr(status_output, "status")
  if (!is.null(status) && !identical(status, 0L)) {
    cat(status_output, sep = "\n")
    stop("Could not check Git status before updating.", call. = FALSE)
  }

  status_lines <- status_output[nzchar(status_output)]
  status_lines <- status_lines[!grepl("^.. protected-local-changes/", status_lines)]

  if (length(status_lines) == 0) {
    return(invisible(NULL))
  }

  timestamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
  backup_dir <- file.path(tempdir(), paste0("course-local-changes-", timestamp))
  dir.create(backup_dir, recursive = TRUE, showWarnings = FALSE)

  copy_local_changes_to_backup(project_root, status_lines, backup_dir)

  message("Local changes detected before update.")
  message("Saving a backup copy and stashing changes before git pull...")

  stash_message <- paste("updater.R protected local changes", timestamp)
  stash_output <- suppressWarnings(system2(
    "git",
    c("stash", "push", "--include-untracked", "-m", stash_message),
    stdout = TRUE,
    stderr = TRUE
  ))
  stash_status <- attr(stash_output, "status")

  protected_dir <- move_backup_into_project(project_root, backup_dir, timestamp)

  if (!is.null(stash_status) && !identical(stash_status, 0L)) {
    cat(stash_output, sep = "\n")
    stop(
      "Git stash failed. Backup copies were saved in: ",
      protected_dir,
      call. = FALSE
    )
  }

  if (length(stash_output) > 0) {
    message(paste(stash_output, collapse = "\n"))
  }

  message("Backup copies saved in: ", protected_dir)
  message("Git stash also saved these changes. Use `git stash list` if an instructor asks you to recover them from Git.")

  invisible(protected_dir)
}

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

  protect_and_stash_local_changes(project_root)

  message("Updating instructor-owned course files with git pull --ff-only...")
  message("Files in practice/work/ are left alone by Git and by this script unless a file is missing.")

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

copy_practice_tasks_to_work <- function(overwrite = FALSE) {
  project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  tasks_dir <- file.path(project_root, "practice", "tasks")
  work_dir <- file.path(project_root, "practice", "work")

  if (!dir.exists(tasks_dir)) {
    stop("Could not find practice/tasks/. Are you running this from the course project root?", call. = FALSE)
  }

  dir.create(work_dir, recursive = TRUE, showWarnings = FALSE)

  task_dirs <- list.dirs(tasks_dir, recursive = FALSE, full.names = TRUE)
  task_dirs <- task_dirs[dir.exists(task_dirs)]

  copied <- character()
  skipped <- character()

  for (task_dir in task_dirs) {
    task_name <- basename(task_dir)
    task_files <- list.files(
      task_dir,
      recursive = TRUE,
      full.names = TRUE,
      all.files = TRUE,
      no.. = TRUE
    )
    task_files <- task_files[!dir.exists(task_files)]
    task_files <- task_files[!grepl("(^|/)\\.DS_Store$", task_files)]
    task_files <- task_files[!grepl("(^|/)\\.gitkeep$", task_files)]

    for (task_file in task_files) {
      relative_path <- file.path(task_name, substring(task_file, nchar(task_dir) + 2))
      destination <- file.path(work_dir, relative_path)

      if (file.exists(destination) && !overwrite) {
        skipped <- c(skipped, relative_path)
        next
      }

      dir.create(dirname(destination), recursive = TRUE, showWarnings = FALSE)
      ok <- file.copy(task_file, destination, overwrite = TRUE, copy.date = TRUE)

      if (isTRUE(ok)) {
        copied <- c(copied, relative_path)
      } else {
        warning("Could not copy ", relative_path, " to practice/work/", call. = FALSE)
      }
    }
  }

  message("Practice task seeding complete.")
  message("Copied new files: ", length(copied))
  message("Skipped existing files: ", length(skipped))

  if (length(copied) > 0) {
    message("\nNew files copied to practice/work/:")
    message(paste0("- ", copied, collapse = "\n"))
  }

  if (length(skipped) > 0) {
    message("\nExisting files were left alone:")
    message(paste0("- ", skipped, collapse = "\n"))
  }

  invisible(list(copied = copied, skipped = skipped))
}

project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)

run_git_pull(project_root)
copy_practice_tasks_to_work()
