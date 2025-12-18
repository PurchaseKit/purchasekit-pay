module PurchaseKit
  module Pay
    module Webhooks
      class SubscriptionExpired < Base
        def call(event)
          pay_subscription = find_subscription(event)
          return unless pay_subscription

          pay_subscription.update!(status: :expired)
        end
      end
    end
  end
end
