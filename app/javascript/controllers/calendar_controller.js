import { Controller } from '@hotwired/stimulus'
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import interactionPlugin from '@fullcalendar/interaction'
import tippy from 'tippy.js'
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
            ? `${newTaskUrl}?startedAt=${startDate.string}&endedAt=${endDate.string}&allDay=true`
            : `${newTaskUrl}?startedAt=${startDate.string}&endedAt=${endDate.string}`
        await Turbo.visit(newURL, {
          frame: 'modal',
          method: 'POST',
        })
      },
      eventClick: function (info) {
        const itemURL = `/${item}/${info.event._def.publicId}`
        Turbo.visit(itemURL, {
          frame: 'modal',
          method: 'POST',
        })
      },
      eventDidMount: function (info) {
        const list_color = info.event.extendedProps.color
        tippy(info.el, {
          content: `
            <div class="bg-white rounded-lg shadow-md shadow-gray-400 flex flex-col w-48">
              <header class="bg-[${list_color}] rounded-t-lg p-2 flex justify-between text-lg">
                <h3 class="font-bold mr-auto">${info.event.title}</h3>
                <div class="font-bold text-green-500 bg-white w-7 text-center aspect-auto rounded-full">${info.event.extendedProps.completed_at}</div>
              </header>
              <div class="p-2 text-gray-900 text-sm">
                <div class="text-[${list_color}] font-bold">> ${info.event.extendedProps.list_title}</div>
                <p>${info.event.extendedProps.description}</p>
              </div>
              <div class="bg-gray-100 flex justify-center items-center rounded-b-lg">
                <i class="h-4 p-2 text-center text-gray-400 fa-solid fa-user"></i>
                <p class="text-gray-900">${info.event.extendedProps.user_nick_name}</p>
              </div>
            <div>
          `,
          allowHTML: true,
          placement: 'top',
          interactive: false,
          animation: 'perspective-subtle',
          theme: 'light-border',
          duration: [500, 0],
          trigger: 'mouseenter',
        })
      },
      eventResize: function (info) {
        alert(info.event.title + ' end is now ' + info.event.end.toISOString())
        info.revert()
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
