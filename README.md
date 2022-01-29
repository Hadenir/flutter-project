# Programowanie aplikacji mobilnych w technologii Flutter
### Konrad Brzózka

## Opis projektu
Aplikacja mobilna pozwalająca na wygodne przeglądanie informacji ze świata Gwiezdnych Wojen. Dostępne są szczegółowe informacje o filmach (z 1. i 2. trylogii) oraz o postaciach, planetach i pojazdach, które się w nich pojawiły. Aplikacja posiada wyszukiwarkę, która znajduje wpisy w zbiorze danych na podstawie podanej frazy.

Każdy widok szczegółów posiada odnośniki pozwalające w łatwy sposób przejść do powiązanych obiektów, np. domowej planety danej postaci.

Na ekranie zawierającym informacje o filmie pojawia się animowany element odgrywający w pętli tzw. *opening crawl* z oryginalnym tekstem znanym z danego filmu.

Aplikacja wspiera deep linki, pozwalające przejść bezpośrednio do ekranu szczegółów filmów, postaci, planet, itd. Mają one następującą postać:
```
swdb://starwarsdb/<rodzaj>/<id>
```
gdzie `<rodzaj>` to rodzaj obiektu (`people`, `films`, `planets`, `species`, `starships`, `vehicles`). `<id>` można pominąć, wtedy przechodzimy do widoku listy danej kategorii.
Przykładowe deep-linki:

* [swdb://starwarsdb/films/1](swdb://starwarsdb/films/1)
* [swdb://starwarsdb/planets/2](swdb://starwarsdb/planets/2)
* [swdb://starwarsdb/people/3](swdb://starwarsdb/people/3)
* [swdb://starwarsdb/starships](swdb://starwarsdb/starships)

## Integracje
Dane pobierane są z zewnętrznego, publicznego API: [https://swapi.dev/](https://swapi.dev/). Zbiory danych nie są przesyłane w całości, ale w stronach po max. 10 elementów i ładowane automatycznie, gdy użytkownik zbliży się do końca listy. Funkcja wyszukiwania jest również udostępniania przez API.

## Wymagania opcjonalne
* Wspierane platformy: Android, iOS, Web
* Wzorzec BLoC do zarządzania stanem aplikacji
* Navigator 2.0 do nawigacji
* Animacje
* Deep linki

## Instrukcja
* Na ekranie głównym dostępne jest 6 kategorii obiektów, których dane można przeglądać
* Po wybraniu kategorii pojawia się lista obiektów. Podczas przewijania listy automatycznie pobierane są kolejne obiekty.
* W prawym górnym rogu jest przycisk, pozwalający przejść do wyszukiwarki
* Po kliknięciu w element listy przechodzimy do widoku szczegółów, który jest unikalny dla danej kategorii.
* Na ekranie szczegółów, pod informacjami ogólnymi, znajdują się rozwijane listy powiązanych obiektów (podzielone na kategorie).
* Do każdego widoku listy/szczegółów obiektu można się dostać również za pomocą deep linka.
