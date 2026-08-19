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

git config --global --add safe.directory "*"

echo === SALVAR E ENVIAR ALTERACOES ===
set /p "caminho=Arraste a pasta do projeto no PC para ca (ou digite o caminho): "
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
    echo [ERRO] Esta pasta nao e um repositorio Git valido!
    echo Selecione a pasta raiz onde o projeto foi clonado.
    pause
    exit /b 1
)

:: Sobrescreve forçadamente o .gitignore do projeto pelo gitignore.txt do pendrive
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
echo ==========================================
echo    Alteracoes enviadas com sucesso!
echo ==========================================
echo.
pause
exit /b 0

:ERRO_PUSH
echo.
echo [ERRO] Falha ao enviar para o GitHub!
echo Verifique se a branch e main, se o Token tem permissao e sua conexao.
echo.
pause
exit /b 1
