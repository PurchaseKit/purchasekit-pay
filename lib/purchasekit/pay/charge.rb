module PurchaseKit
  module Pay
    class Charge
      attr_reader :pay_charge

      delegate :id, :amount, :currency, :metadata, to: :pay_charge

      def initialize(pay_charge)
        @pay_charge = pay_charge
      end

      def self.sync(charge_id, object: nil, stripe_account: nil)
        raise PurchaseKit::Pay::Error, "PurchaseKit only handles ongoing subscriptions, not one-time purchases."
      end

      def refund!(amount_to_refund)
        raise PurchaseKit::Pay::Error, "Refunds must be processed through App Store Connect or Google Play Console."
      end
    end
  end
end
