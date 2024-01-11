import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="map"
export default class extends Controller {
  connect() {
    const map = new google.maps.Map(this.element, {
      center: {
        lat: Number(this.element.dataset.mapLatitude),
        lng: Number(this.element.dataset.mapLongitude),
      },
      zoom: 15,
    });
    new google.maps.Marker({
      position: {
        lat: Number(this.element.dataset.mapLatitude),
        lng: Number(this.element.dataset.mapLongitude),
      },
      map: map,
    });
  }
}
