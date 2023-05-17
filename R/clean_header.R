#' Clean multiline column headers
#'
#' All destatis table come with multiline headers.
#' This function tries to get them in a machine readable form by building new column names.
#' It takes into account that all column names must be unique. So duplicate column names will be marked with the index.
#' Non-character parts like `(%)` or `=100` will be replaced.
#'
#' @param df dataframe
#' @return dataframe
#' @importFrom purrr map
#' @importFrom purrr pmap
#' @importFrom dplyr filter
#' @importFrom dplyr slice
#' @importFrom dplyr row_number
#' @importFrom stringr str_replace_all
#' @importFrom magrittr %>%
#' @importFrom utils head
#' @importFrom utils tail
#' @export


clean_header <- function(df) {

  first_col <- head(colnames(df), n = 1)

  header <- df %>% dplyr::filter(row_number() < which.min(is.na(!!as.name(first_col))))
  df <- df %>% dplyr::filter(row_number() >= which.min(is.na(!!as.name(first_col))))

  list_colnames <- purrr::map(1:nrow(header), function(i) {
    header %>%
      dplyr::filter(dplyr::row_number() == i) %>%
      #dplyr::slice(.) %>%
      c(., recursive=TRUE) %>%
      unname()
  })

  # build columns names from mult-line header names
  # depending on the number of rows
  if (length(list_colnames) == 1) {
    column_names <-purrr::map(1:lengths(list_colnames), function(i){
      paste(list_colnames[[1]][[i]], sep = "_")
    }) %>% tolower()
  } else if (length(list_colnames) == 2) {
    column_names <-purrr::map(1:lengths(list_colnames), function(i){
      paste(list_colnames[[1]][[i]], list_colnames[[2]][[i]], sep = "_")
    }) %>% tolower()
  } else if (length(list_colnames) == 3) {
    column_names <- purrr::map(1:lengths(list_colnames), function(i){
      paste(list_colnames[[1]][[i]], list_colnames[[2]][[i]], list_colnames[[3]][[i]], sep = "_")
    }) %>% tolower()
  } else if (length(list_colnames) == 4) {
    column_names <- purrr::map(1:lengths(list_colnames), function(i){
      paste(list_colnames[[1]][[i]], list_colnames[[2]][[i]], list_colnames[[3]][[i]], list_colnames[[4]][[i]], sep = "_")
    }) %>% tolower()
  } else {
    column_names <- purrr::map(1:lengths(list_colnames), function(i){
      paste(list_colnames[[1]][[i]], list_colnames[[2]][[i]], list_colnames[[3]][[i]], list_colnames[[4]][[i]], list_colnames[[5]][[i]], sep = "_")
    }) %>% tolower()
  }

  # create new column names taking into account duplicate names
  # if there are duplicated, rename them by pasting the column index to the name
  args <- list(column_names, duplicated(column_names), 1:length(column_names))

  column_names <- purrr::pmap(args, function(colume_name, duplicate, length){
    if(duplicate == TRUE) {
      colume_name <- paste0(colume_name, length)
    } else {colume_name}
  }) %>%
    unlist() %>%
    stringr::str_replace_all("\\s", "_") %>%
    stringr::str_replace_all("\\(%\\)", "pct") %>%
    stringr::str_replace_all("\\=", "_index_")

  names(df) <- column_names

  return(df)

}
