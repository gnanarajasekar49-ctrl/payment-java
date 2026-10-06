@echo off

echo ========================================
echo DEPLOYMENT STARTED
echo ========================================

echo Artifact:
echo %ARTIFACT%

if not exist "%ARTIFACT%" (
    echo ERROR: Artifact does not exist.
    exit /b 1
)

echo.
echo Deploying exact artifact:
echo %ARTIFACT%

copy /Y "%ARTIFACT%" "C:\payment-server\payment.jar"

if errorlevel 1 (
    echo ERROR: Deployment failed.
    exit /b 1
)

echo.
echo ========================================
echo DEPLOYMENT COMPLETED
echo ========================================
echo Deployed artifact:
echo %ARTIFACT%

