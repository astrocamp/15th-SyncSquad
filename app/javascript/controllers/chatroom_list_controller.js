import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["usersList", "roomsList", "leftSide"];

  connect() {
    console.log(window.screen.width < 768);
  }

  showUsers() {
    console.log(this.leftSideTarget);
    if (window.screen.width < 768) {
      this.leftSideTarget.classList.remove("hidden");
    } else {
      this.leftSideTarget.classList.add("hidden");
    }

    this.usersListTarget.classList.remove("hidden");
    this.roomsListTarget.classList.add("hidden");
  }

  showRooms() {
    if (window.screen.width < 768) {
      this.leftSideTarget.classList.remove("hidden");
    } else {
      this.leftSideTarget.classList.add("hidden");
    }
    this.roomsListTarget.classList.remove("hidden");
    this.usersListTarget.classList.add("hidden");
  }
  closeSideBar() {
    this.leftSideTarget.classList.add("hidden");
  }
}
