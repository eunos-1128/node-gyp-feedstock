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

pnpm install --prod
if errorlevel 1 exit /b 1

pnpm-licenses generate-disclaimer --prod --output-file=ThirdPartyLicenses.txt
if errorlevel 1 exit /b 1

pnpm pack
if errorlevel 1 exit /b 1

npm install -g %PKG_NAME%-%PKG_VERSION%.tgz
if errorlevel 1 exit /b 1
