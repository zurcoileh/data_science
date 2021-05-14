# SPARK
# Processamento de Dados
# Ferramentas
Apache Spark
Spark SQL # consulta em dados estruturados
Spark Streaming # processamento de stream
MLlib # machine learning
GraphX # processamento de grafos

# Spark shell versao 1 ou 2
pyspark # Python
spark-shell # Skala

# Acessar o Spark

# Adicionar o jar para salvar tabelas Hive:
curl -O https://repo1.maven.org/maven2/com/twitter/parquet-hadoop-bundle/1.6.0/parquet-hadoop-bundle-1.6.0.jar (Links para um site externo.)
docker cp parquet-hadoop-bundle-1.6.0.jar spark:/opt/spark/jars

docker exec -it spark bash
spark-shell

# Shell

# Welcome to
#       ____              __
#      / __/__  ___ _____/ /__
#     _\ \/ _ \/ _ `/ __/  '_/
#    /___/ .__/\_,_/_/ /_/\_\   version 2.4.1
#       /_/
         
# Using Scala version 2.11.12 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_201)
# Type in expressions to have them evaluated.
# Type :help for more information.

# scala> 

sc  # spark context
spark  # session

# DataFrame

# Text files (csv, json, plain)
# Binary (parquet, orc)
# Tables (hive, jdb)

# criar dataframe
# val (constante)
val <dataframe> = spark.read.<formato>('<arquivos>')

<formato>
textFile('arquivo.txt')
csv("arquivo.csv")
jdbc(jdbcUrl, "bd.tabela", connectionProperties)
load ou parquet("arquivo.parquet")
table("tableHive")
json("arquivo.json")
orc("arquivo.orc")

<arquivo>
"diretorio/"
"diretorio/*.log"
"arq1.txt,arq2.txt"
"arq*"

# ou quando é um novo formato que n existe (deve ser configurado)
val <dataframe> = spark.read.format("<formato").load("<arquivo>")
spark.read.option(..) # configurar o arquivo de leitura

# Ações
count (numero registros), 
first (primeira linha), 
take(n) (linhas do array), 
show(n) (primeiras linhas tabela), 
collect (informaçoes dos nós), 
distincts (remove os registros repetidos), 
write (salvar os dados), 
printSchema()  (visualizar a estrutura dos dados)

<dataframe>.<acao>

# Ex
val clientDF = spark.read.json("cliente.json")
clientDF.count()
clientDF.first()
clientDF.distinct()

# Salvar dados
dadosDF.write.save("arquivoParquet")
dadosDF.write.json("arquivoJson")
dadosDF.write.csv("arquivocsv")
dadosDF.saveASTable("tableHive") # /user/hive/warehouse

dadosDF.write.save("outputData")
hdfs dfs -ls /user/cloudera/outputData
dadosDF.write.mode("append").option("path","/user/root").saveASTable("outputData")


# Transformações
select, where, orderBy, groupBy, join, limit(n)

# Ex
val prodQtdDF = prodDF.select("nome","qtd")
val qtd50DF = prodQtdDF.where("qtd>50")
val qtd5ord0DF = qtd50DF.orderBy("nome")
qtd5ord0DF.show()
prodDF.select("nome","qtd").where("qtd>50").orderBy("nome")

count, max, min, mean, sum, pivot, agg (agregação adicional)
peopleDF.groupBy("setor").count()

# acessar atributo
"<atributo>", $"<atributo>", <dataframe>("<atributo")

prodDF.select("nome", "qtd").show()
prodDF.select($"nome", $"qtd" * 0,1).show()
prodDF.where(prodDF("nome").startsWith("A"))show()



# Exercicios
Criar o DataFrame jurosDF para ler o arquivo no HDFS “/user/aluno/<nome>/data/juros_selic/juros_selic.json”

1 - hdfs dfs -put /input/exercises-data/juros_selic/ /user/aluno/helio/data

2 - val jurosDF = spark.read.json("/user/aluno/helio/data/juros_selic/juros_selic.json")
jurosDF: org.apache.spark.sql.DataFrame = [data: string, valor: string]


3 - jurosDF.printSchema()
root
 |-- data: string (nullable = true)
 |-- valor: string (nullable = true)


4 - jurosDF.show(5)
+----------+-----+
|      data|valor|
+----------+-----+
|01/06/1986| 1.27|
|01/07/1986| 1.95|
|01/08/1986| 2.57|
|01/09/1986| 2.94|
|01/10/1986| 1.96|
+----------+-----+
only showing top 5 rows


5 - jurosDF.count()
res3: Long = 393

6 - val jurosDF10 = jurosDF.where("valor>10")

jurosDF10.show()
+----------+-----+
|      data|valor|
+----------+-----+
|01/01/1987|11.00|
|01/02/1987|19.61|
|01/03/1987|11.95|
|01/04/1987|15.30|
|01/05/1987|24.63|
|01/06/1987|18.02|
|01/11/1987|12.92|
|01/12/1987|14.38|
|01/01/1988|16.78|
|01/02/1988|18.35|
|01/03/1988|16.59|
|01/04/1988|20.25|
|01/05/1988|18.65|
|01/06/1988|20.17|
|01/07/1988|24.69|
|01/08/1988|22.63|
|01/09/1988|26.25|
|01/10/1988|29.79|
|01/11/1988|28.41|
|01/12/1988|30.24|
+----------+-----+
only showing top 20 rows



7 - jurosDF10.write.saveAsTable("helio.tab_juros_selic")
hdfs dfs -ls -R /user/hive/warehouse/helio.db/tab_juros_selic
-rw-r--r--   2 root supergroup          0 2021-05-05 02:07 /user/hive/warehouse/helio.db/tab_juros_selic/_SUCCESS
-rw-r--r--   2 root supergroup       1419 2021-05-05 02:07 /user/hive/warehouse/helio.db/tab_juros_selic/part-00000-e1caf7cc-fcbc-4cfa-9f64-90a3406bf1c8-c000.snappy.parquet


8 - val jurosHiveDF = spark.read.table("helio.tab_juros_selic")
jurosHiveDF: org.apache.spark.sql.DataFrame = [data: string, valor: string]

9 - jurosHiveDF.printSchema

root
 |-- data: string (nullable = true)
 |-- valor: string (nullable = true)

10 -jurosHiveDF.show(5)
+----------+-----+
|      data|valor|
+----------+-----+
|01/01/1987|11.00|
|01/02/1987|19.61|
|01/03/1987|11.95|
|01/04/1987|15.30|
|01/05/1987|24.63|
+----------+-----+
only showing top 5 rows

11 - jurosHiveDF.write.parquet("/user/aluno/helio/data/save_juros")

12 -

hdfs dfs -ls -R /user/aluno/helio/data/save_juros            
-rw-r--r--   2 root supergroup          0 2021-05-05 02:16 /user/aluno/helio/data/save_juros/_SUCCESS
-rw-r--r--   2 root supergroup       1419 2021-05-05 02:16 /user/aluno/helio/data/save_juros/part-00000-572df8e5-6ae1-4dde-b38c-e053702aad1f-c000.snappy.parquet

13 - 
val jurosHDFS = spark.read.load("/user/aluno/helio/data/save_juros")
jurosHDFS: org.apache.spark.sql.DataFrame = [data: string, valor: string]

14 - jurosHDFS.printSchema
root
 |-- data: string (nullable = true)
 |-- valor: string (nullable = true)


15 - jurosHDFS.show(5)
+----------+-----+
|      data|valor|
+----------+-----+
|01/01/1987|11.00|
|01/02/1987|19.61|
|01/03/1987|11.95|
|01/04/1987|15.30|
|01/05/1987|24.63|
+----------+-----+
only showing top 5 rows


# SCHEMAS
# inferir esquema automaticamente
# Ex.  
setor.csv  
1, vendas  
2, TI 
3, RH

scala> val sDF = spark.read.csv("setor.csv").printSchema()

_c0: string(nullable=true)
_c1: string(nullable=true)

scala> val sDF = spark.read.option("inferSchema", "true").csv("setor.csv").printSchema()

_c0: integer(nullable=true)
_c1: string(nullable=true)

# Ex. cabeçalho
setor.csv  
id, setor
1, vendas  
2, TI 
3, RH

scala> val sDF = spark.read.csv("setor.csv").printSchema()

_c0: string(nullable=true)
_c1: string(nullable=true)

scala> val sDF = spark.read.option("inferSchema", "true").option("header", "true").csv("setor.csv").printSchema()

id: integer(nullable=true)
setor: string(nullable=true)

# JOIN

# cientes.csv  id_c, nome
# cidades.csv  id_c, cidade

inner, outer, letf_outer, rigth_outer etc...

scala> val clientDF = spark.read.option("header", "true").csv("cliente.csv")
scala> val cidadeDF = spark.read.option("header", "true").csv("cidade.csv")
scala> clientDF.join(cidadeDF, "id_c").show()

# campos diferentes
# cientes.csv  id_c, nome
# cidades.csv  cliente, cidade

scala> val clientDF = spark.read.option("header", "true").csv("cliente.csv")
scala> val cidadeDF = spark.read.option("header", "true").csv("cidade.csv")
scala> clientDF.join(cidadeDF, clientDF("id_c") === cidadeDF("cliente"), "letf_outer").show()

# Exercicios


1 - val alunosDF = spark.read.csv("/user/aluno/helio/data/escola/alunos.csv")

2 - alunosDF.printSchema()
root
 |-- _c0: string (nullable = true)
 |-- _c1: string (nullable = true)
 |-- _c2: string (nullable = true)
 |-- _c3: string (nullable = true)
 |-- _c4: string (nullable = true)
 |-- _c5: string (nullable = true)
 |-- _c6: string (nullable = true)


3 - val alunosDF = spark.read.option("header", "true").csv("/user/aluno/helio/data/escola/alunos.csv")

4 - alunosDF.printSchema()
root
 |-- id_discente: string (nullable = true)
 |-- nome: string (nullable = true)
 |-- ano_ingresso: string (nullable = true)
 |-- periodo_ingresso: string (nullable = true)
 |-- nivel: string (nullable = true)
 |-- id_forma_ingresso: string (nullable = true)
 |-- id_curso: string (nullable = true)


5 - val alunosDF = spark.read.option("header", "true").option("inferSchema", "true").csv("/user/aluno/helio/data/escola/alunos.csv")

6 - alunosDF.printSchema()
root
 |-- id_discente: integer (nullable = true)
 |-- nome: string (nullable = true)
 |-- ano_ingresso: integer (nullable = true)
 |-- periodo_ingresso: integer (nullable = true)
 |-- nivel: string (nullable = true)
 |-- id_forma_ingresso: integer (nullable = true)
 |-- id_curso: integer (nullable = true)


7 - alunosDF.write.saveAsTable("helio.tab_alunos")

8 - val cursosDF = spark.read.option("header", "true").option("inferSchema", "true").csv("/user/aluno/helio/data/escola/cursos.csv")
cursosDF.printSchema()
root
 |-- id_curso: integer (nullable = true)
 |-- id_unidade: integer (nullable = true)
 |-- codigo: string (nullable = true)
 |-- nome: string (nullable = true)
 |-- nivel: string (nullable = true)
 |-- id_modalidade_educacao: integer (nullable = true)
 |-- id_municipio: integer (nullable = true)
 |-- id_tipo_oferta_curso: integer (nullable = true)
 |-- id_area_curso: integer (nullable = true)
 |-- id_grau_academico: integer (nullable = true)
 |-- id_eixo_conhecimento: integer (nullable = true)
 |-- ativo: integer (nullable = true)



9 - val alunos_cursosDF = alunosDF.join(cursosDF, alunosDF("id_curso") === cursosDF("id_curso"))

10 - alunos_cursosDF.show(10)

+-----------+--------------------+------------+----------------+-----+-----------------+--------+--------+----------+----------+--------------------+-----+----------------------+------------+--------------------+-------------+-----------------+--------------------+-----+
|id_discente|                nome|ano_ingresso|periodo_ingresso|nivel|id_forma_ingresso|id_curso|id_curso|id_unidade|    codigo|                nome|nivel|id_modalidade_educacao|id_municipio|id_tipo_oferta_curso|id_area_curso|id_grau_academico|id_eixo_conhecimento|ativo|
+-----------+--------------------+------------+----------------+-----+-----------------+--------+--------+----------+----------+--------------------+-----+----------------------+------------+--------------------+-------------+-----------------+--------------------+-----+
|      18957|ABELARDO DA SILVA...|        2017|               1|    G|            62151|   76995|   76995|       194|      null|LICENCIATURA EM C...|    G|                     1|        8550|                   4|     20000006|          8067070|                null|    1|
|        553| ABIEL GODOY MARIANO|        2015|            null|    M|          2081113|    3402|    3402|       150|  SVTIAGRO|TÉCNICO EM AGROPE...|    M|                     1|        9332|                null|         null|             null|             6264215|    1|
|      17977|ABIGAIL ANTUNES S...|        2017|               1|    T|          2081111|  759711|  759711|       696|   UGTCADM|TÉCNICO EM ADMINI...|    T|                     1|        9431|                null|         null|             null|              171158|    1|
|      16613|ABIGAIL FERNANDA ...|        2017|            null|    M|            37350|    1222|    1222|       349|  PBTIQUIM|TÉCNICO EM QUÍMIC...|    M|                     1|        9091|                null|         null|             null|             6264214|    1|
|      17398|ABIGAIL JOSIANE R...|        2017|            null|    M|            37350|    5041|    5041|       189|  ALTIAGRP|TÉCNICO EM AGROPE...|    M|                     1|        8550|                null|         null|             null|                null|    1|
|      26880|ABIMAEL CHRISTOPF...|        2019|               1|    T|          2081115| 1913420| 1913420|       269|SRTSADMEAD|TÉCNICO EM ADMINI...|    T|                     2|        9244|                null|     60000007|             null|              171158|    1|
|      28508|   ABNER NUNES PERES|        2019|               1|    G|            37350|  181097|  181097|       434|      null|BACHARELADO EM AD...|    G|                     1|        8971|                   3|     90000005|                1|                null|    1|
|      18693|ACSA PEREIRA RODR...|        2017|               1|    G|            62151|   77498|   77498|       155|      null|LICENCIATURA EM C...|    G|                     1|        9332|                   3|     20000006|          8067070|                null|    1|
|      28071|ACSA ROBALO DOS S...|        2019|               1|    T|          2081115| 3996007| 3996007|       229|   SBTSLOG|TÉCNICO EM LOGÍST...|    T|                     1|        9273|                null|     60000007|             null|              171158|    1|
|      21968|AÇUCENA CARVALHO ...|        2018|               0|    N|          2081113| 2399357| 2399357|       428|   JCTPCOM|TÉCNICO EM COMÉRC...|    N|                     1|        8971|                null|     60000007|             null|              171158|    1|
+-----------+--------------------+------------+----------------+-----+-----------------+--------+--------+----------+----------+--------------------+-----+----------------------+------------+--------------------+-------------+-----------------+--------------------+-----+
only showing top 10 rows


# Spark SQL Queries

# Retornar um Dataframe (Hive)
scala> val myDF = spark.sql("select * from people")
scala> myDF.printSchema()
scala> myDF.show()

# arquivo parquet e json
scala> val myDF = spark.sql("select * from parquet.`/bd/tabela.parquet`")
scala> val myDF = spark.sql("select * from json.`/bd/tabela.json`")

# Consultas e Views
# select, where, group by, having, order by, limit, count, sum , mean, as, subqueries
scala> val maAgeDF = spark.sql("SELECT MEAN(age) AS mean_age, STDDEV(age) as sdev_age FROM people WHERE pcode IN \
(SELECT pcode FROM pcodes WHERE state='MA')")

# criar uma view
Dataframe.createTempView(view-name)
Dataframe.createOrReplaceTempView(view-name)
Dataframe.createGlobalTempView(view-name)

scala> val clienteDF = spark.read.json("cliente.json").createTempView("clienteView")
scala> val tabDF = spark.sql("select * from clienteView").show(10)

# API Catalog
spark.catalog

listDatabases # list banco de dados
setCurrentDatabase(nomeBD) #setar banco de dados padrao
listTables # listar tableas e views
listColumns(nomeTabela) # listar colunas de tabela ou view
dropTempView(nomeView) # remover view

val tabDF = spark.sql("select * from bdtest.user").show(10)

scala> spark.catalog.listDatabases.show()
scala> spark.catalog.setCurrentDatabase("bdtest")
scala> spark.catalog.listTables.show()

val tabDF = spark.sql("select * from user").show(10)

# Exercicios

1 - spark.catalog.listDatabases.show()
+-------+--------------------+--------------------+
|   name|         description|         locationUri|
+-------+--------------------+--------------------+
|default|Default Hive data...|hdfs://namenode:8...|
|  helio|                    |hdfs://namenode:8...|
|   test|                    |hdfs://namenode:8...|
+-------+--------------------+--------------------+


2 - spark.catalog.setCurrentDatabase("helio")

3 - spark.catalog.listTables.show()
+------------------+--------+--------------------+---------+-----------+
|              name|database|         description|tableType|isTemporary|
+------------------+--------+--------------------+---------+-----------+
|        nascimento|   helio|                null| EXTERNAL|      false|
|               pop|   helio|                null|  MANAGED|      false|
|       pop_parquet|   helio|                null|  MANAGED|      false|
|pop_parquet_snappy|   helio|                null|  MANAGED|      false|
|   tab_juros_selic|   helio|                null|  MANAGED|      false|
|            titles|   helio|Imported by sqoop...|  MANAGED|      false|
+------------------+--------+--------------------+---------+-----------+


4 - spark.catalog.listColumns("tab_alunos").show()

5 - val tabDF = spark.sql("select * from tab_alunos limit 10").show()

# Exercicios

val alunosDF = spark.read.option("header", "true").option("inferSchema", "true").csv("/user/aluno/helio/data/escola/alunos.csv")

1 - 

alunosDF.select("id_discente", "nome").limit(5).show()

val alunosDF = spark.sql("select id_discente, nome from tab_alunos limit 5").show()

+-----------+--------------------+
|id_discente|                nome|
+-----------+--------------------+
|      18957|ABELARDO DA SILVA...|
|        553| ABIEL GODOY MARIANO|
|      17977|ABIGAIL ANTUNES S...|
|      16613|ABIGAIL FERNANDA ...|
|      17398|ABIGAIL JOSIANE R...|
+-----------+--------------------+

2 - 

alunosDF.select("id_discente", "nome").where("ano_ingresso>=2018").show()

val alunosDF = spark.sql("select id_discente, nome from tab_alunos where ano_ingresso>=2018").show()


+-----------+--------------------+
|id_discente|                nome|
+-----------+--------------------+
|      26880|ABIMAEL CHRISTOPF...|
|      28508|   ABNER NUNES PERES|
|      28071|ACSA ROBALO DOS S...|
|      21968|AÇUCENA CARVALHO ...|
|      22374|ADALBERTO LUFT LU...|
|      26367|ADALBERTO SEIDEL ...|
|      25120|ADÃO VAGNER DOS S...|
|      24787|ADELITA ALVES SIL...|
|      28001|ADEMIR LUIZ SCHEN...|
|      21618|    ADENIR CALLEGARO|
|      27346|        ADILSON HAAS|
|      21569|ADILSON LOPES DA ...|
|      24456|ADILSON MARTINS D...|
|      24958|  ADIR JOSÉ HECHMANN|
|      25805|ADRIANA CLARICE H...|
|      27021|ADRIANA GÖTENS AN...|
|      25968|ADRIANA MAGALHÃES...|
|      27232|ADRIANA PAIVA GÜL...|
|      21247|ADRIANA PERES FER...|
|      27223|       ADRIANA PIRAN|
+-----------+--------------------+
only showing top 20 rows


3 - 

alunosDF.select("id_discente", "nome", "ano_ingresso").where("ano_ingresso>=2018").orderBy("nome").show()

val alunosDF = spark.sql("select id_discente, nome from tab_alunos where ano_ingresso>=2018 order by nome").show()

+-----------+--------------------+------------+
|id_discente|                nome|ano_ingresso|
+-----------+--------------------+------------+
|      26880|ABIMAEL CHRISTOPF...|        2019|
|      28508|   ABNER NUNES PERES|        2019|
|      28071|ACSA ROBALO DOS S...|        2019|
|      22374|ADALBERTO LUFT LU...|        2018|
|      26367|ADALBERTO SEIDEL ...|        2019|
|      24787|ADELITA ALVES SIL...|        2018|
|      28001|ADEMIR LUIZ SCHEN...|        2019|
|      21618|    ADENIR CALLEGARO|        2018|
|      27346|        ADILSON HAAS|        2019|
|      21569|ADILSON LOPES DA ...|        2018|
|      24456|ADILSON MARTINS D...|        2018|
|      24958|  ADIR JOSÉ HECHMANN|        2018|
|      23809|ADRIAN FIGUEIRÓ P...|        2018|
|      25805|ADRIANA CLARICE H...|        2018|
|      27021|ADRIANA GÖTENS AN...|        2019|
|      25968|ADRIANA MAGALHÃES...|        2018|
|      27232|ADRIANA PAIVA GÜL...|        2019|
|      21247|ADRIANA PERES FER...|        2018|
|      27223|       ADRIANA PIRAN|        2019|
|      25491|ADRIANE DA SILVA ...|        2018|
+-----------+--------------------+------------+
only showing top 20 rows


4 - 

alunosDF.select("id_discente", "nome", "ano_ingresso").where("ano_ingresso>=2018").orderBy("nome").count()

val alunosDF = spark.sql("select count(*) from tab_alunos where ano_ingresso>=2018 order by nome").show()

res31: Long = 4266                                                              

