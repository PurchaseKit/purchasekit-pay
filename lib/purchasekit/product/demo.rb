module PurchaseKit
  class Product
    class Demo
      class << self
        def find(id)
          product_data = PurchaseKit::Pay.config.demo_products[id]
          raise PurchaseKit::Pay::NotFoundError, "Product not found: #{id}" unless product_data

          Product.new(
            id: id,
            apple_product_id: product_data[:apple_product_id],
            google_product_id: product_data[:google_product_id]
          )
        end
      end
    end
  end
end
