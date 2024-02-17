as_frame <- function(jsonf) {
  jsonf |>
    jsonlite::read_json() |>
    purrr::map(dplyr::bind_cols) |>
    dplyr::bind_rows()
}

my_frames <- function() {

  datasets <-
    c("reviews", "products", "prices")

  datasets |>
    sprintf(fmt = "%s.json") |>
    purrr::map(as_frame) |>
    setNames(datasets)

}

robust_data <- function(n = 1e4) {

  dummy <- my_frames()

  reviews <-
    tibble::tibble(
      productId = uuid::UUIDgenerate(n = n),
      rating = sample(1:5, size = n, replace = TRUE),
      comment = sample(unique(dummy$reviews$comment), size = n, replace = TRUE),
      commenter = sample(unique(dummy$reviews$commenter), size = n, replace = TRUE)
    )

  products <-
    tibble::tibble(
      productId = reviews$productId,
      manufacturer = paste("Corp", order(rnorm(n = n))),
      model = paste("Model", order(rnorm(n = n)))
    )

  prices <-
    tibble::tibble(
      productId = reviews$productId,
      price = as.character(sample(1:100, n, replace = TRUE))
    )

  list(
    reviews = reviews,
    products = products,
    prices = prices
  )
}

create_sqlite_db <- function(data, dest) {

  if (file.exists(dest)) {
    warning("Deleting ", dest, " since it already exists...")
    unlink(dest)
  }

  con <- RSQLite::dbConnect(RSQLite::SQLite(), dest)
  on.exit(DBI::dbDisconnect(con))

  write_tbl <- function(tbl_name, tbl_frame)
    DBI::dbWriteTable(con, tbl_name, tbl_frame)

  is_written <-
    purrr::map2_lgl(names(data), data, write_tbl) |>
    all()

  if (is_written)
    message("Wrote database ", dest)

}

robust_data(n = 1e4) |>
  create_sqlite_db("synth.db")

