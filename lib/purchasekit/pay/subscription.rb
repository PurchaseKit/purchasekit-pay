module PurchaseKit
  module Pay
    class Subscription
      attr_reader :pay_subscription

      delegate :active?,
        :canceled?,
        :on_grace_period?,
        :on_trial?,
        :ends_at,
        :name,
        :processor_id,
        :processor_plan,
        :quantity,
        :trial_ends_at,
        to: :pay_subscription

      def initialize(pay_subscription)
        @pay_subscription = pay_subscription
      end

      def self.sync(subscription_id, object: nil, name: ::Pay.default_product_name)
        # TODO: Sync subscription from PurchaseKit webhook data.
      end

      def cancel(**options)
        raise PurchaseKit::Pay::Error, "Subscriptions must be cancelled through App Store or Google Play"
      end

      def cancel_now!(**options)
        raise PurchaseKit::Pay::Error, "Subscriptions must be cancelled through App Store or Google Play"
      end

      def resume
        raise PurchaseKit::Pay::Error, "Subscriptions must be resumed through App Store or Google Play"
      end

      def swap(plan, **options)
        raise PurchaseKit::Pay::Error, "Plan changes must be initiated through App Store or Google Play"
      end
    end
  end
end
