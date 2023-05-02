resource "null_resource" "update_packages" { 
provisioner "local-exec" { command = "sudo apt-get upgrade -y"} 
}


resource "null_resource" "System-info" { 
provisioner "local-exec" { command =  "sudo uptime"} 
}
