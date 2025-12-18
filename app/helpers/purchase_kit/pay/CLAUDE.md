# Paywall helpers

View helpers for rendering paywalls.

## `PaywallHelper`

### `purchasekit_paywall(customer:, success_path:, **options)`

Renders a form that posts to the gem's PurchasesController.

**Parameters:**
- `customer:` (required) - `Pay::Customer` instance
- `success_path:` - Redirect destination after purchase (default: `main_app.root_path`)

**Yields:** `PaywallBuilder` instance

**Generated HTML:**
```html
<form action="/purchasekit/purchases" method="post"
      id="purchasekit_paywall"
      data-controller="purchasekit-pay--paywall"
      data-purchasekit-pay--paywall-customer-id-value="123">
  <input type="hidden" name="customer_id" value="123">
  <input type="hidden" name="success_path" value="/dashboard">
  <!-- yielded content -->
</form>
```

## `PaywallBuilder`

Builder yielded by the paywall helper.

### Methods

| Method | Purpose | Data attributes |
|--------|---------|-----------------|
| `plan_option(store_product_id:, selected:)` | Radio + label for a plan | `purchasekit_pay__paywall_target: "planRadio"` |
| `price(store_product_id:)` | Span for localized price | `purchasekit_pay__paywall_target: "price"` |
| `submit(text)` | Submit button (starts disabled) | `purchasekit_pay__paywall_target: "submitButton"` |
| `restore_link(text:)` | Link to restore purchases | `action: "click->purchasekit-pay--paywall#restore"` |

## Usage with ActionCable

The view must also include a Turbo Stream subscription for real-time redirect:

```erb
<%= turbo_stream_from dom_id(customer) %>
<%= purchasekit_paywall customer: customer, success_path: paid_path do |paywall| %>
  ...
<% end %>
```
