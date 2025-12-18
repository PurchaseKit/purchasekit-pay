require "active_job"

module PurchaseKit
  module Pay
    class WebhooksController < ApplicationController
      skip_forgery_protection

      def create
        queue_event(verified_event)
        head :ok
      rescue SignatureVerificationError => e
        Rails.logger.error "[PurchaseKit] Webhook signature error: #{e.message}"
        head :bad_request
      end

      private

      def queue_event(event)
        event_type = event[:type]
        return unless ::Pay::Webhooks.delegator.listening?("purchasekit.#{event_type}")

        record = ::Pay::Webhook.create!(processor: :purchasekit, event_type:, event:)
        ProcessWebhookJob.perform_later(record.id)
      end

      class ProcessWebhookJob < ::ActiveJob::Base
        def perform(webhook_id)
          pay_webhook = ::Pay::Webhook.find(webhook_id)
          pay_webhook.process!
        end
      end

      def verified_event
        payload = request.raw_post
        signature = request.headers["X-PurchaseKit-Signature"]
        secret = PurchaseKit::Pay.config.webhook_secret

        return JSON.parse(payload, symbolize_names: true) if secret.blank?

        raise SignatureVerificationError, "Missing signature" if signature.blank?

        expected = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
        unless ActiveSupport::SecurityUtils.secure_compare(signature, expected)
          raise SignatureVerificationError, "Invalid signature"
        end

        JSON.parse(payload, symbolize_names: true)
      end

      class SignatureVerificationError < StandardError; end
    end
  end
end
