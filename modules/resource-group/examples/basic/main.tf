module "resource_group" {
  source = "../.."

  name     = "rg-example-platform-001"
  location = "placeholder-region"

  tags = {
    managed_by = "terraform"
    purpose    = "example"
  }
}
