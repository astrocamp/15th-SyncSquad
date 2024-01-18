import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["usersList", "roomsList"];

  showUsers() {
    this.usersListTarget.classList.remove("hidden");
    this.roomsListTarget.classList.add("hidden");
  }

  showRooms() {
    this.roomsListTarget.classList.remove("hidden");
    this.usersListTarget.classList.add("hidden");
  }
}
