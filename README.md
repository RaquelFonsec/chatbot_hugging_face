# 🤖 Chatbot com Hugging Face e Ruby on Rails

Este é um projeto de chatbot com interface web, desenvolvido com **Ruby on Rails**, utilizando um modelo de linguagem da **Hugging Face**. A aplicação permite o envio de mensagens, exibição de respostas automáticas da IA, histórico e testes automatizados com RSpec.

🎨 Frontend com JavaScript

A interface é feita com HTML, Bootstrap 5 e JavaScript puro. Usamos form_with, spinner com display: none, e JavaScript para exibir a animação de carregamento durante a requisição da IA.


## 🚀 Funcionalidades

- Interface web estilizada com **Bootstrap 5**
- Integração com **modelos da Hugging Face API**
- Histórico de conversas persistente com **PostgreSQL**
- Interações assíncronas com **JavaScript puro**
- Spinner de carregamento durante resposta da IA
- Tratamento de erros com mensagens visuais
- Testes automatizados com **RSpec**

---

## 🧰 Pré-requisitos

Antes de começar, você precisa ter instalado:

- Git
- **Ruby** (versão 3.1 ou superior)
- **Rails** (7+)
- **Bundler**
- **PostgreSQL**
- **Node.js** e **Yarn** (para o frontend Rails)

---

## 💻 Instalação do Ruby (Linux/macOS)


### 1. Instale o `rbenv` e `ruby-build`

```bash
sudo apt update
sudo apt install rbenv ruby-build -y


No macOS: use Homebrew
brew install rbenv ruby-build


Instale o Ruby

rbenv install 3.2.2
rbenv global 3.2.2
ruby -v


Instale o Bundler e Rails

gem install bundler
gem install rails



🐘 Instalação do PostgreSQL
Ubuntu

sudo apt update
sudo apt install postgresql postgresql-contrib libpq-dev -y


macOS

brew install postgresql


📥 Clonando o repositório

git clone https://github.com/RaquelFonsec/chatbot_hugging_face.git
cd chatbot_hugging_face


🔑 Configuração da Hugging Face API
Crie uma conta na Hugging Face

Vá em: https://huggingface.co/settings/tokens

Clique em "New token", dê um nome e selecione read.

Copie o token gerado.

Escolha o modelo

Você pode explorar os modelos disponíveis aqui:

👉 https://huggingface.co/models

Exemplo usado neste projeto: mistralai/Mixtral-8x7B-Instruct-v0.1


🛠️ Configurando o projeto

Crie seu token de acesso na Hugging Face com permissão read.

Crie um arquivo .env na raiz do projeto e adicione suas credenciais:


HUGGINGFACE_TOKEN=seu_token_aqui
HUGGINGFACE_MODEL=mistralai/Mixtral-8x7B-Instruct-v0.1

No arquivo app/services/huggingface_service.rb, o código já busca essas variáveis automaticamente com:


BEARER_TOKEN = ENV["HUGGINGFACE_TOKEN"]
MODEL = ENV["HUGGINGFACE_MODEL"]

⚠️ Lembre-se de instalar a gem dotenv-rails se ainda não estiver incluída:

# Gemfile

gem 'dotenv-rails', groups: [:development, :test]


E depois rode:

bundle install

Adicione .env ao .gitignore para evitar subir suas chaves:

# .gitignore

.env


Instale as gems:

bundle install


Crie e configure o banco de dados:


rails db:create db:migrate


Inicie o servidor:

rails server


Abra o navegador em:

📍 http://localhost:3000

🧪 Testes automatizados com RSpec

Este projeto contém testes automatizados para:

Controller

Serviço Hugging Face

Integração (sistema)

Execute os testes com:

bundle exec rspec


🧾 Estrutura e principais arquivos

Caminho	Descrição

app/controllers/messages_controller.rb	Controlador das mensagens

app/services/huggingface_service.rb	Serviço que integra com a API da Hugging Face

app/views/messages/index.html.erb	Interface principal do chatbot

spec/	Diretório com testes automatizados

db/migrate	Migrações para o banco de dados PostgreSQL


🔐 Segurança

⚠️ Nunca suba tokens da Hugging Face no GitHub.

Este projeto foi ajustado para não conter nenhum segredo sensível no histórico de commits.

🌟 Créditos

Desenvolvido por Raquel Fonseca 💜



