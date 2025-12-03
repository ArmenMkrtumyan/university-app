# Database Initialization Script for Windows PowerShell
# Usage: .\init_db.ps1

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Database Initialization Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will:"
Write-Host "1. Stop all containers"
Write-Host "2. Remove the database volume (postgres_data)"
Write-Host "3. Start the database"
Write-Host "4. Run the ETL process to load data"
Write-Host ""

$confirm = Read-Host "This will DELETE all existing database data. Continue? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Step 1: Stopping containers and removing volumes..." -ForegroundColor Green
docker compose down -v

Write-Host ""
Write-Host "Step 2: Cleaning up old database directory (if exists)..." -ForegroundColor Green
if (Test-Path "postgres_data") {
    Remove-Item -Path "postgres_data" -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Step 3: Starting database..." -ForegroundColor Green
docker compose up -d db

Write-Host ""
Write-Host "Step 4: Waiting for database to be ready..." -ForegroundColor Green
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "Step 5: Running ETL to load data..." -ForegroundColor Green
docker compose run --rm etl bash run_etl.sh

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Database initialization complete!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now start all services with:" -ForegroundColor Green
Write-Host "  docker compose up -d" -ForegroundColor Yellow

