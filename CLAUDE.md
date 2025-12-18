# PurchaseKit gems

This directory contains Ruby gems for PurchaseKit.

## Structure

- `purchasekit-pay/` - Pay gem integration for in-app purchases

## Architecture

The gem acts as a bridge between:
1. **Rails app** - Renders paywall, handles webhooks, manages subscriptions
2. **PurchaseKit SaaS** - Normalizes Apple/Google webhooks, manages purchase intents
3. **Native app** - Handles App Store/Play Store purchase flow via Hotwire Native Bridge

## Data flow

```
User taps Subscribe
    -> Form submits to PurchasesController
    -> Creates purchase intent with SaaS (TODO)
    -> Returns correlation ID to native app
    -> Native app triggers App Store purchase
    -> Apple sends webhook to SaaS
    -> SaaS normalizes and POSTs to Rails app
    -> Webhook handler creates Pay::Subscription
    -> Broadcasts Turbo Stream redirect via ActionCable
    -> User redirected to success_path
```

## Key decisions

- SaaS normalizes Apple/Google payloads (gem never sees raw data)
- Uses Pay gem's webhook infrastructure (`Pay::Webhooks.delegator`)
- Real-time UI updates via Turbo Streams over ActionCable
- `success_path` passed through SaaS in webhook payload (no Rails.cache)
