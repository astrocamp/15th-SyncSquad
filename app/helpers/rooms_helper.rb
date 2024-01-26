# frozen_string_literal: true

module RoomsHelper
  def format_user_name(user, max_length = 10)
    truncated_name = user.name.truncate(max_length)
    truncated_name
  end
end
