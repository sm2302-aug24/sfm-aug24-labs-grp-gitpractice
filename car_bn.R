library(rvest)
library(tidyverse)
# This is how you get read the HTML into R
url <- "https://www.honeycarsmart.com/index.php/full-inventory/"
html <- read_html(url)

# Extract the car price
prices <-
  html |>
  html_elements(".results") |>
  html_text2() 

# Clean up
prices <- 
  prices <- 
  str_remove_all(prices, "[^0-9]") |>  # Remove non-numeric characters
  na_if("") |>                         # Replace empty strings with NA
  as.integer()                         # Convert to integers

# Do same thing for number of brands, mileages, colors, and other remarks
brands <-
  html |>
  html_elements(".vehicle-name") |>
  html_text2() |>
  as.character()

mileages <-
  html |>
  html_elements(".car-mileages") |>
  html_text2() |>
  as.integer()

library(rvest)
library(dplyr)

num_pages <- 21
all_data <- data.frame()

for (i in 1:num_pages) { 
  url <- paste0("https://www.honeycarsmart.com/index.php/full-inventory/page/", i)
  page <- read_html(url)
  data <- page %>% 
    html_elements(".mini-hide") %>%
    html_text2() %>%
    data.frame(color = .)  # Convert to data frame
  
  all_data <- bind_rows(all_data, data)
}

# Remove years
all_data <- all_data %>%
  mutate(color = gsub("\\d{4}", "", color)) %>%
  mutate(color = trimws(color))  # Trim whitespace

library(rvest)
library(stringr)  # Ensure the stringr package is loaded

# Number of pages to scrape
num_pages <- 21
all_data <- list()

for (i in 1:num_pages) { 
  url <- paste0("https://www.honeycarsmart.com/index.php/full-inventory/page/", i)
  
  # Read the page content
  page <- read_html(url)
  
  # Extract the data and remove the year
  data <- page %>% 
    html_elements(".mini-hide") %>%
    html_text2()
  
  # Remove the year (number) from the data
  data <- str_remove_all(data, "\\d{4}") 
  
  # Store the cleaned data in the list
  all_data[[i]] <- data
}

# Combine the list into a vector
combined_data <- unlist(all_data)
# Remove leading/trailing whitespace
combined_data <- trimws(combined_data)

# Print the final combined data
print(combined_data)


print(all_data)


colors <-
  html |>
  html_elements(".mini-hide") |>
  html_text2()
str_remove_all(colors, "[0-9]")
str_trim(clean_colors)

remarks <- 
  html |>
  html_elements("div p .mt-3") |>
  html_text2()

remarks <- tail(remarks, length(prices))

# Put it all in a data frame
hsp_df <- tibble(
  price = prices,
  brands = brands,
  mileages = mileages,
  colors = colors,
  remarks = remarks
)