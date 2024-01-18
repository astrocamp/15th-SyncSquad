import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.showUsersIcon = document.getElementById("show-users");
    this.showRoomsIcon = document.getElementById("show-rooms");
    this.leftSideDiv = document.getElementById("left-side");
  }

  showUsers(event) {
    // 清除現有內容，並加載用戶列表
    this.leftSideDiv.innerHTML = "<%= render '/shared/users_list' %>";
  }

  showRooms(event) {
    // 清除現有內容，並加載聊天室列表
    this.leftSideDiv.innerHTML = "<%= render '/shared/rooms_list' %>";
  }
}
