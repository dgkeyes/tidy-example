# TODO: make demographics data frame
# TODO: make function to import data
# TODO: show importing multiple years of data

# Load Packages -----------------------------------------------------------

library(tidyverse)


# Import Data -------------------------------------------------------------

survey_data_raw <-
  read_csv("data-raw/survey_data.csv")

pre_post_data <-
  survey_data_raw |>
  select(respondent_id, pre_question_1:post_question_2) |>
  pivot_longer(
    cols = -respondent_id,
    values_to = "rating"
  ) |>
  separate_wider_delim(
    cols = name,
    delim = "_",
    names = c("timing", "question", "question_number")
  ) |>
  select(-question)

pre_post_data |>
  write_rds("data/pre_post_data.rds")

favorite_parts <-
  survey_data_raw |>
  select(respondent_id, favorite_parts) |>
  separate_longer_delim(
    cols = favorite_parts,
    delim = ", "
  )

favorite_parts |>
  write_rds("data/favorite_parts.rds")
