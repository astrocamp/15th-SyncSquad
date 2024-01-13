import { Controller } from '@hotwired/stimulus'
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import interactionPlugin from '@fullcalendar/interaction'
import tippy, { followCursor } from 'tippy.js'
import 'tippy.js/animations/perspective-subtle.css'
import 'tippy.js/animations/scale.css'
import 'tippy.js/themes/light-border.css'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ['calendar']

  initialize() {
    this.calendar = null
  }

  disconnect() {
    this.calendar = null
  }

  connect() {
    const newTaskUrl = this.calendarTarget.dataset.newTaskUrl
    const item = this.calendarTarget.dataset.item
    const tasks = JSON.parse(this.calendarTarget.dataset.tasks)
    const calendar = new Calendar(this.calendarTarget, {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin],
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,listWeek',
      },
      events: tasks,
      timeZone: 'auto',
      locale: 'zh-tw',
      droppable: true,
      editable: true,
      eventResizableFromStart: true,
      selectable: true,
      unselectCancel: '.unsetTime',
      select: async (info) => {
        const oneDayInMilliseconds = 24 * 60 * 60 * 1000
        const startDate = this.toDateObject('start', info.startStr)
        const endDate = this.toDateObject('end', info.endStr)
        const timestampDifference = endDate.timestamp - startDate.timestamp
        const newURL =
          timestampDifference > oneDayInMilliseconds
            ? `${newTaskUrl}?startedAt=${startDate.string}&endAt=${endDate.string}&allDay=true`
            : `${newTaskUrl}?startedat=${startDate.string}&endAt=${endDate.string}`
        await Turbo.visit(newURL, {
          frame: 'modal',
          method: 'POST',
        })
      },
      eventClick: function (info) {
        info.el.style.color = 'red'
        const itemURL = `/${item}/${info.event._def.publicId}`
        Turbo.visit(itemURL, {
          frame: 'modal',
          method: 'POST',
        })
      },
      eventDidMount: function (info) {
        const itemURL = `/${item}/${info.event._def.publicId}`
        tippy(info.el, {
          content: `
            <div class="bg-white rounded p-2 shadow-md">
              <header>
                <h3>${info.event.title}</h3>
              <header>
              <div>
                <p>${
                  info.event.extendedProps.description == null
                    ? ''
                    : info.event.extendedProps.description
                }</p>
              </div>
              <div>
                <a data-turbo-frame="modal"
                class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                href="${itemURL}">show</a>
              </div>
            <div>
          `,
          allowHTML: true,
          placement: 'top',
          interactive: true,
          animation: 'perspective-subtle',
          theme: 'light-border',
          duration: [500, 0],
          followCursor: 'horizontal',
          trigger: 'mouseenter',
          maxWidth: 350,
          plugins: [followCursor],
        })
      },
      eventResize: function (info) {
        alert(info.event.title + ' end is now ' + info.event.end.toISOString())
        if (!confirm('is this okay?')) {
          info.revert()
        }
      },
      eventDrop: function (taskResizeInfo) {
        console.log(taskResizeInfo)
      },
    })
    calendar.render()
  }

  toDateObject(dateType, dateString) {
    let dateTimestamp
    let date
    if (dateType === 'start') {
      dateTimestamp = new Date(dateString).getTime()
      date = this.formatTimestampToDate(dateTimestamp).toString()
    }
    if (dateType === 'end') {
      dateTimestamp = new Date(dateString).getTime()
      date = this.formatTimestampToDate(
        dateTimestamp - 24 * 60 * 60 * 1000
      ).toString()
    }
    return { string: date, timestamp: dateTimestamp }
  }

  formatTimestampToDate(timestamp) {
    const dateObject = new Date(timestamp)
    const year = dateObject.getFullYear()
    const month = ('0' + (dateObject.getMonth() + 1)).slice(-2)
    const day = ('0' + dateObject.getDate()).slice(-2)
    return `${year}-${month}-${day}`
  }
}
