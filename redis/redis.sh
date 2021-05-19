########
# Redis

download
https://redis.io/download

linux
wget http://download.redis.io/releases/redis-6.0.6.tar.gz
tar xzf redis-6.0.0.tar.gz
cd redis-6.0.6
make

cloud
https://redislabs.com/redis-enterprise-cloud/overview

docker
download da imagem
https://hub.docker.com/redis
docker pull redis

criar a pasta redis e docker-coompose.yml

# acessar o cli
docker exec -it redis bash
# redis-cli
# redis-server

#####################
# Strings
# memcached
SET <chave> <valor>
GET <chave>

> set minhaChave valorChave
OK
> get minhaChave
"valorChave"

# NX (falha se a chave existir)
# XX (subsitui o valor da chave)
set minhaChave novoValor nx 
(nil)
set minhaChave novoValor xx 
OK

# strlen (tamanho do valor)
strlen minhaChave
(integer) 9

# string como inteiro
# contador
incr <chave>
decr <chave>
incrBy <chave> <incremento>
decrBy <chave> <decremento>

> set contador 10
> incr contador 
(integer) 11
> incrBy contador 5
(integer) 16
> decr contador
(integer) 15
> decrBy contador 5
(integer) 10

# reduzir latencia
MSET <chave 1> <valor. <chave2> <valor> ... <N>
MGET <chave 1> <chave2> ... <N>

> mset chave 10 chave2 20
> mget chave1 chave2
1)"10"
2)"20"

# persistência de chaves

# verificar se a chave exist
exists <chave>

# deletar chave
del <chave>

# tipo da chave
type <chave>

> set minhaChave teste
> type minhaChave
string
> exists minhaChave
(integer) 1
> del minhaChave
(integer) 1
> exists minhaChave
(integer) 0
> type minhaChave
none 

# tempo de expiração
expire <chave> <tempo segundos>
pexpire <chave> <tempo milisegundos>
set <chave> <valor> ex <segundos>
set <chave> <valor> px <milisegundos>

# verificar tempo restante
ttl <chave>
pttl <chave>

> set minhaChave teste
> ttl minhaChave
(integer) -1 # não existe tempo
> expire minhaChave 20
(integer) 1
>get minhaChave
"teste"
> ttl minhaChave
(integer) 7
>ttl minhaChave
(integer) -2  # nao existe
>get minhaChave
(nil)

# remover tempo
> persist minhaChave
> ttl minhaChave
(integer) -1

# Exercicios
1 - set usuario:nome helio
OK

2 - set usuario:sobrenome ribeiro
OK

3 - get usuario:nome
"helio"

4 - strlen usuario:nome
(integer) 5

5 - type usuario:sobrenome
string

6 - set views:qtd 100
OK

7 - incrBy views:qtd 10
(integer) 110

8 - get views:qtd
"110"

9 - del usuario:sobrenome
(integer) 1

10 - exists usuario:sobrenome
(integer) 0

11 - expire views:qtd 3600
(integer) 1

12 - ttl views:qtd
(integer) 3579

13 - ttl usuario:nome
(integer) -1

14 - persist views:qtd
(integer) 1


###############
# LISTAS

# Linked List

# adicionar novo elemento
lpush <chave> <valor>  # inicio (esquerda)
rpush <chave> <valor> # finald (direita)

# extrair elementos em um intervalo
lrange <chave> <inicio> <fim>
# 0 (primeiro), -1 (ultimo), -2 (penultimo)

> rpush lista primeiro
(integer) 1
> rpush lista segundo
(integer) 2
> lpush lista novoPrimeiro
(integer) 3
> rpush lista ultimo
(integer) 4
>lrange lista 0 -1
1) "novoPrimeiro"
2) "primeiro"
3) "segundo"
4) "ultimo"
>lrange lista 1 3
1) "primeiro"
2) "segundo"
3) "ultimo"

# recuperar e eliminar
lpop <chave>
rpop <chave>
> lpop lista
"novoPrimeiro"
> lpop lista
"primeiro"
> rpop lista
"ultimo"
> lpop lista
"segundo"
> lpop lista
(nil)

# recuperar a informacao ate um tempo ( evitar receer valores null)
blpop <chave> <tempo>
brpop <chave> <tempo>

# definir novo intervalo
ltrim <chave> <novoInicio> <novoFim>

# tamanho da lista
llen <chave>

> rpush letras A B C D E F 
(integer) 6
> llen letras
(integer) 6
> ltrim letras 2 4
OK
> llen letras 
(integer) 3

# Exercicios

1 - rpush views:ultimo_usuario Carlos Joao Ana Carol
(integer) 4

2 -  lrange views:ultimo_usuario 0 -1
1) "Carlos"
2) "Joao"
3) "Ana"
4) "Carol"

3 - lrange views:ultimo_usuario 0 -2
1) "Carlos"
2) "Joao"
3) "Ana"

4 - llen views:ultimo_usuario
(integer) 4

5 - ltrim views:ultimo_usuario 1 -1
OK

6 -  llen views:ultimo_usuario
(integer) 3

7 - lpop views:ultimo_usuario
"Joao"
 - rpop views:ultimo_usuario
 "Carol"
 - blpop views:ultimo_usuario 5
 1) "views:ultimo_usuario"
 2) "Ana"
 - brpop views:ultimo_usuario 5
 (nil)
(5.06s)


##########
# Sets (lista nao ordenada)

sadd <chave> <valor1> ... <valor N>

smembers <chave>

spop <chave>

sadd views:nome Rodrigo Carlos Ana
(integer) 3

smembers views:nome
1) "Ana"
2) "Carlos"
3 "Rodrigo"
spop views:nome
"Carlos"

# elemento existe
sismember views:nome Rodrigo
(integer) 1

# numero de elementos
scard views:nome
(integer) 3

# remover
srem views:nome Carlos

# Multiplos sets

# interseção
sinter views:nome comentario:nome

# diferença
sdiff views:nome comentario:nome

# uniao
sunion views:nome comentario:nome

# armazenar em outro set
sinterstore inter_views_comentario:nome views:nome comentario:nome

sdiffstore diff_views_comentario:nome views:nome comentario:nome

sunionstore union_views_comentario:nome views:nome comentario:nome

# Exercicios
1 - del pesquisa:produto
(integer) 0

2 - sadd pesquisa:produto monitor mouse teclado
(integer) 3

3 - scard pesquisa:produto

4 - smembers pesquisa:produto
1) "mouse"
2) "monitor"
3) "teclado"

5 - sismember pesquisa:produto monitor
(integer) 1

6 - srem pesquisa:produto monitor
(integer) 1

7 - spop pesquisa:produto
"mouse"

8 - sadd pesquisa:desconto monitor "memória RAM" monitor teclado HD
(integer) 4

9 - 

sinter pesquisa:produto pesquisa:desconto
1) "teclado"

sdiff pesquisa:produto pesquisa:desconto
(empty array)

sunion pesquisa:produto pesquisa:desconto
1) "monitor"
2) "mem\xc3\xb3ria RAM"
3) "HD"
4) "teclado"

##################
# Sets ordenados

zadd <chave> <score1> <valor1> ... <valorN>

# visualizar elementos
zrange <chave> <inicio> <fim>
zrevrange <chave> <inicio> <fim>

zadd views:nomes 10 Rodrigo 15 Carlos 10 Ana
(integer) 3

zrange view:nomes 0 -1
zrevrange views:nomes 0 -1
zrange view:nomes 0 -1 withscores

# ordem por score e depois ordem alfabetica
1) "Ana"
2) "10"
3) "Rodrigo"
4) "10"
5) "Carlos"
6 "15"

# recuperar e remover
zpopmax views:nomes
1) "Carlos"
2) "15"

zpopmin views:nomes
1) "Ana"
2) "10"

# bloquear se estiver vazio
bzpopmax views:nomes 5
1) "views:nomes"
1) "Rodrigo"
2) "10"

bzpopmin views:nomes 5
(nil)
(5.08s)

# visualiza a posição de um elemento
zrank views:nomes Rodrigo
(integer) 1

zrevrank views:nomes Rodrigo

# visualizar score
zscore views:nomes Rodrigo
"10"

# visualizar numero de elementos
zcard views:nomes
(integer) 3

# remover um elemento
zrem views:nomes Carlos
(integer) 1


# Exercicios
1 - del pesquisa:produto
(integer) 1

2 - zadd pesquisa:produto 100 monitor 20 HD 10 mouse 50 teclado
(integer) 4

1 - zcard pesquisa:produto
(integer) 4

2 - zrevrange pesquisa:produto 0 -1
1) "monitor"
2) "teclado"
3) "HD"
4) "mouse"

3 - zrank pesquisa:produto teclado
(integer) 2

4 - zscore pesquisa:produto teclado
"50"

5 - zrem pesquisa:produto HD
(integer) 1

6 - zpopmax pesquisa:produto
1) "monitor"
2) "100"

7 - zpopmin pesquisa:produto
1) "mouse"
2) "10"

8 - zrange pesquisa:produto 0 -1
1) "teclado"

##########
# Hashes

hmset produto:100 nome mouse qtd 10
(integer) 2
hget produto:100 nome
"mouse"
hmget produto:100 nome qtd
1) "mouse"
2) "10"
hget produto:100

# incrementar valor
hincrby produto:100 qtd 1
(integer) 11
hincrby produto:100 qtd -1
(integer) 10

# obter numero de campos
hlen produto:100
(integer) 2

# tamanho do valor do campo
hstrlen produto:100 nome
(integer) 5

# todos os campos da hash
hkeys produto:100
1) "nome"
2) "qtd"

# todos os valores
hvals produto:100
1) "mouse"
2) "10"

# deletar campo
hdel produto:100 nome
(integer) 1

# Exercicios
1 - del usuario:100
(integer) 1

2 - hmset usuario:100 nome Augusto estado SP views 10
OK

3 - hgetall  usuario:100
1) "nome"
2) "Augusto"
3) "views"
4) "12"


4 - hlen usuario:100
(integer) 3

5 - hmget usuario:100 nome views
1) "Augusto"
2) "10"

6 - hstrlen usuario:100 nome
(integer) 7

7 - hincrby usuario:100 views 2
(integer) 12

8 - hkeys usuario:100
1) "nome"
2) "estado"
3) "views"

9 - hvals usuario:100
1) "Augusto"
2) "SP"
3) "12"

10 - hdel usuario:100 estado
(integer) 1


###################
## Pub/Sub

publish <canal> <mensagem>
subscribe <canal1> ... <canalN>

> subscribe canal1
Reading messages...
1) "subscribe"
2) "canal1"
3) (integer) 1

> publish canal1 'msg de teste'
(integer) 1

Reading messages...
1) "subscribe"
2) "canal1"
3) (integer) 1
1) "mesage"
2) "canal1"
3) "msg de teste"

# usar padrão
psubscribe canal*
Reading messages...
1) "psubscribe"
2) "canal*"
3) (integer) 1

# cancelamento
unsubscribe 
unsubscribe canal1
punsubscribe canal*

# exercicios
1 -
subscribe noticias:sp
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "noticias:sp"
3) (integer) 1

2 - 
publish noticias:sp "Msg 1"
(integer) 1
publish noticias:sp "Msg 2"
(integer) 1
publish noticias:sp "Msg 3"
(integer) 1

1) "message"
2) "noticias:sp"
3) "Msg 1"
1) "message"
2) "noticias:sp"
3) "Msg 2"
1) "message"
2) "noticias:sp"
3) "Msg 3"

3 - unsubscribe noticias:sp
1) "unsubscribe"
2) "noticias:sp"
3) (integer) 0

4 - psubscribe noticias*
Reading messages... (press Ctrl-C to quit)
1) "psubscribe"
2) "noticias*"
3) (integer) 1

5 - 
publish noticias:rj "Msg 4"
(integer) 1
publish noticias:rj "Msg 5"
(integer) 1
publish noticias:rj "Msg 6"
(integer) 1

1) "pmessage"
2) "noticias*"
3) "noticias:rj"
4) "Msg 4"
1) "pmessage"
2) "noticias*"
3) "noticias:rj"
4) "Msg 4"
1) "pmessage"
2) "noticias*"
3) "noticias:rj"
4) "Msg 5"


#######################
# Configuração básica

# pode ser feito através do redis.conf

config get appendonly
1) "appendonly"
2) "yes"

config get *
1) "rdbchecksum"
2) "yes"
3) "daemonize"
4) "no"
...

## cache
Maxmemory
Maxmemory-policy
- noeviction # erros quando limite de memória é atingido
- allkeys-lru # remove chaves menos usadas recentemente
- volatile-lru # menos usadas com expiração
- allkeysrandom # remove chaves aleatoriamente
- volatile-random # remove aleatoriamente com expiração
- volatile-ttl # menos usadas recentemente com expiração

Configuração
https://redis.io/topics/lru-cache

config get maxmemory
1) "maxmemory"
2) "0"

config get maxmemory-policy
1) "maxmemory-policy"
2) "noeviction"

config set maxmemory 2mb
OK

config set maxmemory-policy allkeys-lru
OK

config get maxmemory*
1) "maxmemory-policy"
2) "allkeys-lru"
3) "maxmemory-samples"
4) "5"
5) "maxmemory"
6) "2097152"

# Exexrcicios

1 - config get *

2 - config get appendonly
1) "appendonly"
2) "yes"

3 - config set appendonly no
OK

4 - config get save

5 - config set save "120 500"

6 - config get maxmemory*
6) "10"
7) "maxmemory"
8) "0"

7 - config set maxmemory 1mb
config set maxmemory-policy allkeys-lru
1) "maxmemory-policy"
2) "allkeys-lru"
3) "maxmemory-samples"
4) "5"
5) "maxmemory-eviction-tenacity"
6) "10"
7) "maxmemory"
8) "1048576"

