module Pay
  module Purchasekit
    class Error < Pay::Error
    end

    module_function

    def enabled?
      true
    end

    def setup
      # No setup required
    end

    def configure_webhooks
      # Webhooks configured in PurchaseKit::Pay::Webhooks
    end
  end
end
