@echo off
cd /d "%~dp0"

set /p repo_url="Cole a URL do repositorio (ex: https://github.com/usuario/repo.git): "
set /p token="Cole o seu Token (PAT) do GitHub: "

rem Remove o https:// inicial para juntar com o token sem erros
set clean_url=%repo_url:https://=%
set auth_url=https://%token%@%clean_url%

echo.
echo Baixando o repositorio...
git clone %auth_url%

echo.
echo Download concluido!
pause