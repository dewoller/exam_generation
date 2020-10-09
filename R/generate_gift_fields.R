
#// question: 18830891  name: ACAS Status
#::ACAS Status::You have been assigned the following VAED database field\: <br />\n<h3>ACAS Status <br /></h3>\nEnter the field specific answers in the space below.{}

#link = links[1]
#header=''

#do_one(link)


generate_one_question_set = function( field_set) {

  nfields = length(field_set)
  question_text = '

$CATEGORY: $course$/top/Exam_Field

// question_{field_id}
::exam_file_{field_id}::  <p/><p/><h3>Informatics B final Exam - Field Assignment</h3>
<hr><br><br>
The following is a list of {nfields} fields that you have been assigned.
Copy these fields into your Final Exam Questions Document.,
and answer questions there related to this set of fields.<p/>
<hr><br><br>
<h3>Fields </h3>
<ol>
{field_txt}
</ol>
<hr><br><br>
Did you copy your assigned fields to the Final Exam Questions Document?
{{=Yes
#Good
-No
#You are going to want to do that
}}

'

field_set %>%
    str_replace_all('[ ]','_') %>%
    sort() %>%
    paste0(collapse='^') %>%
    { . } -> field_id

  field_set %>%
  map_chr( function(x) {glue::glue('<li>{x}</li>') } ) %>%
    paste0(collapse='\n')  %>%
    { . } -> field_txt

  glue::glue(question_text)

}
#
# fields=sample( letters, 10)
# nsets=10
# nfields=5
# field_set = df_samples[[1]][1]
#
generate_gift_fields <- function( fields, nfields, nsets ) {



seq(1,nsets) %>%
  enframe(name=NULL, value='set_id') %>%
  rowwise() %>%
  mutate( topics=purrr::map( set_id, function(x) { sample_n( fields, nfields, replace=TRUE ) %>%
                           pluck(1)})) %>%
  mutate( result = generate_one_question_set( topics) ) %>%
  pluck('result') %>%
  paste0( collapse='\n\n') %>%
  write_file('output/gift1.txt')


}

