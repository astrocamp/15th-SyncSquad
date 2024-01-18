import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faEllipsis } from '@fortawesome/free-solid-svg-icons/faEllipsis'
import { faBuilding } from '@fortawesome/free-solid-svg-icons/faBuilding'
import { faUser } from '@fortawesome/free-solid-svg-icons/faUser'
import { faPlus } from '@fortawesome/free-solid-svg-icons/faPlus'
import { faCircleChevronLeft } from '@fortawesome/free-solid-svg-icons/faCircleChevronLeft'
import { faChartSimple } from '@fortawesome/free-solid-svg-icons/faChartSimple'
import { faLocationDot } from '@fortawesome/free-solid-svg-icons/faLocationDot'
import { faCheck } from '@fortawesome/free-solid-svg-icons/faCheck'
import { faAnglesUp } from '@fortawesome/free-solid-svg-icons/faAnglesUp'
import { faCalendar } from '@fortawesome/free-regular-svg-icons/faCalendar'
import { faTrashCan } from '@fortawesome/free-regular-svg-icons/faTrashCan'

library.add({
  faEllipsis,
  faBuilding,
  faUser,
  faPlus,
  faCircleChevronLeft,
  faChartSimple,
  faLocationDot,
  faCalendar,
  faTrashCan,
  faCheck,
  faAnglesUp,
})

dom.watch()
