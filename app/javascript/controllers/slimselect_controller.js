import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

// Connects to data-controller="slimselect"
export default class extends Controller {
  connect() {
    new SlimSelect({
      select: this.element,
      settings: {
        searchPlaceholder: this.element.dataset.searchPlaceholder,
      },
    });
  }
}
