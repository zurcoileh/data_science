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
