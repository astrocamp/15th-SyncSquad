# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def create_or_show_users(num_users)
    num_users.times do
        random_name = Faker::Name.name
        nick_name = random_name.split(' ').first
        random_email = Faker::Internet.email(name: random_name, separators: ['-'], domain: 'sync.squad.com')
        existing_user = User.find_by(email: random_email)
        if existing_user
            puts "⛔ 信箱已註冊：#{existing_user.email}，暱稱：#{existing_user.nick_name}"
        else
            begin
                gender = Faker::Number.within(range: 0..1)
                birthday = Faker::Date.birthday(min_age: 18, max_age: 65)
                phone = Faker::PhoneNumber.phone_number_with_country_code
                role = nil
                lang = 'en'
                time_zone = '+0800'
                new_user = User.create!(
                    email: random_email,
                    password: '123456',
                    gender: gender,
                    name: random_name,
                    nick_name: nick_name,
                    birthday: birthday,
                    phone: phone,
                    role: role,
                    lang: lang,
                    time_zone: time_zone
                )
                puts "✅ 註冊新信箱：#{new_user.email}，暱稱：#{new_user.nick_name}"
            rescue ActiveRecord::RecordInvalid => e
                puts "⚠️ 創建用戶時出現錯誤：#{e.message}"
            end
        end
    end
end

puts "建立資料中..."

create_or_show_users(5)

puts "資料建立完成"