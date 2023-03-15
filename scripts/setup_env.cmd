@ECHO OFF

REM: "cd . 1>NUL 2>NUL" is a safe way to reset the ERRORLEVEL variable

REM Ensure we are in the correct directory

for /d %%A in ("%CD%") do set CUR_DIR=%%~nxA
if not "%CUR_DIR%"=="pip-issue-11854-multipackage-repo" goto ERRMSG

echo Making sure we are in virtualenv "venv" ...
for /d %%A in ("%VIRTUAL_ENV%") do set VENV=%%~nxA
if not "%VENV%"=="venv" (
    if not exist venv call py -m virtualenv venv
    call venv\Scripts\activate.bat
)

echo Now working in venv "%VIRTUAL_ENV%" ...

echo Making sure pip-tools is installed...
REM needed for pip-compile
call python -m pip install --upgrade pip 1>NUL 2>NUL
call python -m pip install --upgrade setuptools 1>NUL 2>NUL
call python -m pip install --upgrade pip-tools 1>NUL 2>NUL

REM This enables to manipulate the outer scope variable in a for loop
setlocal enabledelayedexpansion
REM collect the pyproject.toml files from the individual packages
for /d %%i in (pkgs\*) do (
    set "PYPROJECT_TOMLS=%%i\pyproject.toml !PYPROJECT_TOMLS!"
)
REM -- Just using the tox-compiled `requirements.txt` from the indiv. packages
REM -- leads to version conflicts. We compile it ourselves.
echo Will compile requirements from the following pyproject.toml files:
echo %PYPROJECT_TOMLS%
echo Compiling requirements.txt...
call pip-compile -q --extra test --extra type --extra tools --output-file=%TEMP%\requirements.txt --resolver=backtracking %PYPROJECT_TOMLS%
echo Installing development requirements into development virtualenv...
call pip install -r %TEMP%\requirements.txt

goto EOF

:ERRMSG
echo ERROR: This script must be run from the repo root directory containing `pkgs`
goto EOF

:ERRMSG_2
echo ERROR: This script must be run within the virtualenv `venv`
goto EOF

:EOF

REM Author(s):
REM     - André Szabolcs Szelp <a.sz.szelp@gmail.com>

@ECHO ON