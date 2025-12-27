module PurchaseKit
  module Purchase
    class Intent
      attr_reader :id, :uuid, :product

      def initialize(id:, uuid:, product:)
        @id = id
        @uuid = uuid
        @product = product
      end

      def self.create(product_id:, customer_id:, success_path: nil, environment: nil)
        if PurchaseKit::Pay.config.demo_mode?
          Demo.create(product_id:, customer_id:, success_path:)
        else
          Remote.create(product_id:, customer_id:, success_path:, environment:)
        end
      end
    end
  end
end
