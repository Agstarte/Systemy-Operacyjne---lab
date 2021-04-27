#!/bin/bash -eu
#
#  +1.0 - Napisać skrypt, który w zadanym katalogu (jako parametr) każdemu:
# - plikowi regularnemu z rozszerzeniem .bak odbierze uprawnienia do edytowania
# dla właściciela i innych
# - katalogowi z rozszerzeniem .bak (bo można!) pozwoli wchodzić do środka tylko innym
# - w katalogach z rozszerzeniem .tmp pozwoli każdemu tworzyć i usuwać jego pliki
# - plikowi z rozszerzeniem .txt będą czytać tylko właściciele, edytować grupa właścicieli,
# wykonywać inni. Brak innych uprawnień
# - pliki regularne z rozszerzeniem .exe wykonywać będą mogli wszyscy, ale zawsze wykonają
# się z uprawnieniami właściciela (można przetestować na skompilowanym https://github.com/szandala/SO2/blob/master/lab2/suid.c)
# 

DIR_NOT_FOUND=3

SOURCE_DIR=${1}

if [[ ! -d ${SOURCE_DIR} ]]; then
    echo "Katalog ${SOURCE_DIR} nie istnieje."
    exit "${DIR_NOT_FOUND}"
fi

SRC_CONTENT=$(ls ${SOURCE_DIR})

for PLIK in ${SRC_CONTENT}; do
    if [[ -L ${SOURCE_DIR}/${PLIK} ]]; then
        echo "${PLIK} jest dowiązaniem symbolicznym."
    fi

    if [[ -f ${SOURCE_DIR}/${PLIK} ]]; then
        echo "${PLIK} jest plikiem regularnym."
    fi

    if [[ -d ${SOURCE_DIR}/${PLIK} ]]; then
        echo "${PLIK} jest katalogiem."
    fi
done

