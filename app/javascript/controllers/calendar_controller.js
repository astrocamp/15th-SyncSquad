import { Controller } from '@hotwired/stimulus'
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import interactionPlugin from '@fullcalendar/interaction'
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
            ? `${newTaskUrl}?startDate=${startDate.string}&endDate=${endDate.string}&allDay=true`
            : `${newTaskUrl}?startDate=${startDate.string}&endDate=${endDate.string}`
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
