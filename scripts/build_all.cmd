@ECHO OFF

REM Ensure we are in the correct directory

for /d %%A in ("%CD%") do set CUR_DIR=%%~nxA
if not %CUR_DIR%==pip-issue-11854-multipackage-repo goto ERRMSG

REM Main logic

del /q dist\*

for /d %%i in (pkgs\*) do (
    pushd %%i
    if not exist "build" mkdir build
    call pyproject-build -o ..\..\dist
    popd
)
goto EOF

:ERRMSG
echo ERROR: This script must be run from the repo root directory containing `pkgs`

:EOF

REM Author(s):
REM     - André Szabolcs Szelp <a.sz.szelp@gmail.com>

@ECHO ON