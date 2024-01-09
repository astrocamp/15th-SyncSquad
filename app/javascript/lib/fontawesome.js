import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faEllipsis } from '@fortawesome/free-solid-svg-icons/faEllipsis'
import { faBuilding } from '@fortawesome/free-solid-svg-icons/faBuilding'
import { faUser } from '@fortawesome/free-solid-svg-icons/faUser'
import { faPlus } from '@fortawesome/free-solid-svg-icons/faPlus'
import { faCircleChevronLeft } from '@fortawesome/free-solid-svg-icons/faCircleChevronLeft'
import { faChartSimple } from '@fortawesome/free-solid-svg-icons/faChartSimple'
import { faCalendar } from '@fortawesome/free-regular-svg-icons/faCalendar'

library.add({
  faEllipsis,
  faBuilding,
  faUser,
  faPlus,
  faCircleChevronLeft,
  faChartSimple,
  faCalendar,
})

dom.watch()
