library(tidyverse)

data <- read_delim('person_data_full.csv', delim = '|')

data_0_1 <- data %>%
  mutate(Height = !is.na(Height)) %>%
  mutate(Weight = !is.na(Weight)) %>%
  mutate(Nationality = !is.na(Nationality)) %>%
  mutate(Occupation = !is.na(Occupation)) %>%
  mutate(Alma_Mater = !is.na(Alma_Mater)) %>%
  mutate(Spouse = !is.na(Spouse)) %>%
  mutate(Child = !is.na(Child)) %>%
  mutate(EyeColor = !is.na(EyeColor)) %>%
  mutate(Profession = !is.na(Profession)) %>%
  mutate(Salary = !is.na(Salary)) %>%
  mutate(Education = !is.na(Education)) %>%
  mutate(Partner = !is.na(Partner)) %>%
  mutate(NetWorth = !is.na(NetWorth)) %>%
  mutate(Parent = !is.na(Parent)) %>%
  mutate(HairColor = !is.na(HairColor)) %>%
  mutate(Univeristy = !is.na(Univeristy)) %>%
  mutate(Ethnicity = !is.na(Ethnicity)) %>%
  mutate(Citizenship = !is.na(Citizenship)) %>%
  #calculate the age of participants
  mutate(Age = 2022 - as.numeric(Birth))%>%
  filter(Age>= 25 & Age <100)

# mutate attributes into a grouped one variable
data_attributes = data_0_1 %>%
  mutate(Edu_all = ifelse(Alma_Mater==TRUE|Education==TRUE|Univeristy==TRUE, TRUE, FALSE)) %>%
  mutate(career_all = ifelse(Occupation==TRUE|Profession==TRUE, TRUE, FALSE)) %>%
  mutate(Income_all = ifelse(Salary==TRUE|NetWorth==TRUE, TRUE, FALSE)) %>%
  mutate(Relationships_all = ifelse(Partner==TRUE|Spouse==TRUE, TRUE, FALSE)) %>%
  mutate(Family_all = ifelse(Partner==TRUE|Spouse==TRUE|Child==TRUE|Parent==TRUE, TRUE, FALSE)) %>%
  mutate(Height_Weight = ifelse(Height==TRUE|Weight==TRUE, TRUE, FALSE)) %>%
  mutate(Physical_appearance = ifelse(EyeColor==TRUE|HairColor==TRUE, TRUE, FALSE)) %>%
  select(Age, Gender, Edu_all, career_all, Income_all, Relationships_all, Family_all, Child, Parent, Height_Weight, Physical_appearance)

#Calculate the mean 
education <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(education = mean(Edu_all)) %>%
  ungroup()

career <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(career = mean(career_all)) %>%
  ungroup()

Income <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(income = mean(Income_all)) %>%
  ungroup()

Relationships <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(relationships = mean(Relationships_all)) %>%
  ungroup()

Family <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(family = mean(Family_all)) %>%
  ungroup()

Height_Weight <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(height_weight = mean(Height_Weight)) %>%
  ungroup()

Physical_appearance <- data_attributes %>%
  group_by(Age, Gender) %>%
  summarise(physical_appearance = mean(Physical_appearance)) %>%
  ungroup()


##Visualisation
Professional_life <- merge(education,career,by=c("Age","Gender"))
Private_life <- merge(Relationships,Family,by=c("Age","Gender"))
Body <- merge(Height_Weight,Physical_appearance,by=c("Age","Gender"))
Grouped <- merge(Professional_life,Private_life,by=c("Age","Gender"))
Grouped <- merge(Grouped,Body,by=c("Age","Gender"))


#Aggregate

Professional_life<- Professional_life%>%
  pivot_longer(c(3:4),names_to = "variable",values_to = "proportion")
Private_life <- Private_life %>%
  pivot_longer(c(3:4),names_to = "variable",values_to = "proportion")
Body_shape <- Body%>%
  pivot_longer(c(3:4),names_to = "variable",values_to = "proportion")
Grouped <- Grouped%>%
  pivot_longer(c(3:8),names_to = "variable",values_to = "proportion")


## Visualisation 
Professional_life%>%
  ggplot(aes(x=Age,y=proportion, ymin=0, ymax=proportion, fill=Gender))+
  facet_wrap(~ variable)+
  stat_smooth(geom="ribbon", ymin=0, alpha=0.3) +
  #geom_ribbon(stat=stat_smooth(), alpha=0.3)+
  theme_light()+
  labs(x= "Age" ,y="Proportion of professional life mentioned in the age group")

Private_life%>%
  ggplot(aes(x=Age,y=proportion, ymin=0, ymax=proportion, fill=Gender))+
  facet_wrap(~ variable)+
  stat_smooth(geom="ribbon", ymin=0, alpha=0.3) +
  #geom_ribbon(stat=stat_smooth(), alpha=0.3)+
  theme_light()+
  labs(x= "Age" ,y="Proportion of private life mentioned in the age group")

Body_shape%>%
  ggplot(aes(x=Age,y=proportion, ymin=0, ymax=proportion, fill=Gender))+
  facet_wrap(~ variable)+
  stat_smooth(geom="ribbon", ymin=0, alpha=0.3) +
  #geom_ribbon(stat=stat_smooth(), alpha=0.3)+
  theme_light()+
  labs(x= "Age" ,y="Proportion of body shape mentioned in the age group")


Grouped%>%
  ggplot(aes(x=Age,y=proportion, ymin=0, ymax=proportion, fill=Gender))+
  facet_wrap(~ variable,ncol = 2)+
  stat_smooth(geom="ribbon", ymin=0, alpha=0.3) +
  #geom_ribbon(stat=stat_smooth(), alpha=0.3)+
  theme_light()+
  labs(x= "Age" ,y="Proportion mentioned in the age group")

