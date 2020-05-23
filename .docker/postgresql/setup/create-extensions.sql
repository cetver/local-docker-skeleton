-- SELECT * FROM pg_available_extensions WHERE installed_version IS NOT NULL;

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS adminpack;
CREATE EXTENSION IF NOT EXISTS tablefunc;
-- uuid 4
CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- other uuids
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS xml2;