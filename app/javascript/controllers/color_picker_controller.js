import ColorPicker from 'stimulus-color-picker'
import { put } from '@rails/request.js'

export default class extends ColorPicker {
  static targets = ['input']

  connect() {
    super.connect()

    this.picker
      .on('changestop', (source, instance) => {
        this.updateColorReview(instance)
      })
      .on('swatchselect', (color, instance) => {
        this.updateColorReview(instance)
        this.onSave(color)
        this.update(instance)
      })
      .on('hide', (instance) => {
        this.onSave(instance.color)
        this.update(instance)
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
    })
  }

  updateColorReview(instance) {
    instance._eventBindings[6][0].style.setProperty(
      '--pcr-color',
      instance.getColor().toHEXA().toString()
    )
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
