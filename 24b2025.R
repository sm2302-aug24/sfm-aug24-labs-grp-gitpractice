library(rvest)

# This is how you get read the HTML into R
url <- "https://www.honeycarsmart.com/"
html <- read_html(url)

# Extract the car price
prices <-
  html |>
  html_elements(".car-price") |>
  html_text2()

# Clean up
prices <- 
  str_remove_all(prices, "[^0-9]") |>  # Remove non-numeric characters
  na.if("") |>  #Replace empty strings with NA
  as.integer()

# Do same thing for number of brands, mileages, colors, and other remarks
brands <-
  html |>
  html_elements(".car-brands") |>
  html_text2() |>
  as.integer()

mileages <-
  html |>
  html_elements(".car-mileages") |>
  html_text2() |>
  as.integer()

colors <-
  html |>
  html_elements(".car-colors") |>
  html_text2()

remarks <- 
  html |>
  html_elements("div p .mt-3") |>
  html_text2()

remarks <- tail(remarks, length(prices))

library(tidyverse)

# Put it all in a data frame
hsp_df <- tibble(
  price = prices,
  brands = brands,
  mileages = mileage,
  colors = colors,
  remarks = remarks
)
