# Call the setup module to create a random resource prefix
run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

# Apply run block to create the cluster
run "create_default_cluster" {

  command = plan
  variables {
    resource_prefix                 = run.setup_tests.resource_prefix
    location                        = "centralus"
    existing_resource_group_name    = null
    existing_connected_cluster_name = null
    existing_key_vault_name         = null
    enable_aio_instance_secret_sync = true
    aio_ca                          = null

    trust_config = {
      source = "SelfSigned"
    }
  }
}

run "create_non_default_cluster" {
  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"
    trust_config = {
      source = "CustomerManaged"
    }
    enable_aio_instance_secret_sync = false
    existing_resource_group_name             = "test-rg"
    existing_connected_cluster_name          = "test-cluster"
    aio_ca = {
      root_ca_cert_pem  = "root_ca_cert_pem"
      ca_cert_chain_pem = "ca_cert_chain_pem"
      ca_key_pem        = "ca_key_pem"
    }
  }
}
