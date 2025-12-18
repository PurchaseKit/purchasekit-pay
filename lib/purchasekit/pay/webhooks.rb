module PurchaseKit
  module Pay
    module Webhooks
      autoload :Base, "purchasekit/pay/webhooks/base"
      autoload :SubscriptionCreated, "purchasekit/pay/webhooks/subscription_created"
      autoload :SubscriptionUpdated, "purchasekit/pay/webhooks/subscription_updated"
      autoload :SubscriptionCanceled, "purchasekit/pay/webhooks/subscription_canceled"
      autoload :SubscriptionExpired, "purchasekit/pay/webhooks/subscription_expired"

      class << self
        def register_handlers
          ::Pay::Webhooks.delegator.subscribe "purchasekit.subscription.created", SubscriptionCreated.new
          ::Pay::Webhooks.delegator.subscribe "purchasekit.subscription.updated", SubscriptionUpdated.new
          ::Pay::Webhooks.delegator.subscribe "purchasekit.subscription.canceled", SubscriptionCanceled.new
          ::Pay::Webhooks.delegator.subscribe "purchasekit.subscription.expired", SubscriptionExpired.new
        end
      end
    end
  end
end

ActiveSupport.on_load(:pay) do
  PurchaseKit::Pay::Webhooks.register_handlers
end
