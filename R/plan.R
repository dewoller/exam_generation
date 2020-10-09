#https://github.com/dewoller/exam_generation/blob/master/output/exam_2020_answers_sheet_0.xlsx?raw=true
link='https://github.com/dewoller/exam_generation/blob/master/output/exam_2020_answers_sheet_0.xlsx?raw=true'
the_plan <-
  drake_plan(

             df_mbs = read_mbs(1),
             df_pbs = read_pbs(1),

             results = generate_sheets(df_mbs, df_pbs, 300),

             links = map_chr(results, function(file) {
                           glue::glue( r"(https://github.com/dewoller/exam_generation/blob/master/{file}?raw=true)")
              }),

             gift_links = generate_gift(  links) ,
             gift_links_f = write_file( gift_links, 'output/gift.txt'),

             fields=read_csv(file_in('data/fields.csv')),
             giftf= generate_gift_fields(fields,  5,200),

             scenarios=read_xlsx(file_in('data/er_scenario.xlsx'))
             ,
             gift_scenario_f= generate_gift_scenario(scenarios)
             ,








0
)
