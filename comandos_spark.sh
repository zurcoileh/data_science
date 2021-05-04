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

