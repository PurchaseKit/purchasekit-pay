# Stimulus controllers

JavaScript controllers for the paywall UI.

## Controllers

### `paywall_controller.js`

Extends `BridgeComponent` from Hotwire Native Bridge.

**Targets:**
- `planRadio` - Radio buttons for plan selection
- `price` - Spans that display localized prices
- `submitButton` - Subscribe button (disabled until prices load)
- `response` - Hidden element added by Turbo Stream after form submit

**Lifecycle:**
1. `connect()` - Calls `#fetchPrices()` via bridge
2. Native app returns prices, controller updates `price` targets
3. User selects plan, submits form
4. `responseTargetConnected()` - Detects Turbo Stream response, triggers native purchase
5. Native app handles App Store flow
6. On success, webhook broadcasts redirect (handled by `turbo_actions.js`)

**Bridge messages:**
- `prices` - Request localized prices for product IDs
- `purchase` - Trigger native purchase flow with product ID and correlation ID

## Related files

- `purchasekit_pay/turbo_actions.js` - Custom Turbo Stream action for redirects
- `app/helpers/purchase_kit/pay/paywall_helper.rb` - Server-side form builder
