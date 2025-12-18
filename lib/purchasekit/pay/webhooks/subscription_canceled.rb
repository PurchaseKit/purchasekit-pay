module PurchaseKit
  module Pay
    module Webhooks
      class SubscriptionCanceled < Base
        def call(event)
          pay_subscription = find_subscription(event)
          return unless pay_subscription

          pay_subscription.update!(
            status: :canceled,
            ends_at: parse_time(event["ends_at"])
          )
        end
      end
    end
  end
end
