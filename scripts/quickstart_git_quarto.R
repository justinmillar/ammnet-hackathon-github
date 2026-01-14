## Quickstart helper for the live session
## Includes Git/GitHub setup steps and the mini-case analysis.

# Git/GitHub setup -------------------------------------------------------

# Check Git setup inside RStudio
# usethis::git_sitrep()

# Create or refresh a GitHub token
# usethis::gh_token_help()

# Confirm stored credentials
# gitcreds::gitcreds_get()

# Optional: set Git username and email
# usethis::use_git_config(
#   user.name = "Your Name",
#   user.email = "your_email@example.com"
# )

# Mini-case analysis -----------------------------------------------------

packages <- c("readr", "dplyr", "ggplot2", "plotly")
to_install <- packages[!packages %in% rownames(installed.packages())]
if (length(to_install) > 0) {
  install.packages(to_install)
}

library(readr)
library(dplyr)
library(ggplot2)
library(plotly)

if (!file.exists("data/malaria_routine_data.csv")) {
  if (file.exists("07_github/generate_malaria_example.R")) {
    source("07_github/generate_malaria_example.R")
  } else if (file.exists("generate_malaria_example.R")) {
    source("generate_malaria_example.R")
  }
}

case_data <- read_csv("data/malaria_routine_data.csv")

case_summary <- case_data %>%
  mutate(positivity = positive_tests / tests_done) %>%
  group_by(district) %>%
  summarise(
    total_cases = sum(suspected_cases),
    mean_positivity = mean(positivity)
  ) %>%
  arrange(desc(total_cases))

case_summary

ggplot(case_data, aes(month, suspected_cases, color = district)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    title = "Suspected malaria cases by district",
    x = "Month",
    y = "Suspected cases"
  ) +
  theme_minimal()

interactive_plot <- ggplot(case_data, aes(month, suspected_cases, color = district)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    title = "Suspected malaria cases by district (interactive)",
    x = "Month",
    y = "Suspected cases"
  ) +
  theme_minimal()

plotly::ggplotly(interactive_plot)
