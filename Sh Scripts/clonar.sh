#!/bin/bash
cd "$(dirname "$0")"

read -p "Cole a URL do repositorio (ex: https://github.com/usuario/repo.git): " repo_url
read -p "Cole o seu Token (PAT) do GitHub: " token

clean_url="${repo_url/https:\/\//}"
auth_url="https://${token}@${clean_url}"

echo ""
echo "Baixando o repositorio..."
git clone "$auth_url"

echo ""
read -p "Download concluido! Pressione Enter..."