
library(tidyverse)
data <- read_delim('person_data.csv', delim = '|')



data_0_1 <- data %>%
#converting numbers into a binary
  mutate(Height = !is.na(Height))%>%
  mutate(Weight = !is.na(Weight))%>%
  mutate(Nationality = !is.na(Nationality))%>%
  mutate(Occupation = !is.na(Occupation))%>%
  mutate(Spouse = !is.na(Spouse))%>%
#calculate the age of participants 
  mutate(Age=2022-as.numeric(Birth))%>%
  filter(Age>=0 & Age <=100)

proportion <- data_0_1 %>%
  group_by(Age,Gender)%>%
  summarise(proportion_weight=mean(Weight))

#Visualising the result 
ggplot(data=proportion)+
  aes(x=Age,
      y=proportion_weight,
      color=Gender)+
  geom_point()+
  labs(x="Age",
       y="Proportion of people with their height mentioned")
         
         
         
   
