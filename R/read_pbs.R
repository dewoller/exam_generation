



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

  metformin <-paste0('
  SELECT pin, supply_date as "Supply Date", pbs_item,pbs_rgltn24_adjst_qty as "Quantity",  bnft_amt as "Gov Amount", ptnt_cntrbtn_amt as "Patient Amount", ptnt_state as "Patient State", sex, drug_name, form_strength, atc_code
  FROM pbs
  JOIN patient using (pin)
  JOIN pbs_item using (pbs_item)
  JOIN pbs_atc using (atc_code)
  JOIN chronic_disease using (chronic_disease_id)
  WHERE pbs_item IN  ', drugs )

  dbGetQuery(con, metformin) %>%
    as_tibble() %>%
    { . } -> pbs


  dbDisconnect(con)

  pbs
}
