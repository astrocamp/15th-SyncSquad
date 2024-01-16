# frozen_string_literal: true

module ApplicationHelper
  def locale_full_calendar
    case I18n.locale
    when :en
      "en-us"
    when :tw
      "zh-tw"
    end
  end
end
