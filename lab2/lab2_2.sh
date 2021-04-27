#!/bin/bash -eu
#
# zadanie 2
# +0.5 - Napisać skrypt, który w zadanym katalogu (1. parametr) usunie 
# wszystkie uszkodzone dowiązania symboliczne, a ich nazwy wpisze do pliku 
# (2. parametr), wraz z dzisiejszą datą w formacie ISO 8601.
#

DIR_NOT_FOUND=3
FILE_NOT_FOUND=300

SOURCE_DIR=${1}
TARGET_FILE=${2}

if [[ ! -d ${SOURCE_DIR} ]]; then
    echo "Katalog ${SOURCE_DIR} nie istnieje."
    exit "${DIR_NOT_FOUND}"
fi

if [[ ! -f ${TARGET_FILE} ]]; then
    echo "Plik ${TARGET_FILE} nie istnieje."
    exit "${FILE_NOT_FOUND}"
fi

SRC_CONTENT=$(ls ${SOURCE_DIR})

for PLIK in ${SRC_CONTENT}; do
    if [[ ! -e $(readlink -f ${SOURCE_DIR}/${PLIK}) ]]; then
        rm ${SOURCE_DIR}/${PLIK}
        echo "${PLIK} $(date -I)" >> ${TARGET_FILE}
    fi
done