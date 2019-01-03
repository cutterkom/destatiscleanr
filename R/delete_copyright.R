#' Delete copyright and metadata information
#'
#' Copyright information and metadata is positioned at the end of the file.
#' It will be detected and replaced by looking for the first row of the last/right column that is empty.
#'
#' @param df dataframe
#' @return dataframe
#' @importFrom dplyr filter
#' @importFrom magrittr %>%
#' @export



delete_copyright <- function(df) {

  # get last column
  last_col <- tail(colnames(df), n = 1)

  # filtering everything that has != "" by using the last column and the as.name() function in order to get it working withing filter()
  df <- df %>% dplyr::filter((!!as.name(last_col)) != "")

  return(df)
}
