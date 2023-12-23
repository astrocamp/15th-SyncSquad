import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import dayjs from "dayjs";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["startDate", "startTime", "endDate", "endTime"];

  connect() {
    // 結束時間的日曆雛形
    flatpickr(this.endTimeTarget, {
      enableTime: true,
      noCalendar: true, // 不用日期
      minTime: this.getAdjustedTime(),
      minuteIncrement: 30,
      time_24hr: true,
    });

    // 開始日期調整結束日期
    flatpickr(this.startDateTarget, {
      enableTime: false,
      minDate: "today",
      // 選完開始日期就可以調整結束日期
      onChange: (selectedDates) => {
        flatpickr(this.endDateTarget, {
          enableTime: false,
          minDate: selectedDates[0] || "today",
          defaultDate: selectedDates[0] || "today",
        });
        // 選完開始日期就可以調整結束時間
        flatpickr(this.endTimeTarget, {
          enableTime: true,
          noCalendar: true, // 不用日期
          defaultDate: this.getAdjustedTime(),
          minTime: this.getAdjustedTime(),
          minuteIncrement: 30,
          time_24hr: true,
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
      onChange: (selectedDates) => {
        flatpickr(this.endTimeTarget, {
          enableTime: true,
          noCalendar: true, // 不用日期
          defaultDate: this.getAdjustedTime(),
          minTime: this.getAdjustedTime(),
          minuteIncrement: 30,
          time_24hr: true,
        });
      },
    });

    // 結束日期 配合 同一天
    flatpickr(this.endDateTarget, {
      enableTime: false, // 不用時間
      minDate: "today",
      onChange: (selectedDates) => {
        flatpickr(this.endTimeTarget, {
          enableTime: true,
          noCalendar: true, // 不用日期
          defaultDate: this.getAdjustedTime(),
          minTime: this.getAdjustedTime(),
          minuteIncrement: 30,
          time_24hr: true,
        });
      },
    });
  }

  getAdjustedTime() {
    return this.startDateTarget.value === this.endDateTarget.value
      ? dayjs(`${this.startDateTarget.value} ${this.startTimeTarget.value}`)
          .add(5, "minute")
          .format("HH:mm")
      : "00:00";
  }
}
