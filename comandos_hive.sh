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