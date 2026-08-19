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

# Libera permissão global para pastas em pendrives/locais externos
git config --global --add safe.directory "*"

echo "=== SALVAR E ENVIAR ALTERAÇÕES ==="
read -p "Arraste a pasta do projeto no PC para cá (ou digite o caminho): " caminho
caminho=$(echo "$caminho" | tr -d "'\"")

# 2. Verifica se a pasta existe no PC
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

# 3. Verifica se a pasta selecionada é um repositório Git (.git existe)
if [ ! -d ".git" ]; then
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] Esta pasta não é um repositório Git!"
    echo "Certifique-se de selecionar a pasta raiz do projeto."
    echo "----------------------------------------------------"
    read -p "Pressione Enter para sair..."
    exit 1
fi

git add .

read -p "Digite a mensagem do commit: " msg
if [ -z "$msg" ]; then
    msg="Atualização automática"
fi

git commit -m "$msg"

echo ""
echo "Enviando alterações para o GitHub..."

# 4. Tenta fazer o Push e verifica se deu erro
if git push origin main --force; then
    echo ""
    echo "=========================================="
    echo "   Alterações enviadas com sucesso!"
    echo "=========================================="
else
    echo ""
    echo "----------------------------------------------------"
    echo "[ERRO] Falha ao enviar para o GitHub!"
    echo "Verifique:"
    echo "1. Se a branch no GitHub se chama 'main' (ou 'master')."
    echo "2. Se o seu Token tem permissões de escrita (repo/write)."
    echo "3. Se você tem conexão com a internet."
    echo "----------------------------------------------------"
fi

echo ""
read -p "Pressione Enter para finalizar..."
