import ColorPicker from 'stimulus-color-picker'
import { put } from '@rails/request.js'

export default class extends ColorPicker {
  static targets = ['input']
  connect() {
    super.connect()
    if (this.inputTarget.value == '') {
      const defaultColor = '#4299E1'
      const btn = this.element.querySelector('button')
      btn.style.setProperty('--pcr-color', defaultColor)
      this.inputTarget.value = defaultColor
    }

    // Pickr instance
    this.picker
      .on('changestop', (source, instance) => {
        this.updateColorReview(instance)
        this.onSave(color)
      })
      .on('swatchselect', (color, instance) => {
        this.updateColorReview(instance)
        this.onSave(color)
      })
  }

  // Callback when the color is saved
  onSave(color) {
    super.onSave(color)
  }

  // You can override the components options with this getter.
  // Here are the default options.
  get componentOptions() {
    return {
      preview: false,
      hue: false,

      interaction: {
        input: true,
        clear: false,
        save: false,
      },
    }
  }

  updateColorReview(instance) {
    instance._eventBindings[6][0].style.setProperty(
      '--pcr-color',
      instance.getColor().toHEXA().toString()
    )
  }

  get swatches() {
    return ['#F56565', '#ED8936', '#ECC94B', '#48BB78', '#4299E1', '#9F7AEA']
  }
}
