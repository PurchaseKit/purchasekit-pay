module PurchaseKit
  class Product
    attr_reader :id, :apple_product_id, :google_product_id

    def initialize(id:, apple_product_id: nil, google_product_id: nil)
      @id = id
      @apple_product_id = apple_product_id
      @google_product_id = google_product_id
    end

    def store_product_id(platform:)
      case platform
      when :apple then apple_product_id
      when :google then google_product_id
      else raise ArgumentError, "Unknown platform: #{platform}"
      end
    end

    class << self
      def find(id)
        # TODO: Fetch from PurchaseKit SaaS API
        # For now, return stubbed products for development
        stubbed_products[id] || raise(NotFoundError, "Product not found: #{id}")
      end

      private

      def stubbed_products
        @stubbed_products ||= {
          "prod_3VC24F5M" => new(
            id: "prod_3VC24F5M",
            apple_product_id: "dev.purchasekit.pro.annual",
            google_product_id: "pro_annual"
          ),
          "prod_28VWPCQ7" => new(
            id: "prod_28VWPCQ7",
            apple_product_id: "dev.purchasekit.pro.monthly",
            google_product_id: "pro_monthly"
          )
        }
      end
    end

    class NotFoundError < StandardError; end
  end
end
