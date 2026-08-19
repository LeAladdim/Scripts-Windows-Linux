@echo off
set "PATH=%~dp0Git\cmd;%~dp0Git\bin;C:\Program Files\Git\cmd;%PATH%"

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [ERRO] O Git nao foi encontrado!
    echo Certifique-se de que a pasta Git Portable esta na raiz do pendrive.
    echo.
    pause
    exit /b 1
)

echo === CLONAR REPOSITORIO ===
set /p "repo_url=Cole a URL do repositorio: "
set /p "token=Cole o seu Token PAT do GitHub: "
set /p "destino=Arraste a pasta do PC onde quer salvar o projeto: "

set "destino=%destino:"=%"

if "%destino%"=="" (
    echo.
    echo [ERRO] O caminho de destino nao pode estar vazio!
    pause
    exit /b 1
)

if not exist "%destino%" mkdir "%destino%"

cd /d "%destino%"

set "clean_url=%repo_url:https://=%"
set "auth_url=https://%token%@%clean_url%"

echo.
echo Baixando repositorio no PC...
git clone %auth_url%

if %errorlevel% neq 0 goto ERRO_CLONE

echo.
echo ==========================================
echo    Download concluido com sucesso!
echo ==========================================
echo.
pause
exit /b 0

:ERRO_CLONE
echo.
echo [ERRO] Falha ao clonar o repositorio!
echo Verifique a URL, seu Token PAT e a conexao de internet.
echo.
pause
exit /b 1
