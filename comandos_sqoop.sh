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