library(shiny)

source('sourcedir.R')


getdrugenforcevars <- function()
{
    vars <- c(
      'other_submission_description',
      'res_event_number',
      'firm_fei_number',
      'k_numbers',
      'product_code',
      'root_cause_description',
      'pma_numbers',
      'event_date_terminated',
      'product_res_number',
      'openfda.device_name',
      'openfda.registration_number',
      'openfda.fei_number',
      'openfda.device_class',
      'openfda.medical_specialty_description',
      'openfda.regulation_number'
    )
  return(vars)
}

getapplicantvars <- function()
{
  vars <- c('third_party_flag',
            'city',
            'address_1',
            'address_2',
            'statement_or_summary',
            'zip_code',
            'applicant',
            'country_code',
            'contact',
            'state',
            'postal_code')
  return(vars)
}

getopenfdavars <- function()
{
  
  vars <- c('device_name',
            'registration_number',
            'fei_number',
            'device_class',
            'medical_specialty_description',
            'regulation_number')
  return(vars)
}

getallvars <- function()
{
  vars <- c( 'Any Variable', getdrugenforcevars() )
  return(vars)
}


rendercurrec <- function() { 
  
  uiOutput('currec') 
  
} 
renderrepportid <- function() { 
  
  uiOutput('reportid') 
  
} 

renderv1 <- function() { 
  
  ( htmlOutput('v1') )
  
} 
renderv2 <- function() { 
  
  ( htmlOutput('v2') )
  
}  
renderv3 <- function() { 
  
  ( htmlOutput( 'v3' ) )
  
} 
rendert1 <- function() { 
  
  ( htmlOutput('t1') )
  
} 
rendert2 <- function() { 
  
  ( htmlOutput('t2') )
  
}  
rendert3 <- function() { 
  
  ( htmlOutput( 't3' ) )
  
} 
shinyUI(fluidPage(
                  fluidRow(
                    column(width=4,
                           a(href='https://open.fda.gov', 
                             img(src='l_openFDA.png', align='bottom'))
                    ),
                    column(width=8,
                           titlePanel("Device Classification Browser" ) )
                  ),
  fluidRow(
    column(width=2, bsButton( 'prevrow', '< Previous Report', style = 'primary') ),
    column(width=2, htmlOutput("ptext") ),
    column(width=6, 
           strong( rendercurrec() ) ),
    column(width=2, htmlOutput("ntext") ),
    column(width=2, bsButton( 'nextrow', 'Next Report>', style = 'primary') )
  ),
  fluidRow(
    column(width=12, 
           wellPanel( 
             sliderInput('skip', 'Report #', value=1, min=1, step= 1, max=100, width='100%')
           )
    )
  ),
fluidRow(
  column(width=3,
         wellPanel( 
           bsButton("tabBut", "Filter by...", style='primary'),
           br(),
           renderv1(),
           rendert1(),
           conditionalPanel(
             condition = "1 == 2",
             selectizeInput('v1', 'Variable 1', getallvars() , width='100%', 
                            selected=getallvars()[1], options=list(create=TRUE, maxOptions=1000) ),
             textInput("t1", "Terms", '')
           )
           ,
           bsModal( 'modalExample1', "Enter Variables", "tabBut", size = "small",
                    htmlOutput('mymodal'), 
                    selectizeInput('v1_2', 'Variable 1', getallvars()  , width='100%', 
                                   selected=getallvars()[1], options=list(create=TRUE, maxOptions=1000) ),
                    textInput("t1_2", "Terms", ''),
                    selectizeInput('v2_2', 'Variable 2', getallvars()  , width='100%', 
                                   selected=getallvars()[2], options=list(create=TRUE, maxOptions=1000) ),
                    textInput("t2_2", "Terms", ''),
                    selectizeInput("v3_2", "Variable 3", getallvars()  , width='100%', 
                                   selected=getallvars()[1] , options=list(create=TRUE, maxOptions=1000) ), 
                    textInput("t3_2", "Terms", ''),
                    bsButton("update", "Update Variables", style='primary') )
         )
         ,
         wellPanel( 
           renderv2(),
           rendert2(),
           conditionalPanel(
             condition = "1 == 2",
             selectizeInput('v2', 'Variable 2', getallvars()  , width='100%', 
                            selected=getallvars()[1], options=list(create=TRUE, maxOptions=1000) ),
             textInput("t2", "Terms", '')
           )
         ),
         wellPanel( 
           renderv3(),
           rendert3(),
           conditionalPanel(
             condition = "1 == 2",
             selectizeInput("v3", "Variable 3", getallvars()  , width='100%', 
                            selected=getallvars()[1] , options=list(create=TRUE, maxOptions=1000) ), 
             textInput("t3", "Terms", '' )
           )
         ),
         bsAlert("alert")
  ),
  column(width=9, 
         bsAlert("alert2"),  
      tabsetPanel(
                tabPanel("Meta Data",  
                        
                         wellPanel( 
                           htmlOutput( 'querytitle' ), 
                           htmlOutput( 'metatext' ), 
                           htmlOutput( 'querytext' ), 
                           htmlOutput( 'json' )
                         )
                ),
                tabPanel("Classification Data",  
                         
                         wellPanel( 
                           htmlOutput('table1title'),
                           tableOutput( 'table1' ),
                           htmlOutput('table2title'),
                           tableOutput( 'table2' )
                         )
                ),
                tabPanel("Other Apps",  
                         wellPanel( 
                           htmlOutput( 'applinks' )
                         )
                ),
                tabPanel('Data Reference', 
                  HTML( renderiframe( "https://open.fda.gov/device/classification/") )  ),
                tabPanel('About', 
                         img(src='l_openFDA.png'),
                         HTML( (loadhelp('about') ) )  ),
              id='maintabs'
            )
        )
    )
  )
)