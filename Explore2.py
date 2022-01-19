import json
import csv


# import all json datasets
data_list = []
alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
for letter in alphabet:
    with open(f'D:/Zhengning_Ding/Utrecht_University/term5/winter_lab/Group project/People/{letter}_people.json') as file:
        data = json.load(file)
        data_list.extend(data)
# print(len(data_list))

# clean the data - keep only people with a birth date, and filter out fictional characters, species, and dead people
cleaned_data = []
for person in data_list:
    keys = person.keys()
    if not ('ontology/deathDate' in keys or 'ontology/deathYear' in keys or 'fictional character' in keys or 'ontology/creator_label' in keys or 'ontology/creator' in keys or 'ontology/species_label' in keys or 'ontology/species' in keys) and \
        ('ontology/birthYear' in keys or 'ontology/birthDate' in keys):
        cleaned_data.append(person)
# print(len(cleaned_data))

# # convert gender dataset from .txt file to dictionary
gender_dictionary = {}
gender_txt = open('D:/Zhengning_Ding/Utrecht_University/term5/winter_lab/Group project/People/wiki_genders.txt', encoding='utf8')
for line in gender_txt:
        wiki_id, gender, name = line.strip().split('\t')
        gender_dictionary[name] = gender

# print(gender_dictionary)

# # intersection between gender dataset and cleaned dataset
# title_set1 = set()
# for person in cleaned_data:
#     title_set1.add(person['title'].replace('_',' '))
# print(title_set1)

# title_set2 = set(gender_dictionary.keys())
# len(title_set1.intersection(title_set2))
# print(len(title_set1.intersection(title_set2)))

# # merge the datasets - add gender to a new cleaned dataset
cleaned_gender = []
for person in cleaned_data:
    name = person['title'].replace('_', ' ')
    if name in gender_dictionary.keys():
        person['gender'] = gender_dictionary[name]
        cleaned_gender.append(person)
# print(cleaned_gender)

eventual_data=[]
for person in cleaned_gender:
    eventual_datum= [person['title']]
    if 'ontology/birthYear' in person: 
        eventual_datum.append(person['ontology/birthYear'])
    elif 'ontology/birthDate' in person: 
        Year=person['ontology/birthDate'].split('-')
        eventual_datum.append(Year[0]) 
    else:
        eventual_datum.append('NA')
    eventual_datum.append(person['gender'] if 'gender' in person.keys() else "NA")
    eventual_datum.append(person['ontology/height'] if 'ontology/height' in person.keys() else "NA")
    eventual_datum.append(person['ontology/weight'] if 'ontology/weight' in person.keys() else "NA")
    eventual_datum.append(person['ontology/nationality'] if 'ontology/nationality' in person.keys() else "NA")
    eventual_datum.append(person['ontology/occupation'] if 'ontology/occupation' in person.keys() else "NA")
    eventual_datum.append(person['ontology/almaMater'] if 'ontology/almaMater' in person.keys() else "NA")
    eventual_datum.append(person['ontology/award'] if 'ontology/awardard' in person.keys() else "NA")
    eventual_datum.append(person['ontology/spouse'] if 'ontology/spouse' in person.keys() else "NA")
    eventual_datum.append(person['ontology/child'] if 'ontology/child' in person.keys() else "NA")
    eventual_datum.append(person['ontology/waistSize'] if 'ontology/waistSize' in person.keys() else "NA")
    eventual_datum.append(person['ontology/hipSize'] if 'ontology/hipSize' in person.keys() else "NA")
    eventual_datum.append(person['ontology/eyeColor'] if 'ontology/eyeColor' in person.keys() else "NA")
    eventual_datum.append(person['ontology/hairColor'] if 'ontology/hairColor' in person.keys() else "NA")
    eventual_data.append(eventual_datum)


# # convert to csv
with open('cleaned_gender.csv', 'w', encoding='utf8') as cleaned_file:
    headers=['Name', 'Birth date', 'Birth year', 'Gender', 'Height', 'Weight', 'Nationality', 'Occupation', 'Alma Mater', 'Award', 'Spouse', 'Child', 'Waist', 'Hip', 'Eye', 'Hair']
    cleaned_file.write(f'{"|".join(headers)}\n')
    for line in eventual_data:
       cleaned_file.write(f'{"|".join(str(item) for item in line)}\n')


   