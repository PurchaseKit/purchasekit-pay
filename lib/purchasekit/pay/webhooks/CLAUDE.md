# Webhook handlers

Handlers for webhook events from the PurchaseKit SaaS.

## Architecture

- All handlers inherit from `Base` (shared `find_subscription`, `parse_time`)
- Registered with Pay's delegator in `webhooks.rb` via `ActiveSupport.on_load(:pay)`
- Called by `Pay::Webhook#process!` which passes the event hash

## Handlers

| File | Event | Action |
|------|-------|--------|
| `subscription_created.rb` | `subscription.created` | Creates `Pay::Subscription`, broadcasts redirect |
| `subscription_updated.rb` | `subscription.updated` | Updates status, plan, period dates |
| `subscription_canceled.rb` | `subscription.canceled` | Sets status to canceled, sets `ends_at` |
| `subscription_expired.rb` | `subscription.expired` | Sets status to expired |

## Event payload (from SaaS)

The SaaS normalizes Apple/Google data into this format:

```ruby
{
  "type" => "subscription.created",
  "customer_id" => "123",           # Pay::Customer.id
  "subscription_id" => "sub_abc",   # Unique ID from SaaS
  "store_product_id" => "com.example.pro.annual",
  "subscription_name" => "pro",
  "status" => "active",
  "current_period_start" => "2025-01-01T00:00:00Z",
  "current_period_end" => "2026-01-01T00:00:00Z",
  "ends_at" => nil,
  "success_path" => "/dashboard"    # Only on subscription.created
}
```

Note: Keys are strings (not symbols) after JSON round-trip through `Pay::Webhook`.

## Turbo Stream broadcast

`SubscriptionCreated` broadcasts a redirect action:

```ruby
Turbo::StreamsChannel.broadcast_stream_to(
  dom_id(customer),
  content: turbo_stream_action_tag(:redirect, url: redirect_path)
)
```

The view must subscribe: `turbo_stream_from dom_id(customer)`
