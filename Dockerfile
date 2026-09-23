FROM node:22-slim AS base

# Native dependencies such as better-sqlite3 require Python and build tools.
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Use the latest pnpm. pnpm 10+ requires dependency build scripts to be
# explicitly approved. package.json contains pnpm.onlyBuiltDependencies.
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app
COPY . .

# Rebuild the lockfile metadata when a newer pnpm introduces install-policy
# metadata, then install using the resulting lockfile.
RUN pnpm install --no-frozen-lockfile
RUN pnpm build

EXPOSE 3000 3001

CMD ["pnpm", "start"]
