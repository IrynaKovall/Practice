import json
import requests
import random
import numpy as np


# You are going to be given a word. Your job is to return the middle character of the word.
# If the words length is odd, return the middle character. If the word's length is even, return the middle 2 characters.
world = input('Paste any world, which length < 1000 :')
if len(world) % 2 != 0: print(world[int(len(world)/2)])  # для нечетных цифр делим длину на 2 и получаем позицию средней буквы
else: print(world[((int(len(world)/2))-1)], world[int(len(world)/2)])  # также как для нечетных но еще от позиции средней отнимаем 1 чтоб нам выводило 2 средние буквы


# Create a function that returns the sum of the two lowest positive numbers given an array of minimum
# 4 positive integers. No floats or non-positive integers will be passed.
array = [3, 19, 67, 45, 89, 67]
print(sorted(array)[0]+sorted(array)[1])


# In this kata you are required to, given a string, replace every letter with its position in the alphabet.
# If anything in the text isn't a letter, ignore it and don't return it.
letters_list = ('a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z')  # вводим алфавит строкой
letters_list = letters_list.replace(' ', '')  # убираем лишние пробелы
letters = list(letters_list.split(","))  # переобразовуем строку в список
letters_number = list(range(1, (int(len(letters)))+1))  # создаем список порядковых номеров для букв
alphabet = dict(zip(letters, letters_number))  # создаем словарь где каждая буква соответсвует ее порядковому номеру в алф
strings = input('Paste any string: ')
word = []  #
for i in strings:  # итерируем строку введенную пользователем, по каждому символу ищем в словаре ключ и выводим по нему значение
    if i in alphabet:
        i = alphabet[i]
        word.append(i)
print("".join(map(str, word)))


# Parse json
obj = {"number": 10, "people": [{"name": "Oleg Artemyev", "craft": "ISS"}, {"name": "Denis Matveev", "craft": "ISS"}, {"name": "Sergey Korsakov", "craft": "ISS"}, {"name": "Kjell Lindgren", "craft": "ISS"}, {"name": "Bob Hines", "craft": "ISS"}, {"name": "Samantha Cristoforetti", "craft": "ISS"}, {"name": "Jessica Watkins", "craft": "ISS"}, {"name": "Cai Xuzhe", "craft": "Tiangong"}, {"name": "Chen Dong", "craft": "Tiangong"}, {"name": "Liu Yang", "craft": "Tiangong"}], "message": "success"}
obj = json.loads('{"number": 10, "people": [{"name": "Oleg Artemyev", "craft": "ISS"}, {"name": "Denis Matveev", "craft": "ISS"}, {"name": "Sergey Korsakov", "craft": "ISS"}, {"name": "Kjell Lindgren", "craft": "ISS"}, {"name": "Bob Hines", "craft": "ISS"}, {"name": "Samantha Cristoforetti", "craft": "ISS"}, {"name": "Jessica Watkins", "craft": "ISS"}, {"name": "Cai Xuzhe", "craft": "Tiangong"}, {"name": "Chen Dong", "craft": "Tiangong"}, {"name": "Liu Yang", "craft": "Tiangong"}], "message": "success"}')
print(obj.keys())  # смотрим какие есть ключи
print(type(obj['people']))  # нужный нам ключ строка а значит можно итерировать
for i in obj['people']:  # итерируемые объекты словари значит можно обратится по ключу и таким образом распаковать данные
    print(i['name'], i['craft'])


# Запустите серию игр «камень, ножницы, бумага», пока пользователь не # захочет выйти. Выведите статистику после каждой игры (количество
# побед компьютера, количество побед пользователя, количество ничьих).# Когда пользователь уйдет, выведите окончательного победителя.
end_game = ''
your_win = []
comp_win = []
draw = []
while end_game != 'стоп':
    figure = input('укажите фигуру колодец или ножници или бумага: ')
    comp_figure = random.choice(['колодец', 'ножници', 'бумага'])
    if figure == 'колодец' and comp_figure == 'ножници':
        your_win.append(1)
    elif figure == 'колодец' and comp_figure == 'бумага':
        comp_win.append(1)
    elif figure == 'бумага' and comp_figure == 'колодец':
        your_win.append(1)
    elif figure == 'бумага' and comp_figure == 'ножници':
        comp_win.append(1)
    elif figure == 'ножници' and comp_figure == 'бумага':
        your_win.append(1)
    elif figure == 'ножници' and comp_figure == 'колодец':
        comp_win.append(1)
    elif figure == comp_figure:
        draw.append(1)
    end_game = input('стоп если хотите закончить игру: ')
print(f' {len(your_win)} - побед у Вас, {len(comp_win)} - побед у компютера , {len(draw)} - ничьих')
if len(your_win) > len(comp_win):
    print('Вы победитель')
elif len(your_win) > len(comp_win):
    print('Комп победитель')
else:
    print('Ничья')


# Получите от пользователя ввод вещественных чисел, пока он не захочет выйти. Когда он закончит ввод,
# выведите самое большое число, затем  второе по величине число, затем третье по величине число.
arr = np.array([])  # cоздаем пустой масив чтоб записывать данные пользователя
stop_word = input('Paste stop when you want finished: ')
while stop_word != 'stop':  # добавляем данные в масив пока пользователь не захочет остановится
    num = np.array([float(input('Paste float: '))])
    arr = np.concatenate((arr, num))
    stop_word = input('Paste stop when you want finished: ')
sort_arr = np.sort(arr)  # сортируем массив
print(sort_arr[:3])  # слайсим сортированый массив по первым трем значениям.


# Выведите все простые числа от 1 до 100. Постарайтесь сделать вашу программу максимально эффективной, используя  те
# инструменты, которые мы изучили до сих пор. Например, для каждого числа, которое мы проверяем на простоту, нам
# нужно только проверить, делится ли оно на меньшие простые числа (поэтому нам не нужно проверять деление на 4, 6, 8,...

lists = [2]  # создаем список с первым простым числом
for i in range(3, 101):  # проверяем диапазон от 3-х потому что 2 уже в нашем списке
    k = 0
    for j in lists:  # делим число на простые числа которые уже попали в список
        if i % j == 0:
            k = 1  # если число поделится хоть один раз без остатка оно сложное так как простое делится только на 1,а 1(нашем lists отсутсвует) и на само себя(в списке его еще нет)
            break  # останавливаем как только k=1, это значит число уже поделилось на 2 (2 первое в lists) и оно автоматически не простое
    if k == 0:
        lists.append(i)
print(lists)


# Write a program to help manage a Tennis tournament: for each of 10 rounds, take as input the name of the round’s winner.
# At the end of the tournament print the winner(s).
tournament = {}  # создаем пустой словарь что б наполнить его даными о обедителях
for i in range(1, 11):  # range(1,11) потому что 10 раундов
    number_of_round = i + 1  # возращает нам номер раунда
    name = input('paste name of winner:')  # возращает победителя раунда
    tournament[number_of_round] = name  # записывает в словарь раунд-победитель
print(tournament.values())


# Джонни строит забор. В качестве входящих данных запросите - название
# желаемой формы («круг» или «квадрат») и длину забора Джонни.
# Выведите площадь, которую покрывает забор Джонни.

figure = input('введите круг или квадрат:')
long = int(input('введите длину забора:'))
if figure == 'круг':
    print(long*3.14)
elif figure == 'квадрат':
    print('long*long')
else:
    print('правильно введите название фигуры')
