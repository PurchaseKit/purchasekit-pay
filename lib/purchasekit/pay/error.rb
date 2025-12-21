module PurchaseKit
  module Pay
    class Error < ::Pay::Error
    end

    class NotFoundError < Error
    end

    class SubscriptionRequiredError < Error
    end
  end
end
