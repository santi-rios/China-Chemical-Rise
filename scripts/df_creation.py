# Generate R code to create the dataframe manually
r_code = "df <- data.frame(\n"
for column in df.columns:
    values = ', '.join(repr(value) for value in df[column].tolist())
    r_code += f"  {column} = c({values}),\n"
r_code = r_code.rstrip(",\n") + "\n)"

# Save R code to file for user download
r_code_path = "/mnt/data/df_creation_code.R"
with open(r_code_path, "w") as file:
    file.write(r_code)

r_code_path
