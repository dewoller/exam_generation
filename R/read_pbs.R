



read_pbs =  function( generation ) {

  set.seed(123)
  read_xlsx('data/pbs_rr.xlsx') %>%
    select(pbs_code) %>%
    distinct() %>%
    slice_sample(n=50) %>%
    pluck(1) %>%
    paste0(., collapse="','") %>%
    paste0("('", ., "')") %>%
    { . } -> drugs

  # loads the PostgreSQL driver
  con <- dbConnect(dbDriver("PostgreSQL"), dbname = 'pbs_sample',
                   host = "himsql7.latrobe.edu.au", port = 5432,
                   user = "dewollershei-test", password = 'healthGuru' )

  metformin <-paste0("
  SELECT pin, supply_date, bnft_amt, pbs_item, sex, yob, drug_name, form_strength, atc_code, chronic_disease_category
  FROM pbs
  JOIN patient using (pin)
  JOIN pbs_item using (pbs_item)
  JOIN pbs_atc using (atc_code)
  JOIN chronic_disease using (chronic_disease_id)
  WHERE pbs_item IN  ", drugs )

  print(metformin)

  dbGetQuery(con, metformin) %>%
    as_tibble() %>%
    { . } -> pbs

  dbDisconnect(con)

  pbs
}
