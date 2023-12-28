import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'
import { put } from '@rails/request.js'

// Connects to data-controller="sortable"
export default class extends Controller {
  static values = {
    group: String,
  }

  connect() {
    Sortable.create(this.element, {
      onEnd: this.onEnd.bind(this),
      group: this.groupValue,
      animation: 150,
    })
  }

  onEnd(event) {
    put(event.item.dataset.sortbaleUpdateUrl, {
      body: JSON.stringify({
        row_order_position: event.newIndex,
        list_id: event.to.dataset.sortableId,
      }),
    })
    console.log(event.to.dataset.sortableId)
  }
}
