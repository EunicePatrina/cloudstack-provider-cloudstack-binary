vm_name                = "pgcoe-postgres-instance"
display_name           = "pgcoe-postgres-instance"
service_offering       = "standard.2x4.any"
template_id            = "b0934433-b28a-4019-b83b-312e399ecb8d"
root_disk_size         = 25
disk_offering          = "disk.fiberchannel.v1"
project     = "PC-DTT:NPRD"
zone        = "us-west-1a"
network_id  = "c10232af-bb51-44d3-af17-571c981f50cf"

pg_data_disk_name      = "pgcoe-postgres-data-disk"
pg_data_disk_size      = 50
pg_data_mount_point    = "/var/lib/postgresql"

pg_wal_disk_name       = "pgcoe-postgres-wal-disk"
pg_wal_disk_size       = 30
pg_wal_mount_point     = "/pgwal"

pg_temp_disk_name      = "pgcoe-postgres-temp-disk"
pg_temp_disk_size      = 20
pg_temp_mount_point    = "/pgtemp"

pg_log_disk_name      = "pgcoe-postgres-log-disk"
pg_log_disk_size      = 20
pg_log_mount_point    = "/pglog"
