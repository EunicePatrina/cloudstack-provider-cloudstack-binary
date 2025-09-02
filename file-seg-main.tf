resource "cloudstack_instance" "vm" {
  name              = var.vm_name
  display_name      = var.vm_name
  project           = var.project
  service_offering  = var.service_offering
  template          = var.template_id
  zone              = var.zone
  network_id        = var.network_id
  root_disk_size    = var.root_disk_size
  expunge           = true
}

# ---------------------- DATA Disk ----------------------
resource "cloudstack_disk" "pg_data_disk" {
  name               = var.pg_data_disk_name
  disk_offering      = var.disk_offering
  size               = var.pg_data_disk_size
  zone               = var.zone
  project            = var.project
  attach             = true
  shrink_ok          = false
  reattach_on_change = false
  device_id          = "1"
  virtual_machine_id = cloudstack_instance.vm.id

  tags = {
    mount_point = var.pg_data_mount_point
  }
  depends_on = [
    cloudstack_instance.vm]
}

# ---------------------- WAL Disk ----------------------
resource "cloudstack_disk" "pg_wal_disk" {
  name               = var.pg_wal_disk_name
  disk_offering      = var.disk_offering
  size               = var.pg_wal_disk_size
  zone               = var.zone
  project            = var.project
  attach             = true
  shrink_ok          = false
  reattach_on_change = false
  device_id          = "2"
  virtual_machine_id = cloudstack_instance.vm.id

  tags = {
    mount_point = var.pg_wal_mount_point
  }

  # WAL disk depends on DATA disk
  depends_on = [
    cloudstack_instance.vm,
    cloudstack_disk.pg_data_disk]
}

# ---------------------- TEMP Disk ----------------------
resource "cloudstack_disk" "pg_temp_disk" {
  name               = var.pg_temp_disk_name
  disk_offering      = var.disk_offering
  size               = var.pg_temp_disk_size
  zone               = var.zone
  project            = var.project
  attach             = true
  shrink_ok          = false
  reattach_on_change = false
  device_id          = "4"
  virtual_machine_id = cloudstack_instance.vm.id

  tags = {
    mount_point = var.pg_temp_mount_point
  }

  # TEMP disk depends on WAL disk
  depends_on = [
    cloudstack_instance.vm,
    cloudstack_disk.pg_wal_disk]
}

# ---------------------- LOG Disk ----------------------
resource "cloudstack_disk" "pg_log_disk" {
  name               = var.pg_log_disk_name
  disk_offering      = var.disk_offering
  size               = var.pg_log_disk_size
  zone               = var.zone
  project            = var.project
  attach             = true
  shrink_ok          = false
  reattach_on_change = false
  device_id          = "6"
  virtual_machine_id = cloudstack_instance.vm.id

  tags = {
    mount_point = var.pg_log_mount_point
  }

  # LOG disk depends on TEMP disk
  depends_on = [
    cloudstack_instance.vm,
    cloudstack_disk.pg_temp_disk]
}


