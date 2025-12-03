@echo off
REM Database Initialization Script for Windows
REM Usage: init_db.bat

echo ==========================================
echo Database Initialization Script
echo ==========================================
echo.
echo This script will:
echo 1. Stop all containers
echo 2. Remove the database volume (postgres_data)
echo 3. Start the database
echo 4. Run the ETL process to load data
echo.
set /p confirm="This will DELETE all existing database data. Continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Cancelled.
    exit /b 1
)

echo.
echo Step 1: Stopping containers and removing volumes...
docker compose down -v

echo.
echo Step 2: Cleaning up old database directory (if exists)...
if exist postgres_data\ (
    rmdir /s /q postgres_data 2>nul
)

echo.
echo Step 3: Starting database...
docker compose up -d db

echo.
echo Step 4: Waiting for database to be ready...
timeout /t 5 /nobreak >nul

echo.
echo Step 5: Running ETL to load data...
docker compose run --rm etl bash run_etl.sh

echo.
echo ==========================================
echo Database initialization complete!
echo ==========================================
echo.
echo You can now start all services with:
echo   docker compose up -d

