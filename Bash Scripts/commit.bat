#!/bin/bash

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

git config --global --add safe.directory "*"

echo "=== SALVAR E ENVIAR ALTERAÇÕES ==="
read -p "Arraste a pasta do projeto no PC para cá (ou digite o caminho): " caminho
caminho=$(echo "$caminho" | tr -d "'\"")

if [ ! -d "$caminho" ]; then
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] A pasta '$caminho' não foi encontrada!"
    echo "----------------------------------------------------"
    read -p "Pressione Enter para sair..."
    exit 1
fi

cd "$caminho" || {
    echo "[ERRO] Não foi possível acessar a pasta: $caminho"
    read -p "Pressione Enter para sair..."
    exit 1
}

if [ ! -d ".git" ]; then
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] Esta pasta não é um repositório Git!"
    echo "Certifique-se de selecionar a pasta raiz do projeto."
    echo "----------------------------------------------------"
    read -p "Pressione Enter para sair..."
    exit 1
fi

# Sobrescreve forçadamente o .gitignore do projeto pelo gitignore.txt do pendrive
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/gitignore.txt" ]; then
    cp -f "$SCRIPT_DIR/gitignore.txt" .gitignore
fi

git add .

read -p "Digite a mensagem do commit: " msg
if [ -z "$msg" ]; then
    msg="Atualização automática"
fi

git commit -m "$msg"

echo ""
echo "Enviando alterações para o GitHub..."

if git push origin main --force; then
    echo ""
    echo "=========================================="
    echo "   Alterações enviadas com sucesso!"
    echo "=========================================="
else
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] Falha ao enviar para o GitHub!"
    echo "----------------------------------------------------"
fi

echo ""
read -p "Pressione Enter para finalizar..."
