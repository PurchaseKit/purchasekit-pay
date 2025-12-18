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
    const storeProductId = element.dataset.storeProductId

    element.remove()
    this.#disableForm()
    this.#triggerNativePurchase(storeProductId, correlationId)
  }

  restore(event) {
    event.preventDefault()
    this.send("restore")
  }

  #triggerNativePurchase(storeProductId, correlationId) {
    this.send("purchase", { storeProductId, correlationId }, message => {
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
    const storeProductIds = this.priceTargets.map(el => el.dataset.storeProductId)

    this.send("prices", { storeProductIds }, message => {
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
      const storeProductId = el.dataset.storeProductId
      const price = prices[storeProductId]

      if (price) {
        el.textContent = price
      } else {
        console.error(`No price found for store product ID '${storeProductId}'.`)
      }
    })
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
