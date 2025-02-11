######### Data Preparation #########
library(tidyverse)

# read figure 1 data
# read all files in the directory that start with "Figure1" and end with ".tsv" or ".csv"
# pivot_longer to transform the data from wide to long format
# add a column with the source file name (example, "Figure1")
read_figure1 <- function(directory) {
    files_tsv <- list.files(directory, pattern = "^Figure1.*\\.tsv$", full.names = TRUE)
    files_csv <- list.files(directory, pattern = "^Figure1.*\\.csv$", full.names = TRUE)
    files <- c(files_tsv, files_csv)
    
    data_list <- lapply(files, function(file) {
        if (grepl("\\.tsv$", file)) {
            data <- readr::read_tsv(file)
        } else {
            data <- readr::read_csv(file)
        }
        
        data %>%
            pivot_longer(cols = -Country, names_to = "Year", values_to = "Value") %>%
            mutate(Year = as.numeric(Year),
                         source = tools::file_path_sans_ext(basename(file)))
    })
    
    bind_rows(data_list)
}

figure1 <- read_figure1("data/")

# str(figure1)
# head(figure1)
# tail(figure1)
# table(figure1$source)

# write.csv(df, "./data2/df2.csv", row.names = FALSE)

read_figure2 <- function(directory) {
  files <- list.files(directory, pattern = "^Figure2.*\\.tsv$", full.names = TRUE)
  
  data_list <- lapply(files, function(file) {
    read_tsv(file) %>%
      pivot_longer(cols = -Variable, names_to = "Year", values_to = "Value") %>%
      mutate(Year = as.numeric(Year),
             source = tools::file_path_sans_ext(basename(file)))
  })
  
  bind_rows(data_list)
}

figure2 <- read_figure2("data/")

figure_s1 <- read_tsv("data/Figure_S-1.tsv")

read_figureSup <- function(directory) {
  files <- list.files(directory, pattern = "^FigureS.*\\.tsv$", full.names = TRUE)
  
  data_list <- lapply(files, function(file) {
    read_tsv(file) %>%
      pivot_longer(cols = -Variable, names_to = "Year", values_to = "Value") %>%
      mutate(Year = as.numeric(Year),
             source = tools::file_path_sans_ext(basename(file)))
  })
  
  bind_rows(data_list)
}

figureSup <- read_figureSup("data/")


########
## merge data -----
str(figure1)
figure1 <- figure1 %>%
  rename(Variable = `Country`)

str(figure2)

str(figure_s1) 
figure_s1 <- figure_s1 %>%
    mutate(source = "FigureS-1") %>%
    rename(Value = `Percentage`)

str(figureSup)

merged_data <- figure1 %>%
  full_join(figure2, by = c("Variable", "Year", "source", "Value")) %>%
  full_join(figure_s1, by = c("Year", "source", "Value")) %>%
  full_join(figureSup, by = c("Variable", "Year", "source", "Value"))


#### Add Countrycodes -----
library(countrycode)

merged_data_countrycodes <- merged_data %>%
  mutate(iso3c = countrycode(Variable, origin = "country.name", destination = "iso3c"))

tail(merged_data_countrycodes)

#### Save data ----

write_csv(merged_data_countrycodes, "data/merged_data.csv")


figure1 <- figure1 %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))

figure1 <- write.csv(figure1, "data/merged_figure1.csv", row.names = FALSE)

figure2 <- figure2 %>%
  mutate(iso3c = countrycode(Variable, origin = "country.name", destination = "iso3c"))

figure2 <- write.csv(figure2, "data/merged_figure2.csv", row.names = FALSE)

figure_s1 <- figure_s1 %>%
  mutate(iso3c = countrycode(Variable, origin = "country.name", destination = "iso3c"))

figure_s1 <- write.csv(figure_s1, "data/merged_figure_s1.csv", row.names = FALSE)

figureSup <- figureSup %>%
  mutate(iso3c = countrycode(Variable, origin = "country.name", destination = "iso3c"))

figureSup <- write.csv(figureSup, "data/merged_figureSup.csv", row.names = FALSE)
