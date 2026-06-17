resource "hcp_hvn" "this" {
  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.region
  cidr_block     = var.cidr_block
  project_id     = var.project_id

  lifecycle {
    prevent_destroy = true
  }
}
