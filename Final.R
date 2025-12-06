### DAT 511 - Final Project ###
### by Julia Hise ###

# Clear the workspace
rm(list=ls())


### ---------- Loading the data and joining dataset ----------------------------

### Set working directory and define folder path ###
setwd("C:/Users/Julia/OneDrive/Desktop/DAT 511/Final")
folder_path <- "C:/Users/Julia/OneDrive/Desktop/DAT 511/Final"

### Load required libraries ###
library(dplyr)
library(readr)
library(ggplot2)

# Define file paths
details_file <- "StormEvents_details-ftp_v1.0_d2024_c20251118.csv"
fatalities_file <- "StormEvents_fatalities-ftp_v1.0_d2024_c20251118.csv"
locations_file <- "StormEvents_locations-ftp_v1.0_d2024_c20251118.csv"

# Read CSVs into R
details <- read_csv(details_file)
fatalities <- read_csv(fatalities_file)
locations <- read_csv(locations_file)

# Join datasets together by EVENT_ID
joined_data <- details %>%
  left_join(locations, by = "EVENT_ID") %>%
  left_join(fatalities, by = "EVENT_ID")


### Save the Joined Data to new csv file ###
output_file <- file.path(folder_path, "StormEvents_joined_data.csv")
write_csv(joined_data, output_file)

# Inform the user
message("Joined data saved to: ", output_file)

# Preview the joined data
print(head(joined_data))
### ----------------------------------------------------------------------------


### ---------- Cleaning Damage Variables ---------------------------------------

# This is because NOAA often stores property/crop damage with suffixes like K 
# (thousands), M (millions), B (billions), and we want to convert them to numeric:

clean_damage <- function(x) {
  x <- toupper(x)
  ifelse(grepl("K", x), as.numeric(sub("K", "", x)) * 1e3,
         ifelse(grepl("M", x), as.numeric(sub("M", "", x)) * 1e6,
                ifelse(grepl("B", x), as.numeric(sub("B", "", x)) * 1e9,
                       as.numeric(x))))
}

# Apply cleaning function to property and crop damage columns
joined_data$PROP_DAMAGE <- clean_damage(joined_data$DAMAGE_PROPERTY)
joined_data$CROP_DAMAGE <- clean_damage(joined_data$DAMAGE_CROPS)

# View summary statistics for cleaned damage columns
summary(joined_data$PROP_DAMAGE)
summary(joined_data$CROP_DAMAGE)

### ----------------------------------------------------------------------------


### Question 1 - Most Harmful Events to Population Health--------------

# Summarize total fatalities and injuries by event type
health_summary <- joined_data %>%
  group_by(EVENT_TYPE) %>%
  summarise(
    total_fatalities = sum(DEATHS_DIRECT, na.rm = TRUE) + sum(DEATHS_INDIRECT, na.rm = TRUE),
    total_injuries   = sum(INJURIES_DIRECT, na.rm = TRUE) + sum(INJURIES_INDIRECT, na.rm = TRUE)
  ) %>%
  mutate(total_health = total_fatalities + total_injuries) %>%
  arrange(desc(total_health))

# Extract top 10 harmful event types
top10_health <- head(health_summary, 10)

# Plot top 10 harmful event types
ggplot(top10_health, aes(x = reorder(EVENT_TYPE, total_health), y = total_health)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  labs(title = "Top 10 Most Harmful Event Types (2024)",
       x = "Event Type",
       y = "Fatalities + Injuries")

### ----------------------------------------------------------------------------


### Question 2 - Most Frequent Events by State ---------------------------------

# Count number of events by state and event type
q2_summary <- joined_data %>%
  group_by(STATE, EVENT_TYPE) %>%
  summarise(event_count = n(), .groups = "drop") %>%
  arrange(desc(event_count))

# Preview top 10 combinations
head(q2_summary, 10)

# Extract Top 10 Event-Type/State Combinations
top10_combos <- head(q2_summary, 10)

# Plot top 10 combinations
ggplot(top10_combos, aes(x = reorder(paste(EVENT_TYPE, STATE, sep = " - "), event_count), y = event_count)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Event-Type/State Combinations (2024)",
       x = "Event Type - State",
       y = "Number of Events")

### ----------------------------------------------------------------------------


### Question 3 - Events by Month -----------------------------------------------

# Convert BEGIN_DATE_TIME to POSIX format and extract month abbreviation
filtered_data <- joined_data %>%
  filter(!is.na(BEGIN_DATE_TIME)) %>%
  mutate(BEGIN_DATE_TIME = as.POSIXct(BEGIN_DATE_TIME, format = "%d-%b-%y %H:%M:%S", tz = "UTC")) %>%
  mutate(MONTH = factor(format(BEGIN_DATE_TIME, "%b"),
                        levels = month.abb,
                        ordered = TRUE))

# Count events by month and event type
monthly_counts <- filtered_data %>%
  group_by(MONTH, EVENT_TYPE) %>%
  summarise(event_count = n(), .groups = "drop")

# Identify the most frequent event type for each month
top_monthly_events <- monthly_counts %>%
  group_by(MONTH) %>%
  slice_max(order_by = event_count, n = 1, with_ties = FALSE) %>%
  ungroup()

# Plot most frequent event type by month
ggplot(top_monthly_events, aes(x = MONTH, y = event_count, fill = EVENT_TYPE)) +
  geom_col() +
  labs(title = "Most Frequent Event Type by Month (2024)",
       x = "Month",
       y = "Number of Events",
       fill = "Event Type") +
  theme_minimal()

### ----------------------------------------------------------------------------


### Question 4 - Which event types cause the most fatalities? ------------------

# Count fatalities by event type (only rows with FATALITY_ID)
fatality_summary <- joined_data %>%
  filter(!is.na(FATALITY_ID)) %>%   # keep only rows with fatalities
  group_by(EVENT_TYPE) %>%
  summarise(total_fatalities = n(), .groups = "drop") %>%
  arrange(desc(total_fatalities))

# Extract Top 10 deadliest event types
top10_fatalities <- head(fatality_summary, 10)

# Plot top 10 deadliest event types
ggplot(top10_fatalities, aes(x = reorder(EVENT_TYPE, total_fatalities), y = total_fatalities)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  labs(title = "Top 10 Deadliest Event Types (2024)",
       x = "Event Type",
       y = "Number of Fatalities")

### ----------------------------------------------------------------------------







