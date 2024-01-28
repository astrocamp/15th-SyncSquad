# frozen_string_literal: true

class CsvImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform(file_path, company_id, user_id)
    CsvImportUsersService.new.call(file_path, company_id, user_id)
  end
end
