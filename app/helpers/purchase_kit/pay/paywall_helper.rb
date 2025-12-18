module PurchaseKit
  module Pay
    module PaywallHelper
      # Wrapper for paywall with bridge controller
      # Renders a form that posts to the purchases endpoint
      # Yields a builder for plan options and buttons
      # Requires a Pay::Customer - call user.set_payment_processor(:purchasekit) first
      def purchasekit_paywall(customer:, success_path: main_app.root_path, **options)
        raise ArgumentError, "Must provide customer: parameter. Call user.set_payment_processor(:purchasekit) first." unless customer

        builder = PaywallBuilder.new(self, customer)

        form_data = (options.delete(:data) || {}).merge(
          controller: "purchasekit-pay--paywall",
          purchasekit_pay__paywall_customer_id_value: customer.id
        )

        form_with(url: purchasekit_pay.purchases_path, id: "purchasekit_paywall", data: form_data, **options) do |form|
          hidden = hidden_field_tag(:customer_id, customer.id)
          hidden += hidden_field_tag(:success_path, success_path)
          hidden + capture { yield builder }
        end
      end
    end

    class PaywallBuilder
      def initialize(template, customer)
        @template = template
        @customer = customer
      end

      def plan_option(store_product_id:, selected: false, input_class: nil, **options, &block)
        input_id = "purchasekit_plan_#{store_product_id.parameterize.underscore}"

        radio = @template.radio_button_tag(
          :store_product_id,
          store_product_id,
          selected,
          id: input_id,
          class: input_class,
          autocomplete: "off",
          data: {
            purchasekit_pay__paywall_target: "planRadio",
            store_product_id: store_product_id
          }
        )

        label = @template.label_tag(input_id, **options) { @template.capture(&block) }

        radio + label
      end

      def price(store_product_id:, **options, &block)
        data = (options.delete(:data) || {}).merge(
          purchasekit_pay__paywall_target: "price",
          store_product_id: store_product_id
        )

        loading_content = block ? @template.capture(&block) : "Loading..."
        @template.content_tag(:span, loading_content, data: data, **options)
      end

      def submit(text = "Subscribe", **options)
        data = (options.delete(:data) || {}).merge(
          purchasekit_pay__paywall_target: "submitButton",
          turbo_submits_with: text
        )

        @template.submit_tag(text, disabled: true, data: data, **options)
      end

      def restore_link(text: "Restore purchases", **options)
        data = (options.delete(:data) || {}).merge(
          action: "click->purchasekit-pay--paywall#restore"
        )

        @template.link_to(text, "#", data: data, **options)
      end
    end
  end
end
