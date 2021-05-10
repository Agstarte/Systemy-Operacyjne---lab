#!/bin/bash -eu

# +2.0


# Znajdź w pliku access_log zapytania, które mają frazę ""denied"" w linku
# cat access_log | grep "denied"

# Znajdź w pliku access_log zapytania typu POST
# cat access_log | grep "\"POST "

# Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
# cat access_log | grep "^64\.242\.88\.10 "

# Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
# cat access_log | grep "^.*[a-zA-Z].* - - "
# tutaj biorę pod uwagę wszystkie zapytania, których nadawca ma w nazwie co najmniej jedną literę

# Znajdź w pliku access_log unikalne zapytania typu DELETE
# cat access_log | uniq -u | grep "\"DELETE "

# Znajdź unikalnych 10 adresów IP w access_log
# cat access_log | awk '{ print $1 } ' | sort | uniq -u | grep -v "[A-Za-z]" | head -10
