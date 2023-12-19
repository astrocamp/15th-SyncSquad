import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["startDate", "startTime", "endDate", "endTime"];

  connect() {
    // 結束時間的日曆雛形
    flatpickr(this.endTimeTarget, {
      enableTime: true,
      noCalendar: true, // 不用日期

      minuteIncrement: 30,
      time_24hr: true,
    });

    // 開始日期調整結束日期
    flatpickr(this.startDateTarget, {
      enableTime: false,
      minDate: "today",

      // 選完開始日期就可以調整結束日期
      onClose: (selectedDates) => {
        flatpickr(this.endDateTarget, {
          enableTime: false,
          minDate: selectedDates[0] || "today",
          defaultDate: selectedDates[0] || "today",
        });
      },
    });
    // 開始時間調整結束時間
    flatpickr(this.startTimeTarget, {
      enableTime: true,
      noCalendar: true, // 不用日期

      minuteIncrement: 30,
      time_24hr: true,
      // 選完開始時間就可以調整結束時間
      onClose: (selectedDates) => {
        flatpickr(this.endTimeTarget, {
          enableTime: true,
          noCalendar: true, // 不用日期
          defaultDate:
            this.startDateTarget.value == this.endDateTarget.value
              ? selectedDates[0]
              : "12:00",
          minTime:
            this.startDateTarget.value == this.endDateTarget.value
              ? selectedDates[0]
              : "12:00",
          minuteIncrement: 30,
          time_24hr: true,
        });
      },
    });

    // 結束日期 配合 同一天
    flatpickr(this.endDateTarget, {
      enableTime: false, // 不用時間
      minDate: "today",

      onClose: (selectedDates) => {
        flatpickr(this.endTimeTarget, {
          enableTime: true,
          noCalendar: true, // 不用日期
          defaultDate:
            this.startDateTarget.value == this.endDateTarget.value
              ? selectedDates[0]
              : "12:00",
          minTime:
            this.startDateTarget.value == this.endDateTarget.value
              ? selectedDates[0]
              : "12:00",
          minuteIncrement: 30,
          time_24hr: true,
        });
      },
    });
  }
}
