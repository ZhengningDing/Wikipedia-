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


'''
variables=["Height","Weight","Eyecolor","Haircolor","Hipsize"]

data_0_1 <- data %>%
  repeat{
    mutate()
  }
  mutate(selected_variable=! is.na(selected_variable))%>%
  filter(Age>=0 & Age <=100)%>%
  mutate(Age=2022-as.numeric(Birth))
  '''



# proportion of weight entries
weight <- data_0_1 %>%
  group_by(Age,Gender)%>%
  summarise(weight=mean(Weight))%>%
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


merged <- merge(merge(merge(
  weight,
  height,by=c("Age","Gender")),
  eyecolor,by=c("Age","Gender")),
  haircolor,by=c("Age","Gender"))


# Visualisations 
#Aggregate
merged%>%
  pivot_longer(c(3:6),names_to = "variable",values_to = "proportion")%>%
  ggplot(aes(x=Age,y=proportion,color=Gender))+
  facet_wrap(vars(variable),ncol=2)+
  geom_point()+
  theme_light()+
  labs(x= "Age" ,y="Proportion of certain traits mentioned in the age group")




'''
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


