#' Import and clean data from official German statistical offices to jump-start the data analysis.
#'
#' This is the main function of the package destatiscleanr.
#' It calls four functions to read the file, delete copyright and metadata information,
#' cleans the column headers and converts certain columns to numeric.
#' @param file path to the csv file, that should be cleaned
#' @return dataframe
#' @examples
#' \dontrun{
#' destatiscleanr(file = "path/to/destatis_table.csv")
#' }
#' @export

destatiscleanr <- function(file) {
  df <- read_file(file)
  df <- delete_copyright(df)
  df <- clean_header(df)
  df <- convert_columns_to_numeric(df)
  return(df)
}
