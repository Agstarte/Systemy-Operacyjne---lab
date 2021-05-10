#!/bin/bash -eu

# +1.5
# We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/
# We wszystkich plikach w katalogu ‘groovies’ po każdej linijce z 'class' dodać '  String marker = '/!@$%/''
# We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'

# 1
SRC_CONTENT=$(ls groovies)

for FILE in ${SRC_CONTENT}; do
    # 1
    sed -i 's|\$HEADER\$|/temat/|' groovies/${FILE} 
    # 2
    sed -i "/class/ a   String marker = '/!@$%/'" groovies/${FILE}
    # 3
    sed -Ei "s|.*Help docs:.*||" groovies/${FILE}
done
