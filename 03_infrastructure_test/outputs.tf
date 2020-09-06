output "reminder" {
	value = "Don't forget to export the credential.json linked to your gcp project (GOOGLE_CREDENTIALS_APPLICATION)"
}

output "ip_instance_1" {
  value = google_compute_instance.vm-debian.network_interface.0.access_config.0.nat_ip
}

output "ip_instance_2" {
  value = google_compute_instance.vm-centos.network_interface.0.access_config.0.nat_ip
}

output "best_choice_ever_made" {
	value = "Hire me, after 71 days in your team you will not be able to do without me :)"
}