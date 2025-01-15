## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----local connection, eval=FALSE---------------------------------------------
#  # Library calls ====
#  
#  library(odbc)
#  library(DBI)
#  
#  # Database connection ====
#  
#  con <- DBI::dbConnect(odbc::odbc(),
#    Driver = "ODBC Driver 17 for SQL Server",
#    Server = "server_name",
#    Database = "database_name",
#    UID = "",
#    PWD = "",
#    Trusted_Connection = "Yes"
#  )

## ----reading clean sql, eval=FALSE--------------------------------------------
#  sql_query <- dfeR::get_clean_sql("path_to_sql_file.sql")

## ----executing sql query, eval=FALSE------------------------------------------
#  sql_query_result <- DBI::dbGetQuery(con, statement = sql_query)

## ----executing sql query inline, eval=FALSE-----------------------------------
#  sql_query_result <- DBI::dbGetQuery(
#    con,
#    statement = "SELECT * FROM [my_database_table]"
#  )

## ----reading clean sql additional, eval=FALSE---------------------------------
#  sql_query <- dfeR::get_clean_sql(
#    "path_to_sql_file.sql",
#    additional_settings = TRUE
#  )

