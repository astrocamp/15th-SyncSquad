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
      dateClick: DateClick,
      eventClick: function (info) {
        // 在這裡處理點擊事件
        alert("Event clicked: " + info.event.title);
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

async function DateClick(info) {
  // 在點擊日期時，顯示跳出flowbite的modal且可新增事件視窗
  const crudModal = document.querySelector('[data-modal-target="crud-modal"]');
  crudModal.click();
  console.log(info.dateStr);
}
