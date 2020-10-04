if (FALSE) {

generate_sheets(df_mbs, df_pbs, 1)

n_sheets=1

}


generate_sheets <- function( df_mbs, df_pbs, n_sheets) {

  set.seed(123)

  gapminder %>%
    distinct(year) %>%
    { . } -> years

  sheets = paste0('output/exam_2020_answers_sheet_', floor( runif(n_sheets ) * 1000 ), '.xlsx')

  df_pbs %>%
    distinct(pin, sex) %>%
    { . } -> ppin

  df_mbs %>%
    distinct(pin, sex) %>%
    bind_rows(ppin)  %>%
    distinct(pin, sex) %>%
    mutate( gender = ifelse(sex=='M',0,1) ) %>%
    mutate( ethnicity = sample(c(1:4,6),n(), replace=TRUE )) %>%
    mutate( name = randomNames(n(), gender, ethnicity)) %>%
    select(-ethnicity, -gender) %>%
    separate(name, c('Surname','Given_name'), sep=', ') %>%
    mutate(Given_name=str_trim(Given_name) ) %>%
    { . } -> customers




  for (sheet in sheets) {
    print(sheet)

    gapminder %>%
      inner_join( years %>%
                 slice_sample(n=2), by='year') %>%
      { . } -> world_health

    df_mbs %>%
      slice_sample(n=1000) %>%
      { . } -> mbs

    df_pbs %>%
         slice_sample(n=3000) %>%
      { . } -> pbs

    write.xlsx( list('world_health'=world_health,
                                     'mbs'=mbs,
                                     'pbs'=pbs,
                                     'customers'=customers), sheet)


  }

}


write_one_workbook = function( filename, ...) {
  browser()

    sheets <- c(as.list(environment()), list(...))
    sheets = sheets[-1]

    as.list(match.call()) %>%
      as.list() %>%
      map(as.character) %>%
      tail(-2) %>%
      purrr::flatten_chr() %>%
      { . } -> sheet_names

  # Write the first data set in a new workbook
  write.xlsx(sheets[[1]], file = filename,
             sheetName = sheet_names[[1]],
             append = FALSE, showNA=FALSE, row.names=FALSE)

  i=2

  for (i in 2:length(sheets)) {

    write.xlsx(sheets[[i]], file = filename,
               sheetName = sheet_names[[i]],
               append = TRUE, showNA=FALSE, row.names=FALSE
    )

  }



}

