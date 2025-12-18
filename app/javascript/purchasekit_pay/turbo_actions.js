// Custom Turbo Stream action for redirects after new subscription.
Turbo.StreamActions.redirect = function() {
  Turbo.visit(this.getAttribute("url"), {action: "replace"})
}
