import { Controller } from '@hotwired/stimulus'
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import interactionPlugin, { Draggable } from '@fullcalendar/interaction'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

import { patch } from '@rails/request.js'

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ['calendar']

  connect() {
    console.log(this.calendarTarget.dataset.events)
    const calendar = new Calendar(this.calendarTarget, {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin],
      initialView: 'dayGridMonth', //以month形式
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,listWeek',
      },
      events: '/project.json', //json
      timeZone: 'auto',
      locale: 'zh-tw',
      droppable: true,
      editable: true,
      eventResizableFromStart: true,
      selectable: true,
      unselectCancel: '.unsetTime', //在選擇狀態下點選（指定元素），選擇不會消失。
      select: function (info) {
        console.log('selected ' + info.startStr + ' to ' + info.endStr)
      },
      eventClick: function (info) {
        alert('Event: ' + info.event.title)
        info.el.style.borderColor = 'red'
      },
    })
    calendar.render()
  }
}
