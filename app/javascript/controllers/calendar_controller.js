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

  initialize() {
    this.calendar = nill
  }

  disconnect() {
    this.calendar = null
  }

  connect() {
    console.log(this.calendarTarget.dataset.events)
    const newEventUrl = this.calendarTarget.dataset.newEventUrl
    const item = this.calendarTarget.dataset.item
    const events = JSON.parse(this.calendarTarget.dataset.events) // 获取事件数据 JSON 字符串
    const calendar = new Calendar(this.calendarTarget, {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin],
      initialView: 'dayGridMonth', //以month形式
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,listWeek',
      },
      events: events,
      timeZone: 'auto',
      locale: 'zh-tw',
      droppable: true,
      editable: true,
      eventResizableFromStart: true,
      selectable: true,
      unselectCancel: '.unsetTime', //在選擇狀態下點選（指定元素），選擇不會消失。
      select: async function (info) {
        console.log('selected ' + info.startStr + ' to ' + info.endStr)
        const newURL = `${newEventUrl}?startDate=${info.startStr}&endDate=${info.endStr}`
        await Turbo.visit(newURL, {
          frame: 'modal',
          method: 'POST',
        })
      },

      // TODO: 編輯 ＆ 刪除
      eventClick: function (info) {
        // alert('Event: ' + info.event.title)
        info.el.style.color = 'red'
        const itemURL = `/${item}/${info.event._def.publicId}`
        console.log(itemURL)
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
      eventDrop: function (eventResizeInfo) {
        console.log(eventResizeInfo)
      },
      // eventResize: this.settingEvent,
      // eventDrop: this.settingEvent,
    })
    calendar.render()
  }

  async settingEvent(e) {
    dayjs.extend(utc)
    const start_at = dayjs.utc(e.event.start)
    const end_at = dayjs.utc(e.event.end)
    const start_date = start_at.format('YYYY-MM-DD')
    const start_time = start_at.format('HH:mm:ss')
    const end_date = end_at.format('YYYY-MM-DD')
    const end_time = end_at.format('HH:mm:ss')
    const id = e.event.id
    const url = `/events/${id}/drop`
    const data = { start_date, start_time, end_date, end_time }
    await patch(url, { body: JSON.stringify(data) })
  }
}
