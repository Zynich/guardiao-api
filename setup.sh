#!/bin/bash

echo "🚀 Iniciando setup completo do Guardião..."

# 0. Criar rede Docker compartilhada
echo "🌐 Verificando rede Docker 'guardiao-net'..."
docker network inspect guardiao-net >/dev/null 2>&1 || docker network create guardiao-net

# 1. Subir containers
echo "🔧 Subindo containers com Docker Compose..."
docker-compose up -d --build --remove-orphans

# 2. Esperar o MySQL ficar pronto
echo "⏳ Aguardando o MySQL ficar disponível..."
until docker exec guardiao-mysql mysqladmin ping -h"localhost" --silent; do
    echo -n "."; sleep 2
done

# 3. Verificar se o container da API está pronto
echo ""
echo "⏳ Aguardando o container da API iniciar..."
until docker exec guardiao-api ls > /dev/null 2>&1; do
    echo -n "."; sleep 2
done

# 4. Rodar Prisma
echo ""
echo "📐 Rodando Prisma generate..."
docker exec guardiao-api npx prisma generate

echo "📦 Rodando Prisma migrate..."
docker exec guardiao-api npx prisma migrate dev --name init --skip-seed

# 5. Rodar o servidor NestJS (modo dev)
echo "🚀 Iniciando servidor NestJS (modo dev)..."
docker exec -it guardiao-api npm run start:dev

echo "✅ Setup finalizado com sucesso!"
