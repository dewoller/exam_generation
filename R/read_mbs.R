

read_mbs =  function( generation ) {

  # loads the PostgreSQL driver
  con <- dbConnect(dbDriver("PostgreSQL"), dbname = 'pbs_sample',
                   host = "himsql7.latrobe.edu.au", port = 5432,
                   user = "dewollershei-test", password = 'healthGuru' )


  query <- "
  SELECT pin, m.feecharged, m.schedfee, m.item,  m.service_date, d.description, p.sex, p.yob
  FROM mbs m
  JOIN mbs_desc_latest d USING (item)
  JOIN patient p USING (pin)
  where item in  ('42701', '06852', '42704', '51315', '51318', '42704', '42698', '06848', '42702');
  "
  #
  cataract_pbs <- dbGetQuery( con, query ) %>% as_tibble()
  #
  dbDisconnect(con)

  cataract_pbs





}
