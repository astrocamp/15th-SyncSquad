# frozen_string_literal: true

module UsersHelper
  require 'csv'
  def import # rubocop:disable Metrics/MethodLength,Metrics/PerceivedComplexity
    file = params[:file]
    if file.nil? || file.content_type != 'text/csv'
      return redirect_to users_import_path,
                         notice: t('import.please_choose_file')
    end

    csv_data = params[:file].read.force_encoding('utf-8')
    success = 0
    failed_records = []
    CSV.parse(csv_data, headers: true).each_with_index do |row, idx|
      user = User.find_by(email: row['Email'])
      if user
        failed_records << "Row #{idx + 1} - Email:#{row['Email']} exist in system"
      else
        data = User.new(
          email: row['Email'], password: row['Password'],
          name: row['Name'], gender: row['Gender'],
          birthday: row['Birthday'], phone: row['Phone'],
          role: row['Role'], lang: row['Language'],
          time_zone: row['Time Zone'], nick_name: row['Nick Name'],
          company_id: current_company.id
        )
        if data.save
          success += 1
        else
          failed_records << "Row #{idx + 1} - #{data.errors.full_messages.join(' & ')}"
        end
      end
    end
    Importrecord.create(file:, created_at: Time.current,
                        status: failed_records.empty? ? 'Records success' : 'Failures detected',
                        total_count: success + failed_records.size, success_count: success,
                        error_messages: failed_records)
    redirect_to users_import_records_path, notice: t('import.data_import_process')
  end
end
