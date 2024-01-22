import { Controller } from '@hotwired/stimulus'
import { patch } from '@rails/request.js'

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ['field', 'map']
  connect() {
    const { location, latitude, longitude } = this.mapTarget.dataset
    const lat = Number(latitude)
    const lng = Number(longitude)
    if (location) {
      this.mapTarget.style.height = '144px'
      this.locationMap(lat, lng)
    } else {
      this.mapTarget.style.height = '0'
    }
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget)
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this))
  }
  locationMap(lat, lng) {
    const map = new google.maps.Map(this.mapTarget, {
      center: {
        lat: lat,
        lng: lng,
      },
      zoom: 15,
    })
    new google.maps.Marker({
      position: {
        lat: lat,
        lng: lng,
      },
      map: map,
    })
  }
  placeChanged() {
    this.mapTarget.style.height = '144px'
    const place = this.autocomplete.getPlace()
    const changeLat = place.geometry.location.lat()
    const changeLng = place.geometry.location.lng()
    const map = new google.maps.Map(this.mapTarget, {
      center: {
        lat: changeLat,
        lng: changeLng,
      },
      zoom: 15,
    })
    new google.maps.Marker({
      position: {
        lat: changeLat,
        lng: changeLng,
      },
      map: map,
    })
    this.updateLocation(changeLat, changeLng)
  }
  resetLocation(event) {
    event.preventDefault()
    this.fieldTarget.value = ''
    this.updateLocation(null, null)
    this.mapTarget.style.height = '0'
  }

  async updateLocation(latitude, longitude) {
    const { id } = this.mapTarget.dataset
    const url = `/tasks/${id}/update_location`
    const data = { latitude: latitude, longitude: longitude }
    const result = await patch(url, {
      body: JSON.stringify(data),
    })
  }
}
