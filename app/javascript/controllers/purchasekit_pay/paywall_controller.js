import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "paywall"
  static targets = ["planRadio", "price", "submitButton", "response"]

  connect() {
    super.connect()
    this.#fetchPrices()
  }

  responseTargetConnected(element) {
    const correlationId = element.dataset.correlationId
    const productIds = this.#productIds(element)

    element.remove()
    this.#disableForm()
    this.#triggerNativePurchase(productIds, correlationId)
  }

  restore(event) {
    event.preventDefault()
    this.send("restore")
  }

  #triggerNativePurchase(productIds, correlationId) {
    this.send("purchase", { ...productIds, correlationId }, message => {
      const { status, error } = message.data

      if (error) {
        console.error(error)
        alert(`Purchase error: ${error}`)
        this.#enableForm()
      }

      if (status == "cancelled") {
        this.#enableForm()
      }

      // On success, keep showing processing state.
      // Turbo Stream will update the UI when webhook completes.
    })
  }

  #fetchPrices() {
    const products = this.priceTargets.map(el => this.#productIds(el))

    this.send("prices", { products }, message => {
      const { prices, error } = message.data

      if (error) {
        console.error(error)
        return
      }

      if (prices) {
        this.#setPrices(prices)
        this.#enableForm()
      }
    })
  }

  #setPrices(prices) {
    this.priceTargets.forEach(el => {
      const { appleStoreProductId, googleStoreProductId } = this.#productIds(el)
      const price = prices[appleStoreProductId] || prices[googleStoreProductId]

      if (price) {
        el.textContent = price
      } else {
        console.error(`No price found for product.`)
      }
    })
  }

  #productIds(element) {
    debugger
    return {
      appleStoreProductId: element.dataset.appleStoreProductId,
      googleStoreProductId: element.dataset.googleStoreProductId
    }
  }

  #enableForm() {
    this.planRadioTargets.forEach(radio => radio.disabled = false)
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = false
    }
  }

  #disableForm() {
    this.planRadioTargets.forEach(radio => radio.disabled = true)
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
    }
  }
}
