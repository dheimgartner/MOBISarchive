#' Establish connection to MOBIS db
#'
#' Returned object can then be passed to `DBI` functions.
#'
#' @export
con <- function(user = "mobis") {
  tryCatch(
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      dbname = "mobis_study",
      host = "id-hdb-psgr-cp50.ethz.ch",
      user = user,
      port = 5432
    ),
    error = function(e) stop("Do you have a .pgpass file?")
  )

  con
}
