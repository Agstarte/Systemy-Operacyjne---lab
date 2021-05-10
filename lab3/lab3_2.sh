#!/bin/bash -eu

# +1.5
# - Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą. 
# Wyniki zapisz na standardowe wyjście błędów.
# - Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 
# lub $9.99. Nie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). 
# Wyniki zapisz na standardowe wyjście błędów
# - Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim 
# oktecie ma po jednej cyfrze. Wyniki zapisz na standardowe wyjście błędów

# 1
# cat yolo.csv | grep "^[0-9]*[13579]," 2> lab3_2_log_1.txt

# 2 
# cat yolo.csv | sed 1d | grep -E '(\$2\.99|\$5\.99|\$9\.99)[A-Z]' |  cut -d',' -f3,7 2> lab3_2_log_2.txt
# cat yolo.csv | sed 1d | grep -E '\$(2|5|9)\.99[A-Z]' |  cut -d',' -f3,7 2> lab3_2_log_2.txt

# 3
# cat yolo.csv | sed 1d | cut -d',' -f6 | grep -E '^[0-9]\.[0-9]\.[0-9]*\.[0-9]*' 2> lab3_2_log_2.txt

