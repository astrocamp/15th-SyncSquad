import ColorPicker from 'stimulus-color-picker'
import { put } from '@rails/request.js'

export default class extends ColorPicker {
  static targets = ['input']

  connect() {
    super.connect()

    this.picker
      .on('swatchselect', (color, instance) => {
        this.onSave(color)
        this.update(instance)
      })
      .on('hide', (instance) => {
        console.log('Event: "hide"', instance)
      })
      .on('change', (color, source, instance) => {
        console.log('Event: "change"', color, source, instance)
      })
      .on('changestop', (source, instance) => {
        console.log('Event: "changestop"', source, instance)
      })
  }

  onSave(color) {
    super.onSave(color)
  }

  update(instance) {
    put(this.inputTarget.dataset.colorUpdateUrl, {
      body: JSON.stringify({
        color: instance.getColor().toHEXA().toString(),
      }),
    }).then(window.location.replace(this.inputTarget.dataset.redirectToUrl))
    // 之後不用跳轉
  }

  get componentOptions() {
    return {
      interaction: {
        input: true,
      },
    }
  }

  get swatches() {
    return [
      '#A0AEC0',
      '#F56565',
      '#ED8936',
      '#ECC94B',
      '#48BB78',
      '#38B2AC',
      '#4299E1',
      '#667EEA',
      '#9F7AEA',
      '#ED64A6',
    ]
  }
}
