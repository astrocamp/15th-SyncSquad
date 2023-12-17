import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";
import interactionPlugin from "@fullcalendar/interaction";

// Connects to data-controller="calendar"
export default class extends Controller {
  connect() {
    const calendarEle = this.element;
    const calendar = new Calendar(calendarEle, {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin],
      initialView: "dayGridMonth", //以month形式
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,listWeek",
      },
      events: "/events.json", //json
      timeZone: "auto",
      locale: "zh-tw",
    });
    calendar.render();
  }
}
