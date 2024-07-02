# Escopo do Projeto - Cadastro de Itens

## Objetivo
Desenvolver uma aplicação de cadastro que permita ao usuário gerenciar registros com campos de texto e número, implementando funcionalidades de inserção, atualização e exclusão, com armazenamento local em um banco de dados SQLite.

## Requisitos Funcionais

### Cadastro de Dados:
- Permitir ao usuário inserir novos registros contendo um campo de texto e um campo numérico.
- Atualizar registros existentes com novos valores nos campos de texto e numérico.
- Excluir registros específicos da lista de cadastros.

### Banco de Dados:
- Utilizar SQLite como sistema de gerenciamento de banco de dados.
- Criar uma tabela para armazenar os cadastros com os seguintes campos:
  - id (chave primária autoincremental)
  - texto (campo de texto obrigatório)
  - numero (campo numérico obrigatório e único)

### Log de Operações:
- Registrar em uma tabela separada todas as operações realizadas na tabela de cadastros.
- Cada registro de log deve conter:
  - id (chave primária autoincremental)
  - data_hora (data e hora da operação)
  - tipo_operacao (tipo da operação realizada: Insert, Update, Delete)

### Validações:
- Garantir que todos os campos de texto sejam obrigatórios.
- Validar que o campo numérico seja maior que zero e único no banco de dados.

### Interface de Usuário (UI):
- Implementar uma interface intuitiva que permita ao usuário interagir facilmente com as funcionalidades de cadastro.
- Exibir os campos de texto e numérico para inserção e edição de registros.
- Disponibilizar botões visíveis para realizar operações de inserção, atualização e exclusão de registros.
- Permitir a seleção de registros da lista para visualização e edição detalhada dos dados.

## Restrições
- A aplicação deverá acessar somente a tabela de cadastros para operações de CRUD.
- Todas as validações devem ser implementadas no banco de dados SQLite para garantir a integridade dos dados.
