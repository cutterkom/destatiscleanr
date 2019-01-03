#' This functions reads the csv file by using German decimal marks
#'
#' @param file path to the csv file, that should be cleaned
#' @return dataframe
#' @importFrom readr locale
#' @importFrom readr read_delim
#' @export

read_file <- function(file) {

  de_locale <- readr::locale("de", encoding = "latin1", decimal_mark = ",", grouping_mark = ".")

  df <- readr::read_delim(file,
                          delim = ";",
                          escape_double = FALSE,
                          trim_ws = TRUE,
                          skip = 1,
                          locale = de_locale)

  return(df)
}
