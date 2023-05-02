resource "null_resource" "create_user" {
 provisioner "local-exec" { command = "sudo useradd -m someuser" } 
}
