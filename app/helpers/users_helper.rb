module UsersHelper
  require 'csv'
  def import
    file = params[:file]
    return redirect_to users_import_path, notice: '只能傳CSV檔案' unless file.content_type == 'text/csv'

    csv_data = params[:file].read.force_encoding('utf-8')

    success = 0
    failed_records = []

    CSV.parse(csv_data, headers: true) do |row|
      user = User.find_by(email: row['Email'])
      if user
        failed_records << ["email: #{row['Email']} 存在於系統"]
      else
        data = User.new(
          email: row['Email'],
          password: row['Password'],
          name: row['Name'],
          gender: row['Gender'],
          birthday: row['Birthday'],
          phone: row['Phone'],
          role: row['Role'],
          lang: row['Language'],
          time_zone: row['Time Zone'],
          nick_name: row['Nick Name'],
          company_id: current_company.id,
        )
        if data.save
          success += 1
        else
          failed_records << ["詳細錯誤：#{data.errors.full_messages.join(', ')}"]
        end

      end
    end

    redirect_to users_import_path,
                notice: "#{success} 筆 import 成功，但 #{failed_records.size} 筆失敗，詳細錯誤：#{failed_records.join(', ')}"
  end
end
