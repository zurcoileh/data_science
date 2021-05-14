# download docker images 
docker pull mongo
docker pull mongo-express

# create docker-compose.yml

# Use root/example as user/password credentials
# version: '3.1'

# services:

#   mongo:
#     image: mongo
#     restart: always
#     environment:
#       MONGO_INITDB_ROOT_USERNAME: root
#       MONGO_INITDB_ROOT_PASSWORD: example

#   mongo-express:
#     image: mongo-express
#     restart: always
#     ports:
#       - 8081:8081
#     environment:
#       ME_CONFIG_MONGODB_ADMINUSERNAME: root
#       ME_CONFIG_MONGODB_ADMINPASSWORD: example


# start containers
docker-compose -f docker-compose.yml up -d

# run container shell
docker exec -it mongo bash
# mongo shell
>mongo

# acessar o mongodb express
http://localhost:8081/


# conexao mongo
mongo --host <host> -u <usuario> -p <senha> --authenticationDatabase <bdAdmin>
show dbs;

# criar banco e mostrar
> use <nomeBD>
> db

############################
# collection
> db.createCollection('users')
> show collections
> show dbs

# drop collection e db
> db.users.drop()
> db.dropDatabase()

# renomear
> db.users.renameCollection('<nomeNovo>')
> db.users.renameCollection('cliente')

# criação de documentos
db.<nomeCollection>.insertOne({<docuemnto>})
# inserrir N documentos
db.<nomeCollection>.insertMany([{<docuemnto1>},{<docuemnto2}])

# Ex.
> db.cliente.insertOne(
    {
        nome: "Helio",
        idade: 35,
        conhecimento: ["Python", "Linux", "Hadoop"]
    }
)
# Return   { "acknowledged" : true, "insertedId": ObjectId("xxxxxxxxxxxxxxxx") } 
# insertedId ("_id")

# visualizar documentos
db.<collection>.find().pretty()
> db.collection.find().pretty()

# return
{
    "_id": ObjectId("xxxxxxxxxx"),
    "idade": 35,
    "conhecimento":  ["Python", "Linux", "Hadoop"]
}

# alinhado ou embeded
> db.cliente.insertOne(
    {
        nome: "Helio",
        idade: 35,
        conhecimento: ["Python", "Linux", "Hadoop"],
        endereco: {
            rua: "Kansas",
            numero: 975,
            cidade: "São Paulo"
        }
    }
)

# Exercicios
use helio;
show dbs
db.createCollection('produto')
> db.produto.insertMany(
    [
        {
            _id: 1,
            nome: "cpu i5",
            qtd: 15
        },
        {
            _id: 2,
            nome: "memória ram",
            qtd: 10,
            descricao: {
                armazenamento: "8GB",
                tipo: "DDR4"
            }
        },
        {
            _id: 3,
            nome: "mouse",
            qtd: 50,
            descricao: {
                conexao: "USB",
                so: ["Windows", "Mac", "Linux"]
            }
        },
        {
            _id: 4,
            nome: "hd externo",
            qtd: 20,
            descricao: {
                conexao: "USB",
                armazenamento: "500GB",
                so: ["Windows 10", "Windows 8", "Windows 7"]
            }
        }
    ]
)

############################
# consultas básicas
db.<nomeCollection>.find(
    # creiterio de consulta
    { 
        <atributo>: { 
        <operador> : <valor>
        }
    },
    # projecao
    { atributo: 0 }, # ocultar
    { atributo: 1 }  # mostrar
)

# Ex
db.cliente.find( { nome: "Helio"} )
db.cliente.find( { "endereco.cidade": "São Paulo"} )
db.cliente.find( { idade: { $lt: 18 } } )

# operadores:  $eq, $ne, $gt, $gte, $lt, $lte, $in, $nin, $not

# projeção
db.cliente.find( { nome: "Helio"}, { conhecimento: 0 } )
db.cliente.find( { nome: "Helio"}, { conhecimento: 1 } )
db.cliente.find( { nome: "Helio"}, {  _id:0, conhecimento: 0 } )

# Exercicios
1 - db.produto.find().pretty()
2 -
a) db.produto.find({ "nome": "mouse"})

b) db.produto.find({ "qtd": { $eq: 20} }, { _id: 0, nome: 1, descricao: 0})

c) db.produto.find({ "qtd": { $lte: 20} }, { _id: 0, nome: 1, qtd: 1, descricao: 0})

d) db.produto.find({ "qtd": { $gte: 10, $lte: 20 } })

e) db.produto.find({ "descricao.conexao": "USB"}, { _id: 0, qtd: 0})

f) db.produto.find({ "descricao.so": { $in: ["Windows", "Windows 10"] } })


# outras opções

# and e or
db.cliente.find({ "endereco.cidade": "São Paulo", idade: { $gte:18 }})

db.cliente.find({ $or: 
    [ 
        { "endereco.cidade": "São Paulo" }, 
        { idade: { $gte:18 } } 
    ] 
})

db.cliente.find({
    conhecimento: "Windows",
    { $or: 
        [ 
            { "endereco.cidade": "São Paulo" }, 
            { idade: { $gte:18 } } 
        ]
    } 
})

# sort
find().sort(
    { <atributo>: <valor> } # ASC (1) , DESC (-1)
)

find().sort({ "endereco.cidade": 1, nome: 1 })

# limit
.find().limit(<valor>)
find().limit(5)

# 1 doc
findOne({})

# Exercicios
1 - db.produto.find().pretty()
2 - 

a) db.produto.find().sort({ nome: 1 })

b) db.produto.find().limit(3).sort({ nome: 1, qtd: 1 })

c) db.produto.findOne({ "descricao.conexao": "USB" })

d) db.produto.find({ "descricao.conexao": "USB", qtd: { $lt: 25} })

e) db.produto.find({ $or: [ { "descricao.conexao": "USB" }, { qtd: { $lt: 25} } ] })

f) db.produto.find({ $or: [ { "descricao.conexao": "USB" }, { qtd: { $lt: 25} } ] }, { _id: 1 })

############################
# UPDATE E DELETE

db.<nomeCollection>.updateOne(<filtro>,<atualizacao>)
db.<nomeCollection>.updateMany(<filtro>,<atualizacao>)

# set / unset
db.cliente.updateOne({_id: 1}, { $set: { idade:25, estado: "SP" } })
db.cliente.updateOne({_id: 1}, { $unset: { idade: "" } })
db.cliente.updateMany({_idade: { $gt:27 } }, { $set: { seguro: "baixo" } })
# return { "acknowledge": true, "matchedCount": 1, "modifiedCount": 1 }

# atualizar nome do atributo
db.cliente.updateMany({}, { $rename: { "nome": "nome_completo" } })


# data e timestamp
db.test.insertOne(
    ts: new Timestamp(), # timestamp 
    data: new Date(),  # UTC (ISODate)
    data_string: Date(),  # string da data atual
    config_date: new Date("2020-08")  # "<YYYY-mm-ddTHH:MM:ssZ>"
)

# currentDate
# setar valor de data atual
db.cliente.updateMany({_idade: { $gt:27 } }, { $currentDate: { atualizado: { $type: "timestamp" } } })


# array
# atualiza elemento "Mongo" do array "conhecimento" ["Mongo", "Hadoop"]
db.cliente.updateOne({ _id: 2, "conhecimento": "Mongo" }, { $set: { "conhecimento.$": "MongoDB" } })

# pull/push  adicionar e remover
db.cliente.updateOne({ _id: 2 }, { $push: { "conhecimento": "Redis" } })
db.cliente.updateOne({ _id: 2 }, { $pull: { "conhecimento": "Redis" } })

# Exercicios

1 - db.produto.find().pretty()

2 - db.produto.updateOne({_id: 1}, { $set: { nome: "cpu i7" } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : "15" }

3 - db.produto.updateOne({_id: 1}, { $set: { qtd: 15 } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }

4 - db.produto.updateMany({qtd: { $gt:30 } }, { $set: { qtd: 30 } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB", "so" : [ "Windows", "Mac", "Linux" ] } }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "so" : [ "Windows 10", "Windows 8", "Windows 7" ] } }

5 - db.produto.updateMany({}, { $rename: { "descricao.so": "descricao.sistema" } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB", "sistema" : [ "Windows", "Mac", "Linux" ] } }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7" ] } }

6 - db.produto.updateMany({ "descricao.conexao": "USB" }, { $set: { "descricao.conexao": "USB 2.0" } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 2.0", "sistema" : [ "Windows", "Mac", "Linux" ] } }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 2.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7" ] } }

7 - db.produto.updateMany({ "descricao.conexao": "USB 2.0" }, 
{ $set: { "descricao.conexao": "USB 3.0" }, $currentDate: { data_modificacao: { $type: "date" } } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows", "Mac", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z") }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }

8 - db.produto.updateOne({ _id: 3, "descricao.sistema": "Windows" }, { $set: { "descricao.sistema.$": "Windows 10" } })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows 10", "Mac", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z") }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }

9 - db.produto.updateOne({ _id: 4 }, { $push: { "descricao.sistema": "Linux" } })
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }

10 - db.produto.updateOne({ _id: 3 }, { $pull: { "descricao.sistema": "Mac" }, $currentDate: { ts_modificacao: { $type: "timestamp" } } })
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows 10", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z"), "ts_modificacao" : Timestamp(1620859138, 1) }

# deletar
db.<nomeCollection>.deleteOne(<filtro>)
db.<nomeCollection>.deleteMany(<filtro>)

# deletar todos
db.cliente.deleteMany({})

db.cliente.deleteOne({ _id: 2})
db.cliente.deleteMany({ status: "Inativo"})

# Exercicios
1 - db.createCollection("teste")

{ "ok" : 1 }

2 - db.teste.insertOne({ usuario: "Semantix", data_acesso: new Date()})
{
	"acknowledged" : true,
	"insertedId" : ObjectId("609c5bd321045d5828225b28")
}

3 - db.teste.find({ data_acesso: { $gte: new Date("2020")}})
db.teste.find({ data_acesso: { $gte: ISODate("2020-01-01")}})
{ "_id" : ObjectId("609c5bd321045d5828225b28"), "usuario" : "Semantix", "data_acesso" : ISODate("2021-05-12T22:50:59.232Z") }

4 - db.teste.updateOne({usuario: "Semantix" }, { $currentDate: { data_acesso: { $type: "timestamp" } } })

5 - 
{
	"_id" : ObjectId("609c5bd321045d5828225b28"),
	"usuario" : "Semantix",
	"data_acesso" : Timestamp(1620860238, 1)
}


6 - db.teste.deleteOne({ _id: ObjectId("609c5bd321045d5828225b28")})

7 - db.teste.drop()
true

############################
# Index
# Criação de index
> db.cliente.createIndex({ nome: 1})
{
    "createdCollectionAutomatically": false,
    "numIndexBefore": 1,
    "numIndexAfter": 2,
    "ok": 1
}
> db.cliente.getIndexes()
[
    {
        "v": 2,
        "key": {
            "_id": 1
        },
        "name": "_id_"
    },
    {
        "v": 2,
        "key": {
            "nome": 1
        },
        "name": "nome_1"
    }
]
# nome padrão
<atributo>_<valor>_<atributo>_<valor>

db.createIndex({nome:1 , item:-1})
# nome_1_item_-1

db.createIndex({ nome:1, item:-1}, { name: 'query itens'})

# index excusivo
db.cliente.createIndex({user_id:1}, {unique: true})

# remover index
db.cliente.dropIndex({nome: 1})
db.cliente.dropIndexes()

# consulta com index
db.cliente.find().hint({nome: 1})

# plano de execucao
# COLLSCAN, IXSCAN, FETCH, SHARD_MERGE, SHARDING_FITER
db.cliente.find().explain()
"winingPlan": {
    "stage": "COLLSCAN",
    "direction": "forward"
}
db.cliente.find().hint({nome:1}).explain()
"inputStage": {
    "stage": "IXSCAN",
    "keyPattern": {
        "nome": 1
    },
    "indexName": "nome_index"
}

# Execicios
1 - db.produto.find().pretty()
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows 10", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z"), "ts_modificacao" : Timestamp(1620859138, 1) }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }

2 - db.produto.createIndex({ nome:1 }, { name: 'query_produto'})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}

3 - db.produto.getIndexes()
[
	{
		"v" : 2,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_"
	},
	{
		"v" : 2,
		"key" : {
			"nome" : 1
		},
		"name" : "query_produto"
	}
]

4 - db.produto.find().pretty()
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows 10", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z"), "ts_modificacao" : Timestamp(1620859138, 1) }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }

5 - db.produto.find().explain()
"winningPlan" : {
			"stage" : "COLLSCAN",
			"direction" : "forward"
		},
6 - db.produto.find().hint({nome: 1})
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows 10", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z"), "ts_modificacao" : Timestamp(1620859138, 1) }

7 - db.produto.find().hint({nome: 1}).explain()
"winningPlan" : {
			"stage" : "FETCH",
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"nome" : 1
				},
				"indexName" : "query_produto",

8 - db.produto.dropIndex({nome: 1})

{ "nIndexesWas" : 2, "ok" : 1 }

9 - db.produto.getIndexes()
[ { "v" : 2, "key" : { "_id" : 1 }, "name" : "_id_" } ]


############################
# Regex

db.<nomeCollection>.find({ <field>: { $regex: /pattern/, $options: '<options>'} })
db.<nomeCollection>.find({ <field>: { $regex: 'pattern', $options: '<options>'} })
db.<nomeCollection>.find({ <field>: { $regex: '/pattern/<options>'} })

# i ignorar case-sensitive
# m combinar variar linhas  (^ e $)
# exemplos
db.cliente.find({ nome: { $regex: /lucas/, $options: 'i'} })
db.cliente.find({ nome: { $regex: "lucas", $options: 'i'} })
db.cliente.find({ nome: { $regex: /s.o paulo/i} })
db.cliente.find({ nome: { $regex: "^são", $options: 'i'} })
db.cliente.find({ nome: { $regex: "paulo$", $options: 'i'} })
db.cliente.find({ cpf: { $regex: "[a-z]"} })

# Exercicios

1 - db.produto.find()
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 3, "nome" : "mouse", "qtd" : 30, "descricao" : { "conexao" : "USB 3.0", "sistema" : [ "Windows 10", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.958Z"), "ts_modificacao" : Timestamp(1620859138, 1) }
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }

2 - db.produto.find({ nome: { $regex: "cpu", $options: 'i'} })
{ "_id" : 1, "nome" : "cpu i7", "qtd" : 15 }

3 - db.produto.find({ nome: { $regex: "^hd", $options: 'i'} }, { nome: 1, qtd: 1 })
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20 }

4 - db.produto.find({ "descricao.armazenamento": { $regex: "gb$", $options: 'i'} }, { nome: 1, descricao: 1 })
{ "_id" : 2, "nome" : "memória ram", "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }
{ "_id" : 4, "nome" : "hd externo", "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] } }


5 - db.produto.find({ nome: { $regex: "mem.ria" } })
{ "_id" : 2, "nome" : "memória ram", "qtd" : 10, "descricao" : { "armazenamento" : "8GB", "tipo" : "DDR4" } }

6 - db.produto.find({ qtd: { $regex: "[a-z]" } })

7 - db.produto.find({ "descricao.sistema": { $regex: "Windows" } })
{ "_id" : 4, "nome" : "hd externo", "qtd" : 20, "descricao" : { "conexao" : "USB 3.0", "armazenamento" : "500GB", "sistema" : [ "Windows 10", "Windows 8", "Windows 7", "Linux" ] }, "data_modificacao" : ISODate("2021-05-12T22:37:18.959Z") }


##########
# MONGO EXPRESS
acessar localhost:8081

###########
# MONGODB COMPASS
download
https://docs.mongodb.com/compass/current
https://www.mongodb.com/try/download/compass?tck=docs_compass

sudo dpkg -i mongodb-compass_1.26.1_amd64.deb

