# Call the setup module to create a random resource prefix
run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "test__aio_ca__error_with_missing_key" {
  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config = {
      source = "CustomerManaged"
    }
    aio_ca = {
      root_ca_cert_pem  = "test"
      ca_cert_chain_pem = "test"
      ca_key_pem        = ""
    }
  }
  expect_failures = [var.aio_ca]
}

run "test__aio_ca__error_with_missing_cert_chain" {
  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config = {
      source = "CustomerManaged"
    }
    aio_ca = {
      root_ca_cert_pem  = "test"
      ca_cert_chain_pem = ""
      ca_key_pem        = "test"
    }
  }
  expect_failures = [var.aio_ca]
}

run "test__aio_ca__error_with_missing_cert" {
  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config = {
      source = "CustomerManaged"
    }
    aio_ca = {
      root_ca_cert_pem  = ""
      ca_cert_chain_pem = "test"
      ca_key_pem        = "test"
    }
  }
  expect_failures = [var.aio_ca]
}

run "test__aio_ca__error_with_incompatible_source" {
  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config = {
      source = "SelfSigned"
    }
    aio_ca = {
      root_ca_cert_pem  = "test"
      ca_cert_chain_pem = "test"
      ca_key_pem        = "test"
    }
  }
  expect_failures = [var.aio_ca]
}


run "test_trust_config_error_with_invalid_source" {
  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "InvalidSource"
  }
  expect_failures = [var.trust_config_source]
}

run "test_trust_config_byo_issuer_null_trust_and_platform_config_settings" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedByoIssuer"
    byo_issuer_trust_settings = null

    aio_platform_config = {
      install_cert_manager  = true
      install_trust_manager = true
    }
  }
  expect_failures = [var.byo_issuer_trust_settings, var.aio_platform_config]
}

run "test_trust_config_should_pass_generated_issuer_without_extra_settings" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedGenerateIssuer"
  }
}

run "test_trust_config_byo_issuer_error_issuer_settings_missing_name" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedByoIssuer"

    byo_issuer_trust_settings = {
      issuer_name    = ""
      issuer_kind    = "test"
      configmap_name = "test"
      configmap_key  = "test"
    }

    aio_platform_config = {
      install_cert_manager  = false
      install_trust_manager = false
    }
  
  }
  expect_failures = [var.byo_issuer_trust_settings]
}

run "test_trust_config_byo_issuer_error_issuer_settings_missing_kind" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedByoIssuer"

    byo_issuer_trust_settings = {
      issuer_name    = "test"
      issuer_kind    = ""
      configmap_name = "test"
      configmap_key  = "test"
    }

    aio_platform_config = {
      install_cert_manager  = false
      install_trust_manager = false
    }
  
  }
  expect_failures = [var.byo_issuer_trust_settings]
}

run "test_trust_config_byo_issuer_error_issuer_settings_missing_cm_name" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedByoIssuer"

    byo_issuer_trust_settings = {
      issuer_name    = "test"
      issuer_kind    = "test"
      configmap_name = ""
      configmap_key  = "test"
    }

    aio_platform_config = {
      install_cert_manager  = false
      install_trust_manager = false
    }
  
  }
  expect_failures = [var.byo_issuer_trust_settings]
}

run "test_trust_config_byo_issuer_error_issuer_settings_missing_cm_key" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedByoIssuer"

    byo_issuer_trust_settings = {
      issuer_name    = "test"
      issuer_kind    = "test"
      configmap_name = ""
      configmap_key  = "test"
    }

    aio_platform_config = {
      install_cert_manager  = false
      install_trust_manager = false
    }
  
  }
  expect_failures = [var.byo_issuer_trust_settings]
}

run "test_trust_config_generated_issuer_invalid_trust_settings" {

  command = plan
  variables {
    resource_prefix = run.setup_tests.resource_prefix
    location        = "centralus"

    # Variables under test
    trust_config_source = "CustomerManagedGenerateIssuer"
    byo_issuer_trust_settings = {
      issuer_name    = "hello"
      issuer_kind    = "test"
      configmap_name = "test"
      configmap_key  = "test"
    }
  }
  expect_failures = [var.byo_issuer_trust_settings]
}
