module Pay
  module Purchasekit
    class Error < Pay::Error
    end

    def self.enabled?
      Pay.enabled_processors.include?(:purchasekit)
    end
  end
end
