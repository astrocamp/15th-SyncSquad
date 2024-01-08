import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  reset() {
    this.element.reset();
  }
  onEnter(event) {
    if (event.code === "Enter" && !event.shiftKey) {
      if (!event.isComposing) {
        this.element.submit();
        event.preventDefault();
        this.element.reset();
      }
    }
  }
}
