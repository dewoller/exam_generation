


generate_one_scenario = function( name, scenario ) {

  name %>%
    str_replace_all(' ','_') %>%
    { . } -> scenario_id

  question_text = '

  $CATEGORY: $course$/top/Exam_scenario

  // question_{scenario_id}
  ::exam_file_{scenario_id}::  <p/><p/><h3>Informatics B final Exam - Database Scenario</h3>
  The following is a scenario that you have been randomly assigned.
Copy this scenario into your Final Exam Questions Document,
and answer questions in your exam related to this scenario.
<hr>
<h3>Scenario</h3>
{scenario}
<hr>
<br/>
<br/>
Did you copy your scenario to the Final Exam Questions Document?
{{=Yes
#Good
-No
#You are going to want to do that
}}

'



  glue::glue(question_text)

}
#
# fields=sample( letters, 10)
# nsets=10
# nfields=5
# field_set = df_samples[[1]][1]
#
generate_gift_scenario <- function(scenarios) {



scenarios %>%
  mutate( result = map2( name, scenario , generate_one_scenario )) %>%
  pluck('result') %>%
  paste0( collapse='\n\n') %>%
  write_file('output/gift_scenario.txt')


}

