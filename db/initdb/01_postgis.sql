-- Ensures PostGIS is ready on first init of $POSTGRES_DB
CREATE EXTENSION IF NOT EXISTS postgis;
-- optional, uncomment if you use topology:
-- CREATE EXTENSION IF NOT EXISTS postgis_topology;
