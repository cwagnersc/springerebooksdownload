#!/bin/bash

# Script para baixar arquivos pdf do site Springer Ebooks
# baseado no blog encontrado no endereço: https://aabdelfattah.me/2014/02/17/a-linux-bash-script-to-download-all-pdf-files-from-a-page/

# Primeiro baixe o arquivo PDF para um diretório e extraia o conteúdo que interessa com o seguinte comando:

# pdf2txt Springer\ Ebooks.pdf.pdf| grep http > linksSpringerEbooks.txt

# Se não tiver o comando acima no seu Linux, basta instalar com:
# sudo apt install python3-pdfminer

# Agora precisamos extrair os links de downloads dos arquivos de dentro das páginas html de cada livro


# lynx --dump 'http://link.springer.com/openurl?genre=book&isbn=978-0-306-48048-5' | awk '/http/{print $2}' | grep  pdf  | head -1 > link_tmp.txt

for pagina in $(cat linksSpringerEbooks.txt)
     do lynx --dump $pagina | awk '/http/{print $2}' | grep  pdf  | head -1 >> link_tmp.txt 
done

for i in $( cat link_tmp.txt )
    do wget $i
done

# Extrai os títulos diretamente da página de cada livro
for t in $(cat linksSpringerEbooks.txt)
    do  wget   -qO- $t |   perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si'| cut  -f1 -d\| >> titulos.txt
done

# Retira o espaço no final do título das páginas para compor o nome final do arquivo
for t in (cat titulos.txt); do
    echo $t | awk '{gsub(/^ +| +$/,"")} {print $0}' >> titulos2.txt
done

# Retira o nome do arquivo baixado da url
cut -f7 -d\/ link_tmp.txt > arquivos.txt

# Compoem um arquivo com o titulo do livro e o nome do arquivo baizado
paste -d\| titulos2.txt arquivos.txt > titulo-arquivo.txt

# Lê o arquivo com o título e o arquivo 
for ta in $(cat titulo-arquivo.txt ); do
    echo $ta | read -d\| titulo arquivo
    if test -f $arquivo
        echo renomeando arquivo $arquivo para $titulo.pdf
        mv $arquivo $titulo.pdf
    fi
done

