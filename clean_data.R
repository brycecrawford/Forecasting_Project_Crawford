pacman::p_load(tidyverse,fpp3, scales)

# creating file path to data folder
folder <- "Data"

files <- list.files(folder, pattern = "\\.csv$", full.names = TRUE)

# Loading in data files
read_one <- function(path) {
  read_csv(path, col_types = cols(.default = col_character())) |> 
    select(-starts_with("...")) |> 
    filter( ORIGIN == "PDX")
}

# Combining files and removing cargo-only service classes
t_100_raw <- map_dfr(files, read_one) |> 
  type_convert() |> 
  filter(!CLASS %in% c("G","P"))

# Creating time series dataframe 
pdx_monthly <-  t_100_raw |> 
  mutate(date = yearmonth(make_date(YEAR, MONTH))) |> 
  select(date, PASSENGERS) |> 
  group_by(date) |>
  summarise(PASSENGERS = sum(PASSENGERS, na.rm = TRUE)) |>
  as_tsibble(index = date)

# Checking for gaps in data
has_gaps(pdx_monthly)

# Plotting entire series
autoplot(pdx_monthly, PASSENGERS) +
  scale_y_continuous(labels = label_number(scale = 1e-3)) +
  labs(title = "Monthly Passengers at PDX Airport",
       subtitle = "(In Thousands)",
       x = "Date",
       y = "Number of Passengers") +
  theme_minimal()


