import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="turbomodal"
export default class extends Controller {
  connect() {
    this.open();
  }
  reset() {
    this.element.reset();
  }

  //如果 表單填寫成功送出 關掉modal
  submitEnd(e) {
    if (e.detail.success) {
      this.close();
    }
  }
  open() {
    this.element.classList.add("visible");
  }
  clickOutside(e) {
    if (e.target === this.element) {
      this.close();
    }
  }
  close() {
    this.element.classList.add("hidden");
  }
}
