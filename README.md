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

GardenAssistant now includes a smart PowerShell installer. The Docker deployment only requires **Git + Docker Desktop** on the host; Node.js, pnpm, Python, and application packages stay inside the container and do not need to be installed separately.

### First install

```powershell
New-Item -ItemType Directory -Force C:\Docker\GardenAssistant; git clone https://github.com/jrampey/GardenAssistant.git C:\Docker\GardenAssistant; cd C:\Docker\GardenAssistant; .\install.ps1
```

### Future updates

From the GardenAssistant folder, just run:

```powershell
.\install.ps1
```

The script detects an existing installation, pulls the latest code, preserves `data\garden.db`, rebuilds the Docker image, and starts the container. Existing host installs of Node.js, pnpm, or Python are left alone and are not required by the Docker deployment.

For a clean image rebuild without deleting garden data:

```powershell
.\install.ps1 -Mode Repair
```

Open the app at `http://localhost:3000` on the server or `http://RAMPEY-SERVER:3000` from another device on the LAN.

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
