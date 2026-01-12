require "standalone_test_helper"

class StandaloneConfigurationTest < PurchaseKit::StandaloneTestCase
  def test_configuration_works_without_pay
    config = PurchaseKit::Configuration.new

    config.api_key = "sk_standalone"
    config.app_id = "app_standalone"
    config.webhook_secret = "whsec_standalone"

    assert_equal "sk_standalone", config.api_key
    assert_equal "app_standalone", config.app_id
    assert_equal "whsec_standalone", config.webhook_secret
  end

  def test_event_handler_registration_works
    config = PurchaseKit::Configuration.new
    handler_called = false

    config.on(:subscription_created) { handler_called = true }

    assert config.listening?(:subscription_created)
    refute config.listening?(:subscription_canceled)

    # Call the handler
    config.handlers_for(:subscription_created).each(&:call)
    assert handler_called
  end

  def test_demo_mode_works_without_pay
    config = PurchaseKit::Configuration.new
    config.demo_mode = true
    config.demo_products = {
      "prod_annual" => {apple_product_id: "com.example.annual"}
    }

    assert config.demo_mode?
    assert_equal "com.example.annual", config.demo_products["prod_annual"][:apple_product_id]
  end

  def test_multiple_handlers_for_same_event
    config = PurchaseKit::Configuration.new
    calls = []

    config.on(:subscription_created) { calls << 1 }
    config.on(:subscription_created) { calls << 2 }

    config.handlers_for(:subscription_created).each(&:call)

    assert_equal [1, 2], calls
  end
end
