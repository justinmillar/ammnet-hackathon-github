districts <- c(
  "Mansa",
  "Chipata",
  "Solwezi",
  "Kasama",
  "Mongu",
  "Choma"
)

months <- seq.Date(as.Date("2024-01-01"), as.Date("2024-12-01"), by = "month")

season_index <- c(1.20, 1.15, 1.08, 1.00, 0.92, 0.85, 0.80, 0.85, 0.95, 1.05, 1.12, 1.18)
district_effect <- c(1.08, 1.03, 0.95, 0.90, 1.00, 0.93)
district_population <- c(210000, 180000, 160000, 140000, 175000, 150000)
testing_rate <- c(0.85, 0.82, 0.78, 0.80, 0.83, 0.79)
positivity_base <- c(0.28, 0.24, 0.22, 0.20, 0.26, 0.21)

records <- expand.grid(
  district = districts,
  month = months
)

records$population <- district_population[match(records$district, districts)]
records$under5_population <- round(records$population * 0.18)

records$season_multiplier <- season_index[match(format(records$month, "%m"), sprintf("%02d", 1:12))]
records$district_multiplier <- district_effect[match(records$district, districts)]
records$testing_rate <- testing_rate[match(records$district, districts)]
records$positivity_base <- positivity_base[match(records$district, districts)]

baseline_cases <- round(
  0.0040 * records$population *
    records$season_multiplier *
    records$district_multiplier
)

records$suspected_cases <- pmax(baseline_cases, 0)

records$tests_done <- pmax(round(records$suspected_cases * records$testing_rate), 0)

positivity_rate <- pmin(
  pmax(records$positivity_base * records$season_multiplier, 0.12),
  0.65
)

records$positive_tests <- pmin(
  round(records$tests_done * positivity_rate),
  records$tests_done
)

records$rains_mm <- round(40 + (records$season_multiplier * 140), 1)

records <- records[, c(
  "district",
  "month",
  "population",
  "under5_population",
  "suspected_cases",
  "tests_done",
  "positive_tests",
  "rains_mm"
)]

output_path <- file.path("07_github", "malaria_routine_data.csv")
write.csv(records, output_path, row.names = FALSE)

message("Wrote example dataset to: ", normalizePath(output_path, winslash = "/"))
