@ECHO OFF

REM Ensure we are in the correct directory

for /d %%A in ("%CD%") do set CUR_DIR=%%~nxA
if not %CUR_DIR%==pip-issue-11854-multipackage-repo goto ERRMSG

REM Main logic

REM This enables to manipulate the outer scope variable in a for loop
REM -- SETLOCAL works in `update_reqs`, but not here. I guess, because
REM -- it is wrapped inside another `IF`.
REM setlocal enabledelayedexpansion
for /d %%i in (pkgs\*) do (
    pushd %%i
    if not exist "build" mkdir build
    call tox run
    REM if ERRORLEVEL 1 set "ANY_ERROR=+!ANY_ERROR!"
    popd
)

echo.
echo ================================== IMPORTANT ==================================
echo The last lines, even if green, only refer to the last package tested!!!
echo There might have been packages that failed, but they scrolled out of the
echo screen.
echo.
echo ============ PLEASE SCROLL UP AND ENSURE THAT ALL TESTS WERE GREEN! ===========

goto :EOF



:ERRMSG
echo ERROR: This script must be run from the repo root directory containing `pkgs` 1>&2
goto EOF

:TEST_FAIL
ECHO "ERROR: Some tests failed!" 1>&2
ECHO "       Note, that the last potentially green lines only refer to the last package." 1>&2
ECHO "       The failed tests might have scrolled out of the current view." 1>&2
goto EOF

:EOF

REM Author(s):
REM     - André Szabolcs Szelp <a.sz.szelp@gmail.com>

@ECHO ON