# acessar o container namenode
docker exec -it namenode bash

# sistema hdfs

hadoop fs -<comando> [argumentos]

hdfs dfs -<comando>[argumentos]

# help
hadoop fs -help
hdfs dfs -help
hdfs dfs -help ls

# criar diretorio
mkdir <diretorio>
# criar estrutura de diretorios
mkdir -p <diretorio>/<diretorio/<diretorio>
# listar diretorio
ls <diretorio>
Recursivo: -Recursivo
# remocao arquivos e diretorios
rm <src>
-r # deletar diretorio
-skipTrash # remover permanentemente

# enviar dados

# HDFS/LOCAL

# enviar arquivo ou diretorio
put <src> <dst>
-f # sobrescreve o destino
-l # forca um fator de replicacao
copyFromLocal <src> <dst>

# mover arquivo ou diretorio
# put que deletea do local
moveFromLocal <src> <dest>

# receber arquivo ou diretorio
get <src> <dst>
-f
# cria um unico arquivo mesclado
getmerge <src> <dst>

# mover para o local
# get que deleta a copia do hdfs
moveToLocal <src> <localdst>

# HDFS/HDFS
cp <src> <dst> # copiar arquivo ou diretorio  Arg: -f
mv <src> <dst> # mover arquivo ou diretorio
mv <arquivo1> <arquivo2> <dst>

# comandos
du -h <diretorio> # mostrar o uso do disco
df -h <diretorio> exivir o espaco livre

# mostrar as informacoes do diretorio
stat <diretorio>
hdfs dfs -stat %r name.txt #fator de replicacao
hdfs dfs %o name.txt #tamanho do bloco

# contar numero de diretorios, um de arquivos e tamanho do arquivo especifico
count -h <diretorio>

# esvaziar a lixeira
expunge

cat <arquivo> # ver conteudo do arquivo
setrep <num repeticoes> <arquivo> # alterar o fator de replicacao do arquivo
touchz <diretorio> # cria um arquivo de registro com data e hora
checksum <arquivo> # retorna as informacoes da soma de verificacao
tail -f <arquivo> # mostra o ultimo 1kb no console
hdfs dfs -tail name.txt
hdfs dfs -cat name.txt | head -n 1

# localizacao

# localiza todos os arquivos que correspondem a expressao
find <caminho> <procura> -print
hdfs dfs -find / -name data
hdfs dfs -find / -iname Data -print  # /user/semantix/input/data
hdfs dfs -find input/ -name \*.txt -print # input/teste1.txt, input/teste2.txt