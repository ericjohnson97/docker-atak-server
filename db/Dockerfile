# Multi-arch base (has arm64)
FROM postgres:15-bullseye

# Install PostGIS server-side packages for PG15
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-15-postgis-3 postgresql-15-postgis-3-scripts \
 && rm -rf /var/lib/apt/lists/*
