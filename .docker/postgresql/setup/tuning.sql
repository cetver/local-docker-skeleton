----
-- Provided by https://pgtune.leopard.in.ua
----

-- OS Type: linux
-- DB Type: web
-- Total Memory (RAM): 1 GB
-- CPUs num: 4
-- Data Storage: hdd

----
-- DB version: 12
----

ALTER SYSTEM SET max_connections = '200';
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '768MB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = '0.7';
ALTER SYSTEM SET wal_buffers = '7864kB';
ALTER SYSTEM SET default_statistics_target = '100';
ALTER SYSTEM SET random_page_cost = '4';
ALTER SYSTEM SET effective_io_concurrency = '2';
ALTER SYSTEM SET work_mem = '655kB';
ALTER SYSTEM SET min_wal_size = '1GB';
ALTER SYSTEM SET max_wal_size = '4GB';
ALTER SYSTEM SET max_worker_processes = '4';
ALTER SYSTEM SET max_parallel_workers_per_gather = '2';
ALTER SYSTEM SET max_parallel_workers = '4';
ALTER SYSTEM SET max_parallel_maintenance_workers = '2';

----
-- DB version: 11
----

-- ALTER SYSTEM SET max_connections = '200';
-- ALTER SYSTEM SET shared_buffers = '256MB';
-- ALTER SYSTEM SET effective_cache_size = '768MB';
-- ALTER SYSTEM SET maintenance_work_mem = '64MB';
-- ALTER SYSTEM SET checkpoint_completion_target = '0.7';
-- ALTER SYSTEM SET wal_buffers = '7864kB';
-- ALTER SYSTEM SET default_statistics_target = '100';
-- ALTER SYSTEM SET random_page_cost = '4';
-- ALTER SYSTEM SET effective_io_concurrency = '2';
-- ALTER SYSTEM SET work_mem = '655kB';
-- ALTER SYSTEM SET min_wal_size = '1GB';
-- ALTER SYSTEM SET max_wal_size = '4GB';
-- ALTER SYSTEM SET max_worker_processes = '4';
-- ALTER SYSTEM SET max_parallel_workers_per_gather = '2';
-- ALTER SYSTEM SET max_parallel_workers = '4';
-- ALTER SYSTEM SET max_parallel_maintenance_workers = '2';

----
-- DB version: 10
----

-- ALTER SYSTEM SET max_connections = '200';
-- ALTER SYSTEM SET shared_buffers = '256MB';
-- ALTER SYSTEM SET effective_cache_size = '768MB';
-- ALTER SYSTEM SET maintenance_work_mem = '64MB';
-- ALTER SYSTEM SET checkpoint_completion_target = '0.7';
-- ALTER SYSTEM SET wal_buffers = '7864kB';
-- ALTER SYSTEM SET default_statistics_target = '100';
-- ALTER SYSTEM SET random_page_cost = '4';
-- ALTER SYSTEM SET effective_io_concurrency = '2';
-- ALTER SYSTEM SET work_mem = '655kB';
-- ALTER SYSTEM SET min_wal_size = '1GB';
-- ALTER SYSTEM SET max_wal_size = '4GB';
-- ALTER SYSTEM SET max_worker_processes = '4';
-- ALTER SYSTEM SET max_parallel_workers_per_gather = '2';
-- ALTER SYSTEM SET max_parallel_workers = '4';

----
-- DB version: 9.6
----

-- ALTER SYSTEM SET max_connections = '200';
-- ALTER SYSTEM SET shared_buffers = '256MB';
-- ALTER SYSTEM SET effective_cache_size = '768MB';
-- ALTER SYSTEM SET maintenance_work_mem = '64MB';
-- ALTER SYSTEM SET checkpoint_completion_target = '0.7';
-- ALTER SYSTEM SET wal_buffers = '7864kB';
-- ALTER SYSTEM SET default_statistics_target = '100';
-- ALTER SYSTEM SET random_page_cost = '4';
-- ALTER SYSTEM SET effective_io_concurrency = '2';
-- ALTER SYSTEM SET work_mem = '655kB';
-- ALTER SYSTEM SET min_wal_size = '1GB';
-- ALTER SYSTEM SET max_wal_size = '4GB';
-- ALTER SYSTEM SET max_worker_processes = '4';
-- ALTER SYSTEM SET max_parallel_workers_per_gather = '2';

----
-- DB version: 9.5
----

-- ALTER SYSTEM SET max_connections = '200';
-- ALTER SYSTEM SET shared_buffers = '256MB';
-- ALTER SYSTEM SET effective_cache_size = '768MB';
-- ALTER SYSTEM SET maintenance_work_mem = '64MB';
-- ALTER SYSTEM SET checkpoint_completion_target = '0.7';
-- ALTER SYSTEM SET wal_buffers = '7864kB';
-- ALTER SYSTEM SET default_statistics_target = '100';
-- ALTER SYSTEM SET random_page_cost = '4';
-- ALTER SYSTEM SET effective_io_concurrency = '2';
-- ALTER SYSTEM SET work_mem = '1310kB';
-- ALTER SYSTEM SET min_wal_size = '1GB';
-- ALTER SYSTEM SET max_wal_size = '4GB';
-- ALTER SYSTEM SET max_worker_processes = '4';