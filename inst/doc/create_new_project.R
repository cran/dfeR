## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----install_dfer, eval = FALSE-----------------------------------------------
# install.packages("dfeR")

## ----echo = FALSE, warning=FALSE, message=FALSE-------------------------------
library(knitr)
parameter_data <- data.frame(
  Parameter = c(
    "path",
    "init_renv",
    "include_structure_for_pkg",
    "create_publication_proj",
    "include_github_gitignore"
  ),
  Meaning = c(
    "Folder pathway",
    "Initiate renv in the project",
    "Additional folder for package development",
    "Create project with structure for publications",
    "Include a GitHub .gitignore file"
  ),
  Considerations = c(
    "Where do you want to store your project?",
    "Do you want to use renv for package version control?",
    "Are you creating this project to work on a package?",
    "Should the folder structure be for a publication project?",
    "Do you want to exclude certain files from being tracked by Git?"
  ),
  Output = c(
    "This will be the folder your new project is created within.",
    "If set to `TRUE`, renv will be initialised in your project.",
    "If set to `TRUE`, an extra package development folder will
be created",
    "If set to `TRUE`, extra publication specific folders will
be created",
    "If set to `TRUE`, a GitHub .gitignore file will be created."
  )
)


kable(
  parameter_data,
  format = "html",
  col.names = c(
    "Parameter", "Meaning",
    "Considerations", "Output"
  )
)

## ----create_project, eval = FALSE---------------------------------------------
# dfeR::create_project(
#   path = "C:/path/to/your/new/project",
#   init_renv = TRUE,
#   include_structure_for_pkg = FALSE,
#   create_publication_proj = FALSE,
#   include_github_gitignore = TRUE
# )

## ----function_example, eval = FALSE-------------------------------------------
# # Load the dfeR package
# library(dfeR)
# # Create a new project with the desired parameters
# dfeR::create_project(
#   path = "C:/Users/JBLOGGS/repos/my-new-project",
#   init_renv = TRUE,
#   include_structure_for_pkg = FALSE,
#   create_publication_proj = TRUE,
#   include_github_gitignore = TRUE
# )

## ----echo = FALSE, fig.alt = "'New Project Wizard' window with option to create dfeR project template open."----
knitr::include_graphics("../man/figures/project_wizard_screenshot.png")

