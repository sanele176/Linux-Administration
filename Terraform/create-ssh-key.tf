resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits = "4096"
}
