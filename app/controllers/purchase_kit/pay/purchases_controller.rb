module PurchaseKit
  module Pay
    class PurchasesController < ApplicationController
      def create
        @customer = ::Pay::Customer.find(params[:customer_id])
        @store_product_id = params[:store_product_id]

        # TODO: Call SaaS API to create purchase intent
        # response = PurchaseKit::Pay.create_intent(
        #   product_id: @store_product_id,
        #   customer: @customer,
        #   success_path: params[:success_path]
        # )
        # @correlation_id = response.correlation_id

        # For now, generate a correlation ID locally
        @correlation_id = SecureRandom.uuid

        respond_to do |format|
          format.turbo_stream
        end
      end
    end
  end
end
