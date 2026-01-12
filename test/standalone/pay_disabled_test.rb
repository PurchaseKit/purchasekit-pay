require "standalone_test_helper"

class PayDisabledTest < PurchaseKit::StandaloneTestCase
  def test_pay_enabled_returns_false
    # Pay should not be defined when loaded without require "pay"
    refute defined?(::Pay), "Expected Pay constant to NOT be defined"
    refute PurchaseKit.pay_enabled?, "Expected pay_enabled? to return false"
  end

  def test_pay_webhooks_not_loaded
    # The Pay::Webhooks handlers should not be loaded
    refute defined?(PurchaseKit::Pay::Webhooks::SubscriptionCreated),
      "Expected PurchaseKit::Pay::Webhooks::SubscriptionCreated to NOT be defined"
  end
end
