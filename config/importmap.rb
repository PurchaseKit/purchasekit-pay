# Pin Hotwire Native Bridge dependency
# Note: If your app already pins this package, your version will take precedence
# since the app's importmap.rb loads after the gem's importmap.rb
pin "@hotwired/hotwire-native-bridge", to: "@hotwired--hotwire-native-bridge.js" # @1.2.2

pin_all_from PurchaseKit::Pay::Engine.root.join("app/javascript/controllers"), under: "purchasekit-pay", to: "controllers"

pin "purchasekit-pay/turbo_actions", to: "purchasekit_pay/turbo_actions.js"
