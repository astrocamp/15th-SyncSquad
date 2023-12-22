import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";
import interactionPlugin from "@fullcalendar/interaction";

import { patch } from "@rails/request.js";

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
      droppable: true,
      editable: true,
      selectable: true,
      eventResize: adjust,
      eventDrop: adjust,
    });
    calendar.render();
  }
}

async function adjust(e) {
  const start_at = e.event.start;
  const end_at = e.event.end;
  const start = new Date(start_at).toISOString().split("T");
  const start_date = start[0];
  const start_time = start[1].split(".")[0];
  const end = new Date(end_at).toISOString().split("T");
  const end_date = end[0];
  const end_time = end[1].split(".")[0];
  const id = e.event.id;
  const url = `/events/${id}/drop`;
  const data = { start_date, start_time, end_date, end_time };
  await patch(url, { body: JSON.stringify(data) });
}
