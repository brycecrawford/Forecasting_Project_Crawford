pacman::p_load(tidyverse,fpp3, scales)

# Load cleaned monthly data series created by clean_data.R
pdx_monthly <- read_csv("Data/clean/pdx_monthly.csv") |> 
  mutate(date = yearmonth(date)) |> 
  as_tsibble(index = date)
