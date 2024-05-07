library(dplyr)


if(!require("nhanesA")) {
  install.packages("nhanesA")
}
  library(nhanesA)

alcohol_data <- nhanes("P_ALQ")
smoking_data <- nhanes("P_SMQ")
phys_data <- nhanes("P_PAQ")
sleep_data <- nhanes("P_SLQ")
demo_data <- nhanes("P_DEMO")


# Merging the datasets
data <- alcohol_data %>%
  inner_join(smoking_data, by = "SEQN") %>%
  inner_join(phys_data, by = "SEQN")  %>%
  inner_join(sleep_data, by = "SEQN") %>%
  inner_join(demo_data, by = "SEQN")

# Selecting features
data <- data %>%
  select(RIDAGEYR, RIAGENDR, ALQ111, ALQ121, SMQ020, SMQ040, PAQ605, PAQ610, PAQ620, PAQ625, SLQ050, SLD012)

# Feature Engineering
alcoholic_factors = c("Every day", "Nearly every day", "3 to 4 times a week", "2 times a week", "Once a week")
data <- data %>% filter(!is.na(data$ALQ111)) %>%
  mutate(
    Alcoholic = case_when(
      ALQ111 == "Yes" & ALQ121 %in% alcoholic_factors ~ "Alcaholic",
      ALQ111 == "No" ~ "Non-Alcoholic",
      TRUE ~ "Unknown"
    )
  ) %>% select(-ALQ111, -ALQ121)


smoker_factors = c("Every day", "Some days")
data <- data %>% filter(!is.na(SMQ020)) %>%
  mutate(Smoker = case_when(
    SMQ020 == "Yes" & SMQ040 %in% smoker_factors ~ "Smoker",
    SMQ020 == "Yes" & SMQ040 == "Not at all" ~ "Former-Smoker",
    SMQ020 == "No" ~ "Non-Smoker",
    TRUE ~ "Unknown"
  )) %>% select(-SMQ020, -SMQ040)


data <- data %>% filter(!is.na(PAQ610) | !is.na(PAQ625)) %>% mutate(
  Vigorous_Activity_Mins = as.numeric(PAQ610),
  Moderate_Activity_Mins = as.numeric(PAQ625),
  Total_Active_Mins = (Vigorous_Activity_Mins * 2) + Moderate_Activity_Mins,
  Physically_Active_Status = case_when(
    Total_Active_Mins >= 90 ~ "Active",
    TRUE ~ "Inactive"
  )
) %>% select(-ends_with("Mins"), -starts_with("PAQ6"))

data <- data %>% rename(
  Gender = RIAGENDR,
  Age = RIDAGEYR,
  Sleep_Disorder = SLQ050,
  Avg_Sleep_Hrs = SLD012
)

# Write data to csv
file_name = "~/Developer/AIM-5002/Final Project/1. Data/data.csv"
write.csv2(data, file_name, row.names = FALSE)
