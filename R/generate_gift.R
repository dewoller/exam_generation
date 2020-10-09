
#// question: 18830891  name: ACAS Status
#::ACAS Status::You have been assigned the following VAED database field\: <br />\n<h3>ACAS Status <br /></h3>\nEnter the field specific answers in the space below.{}

#link = links[1]
#header=''

#do_one(link)

do_one = function( link ) {

  link %>%
    str_extract('_\\d+\\.') %>%
    str_replace_all('[_.]','') %>%
    { . } -> number

  glue::glue("

$CATEGORY: $course$/top/Exam_Spreadsheets

// question_{number}
::exam_file_{number}::<p/><p/><h3>Informatics B final Exam - Individual Spreadsheet Download</h3>
<hr><br><br>
<h4><a href='{link}'>Click here to download your personalised exam spreadsheet file</a> </h4>
Instructions on how to use the spreadsheet are in the Final Exam Questions Document.
<hr><br><br>
Did you save your spreadsheet?
{{=Yes
#Good
-No
#You are going to want to do that
}}

             ")

}


generate_gift <- function( links ) {

map_chr(links, do_one ) %>%
  paste0(collapse='\n')


}

