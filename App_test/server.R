### chemical selection WEbApp

library(shiny)
library(DT)
library(stringr)
library(tidyr)
library(readxl)
library(dplyr)
library(stringi)
##import package msa
library(msa)

# Define server logic required to draw a histogram
shinyServer(function(input, output){
  

  
  # # Output Headers ----------------------------------------------------------
  # output$headers <- DT::renderDataTable({
  #   
  #   DT::datatable(Headers, filter = 'top',
  #                 options = list(
  #                   columnDefs = list(list(targets = c(1:ncol(Headers)), 
  #                                          searchable = T)),
  #                   pageLength = 100
  #                 )
  #   )
  # })
  # 
  # 
  # 
  # # import excel sheet - "Chemical Meta Info" ------------------------------------------------------
  # withProgress(message = "Loading chemical list", {
  #   chemical_list <- read_excel("/ptox_sftp_jail/chemical_selection/chemical_selection_stefanS/Chemical_list_07June2022.xlsx", 
  #                               sheet = "Chemical Meta Info", col_names = FALSE)
  #   colnames_row <- grep("index",chemical_list$...1)
  #   colnames(chemical_list) <- chemical_list[colnames_row,]
  #   chemical_list <- chemical_list[-(1:colnames_row),]
  #   invalid_characters <- 
  #     c("μ","[(]","[)]", "[{]","[}]", "\\[","\\]", "\\|", ":", ";", ",", 
  #       "\\.", "-", "\\*", "%", "/", "<", "[>]", "[$]", "[°]", "[?]", 
  #       "[&]", " ","\r", "\n","\r\n")
  #   
  # })
  # 
  # 
  # # replace multiple patterns in column names --------------------------------
  # colnames(chemical_list) <-  stri_replace_all_regex(colnames(chemical_list),
  #                                                    pattern=invalid_characters,
  #                                                    replacement=rep("",length(invalid_characters)),
  #                                                    vectorize=FALSE)
  # 
  # # render all fields as check boxes -----------------------------------------
  # # all_fields <- tbl(con, "pt_chemical") %>% colnames()
  # all_fields <- colnames(chemical_list)
  # print(all_fields)
  # choiceNames <- gsub("_"," ",all_fields)
  # output$select_fields <- renderUI({
  #   tagList(
  #     #hr(style = "border-top: 1px solid #000000;"),
  #     checkboxGroupInput(
  #       inputId = "selected_fields",
  #       label = "Select fields of interest",
  #       #choices = all_fields,
  #       selected = all_fields,
  #       inline = F,
  #       width = NULL,
  #       choiceNames = choiceNames,
  #       choiceValues = all_fields
  #     )
  #   )
  #   
  # })
  # 
  # # select/deselect all using action button -------------------------------
  # observe({
  #   if (input$selectall > 0) {
  #     if (input$selectall %% 2 == 0){
  #       updateCheckboxGroupInput(session=session, inputId="selected_fields",
  #                                label = "Select fields of interest",
  #                                choiceNames = choiceNames,
  #                                choiceValues = all_fields,
  #                                selected = all_fields)
  #       
  #     }
  #     else {
  #       updateCheckboxGroupInput(session=session, inputId="selected_fields",
  #                                label = "Select fields of interest",
  #                                choiceNames = choiceNames,
  #                                choiceValues = all_fields,
  #                                selected = NULL)
  #       
  #     }}
  # })
  # 
  # 
  # # render selected chemical list ---------------------------------------
  # output$search_res <- DT::renderDataTable({
  #   sel_fields <- input$selected_fields
  #   if(length(sel_fields)==0){
  #     sel_table <- NULL
  #   }else{
  #     # sel_table <- tbl(con, "pt_chemical") %>% 
  #     #     select(all_of(sel_fields)) %>%
  #     #     collect()
  #     
  #     sel_table <- chemical_list %>%
  #       select(all_of(sel_fields)) %>%
  #       collect()
  #     
  #     DT::datatable(sel_table, filter = 'top',
  #                   options = list(
  #                     columnDefs = list(list(targets = c(1:ncol(sel_table)), 
  #                                            searchable = T)),
  #                     scrollX = TRUE, scrollY = '900px',
  #                     pageLength = 100
  #                   )
  #     )
  #   }
  # })
  # 
  # # download data -------------------------------------------------------
  # output$dn_sel_chem_list <- downloadHandler(
  #   filename = function() {
  #     paste("pt_cehmcial_list_selected", ".csv", sep = "")
  #   },
  #   content = function(file) {
  #     write.csv(pt_chemical_list_res(), file, row.names = FALSE)
  #   }
  # )
  # output intro -----------------------------------------------------

  q_chem_res <- eventReactive(input$go, {
    
    file <- input$lib_seqs
    # ext <- tools::file_ext(file$datapath)
    # 
    # req(file)
    # validate(need(ext == "fasta", "Please upload a fasta file"))
    seq_result <- readDNAStringSet(file)
    seq_result
    
  })
  
  # output$chemInfo <- renderDT({
  #   
  #   t(q_chem_res())
  #   
  # })



})


