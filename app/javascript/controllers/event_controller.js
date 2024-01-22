import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";
import interactionPlugin from "@fullcalendar/interaction";
import allLocales from "@fullcalendar/core/locales-all";
import tippy from "tippy.js";
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import { patch } from "@rails/request.js";
// Connects to data-controller="event"
export default class extends Controller {
  connect() {
    const { locale } = this.element.dataset;
    const newUrl = this.element.dataset.newEventUrl;
    const companyID = this.element.dataset.company > 0;
    const calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin],
      initialView: "dayGridMonth", //以month形式
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,listWeek",
      },
      events: "/events.json",
      timeZone: "auto",
      locales: allLocales,
      locale: locale,
      eventTimeFormat: {
        hour: "2-digit",
        minute: "2-digit",
        hour12: false,
      },
      droppable: companyID,
      editable: companyID,
      selectable: companyID,

      select: async (info) => {
        const started_at = info.startStr;
        const ended_at = info.endStr;
        const newURL = `${newUrl}?startedAt=${started_at}&endedAt=${ended_at}&allDay=${
          ended_at > started_at
        }`;
        await Turbo.visit(newURL, {
          frame: "modal",
          method: "POST",
        });
      },
      eventClick: async function (info) {
        if (companyID) {
          const eventURL = `${newUrl.replace("new", "")}${
            info.event._def.publicId
          }/edit`;
          await Turbo.visit(eventURL, {
            frame: "modal",
            method: "POST",
          });
        }
      },
      eventDidMount: function (info) {
        tippy(info.el, {
          content: `
            <div class="bg-white rounded-lg shadow-md shadow-gray-400 flex flex-col w-48">
              <div class="p-2 text-gray-900 text-sm">
                <h3 class="font-bold">${info.event.title}</h3>
                <div class="font-bold text-green-500 bg-white w-7 text-center aspect-auto rounded-full">${info.event.extendedProps.description}</div>
                <div class=font-bold"><i class="fa-solid fa-hourglass-start"></i> ${info.event.startStr}</div>
              </div>
            <div>
          `,
          allowHTML: true,
          placement: "top",
          interactive: false,
          animation: "perspective-subtle",
          theme: "light-border",
          duration: [500, 0],
          trigger: "mouseenter",
        });
      },
      eventDrop: adjust,
      eventResize: adjust,
    });
    calendar.render();
    async function adjust(info) {
      dayjs.extend(utc);
      const id = info.event._def.publicId;
      const url = `${newUrl.replace("new", "")}${id}/drop`;
      const started_at = info.event.startStr;
      let ended_at = info.event.endStr || info.event.startStr;
      const all_day_event = info.event.allDay;
      if (all_day_event && started_at == ended_at) {
        ended_at = dayjs(ended_at).add(1, "day").format("YYYY-MM-DD");
      }
      const data = { started_at, ended_at, all_day_event };
      await patch(url, { body: JSON.stringify(data) });
    }
  }
}
