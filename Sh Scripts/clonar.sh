#!/bin/bash

# 1. Verifica se o Git está instalado no Linux
if ! command -v git &> /dev/null; then
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] O comando 'git' não foi encontrado no sistema!"
    echo "Instale o Git no Linux usando: sudo apt install git"
    echo "----------------------------------------------------"
    echo ""
    read -p "Pressione Enter para sair..."
    exit 1
fi

echo "=== CLONAR REPOSITÓRIO ==="
read -p "Cole a URL do repositorio: " repo_url
read -p "Cole o seu Token (PAT) do GitHub: " token
read -p "Arraste a pasta do PC onde quer salvar o projeto: " destino

# Remove aspas do caminho arrastado
destino=$(echo "$destino" | tr -d "'\"")

if [ -z "$destino" ]; then
    echo ""
    echo "[ERRO] O caminho de destino não pode estar vazio!"
    read -p "Pressione Enter para sair..."
    exit 1
fi

if [ ! -d "$destino" ]; then
    echo "Criando pasta destino..."
    mkdir -p "$destino"
fi

cd "$destino" || {
    echo "[ERRO] Não foi possível acessar a pasta: $destino"
    read -p "Pressione Enter para sair..."
    exit 1
}

clean_url="${repo_url/https:\/\//}"
auth_url="https://${token}@${clean_url}"

echo ""
echo "Baixando repositório no PC..."

# Tenta clonar e verifica se deu certo
if git clone "$auth_url"; then
    echo ""
    echo "=========================================="
    echo "   Download concluído com sucesso!"
    echo "=========================================="
else
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] Falha ao clonar o repositório!"
    echo "Verifique:"
    echo "1. Se a URL do repositório está correta."
    echo "2. Se o Token (PAT) é válido e não expirou."
    echo "3. Se você está conectado à internet."
    echo "----------------------------------------------------"
fi

echo ""
read -p "Pressione Enter para finalizar..."
