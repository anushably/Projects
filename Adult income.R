# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(RColorBrewer)

# Load the dataset
data <- read.csv("C:\\Users\\Anusha\\Downloads\\adult income dataset\\adult.csv", header = TRUE, stringsAsFactors = FALSE)
View(data)

# Check the structure of the data
str(data)

# Remove duplicate rows
data <- data %>% distinct()

# Function to calculate mode
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


# Replace missing values (if any) with the mean or mode as appropriate
# For simplicity, assume columns with numerical values are filled with mean and categorical with mode
data <- data %>% mutate(across(where(is.numeric), ~replace_na(., mean(., na.rm = TRUE))))

# Check for missing values again to ensure they are imputed
sum(is.na(data))

View(data)
# Check column names
colnames(data)

# 1.Distribution of income levels across different education levels (Bar Plot)
ggplot(data, aes(x = education, fill = income_per_year)) +
  geom_bar(position = "fill") +
  labs(title = "Distribution of Income Levels Across Education Levels", x = "Education Level", y = "Proportion") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")

# 2.How does the number of hours worked per week vary with income levels?
# Boxplot of hours worked per week by income level (Box Plot)
ggplot(data, aes(x = income_per_year, y = hours_worked_per_week, fill = income_per_year)) +
  geom_boxplot() +
  labs(title = "Hours Worked per Week by Income Level", x = "Income Level", y = "Hours Worked per Week") +
  scale_fill_brewer(palette = "Set3")

# Question 3: What is the relationship between age and income levels?
#Histogram of age vs income level (Histogram)
ggplot(data, aes(x = age, fill = income_per_year)) +
  geom_histogram(binwidth = 5, position = "dodge") +
  labs(title = "Age Distribution by Income Level", x = "Age", y = "Count") +
  scale_fill_brewer(palette = "Set3")

# Question 4: How does occupation affect income levels?
# Bar plot of occupation by income level (Bar Plot)
ggplot(data, aes(x = occupation, fill = income_per_year)) +
  geom_bar(position = "fill") +
  labs(title = "Occupation by Income Level", x = "Occupation", y = "Proportion") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")

# Question 5: Is there a significant difference in income based on gender?
# Bar plot of gender by income level (Bar Plot)
ggplot(data, aes(x = gender, fill = income_per_year)) +
  geom_bar(position = "fill") +
  labs(title = "Income Level by Gender", x = "Gender", y = "Proportion") +
  scale_fill_brewer(palette = "Set3")

#Question 6: What is the impact of marital status on income levels?
# Bar plot of marital status by income level (Bar Plot)
ggplot(data, aes(x = marital_status, fill = income_per_year)) +
  geom_bar(position = "fill") +
  labs(title = "Marital Status by Income Level", x = "Marital Status", y = "Proportion") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Paired")

#Question 7: How does race influence income levels?
# Bar plot of race by income level (Bar Plot)
ggplot(data, aes(x = race, fill = income_per_year)) +
  geom_bar(position = "fill") +
  labs(title = "Race by Income Level", x = "Race", y = "Proportion") +
  scale_fill_brewer(palette = "Paired")

#Question 8: What is the relationship between workclass and income levels?
# Define custom colors using the Set2 palette from RColorBrewer
set2_colors <- brewer.pal(8, "Set2")

# Bar plot of workclass by income level with the "Set2" palette
ggplot(data, aes(x = work_class, fill = income_per_year)) +
  geom_bar(position = "fill") +
  labs(title = "Workclass by Income Level", x = "Workclass", y = "Proportion") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = set2_colors)





#Question 09: What are the most common occupations for each income level?
#Chart Type: Bar Plot
# Bar plot of most common occupations by income level (Bar Plot)
ggplot(data, aes(x = occupation, fill = income_per_year)) +
  geom_bar() +
  labs(title = "Most Common Occupations by Income Level", x = "Occupation", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_fill_brewer(palette = "Dark2")



# Load necessary libraries
install.packages("corrplot")  # Install if not already installed
library(corrplot)

# Calculate the correlation matrix
correlation_matrix <- cor(data[, c("age", "hours_worked_per_week")])

# Create the correlation heatmap
corrplot(correlation_matrix, method = "color", 
         type = "upper", order = "hclust",
         tl.col = "black", tl.srt = 45)



