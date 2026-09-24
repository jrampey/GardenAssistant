[CmdletBinding()]
param(
    [ValidateSet("Auto","Install","Update","Repair")]
    [string]$Mode = "Auto",
    [string]$InstallPath = "C:\Docker\GardenAssistant"
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/jrampey/GardenAssistant.git"

function Say($Message) { Write-Host "[GardenAssistant] $Message" -ForegroundColor Cyan }
function Need($Command, $FriendlyName) {
    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        throw "$FriendlyName is required but was not found. Install $FriendlyName, then run this script again."
    }
}

Say "Checking prerequisites..."
Need "git" "Git"
Need "docker" "Docker Desktop"

try { docker info *> $null } catch { throw "Docker is installed but is not running. Start Docker Desktop and try again." }
docker compose version *> $null
if ($LASTEXITCODE -ne 0) { throw "Docker Compose is required. Update Docker Desktop and try again." }

$installed = Test-Path (Join-Path $InstallPath ".git")
if ($Mode -eq "Auto") { $Mode = if ($installed) { "Update" } else { "Install" } }

if ($Mode -eq "Install") {
    if ($installed) {
        Say "Existing install detected; switching to update."
    } else {
        Say "Installing to $InstallPath..."
        New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null
        git clone $RepoUrl $InstallPath
    }
}

Set-Location $InstallPath

if ($Mode -eq "Update" -or $installed) {
    Say "Updating source..."
    git pull --ff-only
}

Say "Ensuring persistent data directory exists..."
New-Item -ItemType Directory -Force -Path (Join-Path $InstallPath "data") | Out-Null

if ($Mode -eq "Repair") {
    Say "Repair mode: rebuilding from scratch without deleting garden data..."
    docker compose down
    docker compose build --no-cache
    docker compose up -d
} else {
    Say "Building and starting GardenAssistant..."
    docker compose up -d --build
}

if ($LASTEXITCODE -ne 0) { throw "Docker Compose failed. Run 'docker compose logs --tail 100' from $InstallPath for details." }

Say "Done."
docker compose ps
Write-Host ""
Write-Host "Open: http://localhost:3000" -ForegroundColor Green
Write-Host "Your garden database remains in: $InstallPath\data" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Future updates: .\install.ps1" -ForegroundColor Yellow
Write-Host "Clean repair:   .\install.ps1 -Mode Repair" -ForegroundColor Yellow
