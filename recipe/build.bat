@echo on
setlocal enabledelayedexpansion

if "%target_platform%"=="win-64" (
    set "npm_config_arch=x64"
) else if "%target_platform%"=="win-arm64" (
    set "npm_config_arch=arm64"
)
if errorlevel 1 exit /b 1

@REM Don't use pre-built gyp packages
set "npm_config_build_from_source=true"
set "NPM_CONFIG_USERCONFIG=%TEMP%\nonexistentrc"

@REM Replace node symlink with `BUILD_PREFIX` version
del "%LIBRARY_BIN%\node.exe"
if errorlevel 1 exit /b 1
mklink /H "%LIBRARY_BIN%\node.exe" "%BUILD_PREFIX%\Library\bin\node.exe"
if errorlevel 1 exit /b 1

@REM pnpm WARNs about missing .EXE shims on Windows, ignore non-fatal errors
pnpm install --prod

pnpm-licenses generate-disclaimer --prod --output-file=ThirdPartyLicenses.txt
if errorlevel 1 exit /b 1

pnpm pack
if errorlevel 1 exit /b 1

npm install -g %PKG_NAME%-%PKG_VERSION%.tgz
if errorlevel 1 exit /b 1

del "%LIBRARY_BIN%\node.exe"
if errorlevel 1 exit /b 1
