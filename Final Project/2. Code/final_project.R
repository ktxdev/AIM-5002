library(dplyr)
library(ggplot2)

file_name <- "~/Developer/AIM-5002/Final Project/1. Data/data.csv"
data <- read.csv2(file_name)

# EDA
# Univariate Analysis
# Gender
ggplot(data, aes(x = Gender)) +
  geom_bar() +
  labs(title = "Barplot of Gender", x = "Gender", y = "Count") +
  theme_minimal()
# Sleep_Disorder
ggplot(data, aes(x = Sleep_Disorder)) +
  geom_bar() +
  labs(title = "Barplot of Sleep Disorder", x="Sleep Disorder", y = "Count") +
  theme_minimal()
# Alcoholic
ggplot(data, aes(x = Alcoholic)) +
  geom_bar() +
  labs(title = "Barplot of Alcoholic", x="Alcoholic", y = "Count") +
  theme_minimal()
# Smoker
ggplot(data, aes(x = Smoker)) +
  geom_bar() +
  labs(title = "Barplot of Smoker", x="Smoker", y = "Count") +
  theme_minimal()
# Physically active
ggplot(data, aes(x = Physically_Active_Status)) +
  geom_bar() +
  labs(title = "Barplot of Smoker", x="Smoker", y = "Count") +
  theme_minimal()

