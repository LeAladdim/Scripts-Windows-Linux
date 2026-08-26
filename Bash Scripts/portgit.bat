@echo off
setlocal
set "HOME=%~dp0"
set "PATH=%~dp0Git\cmd;%~dp0Git\bin;%PATH%"

git --version >nul 2>&1
if errorlevel 1 (
    echo Git nao encontrado
    echo Certifique-se de que a pasta "Git" esta exatamente no mesmo local deste script
    echo %~dp0
    pause
    exit
)

git config --global --add safe.directory "*"
git config --global init.defaultBranch main

set "TOKEN_FILE=%~dp0token.txt"
set "token="
if exist "%TOKEN_FILE%" set /p token=<"%TOKEN_FILE%"

:MENU
cls
echo ******************************************
echo              Cockpit GIT 
echo ******************************************
echo 1. Git Clone
echo 2. Push
echo 3. Git Init
echo 4. Revert
echo 5. Log
echo 6. Branch Init
echo 7. Merge
echo 8. Sair
echo ==========================================
set /p "opt=Escolha uma opcao: "

:: Validar Token
if not "%opt%"=="8" (
    if "%token%"=="" (
        set /p "token=Cole seu Token do GitHub: "
        if not "%token%"=="" echo %token%>"%TOKEN_FILE%"
    )
)

if "%opt%"=="1" goto CLONAR
if "%opt%"=="2" goto SALVAR
if "%opt%"=="3" goto INIT
if "%opt%"=="4" goto REVERT
if "%opt%"=="5" goto STATUS_LOG
if "%opt%"=="6" goto NEW_BRANCH
if "%opt%"=="7" goto MERGE_BRANCH
if "%opt%"=="8" exit
goto MENU

:CLONAR
set /p "repo=URL do Repo: "
set "repo=%repo:https://=%"
echo.
echo Onde deseja salvar o repositorio?
echo (Arraste a pasta para o terminal ou cole o caminho)
set "dest="
set /p "dest=> "
if "%dest%"=="" (
    echo [ERRO] Nenhuma pasta foi informada
    pause & goto MENU
)
set "dest=%dest:"=%"
if not exist "%dest%" mkdir "%dest%"
cd /d "%dest%"
echo Clonando repositorio em "%dest%"...
git clone "https://%token%@%repo%"
pause & goto MENU

:SALVAR
call :GET_CAMINHO
if "%cam%"=="" goto MENU
cd /d "%cam%"
git add .
set /p "msg=Msg do commit: "
if "%msg%"=="" set "msg=Atualizacao automatica"
git commit -m "%msg%"
git push origin HEAD
pause & goto MENU

:INIT
echo.
echo Onde estao os codigos para iniciar o projeto?
echo [Arraste a pasta para o terminal ou cole o caminho]
set "cam="
set /p "cam=> "
if "%cam%"=="" (
    echo [ERRO] Nenhuma pasta foi informada!
    pause & goto MENU
)
set "cam=%cam:"=%"
if not exist "%cam%" mkdir "%cam%"
cd /d "%cam%"

for %%I in (.) do set "nome_pasta=%%~nxI"

git init

if not exist "README.md" (
    echo # %nome_pasta% > "README.md"
    echo Projeto inicializado Cockpit Git. >> "README.md"
)
if not exist ".gitignore" (
    echo # Arquivos ignorados pelo Git > ".gitignore"
    echo node_modules/ >> ".gitignore"
    echo .env >> ".gitignore"
    echo *.log >> ".gitignore"
    echo .idea/ >> ".gitignore"
)
if exist "%~dp0gitignore.txt" copy /y "%~dp0gitignore.txt" ".gitignore" >nul

echo.
echo Repositorio inicializado na maquina
echo.
echo O que deseja fazer agora?
echo 1. Iniciar um novo repo no Git
echo 2. Colar um link de um repositorio ja criado
echo 3. Deixar apenas no PC
set /p "init_op=Escolha (1/2/3): "

if "%init_op%"=="3" (
    echo Projeto criado apenas localmente.
    pause & goto MENU
)
if "%init_op%"=="2" goto INIT_EXISTENTE
if "%init_op%"=="1" goto INIT_NOVO
goto MENU

:INIT_EXISTENTE
set /p "repo=Cole a URL do Repositorio Remoto: "
set "repo=%repo:https://=%"
goto ENVIA_INIT

:INIT_NOVO
set "USER_FILE=%~dp0user.txt"
set "git_user="
if exist "%USER_FILE%" set /p git_user=<"%USER_FILE%"
if not "%git_user%"=="" goto NOME_REPO

echo.
set /p "git_user=Digite seu usuário no Github: "
echo %git_user%>"%USER_FILE%"

:NOME_REPO
echo.
echo Vamos criar o repositorio na sua conta
set /p "repo_name=Qual o nome do projeto? [Aperte ENTER para usar '%nome_pasta%']: "
if "%repo_name%"=="" set "repo_name=%nome_pasta%"

echo Comunicando com o GitHub para criar "%repo_name%"...
curl -s -X POST -H "Authorization: token %token%" -H "Accept: application/vnd.github.v3+json" -d "{\"name\":\"%repo_name%\",\"private\":true}" https://api.github.com/user/repos >nul

set "repo=github.com/%git_user%/%repo_name%.git"
goto ENVIA_INIT


:ENVIA_INIT
echo.
echo Preparando para enviar os codigos...
git add .
git commit -m "Projeto criado"
git branch -M main
git remote add origin "https://%token%@%repo%"
git push -u origin main

echo.
echo Repositorio configurado e codigos enviados com sucesso, GGWP
pause & goto MENU

:REVERT
call :GET_CAMINHO
if "%cam%"=="" goto MENU
cd /d "%cam%"
git revert HEAD --no-edit
echo Reversao concluida. Lembre-se de usar a Opcao 2 (Salvar e Enviar) para subir a reversao.
pause & goto MENU

:STATUS_LOG
call :GET_CAMINHO
if "%cam%"=="" goto MENU
cd /d "%cam%"
echo.
echo --- STATUS ---
git status
echo.
echo --- ULTIMOS 5 COMMITS ---
git log --oneline -n 5
echo.
pause & goto MENU

:NEW_BRANCH
call :GET_CAMINHO
if "%cam%"=="" goto MENU
cd /d "%cam%"
set /p "br=Nome da branch: "
git checkout -b %br%
git add .
git commit -m "Iniciando nova feature na branch %br%"
git push -u origin %br%
pause & goto MENU

:MERGE_BRANCH
call :GET_CAMINHO
if "%cam%"=="" goto MENU
cd /d "%cam%"
git checkout -
set /p "br=Branch secundaria para dar merge aqui: "
git merge %br%
git push origin HEAD
pause & goto MENU


:: ==========================================
:: FUNCOES AUXILIARES
:: ==========================================

:GET_CAMINHO
echo.
echo Qual a pasta do projeto?
echo [Arraste a pasta para o terminal ou cole o caminho]
set "cam="
set /p "cam=> "
if "%cam%"=="" (
    echo Sem pasta 
    set "cam="
    pause
    goto :EOF
)
set "cam=%cam:"=%"
if not exist "%cam%" (
    echo Sem pasta
    set "cam="
    pause
)
goto :EOF
