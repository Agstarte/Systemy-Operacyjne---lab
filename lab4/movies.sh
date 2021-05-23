#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-y ROK\n\tSearch movies newer than ROK"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m${*}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath -- *)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

#+ 1.0: Dodaj opcję -y ROK: wyszuka wszystkie filmy nowsze niż ROK.
function query_rok () {
    # Returns list of movies from ${1} newer than ${2}
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    
    for MOVIE_FILE in ${MOVIES_LIST}; do
        year="$(grep "| Year" "${MOVIE_FILE}" | cut -d':' -f2)"        
        if [[ year -gt ${QUERY} ]]; then           
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}



function print_xml_format () {
    local -r FILENAME=${1}
    local TEMP
    TEMP=$(cat "${FILENAME}")

    # TODO: change 'Author:' into <Author>
	TEMP=${TEMP//| Author:/<Author>}
    # TODO: change others too
    TEMP=${TEMP//| Title:/<Title>}
    TEMP=${TEMP//| Year:/<Year>}
    TEMP=${TEMP//| Runtime:/<Runtime>}
    TEMP=${TEMP//| IMDB:/<IMDB>}
    TEMP=${TEMP//| Tomato:/<Tomato>}
    TEMP=${TEMP//| Rated:/<Rated>}
    TEMP=${TEMP//| Genre:/<Genre>}
    TEMP=${TEMP//| Director:/<Director>}
    TEMP=${TEMP//| Actors:/<Actors>}
    TEMP=${TEMP//| Plot:/<Plot>}


    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # TODO: replace first line of equals signs
    TEMP=$(echo "${TEMP}" | sed '2 s/^.*$/<movie>/')
    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

# ANY_ERRORS=false

while getopts ":hd:t:a:f:x:y" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    y)
        SEARCHING_ROK=true
        QUERY_ROK=${OPTARG}
        ;;
    f)
        FILE_4_SAVING_RESULTS=${OPTARG}
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=${OPTARG}
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        # ANY_ERRORS=true
        exit 1
        ;;
  esac
done


if [[ "${MOVIES_DIR:-}" == "" ]]; then
    print_error "No -d option used"
    exit 1
fi

if [[ ! -d ${MOVIES_DIR} ]]; then
    print_error "MOVIES_DIR is not a directory"
    exit 1
fi


MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

if ${SEARCHING_ROK:-false}; then
    MOVIES_LIST=$(query_rok "${MOVIES_LIST}" "${QUERY_ROK}")
fi

if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo "Found 0 movies :-("
    exit 0
fi

if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    # TODO: add XML option
    if [[ ${OUTPUT_FORMAT} == "xml" ]]; then
        print_xml_format "${MOVIES_LIST}" "raw" | tee "${FILE_4_SAVING_RESULTS}"
    fi
    # + 0.5: Dotyczy opcji ‘-f’: jeżeli plik podany przez użytkownika nie posiada rozszerzenia '.txt' dodaj je

    if [[ "${FILE_4_SAVING_RESULTS}" != *.txt ]]; then
        mv "${FILE_4_SAVING_RESULTS}" "${FILE_4_SAVING_RESULTS}.txt"
    fi
    print_movies "${MOVIES_LIST}" "raw" | tee "${FILE_4_SAVING_RESULTS}"
fi
