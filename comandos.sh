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




# HIVE
# HIVE SQL

# listar todos os DB
show database;

# estrutura do bd
desc database <nomeBD>;

# listar tabelas
show tables;

# estrutura da tabela
desc <nomeTabela>;
desc formatted <nomeTabela>;
desc extended <nomeTabela>;

# criar o banco de dados
create database <nomeBanco>;

# local diferente do conf.Hive
create database <nomeBanco> location "/diretorio";

# adicionar comentario
create database <nomeBanco> comment "descrição";
create database test location "/user/hive/warehouse/test" comment "banco de dados para treinamento";
default
/user/hive/warehouse/test.db 

# tabela interna
create table user(cod int, name string);
drop table; # apaga os dados e metadados
# tabela externa
create external table e_user(cod int, name string) location '/user/semantix/data_users';
drop table
# usar para compartilhar os dados com outras ferramentas
# apaga apenas os metadados
# dados ficam armazenado no sistema de arquivos

# tipos de dados
INT, SMALLINT, TINYINT, BIGINT, BOOLEAN, FLOAT, DOUBLE, DECIMAL, STRING, VARCHAR, CHAR 
# tipos complexos
ARRAY, MAP(chave->valor), STRUCT, UNION

# Leitura de dados
# definir delimitadores
row format delimited
fields terminated by '<delimitador>'
lines terminated by '<delimitador>'
# Delimitadores 'qualquer coisa', \b (backspace), \n (newline), \t (tab)

# pular um numero de linhas de leitura do arquivo
tblproperties("skip.header.line.count"="<numero de linhas>");

# definir localizacao dos dados (tabela externa)
location '/user/cloudera/data/client';

# Ex tabela externa
create external table user(
    id int,
    name String,
    age int
) row format delimited fields terminated by '\t' lines terminated by '\n' stored as textfile location '/user/cloudera/data/client';

# Acessar o Hive
docker exec -it hive-server bash
# Client beeline
beeline -u jdbc:hive2://localhost:10000

# Exercicio criar tabela
# Ex tabela interna
# entrar no banco
create database helio;
use helio;
create table pop(
    zipcode int,
    tal_population int,
    median_age float,
    total_males int,
    total_females int,
    total_households int,
    average_household_size float
) row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile tblproperties("skip.header.line.count"="1");


# Inserir dados
insert into table <nomeTabela> partition(<partition>='<value>') values (<campo>,<value>), (<campo>,<value>), (<campo>,<value>);
# Ex;
insert into users values (10, 'Rodrigo'), (11, 'Augusto');
insert into users partition(data=now()) values(10, 'Rodrigo');
insert into users select * from cliente;

# Carregar dados
# Carregar dados no sistema de arquivos local
hive> load data inpath <diretorio> into table <nomeTabela>;
# Ex
load data local inpath '/home/cloudera/data/test' into table alunos;
load data inpath '/user/cloudera/data/test' overwrite into table alunos partition(id)

# Selecionar dados
select * from <nomeTabela> <where> <group by> <having> <order by> <limit n>;
# inner join, letf outer, rigth outer, full outer
# select * from a join b on a.valor = b.valor;

# views
create view <nomeView> as select * from nomeTabela;

# Particionamento Hive
# criacao da tabela particionada
create table user(
    id int,
    name String,
    age int
)
partitioned by (data String)
clustered by (id) into 4 buckets;

# criar novas particoes manualmente
# particionamento estatico
alter table <nomeTabela> add partition(<particao>='<valor>')
# Ex criar uma particao para cada dia
alter table logs add partition(data='2019-21-02')

# particionamento dinamico
insert overwrite table user_cidade partition(cidade) select * form user;
# ativar o particionamento dinamico
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

# visualizar particoes de uma tabela
show partitions user;

# excluir particoes
alter table user drop partition (city='SP')

# alterar nome da particao
alter table user partition city rename to partition state;

# reparar tabela
msck repair table <nomeTabela>

# Exercicio
create external table nascimento(
    nome String,
    sexo String,
    frequencia int
) 
partitioned by (ano int) 
row format delimited 
fields terminated by ',' 
lines terminated by '\n' 
stored as textfile 
location '/user/aluno/helio/data/nascimento';

# Tipos de arquivo
# Adicionar o parametro stored na criação da tabela
stored as <formatoArquivo>
TEXTFILE (Padrão)
SEQUENCEFILE
RCFILE
ORC
PARQUET
AVRO 
JSONFILE

# tip de compressão
# Se o arquivo mapred-site.xml nao estiver configurado pode setar manualmente
SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=<codec>;
SET mapred.output.compression.type=BLOCK;

#CODEC
gzip:org.apache.hadoop.io.compress.GzipCodec
bzip2:org.apache.hadoop.io.compress.Bzip2Codec
LZO:com.hadoop.compression.lzo.LzopCodec
Snappy:org.apache.hadoop.io.compress.SnappyCodec
Deflate:org.apache.hadoop.io.compress.DeflateCodec

# add parametro de compressao
stored as <formatoArquivo> tblproperties('<formatoArquivo>.compress'='<CompressaoArquivo>');

# Ex tabela
create table user(
    id int,
    name String,
    age int
)
partitioned by (data String)
clustered by (id) into 256 buckets
stored as parquet tblproperties('parquet.compress'='SNAPPY');



create table pop_parquet(
    zipcode int,
    tal_population int,
    median_age float,
    total_males int,
    total_females int,
    total_households int,
    average_household_size float
) row format delimited fields terminated by ',' lines terminated by '\n' stored as parquet tblproperties("skip.header.line.count"="1");

create table pop_parquet_snappy(
    zipcode int,
    tal_population int,
    median_age float,
    total_males int,
    total_females int,
    total_households int,
    average_household_size float
) row format delimited fields terminated by ',' lines terminated by '\n' stored as parquet tblproperties('parquet.compress'='SNAPPY');


# instalar banco de dados relacional para testes

# copiar os dados do local para o container database
docker cp input/exercices-data/db-sql database:/

# acessar o container database
docker exec -it database bash

# instalar o bando de dados teste
# diretorio /db-sql - DB Employees (já existe)
cd /db-sql
mysql -psecret < employees.sql
# diretorio /db-sql/sakila - BD sakila
cd db-sql/sakile/
mysql -psecret < sakile-mv-schema.sql
mysql -psecret < sakile-mv-data.sql


# SQOOP
# Comandos

sqoop <comando>
help, version, import, import-all-tables, export, validation, job, metastore, merge, codegen, create-hive-table, eval, list-databases, list-tables

sqoop help inport

--connect, --connect-managerm --driver, --hadoop-mapred-home, --help, --password-file, -P, --password, --username, --verbose, ...

# acessar o namenode
docker exec -it namenode bash

sqoop version

# listar banco de dados
sqoop list-databases --connect jdbc:mysql://database --username usuario --password senha

# listar tabelas 
sqoop list-tables --connect jdbc:mysql://database/employees --username usuario --password senha

# consultar tabela
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret --query "SELECT * FROM employees limit 15"

# criar tabela
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret 
           --query "create table setor(cod int92), name varchar(30))"
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret 
           --query "describe setor"
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret 
           --query "insert into setor values (1, 'vendas')"
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret 
           --query "select * from setor"
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret 
           --query "select * from employees where first_name like 'A'"

sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret --query "insert into departments values ('d010', 'BI')"   
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret --query "select * from departments"        
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret --query "create table benefits(cod int(2) AUTO_INCREMENT PRIMARY KEY, name varchar(30))"
sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret --query "insert into benefits values (null, 'food vale')"  


# importar dados rdbms para o hdfs
sqoop impport --connect jdbc:mysql://database/employees --username=root --password=secret 

# opções
--table <nomeTabela>
--columns "id,last_name"
--where "state='SP'"

# diretórios

# padrao
/user/<username>/<tablename>

# especificar manualmente
--target-dir /user/root/db
--warehouse-dir /user/root/db

# Ex. importar tabela departments
--target-dir /data = /data
--warehouse-dir /data = /data/departments

# sobrescrever o diretório
--warehouse-dir /user/cloudera/db -delete-target-dir

# anexar so dados no diretório
--warehouse-dir /user/cloudera/db -append

# delimitadores
--fields-terminated-by <delimitador>
--lines-terminated-by <delimitador>

'qualquer coisa', \b, \n, \t, \0(NUL)

# Ex
sqoop import --fields-terminated-by '\t' --lines-terminated-by '&'

# Exercicios
sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table employees --warehouse-dir /user/hive/warehouse/db_test_a

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table employees --where "gender='M'" --warehouse-dir /user/hive/warehouse/db_test_b

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table employees --columns "first_name,last_name" --fields-terminated-by \t --warehouse-dir /user/hive/warehouse/db_test_c

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table employees --columns "first_name,last_name" --fields-terminated-by ":" --warehouse-dir /user/hive/warehouse/db_test_c -delete-target-dir

# Paralelismo

# Quantidade de mapeadores  padrao (4)
sqoop import -m 2
# coluna com chave primaria
-num-mappers 8  

-num-mappers 1
# manipular tabelas automaticamente
-auto-reset-to-one-mapper


# -num-mapers >1 = erro
# dividir mapeadores em uma coluna sem chave
--split-by id

# valores nulos da coluna (registros serão ignorados)

# valor escrito para um campo nulo de numero
--null-non-string '-1'
# valor escrito para um campo null
--null-string 'NA'

# importacao Hive e Impala
--null-non-strin '\\N' --null-string '\\N'

# formato e compressão dos dados

# padrao (texto)
sqoop import --as-textfile
--as-parquetfile
--as-avrodatafile
--as-SEQUENCEFILE

# padrao (gzip)
Gzip - org.apache.hadoop.io.compress.GzipCodec
Bzip2 - org.apache.hadoop.io.compress.BZip2Codec
Snappy - org.apache.hadoop.io.compress.SnappyCodec

# habilitar e escolher compressao
--compress
--compression-codec <codec>

# Exercicios

sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret \
--query "create table cp_titles_date(title varchar(30), to_date date) select title, to_date from titles"

sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret \
--query "update table cp_titles_date set to_date=NULL where title='Staff'"


sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table titles \
--warehouse-dir /user/hive/warehouse/db_test_4 -m 4  --as-parquetfile

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table titles \
--warehouse-dir /user/hive/warehouse/db_test_5 -m 8  --as-parquetfile --compress --compression-codec org.apache.hadoop.io.compress.SnappyCodec

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table cp_titles_date \
--warehouse-dir /user/hive/warehouse/db_test_6 -m 6 --as-parquetfile


sqoop import -Dorg.apache.sqoop.splitter.allow_text_splitter=true -connect jdbc:mysql://database/employees --username=root --password=secret --table cp_titles_date \
--warehouse-dir /user/hive/warehouse/db_test2_title -m 4 --split-by title

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table cp_titles_date \
--warehouse-dir /user/hive/warehouse/db_test2_to_date -m 4 --split-by to_date

hdfs dfs -ls -h -R /user/hive/warehouse/db_test2_date

hdfs dfs -ls -h -R /user/hive/warehouse/db_test2_title

# Sqoop job
# importacao/exportacao incremental
sqoop job --<atributo>
--create <myjob> --import ...
sqoop job --list
sqoop job --show <myjob>
sqoop job --exec <myjob>
sqoop job --delete <myjob>

# carga incremental

# anexar todos os dados
sqoop import --append --where 'id_venda>10'

# apenas os novos dados
sqoop import --incremental append --check-column id_venda --last-value 50

# lastmodified (atualizar os novos dados)
sqoop import --incremental lastmodified --merge-key data_id --check-column data_venda --last-value '2021-01-18'

# Exercicios

create table cp_rental_append select rental_id, rental_date from rental;
create table cp_rental_id select rental_id, rental_date from cp_rental_append;
create table cp_rental_date select rental_id, rental_date from cp_rental_append;

sqoop import --connect jdbc:mysql://database/sakila --username=root --password=secret --table cp_rental_append \
--warehouse-dir /user/hive/warehouse/db_test3 -m 1

sqoop import --connect jdbc:mysql://database/sakila --username=root --password=secret --table cp_rental_id \
--warehouse-dir /user/hive/warehouse/db_test3 -m 1

sqoop import --connect jdbc:mysql://database/sakila --username=root --password=secret --table cp_rental_date \
--warehouse-dir /user/hive/warehouse/db_test3 -m 1

hdfs dfs -ls -h -R /user/hive/warehouse/db_test3

hdfs dfs -cat /user/hive/warehouse/db_test3/cp_rental_append/part-m-00000 | head -n 5

docker cp input/exercises-data/db-sql/ database:/

cd /db-sql/sakila

mysql -psecret < insert_rental.sql


sqoop import --append --connect jdbc:mysql://database/sakila --username=root --password=secret --table cp_rental_append \
--warehouse-dir /user/hive/warehouse/db_test3 -m 1

hdfs dfs -cat /user/hive/warehouse/db_test3/cp_rental_append/part-m-00000 | head -n 5

select * from cp_rental_id order by rental_id desc limit 5;

sqoop import --incremental append -check-column rental_id --last-value 16055 \
--connect jdbc:mysql://database/sakila --username=root --password=secret --table cp_rental_id \
--warehouse-dir /user/hive/warehouse/db_test3 -m 1

hdfs dfs -cat /user/hive/warehouse/db_test3/cp_rental_id/part-m-00000 | head -n 5


sqoop import --incremental lastmodified --merge-key rental_id --check-column rental_date --last-value '2006-02-14 15:16:03' \
--connect jdbc:mysql://database/sakila --username=root --password=secret --table cp_rental_date \
--warehouse-dir /user/hive/warehouse/db_test3 -m 1

hdfs dfs -tail /user/hive/warehouse/db_test3/cp_rental_date/part-m-00000


# importar dados no Hive

# caminho padrao
/user/hive/warehouse/
# formato Parquet e compressao Snappy

# mapeamento para java
--map-column-java id=String,value=Integer
# mapeamento para hive
--map-column-hive id=String,value=Integer

sqoop import --connect ...
--hive-import
# sobrescever os dados
--hive-overwrite
# falha se ja existir tabela
--create-hive-table
# nome da tabela
--hive-table <db_name>.<table_name>

# Ex:
sqoop import --connect jdbc:mysql://database/sakila --username=root --password=secret --table employees \
--warehouse-dir /user/hive/warehouse/teste.db \
--hive-import --create-hive-table --hive-table teste.user

# exportar dados do hdfs para SGDB

sqoop export --connect jdbc:mysql://database/log --username=root --password=secret \

# diretorio de leitura do hdfs
--export-dir <diretorio>
# nomde da tabela no SGBD
--table <nomeTabela>
# update mode (atualizacao)
--update-mode
updateonly # default (novas linhas)
allowinsert # atualiza se existe e insere se não existe

# Obs Criar a tabela product_recommendations no SGDB antes de exportar

sqoop export --connect jdbc:mysql://database/log --username=root --password=secret \
--export-dir /user/root/recommender_output --update-mode allowinsert --table product_recommendations

# Exercicios
sqoop import --append --connect jdbc:mysql://database/employees --username=root --password=secret --table titles \
--warehouse-dir /user/aluno/helio/data -m 1
hdfs dfs -ls -h -R /user/aluno/helio/data/titles

sqoop import --connect jdbc:mysql://database/employees --username=root --password=secret --table titles \
--warehouse-dir /user/hive/warehouse/helio.db -m 1 --hive-import --create-hive-table --hive-table helio.titles

docker exec -it hive-server bash

beeline -u jdbc:hive2://localhost:10000

select * from titles limit 10;


docker exec -it database bash

mysql -p

use employees;

delete from titles;

docker exec -it namenode bash


sqoop eval --connect jdbc:mysql://database/employees --username=root --password=secret \
--query "select count(*) from titles;"


sqoop export --connect jdbc:mysql://database/employees --username=root --password=secret \
--export-dir /user/aluno/helio/data/titles --update-mode allowinsert --table titles

# HBASE
# Armazenamento de dados

# Comandos básicos
hbase shell
status
version
table_help
whoami
help "comando"
create, list, disable, is_disabled, enable, is_enabled, describe, alter, exists, drop, drop_all
put, get, delete, deleteall, scan, count, truncate

# inicializar o hbase
docker exec -it hbase-master bash
hbase shell

# criar tabela
create 'nomeTabela',{NAME=>'familia'}

# Ex
create 'clientes', {NAME=>'endereco', VERSIONS=>2}, {NAME=>'pedido'}
create 'clientes', 'endereco', 'pedido'

list
describe 'nomeTabela'
drop 'nomeTabela'  ou drop_all 'c.*'
exists 'nomeTabela'
# desabilitar tabela
disable 'nomeTabela'
scan 'nomeTabela'
disable_all 'r.*'
is_disabled 'nomeTabela'
enable 'nomeTabela'
is_enabled nomeTabela
# desabilitar e recriar
truncate 'nomeTabela'

# insercao de dados
put 'nomeTabela','chave','familia:coluna','valor'
put 'clientes','emiranda','endereco:cidade','BH'
put 'clientes','emiranda','endereco:estado','MG'
# alterar dados
put 'clientes','emiranda','pedido:nitem','1234A'

# leitura de dados
get (chave) ou scan (tabela)

get 'nomeTabela','chave'
get 'clientes','emiranda'

get 'nomeTabela','chave', {COLUMNS=>['familia']}
get 'clientes', 'emiranda', {COLUMNS=>['endereco']}

# consulta valores da chave pela coluna
get 'clientes', 'emiranda', {COLUMNS=>['endereco:cidade']}

# scan
scan 'clientes'
scan 'clientes',{COLUMNS=>['endereco']}
scan 'clientes',{COLUMNS=>['endereco:cidade']}
scan 'clientes',{COLUMNS=>['endereco:cidade'], VERSIONS=>5}

# todas as linhas pela chave
scan 'clientes',{STARTROW=>'emi', COLUMNS=>['endereco']}

# deletar dados
delete 'nomeTabela', 'chave', 'familia:coluna'
# deletar coluna
delete 'clientes', 'emiranda', 'endereco:cidade'
delete 'clientes','emiranda', 'endereco'
# deletar uma chave
deleteall 'clientes', 'emiranda'

# alterar a familia da coluna
alter 'nomeTabela', {NAME=>'familia', VERSIONS=>NUM}
# Ex.
alter 'clientes', {NAME=>'pedido', VERSIONS=>5}

# deletar a familia de coluna
alter 'nomeTabela', 'delete'=>'familia'
alter 'employee', 'delete'=>'professional'

# count
count 'nomeTabela'
count 'clientes'

# Exericios
1 - 
create 'controle', 'produto', 'fornecedor'
put 'controle','1','produto:nome','ram'
put 'controle','2','produto:nome','hd'
put 'controle','3','produto:nome','mouse'
put 'controle','1','produto:qdt','100'
put 'controle','2','produto:qtd','50'
put 'controle','3','produto:qtd','150'
put 'controle','1','fornecedor:nome','TI Comp'
put 'controle','2','fornecedor:nome','Peças PC'
put 'controle','3','fornecedor:nome','Inf Tec'
put 'controle','1','fornecedor:estado','SP'
put 'controle','2','fornecedor:estado','MG'
put 'controle','3','fornecedor:estado','SP'


2 - list
describe 'controle'
scan 'controle'

ROW                                     COLUMN+CELL                                                                                                       
 1                                      column=fornecedor:estado, timestamp=1620092733089, value=SP                                                       
 1                                      column=fornecedor:nome, timestamp=1620092716904, value=TI Comp                                                    
 1                                      column=produto:nome, timestamp=1620092655075, value=ram                                                           
 1                                      column=produto:qdt, timestamp=1620092701944, value=100                                                            
 2                                      column=fornecedor:estado, timestamp=1620092737338, value=MG                                                       
 2                                      column=fornecedor:nome, timestamp=1620092724647, value=Pe\xC3\xA7as PC                                            
 2                                      column=produto:nome, timestamp=1620092673143, value=hd                                                            
 2                                      column=produto:qtd, timestamp=1620092706905, value=50                                                             
 3                                      column=fornecedor:estado, timestamp=1620092742642, value=SP                                                       
 3                                      column=fornecedor:nome, timestamp=1620092728648, value=Inf Tec                                                    
 3                                      column=produto:nome, timestamp=1620092697085, value=mouse                                                         
 3                                      column=produto:qtd, timestamp=1620092712250, value=150                                                            
3 row(s) in 0.0350 seconds


3 - count 'controle'
=> 3

4 - alter 'controle', {NAME=>'produto', VERSIONS=>3}

5 - put 'controle','2','produto:qtd','200'

6 -
get 'controle', '2', {COLUMNS=>['produto:qtd'], VERSIONS=>2}

COLUMN                                  CELL                                                                                                              
 produto:qtd                            timestamp=1620092840240, value=200                                                                                
 produto:qtd                            timestamp=1620092706905, value=50   


7 - 
deleteall 'controle', '1'
deleteall 'controle', '3'

8 - delete 'controle', '2', 'fornecedor:estado'

9 - scan 'controle'

ROW                                     COLUMN+CELL                                                                                                       
 2                                      column=fornecedor:nome, timestamp=1620092724647, value=Pe\xC3\xA7as PC                                            
 2                                      column=produto:nome, timestamp=1620092673143, value=hd                                                            
 2                                      column=produto:qtd, timestamp=1620092840240, value=200                                                            
1 row(s) in 0.0220 seconds






























