# Gardeneus

A personal garden planning app for tracking your yard layout, plantings, and growing schedule. Built with React Server Components, Vite, and SQLite.

## Features

- **Yard Planner** — SVG grid editor with 10 bed shapes (rectangle, circle, keyhole, spiral, hugelkultur, mandala, container, path, structure, water). Drag-and-drop placement, rotation, and companion planting intelligence.
- **Plant Library** — 78 plants with zone-relative planting windows, spacing, days to harvest, companion/incompatible relationships, crop families, and succession intervals.
- **Planting Calendar** — Gantt-style timeline showing indoor start, direct sow, transplant, and harvest windows based on your frost dates. Weekly task list with checkboxes.
- **Garden Log** — Timeline of observations, watering, fertilizing, pest sightings, harvests, and more. Quick-log from the yard editor. Harvest totals per plant.
- **Crop Rotation** — Tracks plant families per bed across seasons. Warns when the same family is planted within 3 years.
- **Succession Planting** — Nudges to re-sow eligible crops (lettuce, radish, beans, etc.) at the right interval.
- **Dashboard** — This week's tasks, recent activity, yard preview, and at-a-glance stats.

## Tech Stack

- React 19 + React Server Components
- Vite 7.3 + React Router 7.13
- Tailwind CSS v4
- Drizzle ORM + better-sqlite3
- No auth — single-user, local-first

## Install on Rampey Server (Windows 11 + Docker Desktop)

Gardeneus can run as a Docker container on Rampey Server. The SQLite database should be stored outside the container so garden data survives container rebuilds and upgrades.

### 1. Open PowerShell and create the app directory

```powershell
New-Item -ItemType Directory -Force C:\Docker\GardenAssistant
Set-Location C:\Docker\GardenAssistant
```

### 2. Clone the repository

```powershell
git clone https://github.com/jrampey/GardenAssistant.git .
```

If the repository is already cloned, update it instead:

```powershell
git pull
```

### 3. Create persistent database storage

```powershell
New-Item -ItemType Directory -Force .\data
```

Gardeneus stores its SQLite database at:

```text
./data/garden.db
```

### 4. Build the Docker image

From `C:\Docker\GardenAssistant`:

```powershell
docker build -t gardenassistant .
```

The first build may take several minutes because the image installs the build tools required by `better-sqlite3`.

### 5. Start Gardeneus

```powershell
docker run -d `
  --name gardenassistant `
  --restart unless-stopped `
  -p 3000:3000 `
  -v "C:\Docker\GardenAssistant\data:/app/data" `
  gardenassistant
```

The container is configured to restart automatically with Docker.

### 6. Open the app

On Rampey Server:

```text
http://localhost:3000
```

From another device on the home network:

```text
http://RAMPEY-SERVER:3000
```

If hostname resolution is unavailable, use Rampey Server's LAN IP address:

```text
http://<RAMPEY-SERVER-IP>:3000
```

On first run, Gardeneus creates `data/garden.db` and seeds the plant library. Configure your growing zone and frost dates in **Settings**.

### Check container status

```powershell
docker ps --filter "name=gardenassistant"
```

View application logs:

```powershell
docker logs -f gardenassistant
```

### Stop / start / restart

```powershell
docker stop gardenassistant
docker start gardenassistant
docker restart gardenassistant
```

### Update Gardeneus

From PowerShell:

```powershell
Set-Location C:\Docker\GardenAssistant
git pull
docker stop gardenassistant
docker rm gardenassistant
docker build -t gardenassistant .
docker run -d `
  --name gardenassistant `
  --restart unless-stopped `
  -p 3000:3000 `
  -v "C:\Docker\GardenAssistant\data:/app/data" `
  gardenassistant
```

The `data` directory remains on Rampey Server, so rebuilding the container does not delete the garden database.

## Local Development

For development without Docker:

```sh
npm install
npm run dev
```

On first run the database is created at `./data/garden.db` and seeded with the plant library. Open the app and configure your zone + frost dates in Settings.

## Build

```sh
npm run build
npm run preview
```
