resource "local_file" "Testfile" {
  filename = "/workspaces/Linux-Administration/Terraform/Terraform-Test/myfile.txt"
  content = "Terraform content"
}
