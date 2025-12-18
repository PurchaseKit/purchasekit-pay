module PurchaseKit
  module Pay
    class Engine < ::Rails::Engine
      isolate_namespace PurchaseKit::Pay

      initializer "purchasekit_pay.helpers" do
        ActiveSupport.on_load(:action_controller_base) do
          helper PurchaseKit::Pay::PaywallHelper
        end
      end

      initializer "purchasekit_pay.importmap", before: "importmap" do |app|
        if defined?(Importmap)
          app.config.importmap.paths << Engine.root.join("config/importmap.rb")
        end

        app.config.importmap.cache_sweepers << root.join("app/javascript")
      end

      initializer "purchasekit_pay.assets" do |app|
        app.config.assets.paths << root.join("app/javascript")
        app.config.assets.precompile += %w[purchasekit-pay/manifest.js]
      end
    end
  end
end
