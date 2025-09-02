variable "vm_name" {
  type    = string
  default = "pgcoe-postgres-instance"
}

variable "display_name" {
  type    = string
  default = "pgcoe-postgres-instance"
}

variable "project" {
  type = string
}

variable "service_offering" {
  type    = string
  default = "standard.2x4.any"
}

variable "template_id" {
  type    = string
  default = "b0934433-b28a-4019-b83b-312e399ecb8d"
}

variable "zone" {
  type = string
}

variable "network_id" {
  type = string
}

variable "root_disk_size" {
  type    = number
  default = 25
}

variable "disk_offering" {
  type    = string
  default = "disk.fiberchannel.v1"
}

# ---------------- Data Disk ----------------
variable "pg_data_disk_name" {
  type    = string
  default = "pgcoe-postgres-data-disk"
}

variable "pg_data_disk_size" {
  type    = number
  default = 50
}

variable "pg_data_mount_point" {
  type    = string
  default = "/var/lib/postgresql"
}

# ---------------- WAL Disk ----------------
variable "pg_wal_disk_name" {
  type    = string
  default = "pgcoe-postgres-wal-disk"
}

variable "pg_wal_disk_size" {
  type    = number
  default = 30
}

variable "pg_wal_mount_point" {
  type    = string
  default = "/pgwal"
}

# ---------------- TEMP Disk ----------------
variable "pg_temp_disk_name" {
  type    = string
  default = "pgcoe-postgres-temp-disk"
}

variable "pg_temp_disk_size" {
  type    = number
  default = 20
}

variable "pg_temp_mount_point" {
  type    = string
  default = "/pgtemp"
}

# ---------------- Log Disk ----------------
variable "pg_log_disk_name" {
  type    = string
  default = "pgcoe-postgres-log-disk"
}

variable "pg_log_disk_size" {
  type    = number
  default = 20
}

variable "pg_log_mount_point" {
  type    = string
  default = "/pglog"
}

