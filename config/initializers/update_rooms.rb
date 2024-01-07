Rails.application.config.after_initialize do
    Room.update_specific_single_rooms_sort
  end