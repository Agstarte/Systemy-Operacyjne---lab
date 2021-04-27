#!/bin/bash -eu
# 
# zadanie 1
#
# Napisać skrypt, który przyjmuje 2 parametry – 2 ścieżki do katalogów. 
# Z zadanego katalogu nr 1 wypisać wszystkie pliki po kolei, wraz z informacją:
# - czy jest to katalog
# - czy jest to dowiązanie symboliczne
# - czy plik regularny.
# Następnie (lub równolegle) utworzyć w katalogu nr 2 dowiązania symboliczne 
# do każdego pliku regularnego i katalogu z katalogu nr 1, dodając "_ln" 
# przed rozszerzeniem i zmieni nazwę na pisanę WIELKIMI literami, 
# np. magic_file.txt -> MAGIC_FILE_ln.txt
# 

DIR_NOT_FOUND=3
PARAMETERS_NOT_PASSED=4

SOURCE_DIR=${1}
TARGET_DIR=${2}

if [[ ! ${SOURCE_DIR} || ! ${TARGET_DIR} ]]; then
    echo "Nie podano wystarczającej ilości parametrów (2)."
    exit "${PARAMETERS_NOT_PASSED}"
fi

if [[ ! -d ${SOURCE_DIR} ]]; then
    echo "Katalog ${SOURCE_DIR} nie istnieje."
    exit "${DIR_NOT_FOUND}"
fi
    
if [[ ! -d ${TARGET_DIR} ]]; then
    echo "Katalog ${TARGET_DIR} nie istnieje."
    exit "${DIR_NOT_FOUND}"
fi

SRC_CONTENT=$(ls ${SOURCE_DIR})

for PLIK in ${SRC_CONTENT}; do
    if [[ -L ${SOURCE_DIR}/${PLIK} ]]; then
        echo "${PLIK} jest dowiązaniem symbolicznym."
    fi

    if [[ -f ${SOURCE_DIR}/${PLIK} ]]; then
        echo "${PLIK} jest plikiem regularnym."
        ln -s $(readlink -e ${SOURCE_DIR}/${PLIK}) ${TARGET_DIR}/${PLIK^^}_ln
    fi

    if [[ -d ${SOURCE_DIR}/${PLIK} ]]; then
        echo "${PLIK} jest katalogiem."
        ln -s $(readlink -e ${SOURCE_DIR}/${PLIK}) ${TARGET_DIR}/${PLIK^^}_ln
    fi
done




