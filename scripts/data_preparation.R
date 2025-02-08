######### Data Preparation #########
# read_figuras <- function(directory) {
#   files <- list.files(directory, pattern = "^Figure1.*\\.tsv$", full.names = TRUE)
  
#   data_list <- lapply(files, function(file) {
#     read_tsv(file) %>%
#       pivot_longer(cols = -Country, names_to = "Year", values_to = "Value") %>%
#       mutate(Year = as.numeric(Year),
#              source = tools::file_path_sans_ext(basename(file)))
#   })
  
#   bind_rows(data_list)
# }

# df <- read_figuras("data/")

# str(df)
# write.csv(df, "df.csv", row.names = FALSE)

# df <- read.csv("df.csv")