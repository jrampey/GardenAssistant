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

Gardeneus includes a Docker Compose configuration for Rampey Server. The SQLite database is stored in the local `data` directory so garden data survives container rebuilds and upgrades.

### 1. Clone the repository

Open PowerShell:

```powershell
New-Item -ItemType Directory -Force C:\Docker\GardenAssistant
Set-Location C:\Docker\GardenAssistant
git clone https://github.com/jrampey/GardenAssistant.git .
```

If it is already cloned:

```powershell
Set-Location C:\Docker\GardenAssistant
git pull
```

### 2. Start GardenAssistant

```powershell
docker compose up -d --build
```

Docker Compose will build the image, create the `gardenassistant` container, expose port 3000, mount `./data` at `/app/data`, and configure the container to restart unless manually stopped.

### 3. Open the app

On Rampey Server:

```text
http://localhost:3000
```

From another device on the home network:

```text
http://RAMPEY-SERVER:3000
```

If hostname resolution is unavailable:

```text
http://<RAMPEY-SERVER-IP>:3000
```

On first run, Gardeneus creates `data/garden.db` and seeds the plant library. Configure your growing zone and frost dates in **Settings**.

### Container management

Check status:

```powershell
docker compose ps
```

View logs:

```powershell
docker compose logs -f
```

Restart:

```powershell
docker compose restart
```

Stop:

```powershell
docker compose down
```

Start again:

```powershell
docker compose up -d
```

### Update GardenAssistant

```powershell
Set-Location C:\Docker\GardenAssistant
git pull
docker compose up -d --build
```

Your SQLite database remains in `C:\Docker\GardenAssistant\data`, so rebuilding or replacing the container does not delete your garden data.

### Fresh rebuild

If you need to force a completely clean image rebuild:

```powershell
docker compose down
docker compose build --no-cache
docker compose up -d
```

Do **not** delete the `data` directory unless you intentionally want to remove the GardenAssistant database.

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
