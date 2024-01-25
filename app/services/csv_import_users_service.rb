# frozen_string_literal: true

class CsvImportUsersService
  require 'csv'
  def call(file, company, user) # rubocop:disable Metrics/MethodLength
    csv_data = file.read.force_encoding('utf-8')
    success = 0
    failed_records = []
    CSV.parse(csv_data, headers: true).each_with_index do |row, idx|
      found_user = User.find_by(email: row['Email'])
      if found_user
        failed_records << "csv_import.email_exists_row_number_email|#{idx + 1}|#{row['Email']}"
      elsif %w[staff hr].include?(row['Role'])
        data = User.new(
          email: row['Email'], password: row['Password'],
          name: row['Name'], gender: row['Gender'],
          birthday: row['Birthday'], phone: row['Phone'],
          role: row['Role'], lang: row['Language'],
          time_zone: row['Time Zone'], nick_name: row['Nick Name'],
          company_id: company
        )
        if data.save
          success += 1
        else
          failed_records << "csv_import.#{data.errors.full_messages.join('&')}|#{idx + 1}"
        end
      else
        failed_records << "csv_import.role_row_number_email|#{idx + 1}"
      end
    end
    Importrecord.create(file:,
      status: failed_records.empty? ? 'Success' : 'Failures',
      total_count: success + failed_records.size, success_count: success,
      error_messages: failed_records, company_id: company, user_id: user
    )
  end
end
