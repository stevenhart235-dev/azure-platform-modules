module "resource_group" {
  source = "../.."

  name     = "rg-example-shared-services-001"
  location = "placeholder-region"

  tags = {
    managed_by          = "terraform"
    environment         = "placeholder-environment"
    workload            = "placeholder-workload"
    data_classification = "placeholder-classification"
  }
}
