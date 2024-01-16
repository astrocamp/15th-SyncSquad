import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import dayjs from "dayjs";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["startedAt", "endedAt", "allDay"];

  connect() {
    if (this.allDayTarget.checked) {
      flatpickr(this.endedAtTarget, {
        enableTime: false,
        defaultDate: this.endedAtTarget.value,
        minDate: this.startedAtTarget.value,
      });
      flatpickr(this.startedAtTarget, {
        enableTime: false,
        defaultDate: this.startedAtTarget.value,
        onChange: (selectedDates) => {
          flatpickr(this.endedAtTarget, {
            enableTime: false,
            defaultDate: selectedDates[0],
            minDate: selectedDates[0],
          });
        },
      });
    } else {
      flatpickr(this.endedAtTarget, {
        enableTime: true,
        minuteIncrement: 30,
        time_24hr: true,
        defaultDate: this.endedAtTarget.value,
        minDate: this.startedAtTarget.value,
      });
      flatpickr(this.startedAtTarget, {
        enableTime: true,
        minuteIncrement: 30,
        time_24hr: true,
        defaultDate: this.startedAtTarget.value,
        onChange: (selectedDates) => {
          flatpickr(this.endedAtTarget, {
            enableTime: true,
            minuteIncrement: 30,
            time_24hr: true,
            defaultDate: selectedDates[0],
            minDate: selectedDates[0],
          });
        },
      });
    }
  }

  clickedAllDay(event) {
    if (event.target.checked) {
      flatpickr(this.endedAtTarget, {
        enableTime: false,
        defaultHour: "00",
        defaultMinute: "00",
        defaultDate: this.endedAtTarget.value,
        minDate: this.startedAtTarget.value,
      });
      flatpickr(this.startedAtTarget, {
        enableTime: false,
        defaultHour: "00",
        defaultMinute: "00",
        defaultDate: this.startedAtTarget.value,
        onChange: (selectedDates) => {
          flatpickr(this.endedAtTarget, {
            enableTime: false,
            defaultHour: "00",
            defaultMinute: "00",
            defaultDate: selectedDates[0],
            minDate: selectedDates[0],
          });
        },
      });
    } else {
      flatpickr(this.endedAtTarget, {
        enableTime: true,
        minuteIncrement: 30,
        time_24hr: true,
        defaultDate: this.endedAtTarget.value,
        minDate: this.startedAtTarget.value,
      });

      flatpickr(this.startedAtTarget, {
        enableTime: true,
        minuteIncrement: 30,
        time_24hr: true,
        defaultDate: this.startedAtTarget.value,
        onChange: (selectedDates) => {
          flatpickr(this.endedAtTarget, {
            enableTime: true,
            minuteIncrement: 30,
            defaultDate: selectedDates[0],
            minDate: selectedDates[0],
          });
        },
      });
    }
  }
}
