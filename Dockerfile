# Usa imagem base oficial do Node
FROM node:20

# Cria diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência primeiro (de dentro da pasta app/)
COPY app/package*.json ./

# Instala dependências
RUN npm install -g @nestjs/cli && npm install

# Copia o restante da aplicação
COPY app .

# Expõe a porta da API
EXPOSE 3000

# Comando padrão
CMD ["npm", "run", "start:dev"]
