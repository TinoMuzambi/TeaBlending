#!/usr/bin/env Rscript

# Parse every R chunk and inline expression without installing report packages.
report <- "tea_blending_optimization.Rmd"
lines <- readLines(report, warn = FALSE, encoding = "UTF-8")
errors <- character()

fail <- function(message) {
  errors <<- c(errors, message)
}

if (length(lines) < 3 || trimws(lines[[1]]) != "---") {
  fail("R Markdown must begin with YAML front matter.")
  yaml_end <- integer()
} else {
  yaml_end <- which(trimws(lines[-1]) == "---")[1] + 1
  if (is.na(yaml_end)) {
    fail("YAML front matter is not closed.")
    yaml_end <- integer()
  }
}

if (length(yaml_end)) {
  yaml <- lines[2:(yaml_end - 1)]
  for (field in c("title:", "bibliography:", "csl:", "output:")) {
    if (!any(startsWith(trimws(yaml), field))) {
      fail(sprintf("YAML front matter is missing %s", field))
    }
  }

  referenced_files <- sub(
    "^[^:]+:[[:space:]]*", "",
    grep("^[[:space:]]*(bibliography|csl):", yaml, value = TRUE)
  )
  referenced_files <- gsub("^[\"']|[\"']$", "", trimws(referenced_files))
  for (path in referenced_files) {
    if (!nzchar(path) || !file.exists(path)) {
      fail(sprintf("Referenced metadata file does not exist: %s", path))
    }
  }
}

chunk_starts <- grep("^[[:space:]]*```\\{r([,[:space:]}])", lines)
chunk_labels <- character()
cursor <- 1

for (start in chunk_starts) {
  if (start < cursor) {
    next
  }
  relative_end <- which(trimws(lines[(start + 1):length(lines)]) == "```")[1]
  if (is.na(relative_end)) {
    fail(sprintf("R chunk beginning on line %d is not closed.", start))
    next
  }
  end <- start + relative_end
  cursor <- end + 1

  header <- sub("^[[:space:]]*```\\{r[[:space:]]*", "", lines[[start]])
  header <- sub("\\}[[:space:]]*$", "", header)
  label <- trimws(strsplit(header, ",", fixed = TRUE)[[1]][1])
  if (nzchar(label)) {
    if (label %in% chunk_labels) {
      fail(sprintf("Duplicate R chunk label '%s' on line %d.", label, start))
    }
    chunk_labels <- c(chunk_labels, label)
  }

  code <- if (end > start + 1) lines[(start + 1):(end - 1)] else character()
  tryCatch(
    parse(text = code, keep.source = TRUE),
    error = function(error) {
      fail(sprintf("R syntax error in chunk '%s' near line %d: %s",
                   ifelse(nzchar(label), label, "<unnamed>"), start, error$message))
    }
  )
}

inline_matches <- gregexpr("`r[[:space:]]+[^`]+`", lines, perl = TRUE)
for (line_number in seq_along(lines)) {
  matches <- regmatches(lines[[line_number]], inline_matches[[line_number]])
  for (expression in matches) {
    expression <- sub("^`r[[:space:]]+", "", expression)
    expression <- sub("`$", "", expression)
    tryCatch(
      parse(text = expression),
      error = function(error) {
        fail(sprintf("Inline R syntax error on line %d: %s", line_number, error$message))
      }
    )
  }
}

bibliography <- readLines("references.bib", warn = FALSE, encoding = "UTF-8")
bib_keys <- sub(
  "^@[^{]+\\{([^,]+),.*$", "\\1",
  grep("^@[^{]+\\{[^,]+,", bibliography, value = TRUE)
)
citations <- unique(unlist(regmatches(
  lines,
  gregexpr("(?<![[:alnum:]_.-])@[[:alnum:]_.:-]+", lines, perl = TRUE)
)))
citations <- sub("^@", "", citations)
missing_citations <- setdiff(citations, bib_keys)
if (length(missing_citations)) {
  fail(sprintf("Missing bibliography entries: %s", paste(missing_citations, collapse = ", ")))
}

if (!any(grepl("set\\.seed[[:space:]]*\\(", lines))) {
  fail("The report must set an explicit random seed.")
}

generated <- list.files(pattern = "\\.(html|pdf|docx)$", ignore.case = TRUE)
if (length(generated)) {
  fail(sprintf("Generated report files should not be committed: %s",
               paste(generated, collapse = ", ")))
}

if (length(errors)) {
  writeLines(paste("ERROR:", errors), con = stderr())
  quit(status = 1)
}

cat(sprintf(
  "Validated %d R chunks, %d unique labels, metadata files, citations, and inline R syntax.\n",
  length(chunk_starts), length(chunk_labels)
))
