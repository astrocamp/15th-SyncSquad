// stimulus/controllers/modal_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["modal", "modalBody", "form"];

  // async submitForm(event) {
  //   event.preventDefault();
  //   const form = this.formTarget;
  //   const url = event.currentTarget.getAttribute("href");
  //   const method = event.currentTarget.getAttribute("method")

  //   try {
  //     const response = await fetch(form.action, {
  //       method: form.method,
  //       body: new FormData(form)
  //     });

  //     if (response.ok) {
  //       // 处理成功提交表单后的逻辑
  //       console.log("Form submitted successfully");
  //       this.closeModal();
  //     } else {
  //       // 处理提交表单失败的逻辑
  //       console.error("Form submission failed");
  //     }
  //   } catch (error) {
  //     console.error("Error submitting form", error);
  //   }
  // }
}
