import ColorPicker from 'stimulus-color-picker'

export default class extends ColorPicker {
  connect() {
    super.connect()

    this.picker
  }

  onSave(color) {
    super.onSave(color)
  }

  get componentOptions() {
    return {
      preview: true,
      hue: true,

      interaction: {
        input: true,
        clear: true,
        save: true,
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
