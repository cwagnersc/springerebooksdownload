#!/bin/bash

for t in $(cat linksSpringerEbooks.txt)
    do  wget   -qO- $t |   perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si'| cut  -f1 -d\| >> titulos.txt
done

