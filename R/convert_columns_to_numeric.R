#' Converts specific columns to numeric.
#'
#' At first, all imported columns are characters/strings. But of cource, most data in the columns
#' are numeric values. This function makes an educated guess to find all columns that contain
#' numeric values.
#'
#' This is done in several steps:
#' - make all values to label missing values NA
#' - set decimal marks to .
#' - guess which colums should be numeric by setting as.numeric if there are no [A-z] characters in the column
#' @param df dataframe
#' @return dataframe
#' @importFrom purrr map_df
#' @importFrom dplyr mutate_if
#' @importFrom magrittr %>%
#' @export



convert_columns_to_numeric <- function(df) {
  df <- df %>%
    purrr::map_df(~gsub("^\\.$|^-$|^x$|^/$|^\\.\\.\\.$", "", .)) %>%
    purrr::map_df(~gsub("^\\+", "", .)) %>%
    purrr::map_df(~gsub(",", "\\.", .)) %>%
    # if there are characters or a date (daily, monthly), then do not convert to numeric
    dplyr::mutate_if(~all(!grepl("[A-z]|[0-9]{1,2}\\.[0-9]{1,2}\\.[0-9]{4}|\\/", .)), as.numeric)
  return(df)
}
