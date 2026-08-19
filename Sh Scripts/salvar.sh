#!/bin/bash
cd "$(dirname "$0")"

read -p "Digite o nome da pasta do projeto: " pasta
cd "$pasta"

git add .
read -p "Digite a mensagem do commit: " msg
git commit -m "$msg"
git push origin main

echo ""
read -p "Alteracoes enviadas com sucesso! Pressione Enter..."