library(tidyverse)

data <- read_delim('person_data_allvariable.csv', delim = '|')

data_0_1 <- data %>%
  #converting entries to binary
  mutate(Height = !is.na(Height)) %>%
  mutate(Weight = !is.na(Weight)) %>%
  mutate(EyeColor = !is.na(EyeColor)) %>%
  mutate(HairColor = !is.na(HairColor)) %>%
  mutate(HipSize = !is.na(HipSize)) %>%
  #calculate the age of participants
  filter(Birth >= 1922 & Birth < 2022) %>%
  mutate(Age = 2022 - as.numeric(Birth))

# proportion of weight entries
weight <- data_0_1 %>%
  group_by(Age,Gender)%>%
  summarise(Proportion_Weight=mean(Weight))%>%
  ungroup()

# proportion of height entries
height <- data_0_1 %>%
  group_by(Age, Gender) %>%
  summarise(height = mean(Height))%>%
  ungroup()

eyecolor <- data_0_1 %>%
  group_by(Age, Gender) %>%
  summarise(eyecolor = mean(EyeColor))%>%
  ungroup()

haircolor <- data_0_1 %>%
  group_by(Age, Gender) %>%
  summarise(haircolor = mean(HairColor))%>%
  ungroup()

hipsize <- data_0_1 %>%
  group_by(Age, Gender) %>%
  summarise(hipsize = mean(HipSize))%>%
  ungroup()

merged<-cbind(weight,height,haircolor,eyecolor,hipsize)

# Visualisations 
# weight
ggplot(data = weight) +
  aes(x = Age, y = weight, color = Gender) +
  geom_point() +
  labs(x = "Age", y = "Proportion of people with their weight mentioned") +
  scale_y_continuous(labels = scales::label_percent()) +
  theme_light()

# height
ggplot(data = height) +
  aes(x = Age, y = height, color = Gender) +
  geom_point() +
  labs(x = "Age", y = "Proportion of people with their height mentioned") +
  scale_y_continuous(labels = scales::label_percent()) +
  theme_light()


