@REM @echo off
@REM setlocal ENABLEDELAYEDEXPANSION

@REM rem ============================================================
@REM rem 1. Detect project root
@REM rem    Current script is in: realtek\tools\env_test\
@REM rem    So project root is:   realtek\
@REM rem    If your layout is different, adjust the ..\..\ below.
@REM rem ============================================================
@REM set "SCRIPT_DIR=%~dp0"
@REM pushd "%SCRIPT_DIR%\..\.."  2>nul
@REM set "PROJ_ROOT=%CD%"
@REM popd

@REM echo Project root: %PROJ_ROOT%

@REM rem ============================================================
@REM rem 1.5 Download & extract toolchains to the same dir as env
@REM rem     (i.e. into %PROJ_ROOT%)
@REM rem ============================================================
@REM set "DL_DIR=%PROJ_ROOT%"

@REM rem --- Download URLs ---
@REM set "ARM_GNU_URL=https://developer.arm.com/-/media/files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.zip?rev=93fda279901c4c0299e03e5c4899b51f&revision=93fda279-901c-4c02-99e0-3e5c4899b51f&hash=6D4143DACC9AF570096EB2A038C54605"
@REM set "MINGW_URL=https://sourceforge.net/projects/mingw-w64/files/Toolchains%%20targetting%%20Win64/Personal%%20Builds/mingw-builds/8.1.0/threads-posix/sjlj/x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z/download"

@REM rem --- Local archive paths ---
@REM set "ARM_GNU_ZIP=%DL_DIR%\arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.zip"
@REM set "MINGW_7Z=%DL_DIR%\x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z"

@REM rem --- Target extract folders ---
@REM set "ARM_GNU_DIR=%DL_DIR%\arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi"
@REM set "MINGW_DIR=%DL_DIR%\mingw64"

@REM echo.
@REM echo [INFO] Checking ARM GNU toolchain...

@REM if not exist "%ARM_GNU_DIR%" (
@REM     echo   ARM GNU toolchain not found, downloading...
@REM     powershell -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri '%ARM_GNU_URL%' -OutFile '%ARM_GNU_ZIP%'"
@REM     if exist "%ARM_GNU_ZIP%" (
@REM         echo   Downloaded: %ARM_GNU_ZIP%
@REM         echo.
@REM         echo   [PAUSE] ARM GNU ZIP download finished, press Enter to start extraction...
@REM         pause

@REM         echo   Extracting ARM GNU toolchain...
@REM         powershell -NoLogo -NoProfile -Command "Expand-Archive -LiteralPath '%ARM_GNU_ZIP%' -DestinationPath '%DL_DIR%' -Force"
@REM         if exist "%ARM_GNU_DIR%" (
@REM             echo   Extracted to: %ARM_GNU_DIR%
@REM             echo.
@REM             echo   [PAUSE] ARM GNU extraction finished, press Enter to continue...
@REM             pause

@REM             del /f /q "%ARM_GNU_ZIP%"
@REM             echo   Deleted archive: %ARM_GNU_ZIP%
@REM         ) else (
@REM             echo   [ERROR] ARM GNU toolchain extraction failed.
@REM         )
@REM     ) else (
@REM         echo   [ERROR] ARM GNU toolchain download failed.
@REM     )
@REM ) else (
@REM     echo   ARM GNU toolchain already exists: %ARM_GNU_DIR%
@REM )

@REM echo.
@REM echo [INFO] Checking MinGW-w64 toolchain...

@REM if not exist "%MINGW_DIR%" (
@REM     echo   MinGW-w64 not found, downloading...
@REM     echo   URL      : %MINGW_URL%
@REM     echo   Save to  : %MINGW_7Z%

@REM     rem Use curl to download (builtin on Windows 10+), -L follows redirects
@REM     curl -L -C - --retry 5 --retry-delay 5 -o "%MINGW_7Z%" "%MINGW_URL%"
@REM     if errorlevel 1 (
@REM         echo   [ERROR] curl download failed, exit code: !ERRORLEVEL!
@REM         goto :AFTER_MINGW
@REM     )

@REM     if exist "%MINGW_7Z%" (
@REM         echo   Downloaded: %MINGW_7Z%
@REM         echo.
@REM         echo   [PAUSE] MinGW 7z download finished, press Enter to start extraction...
@REM         pause

@REM         rem ================================
@REM         rem 1. First search 7z.exe in PATH
@REM         rem ================================
@REM         set "SEVENZIP_EXE="
@REM         for /f "delims=" %%I in ('where 7z.exe 2^>nul') do (
@REM             if not defined SEVENZIP_EXE set "SEVENZIP_EXE=%%I"
@REM         )

@REM         rem ================================
@REM         rem 2. If not found in PATH, search common install locations
@REM         rem ================================
@REM         if not defined SEVENZIP_EXE (
@REM             if exist "%ProgramFiles%\7-Zip\7z.exe" (
@REM                 set "SEVENZIP_EXE=%ProgramFiles%\7-Zip\7z.exe"
@REM             ) else if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" (
@REM                 set "SEVENZIP_EXE=%ProgramFiles(x86)%\7-Zip\7z.exe"
@REM             )
@REM         )

@REM         rem ================================
@REM         rem 3. Use located 7z.exe to extract
@REM         rem ================================
@REM         if defined SEVENZIP_EXE (
@REM             echo   Using 7-Zip: !SEVENZIP_EXE!
@REM             echo   Extracting MinGW-w64...
@REM             "!SEVENZIP_EXE!" x "%MINGW_7Z%" -o"%MINGW_DIR%" -y

@REM             if exist "%MINGW_DIR%" (
@REM                 echo   Extracted to: %MINGW_DIR%
@REM                 echo.
@REM                 echo   [PAUSE] MinGW extraction finished, press Enter to continue...
@REM                 pause

@REM                 del /f /q "%MINGW_7Z%"
@REM                 echo   Deleted archive: %MINGW_7Z%
@REM             ) else (
@REM                 echo   [ERROR] MinGW-w64 extraction failed
@REM             )
@REM         ) else (
@REM             echo   [WARN] 7-Zip not found (7z.exe not in PATH or default install dirs)
@REM             echo   Please install 7-Zip and extract it manually to: %MINGW_DIR%
@REM         )
@REM     ) else (
@REM         echo   [ERROR] MinGW-w64 download failed, file not found: %MINGW_7Z%
@REM     )
@REM ) else (
@REM     echo   MinGW-w64 already exists: %MINGW_DIR%
@REM )

@REM :AFTER_MINGW

@REM rem ============================================================
@REM rem 2. Decide which toolchain is the DEFAULT compiler
@REM rem ============================================================
@REM set "TOOLCHAIN=%~1"
@REM if "%TOOLCHAIN%"=="" (
@REM     echo No toolchain specified, default to "mingw".
@REM     set "TOOLCHAIN=mingw"
@REM ) else (
@REM     echo Selected toolchain: %TOOLCHAIN%
@REM )

@REM rem ============================================================
@REM rem 3. Configure TOOL ROOTS
@REM rem ============================================================
@REM set "MINGW_ROOT=%MINGW_DIR%"
@REM set "GNU_ARM_ROOT=%ARM_GNU_DIR%"

@REM rem ============================================================
@REM rem 4. [Env isolation preparation] Capture local Python path
@REM rem    (before masking external environment)
@REM rem ============================================================
@REM echo.
@REM echo [INFO] Locating System Python before isolating environment...
@REM set "SYS_PYTHON_DIR="
@REM for /f "delims=" %%i in ('where python 2^>nul') do (
@REM     set "SYS_PYTHON_DIR=%%~dpi"
@REM     goto :found_python
@REM )
@REM :found_python
@REM if not defined SYS_PYTHON_DIR (
@REM     echo [ERROR] Python not found in current system. Please install Python and add to PATH.
@REM     goto :END
@REM )
@REM echo   Found Python at: !SYS_PYTHON_DIR!
@REM set "PYTHON_EXE=python"

@REM rem ============================================================
@REM rem 5. [Core isolation logic] Reset system vars, cut off external interference (Clean Room)
@REM rem ============================================================
@REM echo.
@REM echo [INFO] Isolating environment (Masking local PATH and Env Vars)...

@REM rem Clear local environment variables that may cause build conflicts
@REM set "PYTHONHOME="
@REM set "PYTHONPATH="
@REM set "INCLUDE="
@REM set "LIB="
@REM set "CPATH="
@REM set "LIBRARY_PATH="

@REM rem Build a minimal clean PATH: only keep core Windows commands and the located Python
@REM set "CLEAN_PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\;%SYS_PYTHON_DIR%;%SYS_PYTHON_DIR%Scripts\"

@REM rem Completely overwrite PATH, discard original messy PATH
@REM set "PATH=%CLEAN_PATH%"
@REM echo   + Local PATH masked. Built clean foundation.

@REM rem ============================================================
@REM rem 6. Add downloaded toolchains into the clean PATH
@REM rem ============================================================
@REM echo.
@REM echo [INFO] Adding Toolchains to isolated PATH...

@REM if exist "%MINGW_ROOT%\mingw64\bin" (
@REM     set "PATH=%MINGW_ROOT%\mingw64\bin;%PATH%"
@REM     echo   + MINGW_ROOT added: %MINGW_ROOT%\mingw64\bin
@REM     pause
@REM ) else (
@REM     echo   [WARN] MINGW_ROOT not found: %MINGW_ROOT%\bin
@REM )

@REM if exist "%GNU_ARM_ROOT%\bin" (
@REM     set "PATH=%GNU_ARM_ROOT%\bin;%GNU_ARM_ROOT%\arm-none-eabi\bin;%PATH%"
@REM     echo   + GNU_ARM_ROOT added: %GNU_ARM_ROOT%\bin and arm-none-eabi\bin
@REM     pause
@REM ) else (
@REM     echo   [WARN] GNU_ARM_ROOT not found: %GNU_ARM_ROOT%\bin
@REM )

@REM rem If CMAKE_BIN / NINJA_BIN / GIT_BIN are set locally, also add them into the clean env
@REM if exist "%CMAKE_BIN%" (
@REM     set "PATH=%CMAKE_BIN%;%PATH%"
@REM     echo   + CMake added
@REM )
@REM if exist "%NINJA_BIN%" (
@REM     set "PATH=%NINJA_BIN%;%PATH%"
@REM     echo   + Ninja added
@REM )
@REM if exist "%GIT_BIN%" (
@REM     set "PATH=%GIT_BIN%;%PATH%"
@REM     echo   + Git added
@REM )

@REM rem ============================================================
@REM rem 7. Create / activate venv (at this point environment is already clean)
@REM rem ============================================================
@REM set "VENV_DIR=%PROJ_ROOT%\env"
@REM if not exist "%VENV_DIR%\Scripts\activate.bat" (
@REM     echo.
@REM     echo [INFO] Virtual environment not found, creating: %VENV_DIR%
@REM     "%PYTHON_EXE%" -m venv "%VENV_DIR%"
@REM )

@REM echo.
@REM echo [INFO] Activating virtual environment...
@REM call "%VENV_DIR%\Scripts\activate.bat"

@REM rem ============================================================
@REM rem 8. Upgrade pip & install dependencies
@REM rem ============================================================
@REM echo.
@REM echo [INFO] Upgrading pip...
@REM python -m pip install -U pip

@REM if exist "%SCRIPT_DIR%requirements.txt" (
@REM     echo.
@REM     echo [INFO] Installing Python dependencies ^(cmake/ninja/kconfiglib, etc.^)
@REM     python -m pip install -r "%SCRIPT_DIR%requirements.txt"
@REM ) else (
@REM     echo.
@REM     echo [WARN] %SCRIPT_DIR%requirements.txt not found, skipping dependency installation
@REM )


@REM echo.
@REM echo [OK] Clean Environment is ready!
@REM echo Project root      : %PROJ_ROOT%
@REM echo Default compiler  : %CC%
@REM echo Python executable : %PYTHON_EXE%
@REM echo.

@REM rem Keep this shell open so you can run cmake/ninja/make commands safely
@REM cmd /k

@REM :END
@REM endlocal


@echo off
setlocal ENABLEDELAYEDEXPANSION

rem ============================================================
rem 1. Detect project root
rem    Current script is in: realtek\tools\env_test\
rem    So project root is:   realtek\
rem    If your layout is different, adjust the ..\..\ below.
rem ============================================================
set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%\..\.."  2>nul
set "PROJ_ROOT=%CD%"
popd

echo Project root: %PROJ_ROOT%

rem ============================================================
rem 1.1 Define ENV directory under script directory
rem     All toolchains / ninja / venv will be placed here
rem     e.g. <SCRIPT_DIR>\env\
rem ============================================================
set "ENV_DIR=%SCRIPT_DIR%env"
if not exist "%ENV_DIR%" (
    mkdir "%ENV_DIR%"
)

rem ============================================================
rem 1.5 Download & extract toolchains into ENV_DIR
rem     (i.e. into %ENV_DIR%)
rem ============================================================
set "DL_DIR=%ENV_DIR%"

rem --- Download URLs ---
set "ARM_GNU_URL=https://developer.arm.com/-/media/files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.zip?rev=93fda279901c4c0299e03e5c4899b51f&revision=93fda279-901c-4c02-99e0-3e5c4899b51f&hash=6D4143DACC9AF570096EB2A038C54605"
set "MINGW_URL=https://sourceforge.net/projects/mingw-w64/files/Toolchains%%20targetting%%20Win64/Personal%%20Builds/mingw-builds/8.1.0/threads-posix/sjlj/x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z/download"

rem --- Local archive paths (under ENV_DIR) ---
set "ARM_GNU_ZIP=%DL_DIR%\arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi.zip"
set "MINGW_7Z=%DL_DIR%\x86_64-8.1.0-release-posix-sjlj-rt_v6-rev0.7z"

rem --- Target extract folders (under ENV_DIR) ---
set "ARM_GNU_DIR=%DL_DIR%\arm-gnu-toolchain-13.2.rel1-mingw-w64-i686-arm-none-eabi"
set "MINGW_DIR=%DL_DIR%\mingw64"

echo.
echo [INFO] Checking ARM GNU toolchain...

if not exist "%ARM_GNU_DIR%" (
    echo   ARM GNU toolchain not found, downloading...
    powershell -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri '%ARM_GNU_URL%' -OutFile '%ARM_GNU_ZIP%'"
    if exist "%ARM_GNU_ZIP%" (
        echo   Downloaded: %ARM_GNU_ZIP%
        echo.
        echo   [PAUSE] ARM GNU ZIP download finished, press Enter to start extraction...
        pause

        echo   Extracting ARM GNU toolchain...
        powershell -NoLogo -NoProfile -Command "Expand-Archive -LiteralPath '%ARM_GNU_ZIP%' -DestinationPath '%DL_DIR%' -Force"
        if exist "%ARM_GNU_DIR%" (
            echo   Extracted to: %ARM_GNU_DIR%
            echo.
            echo   [PAUSE] ARM GNU extraction finished, press Enter to continue...
            pause

            del /f /q "%ARM_GNU_ZIP%"
            echo   Deleted archive: %ARM_GNU_ZIP%
        ) else (
            echo   [ERROR] ARM GNU toolchain extraction failed.
        )
    ) else (
        echo   [ERROR] ARM GNU toolchain download failed.
    )
) else (
    echo   ARM GNU toolchain already exists: %ARM_GNU_DIR%
)

echo.
echo [INFO] Checking MinGW-w64 toolchain...

if not exist "%MINGW_DIR%" (
    echo   MinGW-w64 not found, downloading...
    echo   URL      : %MINGW_URL%
    echo   Save to  : %MINGW_7Z%

    rem Use curl to download (builtin on Windows 10+), -L follows redirects
    curl -L -C - --retry 5 --retry-delay 5 -o "%MINGW_7Z%" "%MINGW_URL%"
    if errorlevel 1 (
        echo   [ERROR] curl download failed, exit code: !ERRORLEVEL!
        goto :AFTER_MINGW
    )

    if exist "%MINGW_7Z%" (
        echo   Downloaded: %MINGW_7Z%
        echo.
        echo   [PAUSE] MinGW 7z download finished, press Enter to start extraction...
        pause

        rem ================================
        rem 1. First search 7z.exe in PATH
        rem ================================
        set "SEVENZIP_EXE="
        for /f "delims=" %%I in ('where 7z.exe 2^>nul') do (
            if not defined SEVENZIP_EXE set "SEVENZIP_EXE=%%I"
        )

        rem ================================
        rem 2. If not found in PATH, search common install locations
        rem ================================
        if not defined SEVENZIP_EXE (
            if exist "%ProgramFiles%\7-Zip\7z.exe" (
                set "SEVENZIP_EXE=%ProgramFiles%\7-Zip\7z.exe"
            ) else if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" (
                set "SEVENZIP_EXE=%ProgramFiles(x86)%\7-Zip\7z.exe"
            )
        )

        rem ================================
        rem 3. Use located 7z.exe to extract
        rem ================================
        if defined SEVENZIP_EXE (
            echo   Using 7-Zip: !SEVENZIP_EXE!
            echo   Extracting MinGW-w64...
            "!SEVENZIP_EXE!" x "%MINGW_7Z%" -o"%MINGW_DIR%" -y

            if exist "%MINGW_DIR%" (
                echo   Extracted to: %MINGW_DIR%
                echo.
                echo   [PAUSE] MinGW extraction finished, press Enter to continue...
                pause

                del /f /q "%MINGW_7Z%"
                echo   Deleted archive: %MINGW_7Z%
            ) else (
                echo   [ERROR] MinGW-w64 extraction failed
            )
        ) else (
            echo   [WARN] 7-Zip not found (7z.exe not in PATH or default install dirs)
            echo   Please install 7-Zip and extract it manually to: %MINGW_DIR%
        )
    ) else (
        echo   [ERROR] MinGW-w64 download failed, file not found: %MINGW_7Z%
    )
) else (
    echo   MinGW-w64 already exists: %MINGW_DIR%
)

rem ============================================================
rem 1.6 Download & extract Ninja (fixed version) into ENV_DIR
rem ============================================================
set "NINJA_URL=https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-win.zip"
set "NINJA_ZIP=%DL_DIR%\ninja-win.zip"
set "NINJA_DIR=%DL_DIR%\ninja"

echo.
echo [INFO] Checking Ninja (from GitHub)...

if not exist "%NINJA_DIR%\ninja.exe" (
    echo   Ninja not found, downloading...
    powershell -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri '%NINJA_URL%' -OutFile '%NINJA_ZIP%'"
    if exist "%NINJA_ZIP%" (
        echo   Downloaded: %NINJA_ZIP%
        echo.
        echo   [PAUSE] Ninja ZIP download finished, press Enter to start extraction...
        pause

        if exist "%NINJA_DIR%" (
            echo   Cleaning existing Ninja directory: %NINJA_DIR%
            rmdir /s /q "%NINJA_DIR%" 2>nul
        )
        mkdir "%NINJA_DIR%" 2>nul

        echo   Extracting Ninja...
        powershell -NoLogo -NoProfile -Command "Expand-Archive -LiteralPath '%NINJA_ZIP%' -DestinationPath '%NINJA_DIR%' -Force"
        if exist "%NINJA_DIR%\ninja.exe" (
            echo   Extracted to: %NINJA_DIR%
            echo.
            echo   [PAUSE] Ninja extraction finished, press Enter to continue...
            pause

            del /f /q "%NINJA_ZIP%"
            echo   Deleted archive: %NINJA_ZIP%
        ) else (
            echo   [ERROR] Ninja extraction failed.
        )
    ) else (
        echo   [ERROR] Ninja download failed.
    )
) else (
    echo   Ninja already exists: %NINJA_DIR%\ninja.exe
)

:NINJA_DONE

:AFTER_MINGW

rem ============================================================
rem 2. Decide which toolchain is the DEFAULT compiler
rem ============================================================
set "TOOLCHAIN=%~1"
if "%TOOLCHAIN%"=="" (
    echo No toolchain specified, default to "mingw".
    set "TOOLCHAIN=mingw"
) else (
    echo Selected toolchain: %TOOLCHAIN%
)

rem ============================================================
rem 3. Configure TOOL ROOTS (all under ENV_DIR now)
rem ============================================================
set "MINGW_ROOT=%MINGW_DIR%"
set "GNU_ARM_ROOT=%ARM_GNU_DIR%"
set "NINJA_BIN=%NINJA_DIR%"

rem ============================================================
rem 4. [Env isolation preparation] Capture local Python path
rem    (before masking external environment)
rem ============================================================
echo.
echo [INFO] Locating System Python before isolating environment...
set "SYS_PYTHON_DIR="
for /f "delims=" %%i in ('where python 2^>nul') do (
    set "SYS_PYTHON_DIR=%%~dpi"
    goto :found_python
)
:found_python
if not defined SYS_PYTHON_DIR (
    echo [ERROR] Python not found in current system. Please install Python and add to PATH.
    goto :END
)
echo   Found Python at: !SYS_PYTHON_DIR!
set "PYTHON_EXE=python"

rem ============================================================
rem 5. [Core isolation logic] Reset system vars, cut off external interference (Clean Room)
rem ============================================================
echo.
echo [INFO] Isolating environment (Masking local PATH and Env Vars)...

rem Clear local environment variables that may cause build conflicts
set "PYTHONHOME="
set "PYTHONPATH="
set "INCLUDE="
set "LIB="
set "CPATH="
set "LIBRARY_PATH="

rem Build a minimal clean PATH: only keep core Windows commands and the located Python
set "CLEAN_PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\;%SYS_PYTHON_DIR%;%SYS_PYTHON_DIR%Scripts\"

rem Completely overwrite PATH, discard original messy PATH
set "PATH=%CLEAN_PATH%"
echo   + Local PATH masked. Built clean foundation.

rem ============================================================
rem 6. Add downloaded toolchains into the clean PATH
rem ============================================================
echo.
echo [INFO] Adding Toolchains to isolated PATH...

if exist "%MINGW_ROOT%\mingw64\bin" (
    set "PATH=%MINGW_ROOT%\mingw64\bin;%PATH%"
    echo   + MINGW_ROOT added: %MINGW_ROOT%\mingw64\bin
    pause
) else (
    echo   [WARN] MINGW_ROOT not found: %MINGW_ROOT%\bin
)

if exist "%GNU_ARM_ROOT%\bin" (
    set "PATH=%GNU_ARM_ROOT%\bin;%GNU_ARM_ROOT%\arm-none-eabi\bin;%PATH%"
    echo   + GNU_ARM_ROOT added: %GNU_ARM_ROOT%\bin and arm-none-eabi\bin
    pause
) else (
    echo   [WARN] GNU_ARM_ROOT not found: %GNU_ARM_ROOT%\bin
)

rem If CMAKE_BIN / NINJA_BIN / GIT_BIN are set locally, also add them into the clean env
if exist "%CMAKE_BIN%" (
    set "PATH=%CMAKE_BIN%;%PATH%"
    echo   + CMake added
)
if exist "%NINJA_BIN%" (
    set "PATH=%NINJA_BIN%;%PATH%"
    echo   + Ninja added (from GitHub release)
)
if exist "%GIT_BIN%" (
    set "PATH=%GIT_BIN%;%PATH%"
    echo   + Git added
)

rem ============================================================
rem 7. Create / activate venv (at this point environment is already clean)
rem    VENV_DIR is now ENV_DIR (i.e. <SCRIPT_DIR>\env)
rem ============================================================
set "VENV_DIR=%ENV_DIR%"
if not exist "%VENV_DIR%\Scripts\activate.bat" (
    echo.
    echo [INFO] Virtual environment not found, creating: %VENV_DIR%
    "%PYTHON_EXE%" -m venv "%VENV_DIR%"
)

echo.
echo [INFO] Activating virtual environment...
call "%VENV_DIR%\Scripts\activate.bat"

rem ============================================================
rem 8. Upgrade pip & install dependencies
rem ============================================================
echo.
echo [INFO] Upgrading pip...
python -m pip install -U pip

if exist "%SCRIPT_DIR%requirements.txt" (
    echo.
    echo [INFO] Installing Python dependencies ^(cmake/ninja/kconfiglib, etc.^)
    python -m pip install -r "%SCRIPT_DIR%requirements.txt"
) else (
    echo.
    echo [WARN] %SCRIPT_DIR%requirements.txt not found, skipping dependency installation
)

rem ============================================================
rem 9. Show environment summary (including newly added variables)
rem ============================================================
echo.
echo [OK] Clean Environment is ready!
echo ------------------------------------------------------------
echo [SUMMARY] Basic Info
echo   Project root      : %PROJ_ROOT%
echo   ENV directory     : %ENV_DIR%
echo   Virtualenv (VENV) : %VENV_DIR%
echo   Python executable : %PYTHON_EXE%
echo   System Python dir : %SYS_PYTHON_DIR%
echo   Selected toolchain: %TOOLCHAIN%
echo   Default compiler  : %CC%
echo.
echo [SUMMARY] Toolchain / Tools Paths
echo   MINGW_ROOT        : %MINGW_ROOT%
echo   GNU_ARM_ROOT      : %GNU_ARM_ROOT%
echo   NINJA_BIN         : %NINJA_BIN%
if defined CMAKE_BIN echo   CMAKE_BIN         : %CMAKE_BIN%
if defined GIT_BIN   echo   GIT_BIN           : %GIT_BIN%
echo.
echo [SUMMARY] Effective PATH in this shell:
echo   %PATH%
echo ------------------------------------------------------------
echo.

rem Keep this shell open so you can run cmake/ninja/make commands safely
cmd /k

:END
endlocal
