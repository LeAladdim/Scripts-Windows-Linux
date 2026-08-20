@echo off
set "PATH=%~dp0Git\cmd;%~dp0Git\bin;C:\Program Files\Git\cmd;%PATH%"

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [ERRO] O Git nao foi encontrado
    echo Certifique-se de que a pasta Git Portable esta na raiz do pendrive.
    echo.
    pause
    exit /b 1
)

git config --global --add safe.directory "*"

echo *** SALVAR E ENVIAR ALTERACOES ***
set /p "caminho=Arraste a pasta do projeto para ca : "
set "caminho=%caminho:"=%"

if not exist "%caminho%" (
    echo.
    echo [ERRO] A pasta nao foi encontrada!
    pause
    exit /b 1
)

cd /d "%caminho%"

if not exist ".git" (
    echo.
    echo [ERRO] Esta pasta nao e um repositorio Git
    echo Selecione a pasta raiz onde o projeto foi clonado.
    pause
    exit /b 1
)

set "TOKEN_FILE=%~dp0token.txt"
set "token="

if exist "%TOKEN_FILE%" set /p token=<"%TOKEN_FILE%"

if "%token%"=="" (
    echo.
    set /p "token=Cole o seu Token (PAT) do GitHub: "
    if not "%token%"=="" (
        echo %token%>"%TOKEN_FILE%"
        echo Token salvo com sucesso (cheque o Pendrive)
    )
)

for /f "delims=" %%i in ('git remote get-url origin 2^>nul') do set "RAW_URL=%%i"

if not "%RAW_URL%"=="" if not "%token%"=="" (
    set "URL_NO_HTTP=%RAW_URL:https://=%"
    for /f "tokens=1* delims=@" %%a in ("%RAW_URL%") do (
        if not "%%b"=="" set "URL_NO_HTTP=%%b"
    )
    git remote set-url origin "https://%token%@%URL_NO_HTTP%"
)

if exist "%~dp0gitignore.txt" copy /y "%~dp0gitignore.txt" ".gitignore" >nul

git add .

set /p "msg=Digite a mensagem do commit: "
if "%msg%"=="" set "msg=Atualizacao automatica"

git commit -m "%msg%"

echo.
echo Enviando alteracoes para o GitHub...
git push origin main --force

if %errorlevel% neq 0 goto ERRO_PUSH

echo.
echo ******************************************
echo        Commit Concluído, GGWP
echo ******************************************
echo.
pause
exit /b 0

:ERRO_PUSH
echo.
echo [ERRO] Falha ao enviar para o GitHub
echo Checa a branch e main, se o Token tem permissao e sua conexao.
echo.
pause
exit /b 1
