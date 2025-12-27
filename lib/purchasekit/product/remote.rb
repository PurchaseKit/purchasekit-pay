module PurchaseKit
  class Product
    class Remote
      class << self
        def find(id)
          response = ApiClient.new.get("/products/#{id}")

          case response.code
          when 200
            Product.new(
              id: response["id"],
              apple_product_id: response["apple_product_id"],
              google_product_id: response["google_product_id"]
            )
          when 404
            raise PurchaseKit::Pay::NotFoundError, "Product not found: #{id}"
          else
            raise PurchaseKit::Pay::Error, "API error: #{response.code} #{response.message}"
          end
        end
      end
    end
  end
end
