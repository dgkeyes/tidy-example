# Load Packages -----------------------------------------------------------

library(tidyverse)

# Import Data -------------------------------------------------------------

survey_data_raw <-
  read_csv("data-raw/survey_data_2023.csv")

import_demographics_data <- function(data_year) {
  read_csv(str_glue("data-raw/survey_data_{data_year}.csv")) |>
    select(respondent_id, location) |>
    separate_wider_delim(
      cols = location,
      delim = ", ",
      names = c("city", "state")
    ) |>
    mutate(year = data_year)
}

demographics_2024 <- import_demographics_data(data_year = 2024)
demographics_2023 <- import_demographics_data(data_year = 2023)
demographics_2022 <- import_demographics_data(data_year = 2022)

demographics <-
  bind_rows(
    demographics_2022,
    demographics_2023,
    demographics_2024
  )

demographics |>
  write_rds("data/demographics.rds")

read_csv(str_glue("data-raw/survey_data_2023.csv")) |>
  select(respondent_id, starts_with("pre"), starts_with("post")) |>
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


import_pre_post_data <- function(data_year) {
  read_csv(str_glue("data-raw/survey_data_{data_year}.csv")) |>
    select(respondent_id, starts_with("pre"), starts_with("post")) |>
    pivot_longer(
      cols = -respondent_id,
      values_to = "rating"
    ) |>
    separate_wider_delim(
      cols = name,
      delim = "_",
      names = c("timing", "question", "question_number")
    ) |>
    select(-question) |>
    mutate(year = data_year)
}

pre_post_data_2024 <- import_pre_post_data(data_year = 2024)
pre_post_data_2023 <- import_pre_post_data(data_year = 2023)
pre_post_data_2022 <- import_pre_post_data(data_year = 2022)
pre_post_data_2021 <- import_pre_post_data(data_year = 2021)

pre_post_data <-
  bind_rows(
    pre_post_data_2021,
    pre_post_data_2022,
    pre_post_data_2023,
    pre_post_data_2024
  )


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
