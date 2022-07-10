### chemical selection WEbApp

library(shiny)
library(DT)
library(stringr)
library(tidyr)
library(readr)
library(shinythemes)

# Define UI for application

shinyUI(navbarPage("Mutation Library Analysis", id = "navbarTabs",
                   
                   tabPanel("Chemical list",
                            # 
                            # fluidPage(
                            #   fluidRow(
                            #     column(12,
                            #            #DTOutput('range_finding_report')
                            #            DT::dataTableOutput("range_finding_report")
                            #     )
                            #   )
                            # )
                            
                            
                            
                            fluidPage(#theme = shinytheme("flatly"),
                                
                                # Application title
                                titlePanel("Search"),
                                
                                sidebarLayout(
                                    sidebarPanel(
                                        width = 4,
                                        fileInput("lib_seqs", "Choose fasta File", accept = ".fasta"),
                                        fileInput("wt_seq", "Choose fasta File", accept = ".fasta"),
                                        actionButton(inputId = "go", label = "GO"),
                                        # actionButton("selectall", label="Select/Deselect all"),
                                        # uiOutput("select_fields")

                                    ),
                                    mainPanel(
                                        fluidRow(
                                            column(12,
                                                   DT::dataTableOutput("search_res"),
                                                   style = "height:900px;",
                                                   #style = "height:900px; overflow-y: scroll;overflow-x: scroll;"
                                                   # textOutput('fasta')
                                            )
                                        ),
                                        br(),
                                    )
                                )
                            )
                   ),
                   # tabPanel("Download",
                   #          # Button
                   #          downloadButton("dn_sel_chem_list",
                   #                         "Download selected chemical table"),
                   # ),
                   tabPanel("Headers",
                            fluidPage(
                                fluidRow(
                                    column(12,
                                           DT::dataTableOutput("headers"),
                                           style = "height:900px; overflow-y: scroll;overflow-x: scroll;"
                                    )
                                )
                            )
                   ),
                   tabPanel("Info",
                            fluidPage(
                                fluidRow(
                                    column(12,
                                           verbatimTextOutput("Intro"),
                                    )
                                )
                            )
                   ),
                   
                   position = c("static-top"),
                   # header = "Tag or list of tags to display as a common header above all tabPanels",
                   # footer = "Tag or list of tags to display as a common footer below all tabPanels",
                   inverse = F,
                   collapsible = F,
                   fluid = TRUE,
                   theme = shinytheme("flatly"), 
                   windowTitle = "Navbar page"
))
