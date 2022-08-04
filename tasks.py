import json
import requests

# You are going to be given a word. Your job is to return the middle character of the word.
# If the words length is odd, return the middle character. If the word's length is even, return the middle 2 characters.
world = input('Paste any world, which length < 1000 :')
if len(world) % 2 != 0: print(world[int(len(world)/2)]) # для нечетных цифр делим длину на 2 и получаем позицию средней буквы
else: print(world[((int(len(world)/2))-1)], world[int(len(world)/2)]) # также как для нечетных но еще от позиции средней отнимаем 1 чтоб нам выводило 2 средние буквы


# Create a function that returns the sum of the two lowest positive numbers given an array of minimum
# 4 positive integers. No floats or non-positive integers will be passed.
array = [3, 19, 67, 45, 89, 67]
print(sorted(array)[0]+sorted(array)[1])

# In this kata you are required to, given a string, replace every letter with its position in the alphabet.
# If anything in the text isn't a letter, ignore it and don't return it.
letters_list = ('a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z')  # вводим алфавит строкой
letters_list = letters_list.replace(' ','')  # убираем лишние пробелы
letters = list(letters_list.split(","))  # переобразовуем строку в список
letters_number = list(range(1,(int(len(letters)))+1))  # создаем список порядковых номеров для букв
alphabet = dict(zip(letters, letters_number))  # создаем словарь где каждая буква соответсвует ее порядковому номеру в алф
strings = input('Paste any string: ')
word = []  #
for i in strings:  # итерируем строку введенную пользователем, по каждому символу ищем в словаре ключ и выводим по нему значение
    if i in alphabet:
        i = alphabet[i]
        word.append(i)
print("".join(map(str,word)))

# Parse json
obj = {"number": 10, "people": [{"name": "Oleg Artemyev", "craft": "ISS"}, {"name": "Denis Matveev", "craft": "ISS"}, {"name": "Sergey Korsakov", "craft": "ISS"}, {"name": "Kjell Lindgren", "craft": "ISS"}, {"name": "Bob Hines", "craft": "ISS"}, {"name": "Samantha Cristoforetti", "craft": "ISS"}, {"name": "Jessica Watkins", "craft": "ISS"}, {"name": "Cai Xuzhe", "craft": "Tiangong"}, {"name": "Chen Dong", "craft": "Tiangong"}, {"name": "Liu Yang", "craft": "Tiangong"}], "message": "success"}
obj = json.loads('{"number": 10, "people": [{"name": "Oleg Artemyev", "craft": "ISS"}, {"name": "Denis Matveev", "craft": "ISS"}, {"name": "Sergey Korsakov", "craft": "ISS"}, {"name": "Kjell Lindgren", "craft": "ISS"}, {"name": "Bob Hines", "craft": "ISS"}, {"name": "Samantha Cristoforetti", "craft": "ISS"}, {"name": "Jessica Watkins", "craft": "ISS"}, {"name": "Cai Xuzhe", "craft": "Tiangong"}, {"name": "Chen Dong", "craft": "Tiangong"}, {"name": "Liu Yang", "craft": "Tiangong"}], "message": "success"}')
print(obj.keys()) # смотрим какие есть ключи
print(type(obj['people'])) # нужный нам ключ строка а значит можно итерировать
for i in obj['people']: # итерируемые объекты словари значит можна обратится по ключу и таким образом распаковать данные
    print(i['name'],i['craft'])

