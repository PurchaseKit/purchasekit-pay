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

    def self.find(id)
      if PurchaseKit::Pay.config.demo_mode?
        Demo.find(id)
      else
        Remote.find(id)
      end
    end
  end
end
