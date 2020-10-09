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


  df_mbs %>%
    distinct(pin, sex) %>%
    mutate( gender = ifelse(sex=='M',0,1) ) %>%
    mutate( ethnicity = sample(c(1:4,6),n(), replace=TRUE )) %>%
    mutate( name = randomNames(n(), gender, ethnicity)) %>%
    select(-ethnicity, -gender) %>%
    separate(name, c('Surname','Given_name'), sep=', ') %>%
    mutate(Given_name=str_trim(Given_name) ) %>%
    { . } -> customers


  df_pbs %>%
    distinct(pbs_item, drug_name, form_strength, atc_code) %>%
    rename("Drug Name"=drug_name) %>%
    rename("Form Strength"=form_strength) %>%
    rename("ATC Code"=atc_code) %>%
    { . } -> pbs_item

  df_pbs %>%
    select(-drug_name, -form_strength, -atc_code, -sex) %>%
    { . } -> df_pbs

  fs::dir_ls('output', glob='*.xlsx') %>%
    fs::file_delete()

  for (sheet in sheets) {
    print(sheet)

    gapminder %>%
      inner_join( years %>%
                 slice_sample(n=2), by='year') %>%
      { . } -> world_health

    # df_mbs %>%
    #   slice_sample(n=1000) %>%
    #   { . } -> mbs

    df_pbs %>%
         slice_sample(n=3000) %>%
      { . } -> pbs

    write.xlsx( list('world_health'=world_health,
                                     'pbs'=pbs,
                                     'pbs_item'=pbs_item
                                    # 'mbs'=mbs,
                                    # 'customers'=customers
                                     ), sheet)


  }

  sheets
}


