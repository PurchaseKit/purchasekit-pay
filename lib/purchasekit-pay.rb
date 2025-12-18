require "pay"
require "purchasekit/pay/version"
require "purchasekit/pay/configuration"
require "purchasekit/pay/engine"
require "purchasekit/pay/billable"
require "purchasekit/pay/charge"
require "purchasekit/pay/subscription"
require "purchasekit/pay/customer"
require "purchasekit/pay/webhooks"

# Register PurchaseKit as a Pay processor
require "pay/purchasekit"

module PurchaseKit
  module Pay
    autoload :Error, "purchasekit/pay/error"
    autoload :PaywallHelper, "purchasekit/pay/paywall_helper"
  end
end
