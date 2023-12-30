import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";
import interactionPlugin from "@fullcalendar/interaction";
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";

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
      select: function (info) {
        dayjs.extend(utc);
        const modal = document.querySelector(
          'a[data-turbo-frame="modal"][href="/events/new"]'
        );
        setTimeout(() => {
          const startDate = document.querySelector("#event_start_date");
          const endDate = document.querySelector("#event_end_date");
          startDate.value = info.startStr;
          endDate.value = dayjs(info.endStr)
            .subtract(1, "day")
            .format("YYYY-MM-DD");
        }, 100);
        modal.click();
      },
      eventClick: function (info) {
        const eventId = info.event.id;
        const modal = document.querySelector(
          `a[data-turbo-frame="modal"][href="/events/${eventId}"]`
        );
        modal.click();
      },
      eventResize: adjust,
      eventDrop: adjust,
    });
    calendar.render();
  }
}

async function adjust(e) {
  dayjs.extend(utc);
  const start_at = dayjs.utc(e.event.start);
  const end_at = dayjs.utc(e.event.end);
  const start_date = start_at.format("YYYY-MM-DD");
  const start_time = start_at.format("HH:mm:ss");
  const end_date = end_at.format("YYYY-MM-DD");
  const end_time = end_at.format("HH:mm:ss");
  const id = e.event.id;
  const url = `/events/${id}/drop`;
  const data = { start_date, start_time, end_date, end_time };
  await patch(url, { body: JSON.stringify(data) });
}
