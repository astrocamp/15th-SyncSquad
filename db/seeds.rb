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

    generated_emails = Set.new
    while generated_emails.size < num_users do
        random_name = Faker::Name.name
        nick_name = random_name.split(' ').first
        random_email = Faker::Internet.email(name: random_name, separators: ['-'], domain: 'sync.squad.com')
        unless generated_emails.include?(random_email)
            begin
                gender = Faker::Number.within(range: 0..1)
                birthday = Faker::Date.birthday(min_age: 18, max_age: 65)
                phone = Faker::PhoneNumber.phone_number_with_country_code
                role = "hr"
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
                generated_emails << random_email
                create_project(new_user)
            rescue ActiveRecord::RecordInvalid => e
                puts "⚠️ 創建用戶時出現錯誤：#{e.message}"
            end
        end
    end
end

def create_project(new_user)
    generated_titles = Set.new
    num_projects = Faker::Number.within(range: 3..7)
    list_themes = [
        ['Todo', 'Doing', 'Complete'],
        ['Backlog', 'Doing', 'Review', 'Done'],
        ['Stories', 'To Do', 'In Process', 'Testing', 'Done'],
        ['Eliminate', 'Delegate', 'Schedule', 'Do'],
        ['Collaborating', 'Accommodating', 'Compromise', 'Competing', 'Avoiding']
    ]
    
    num_projects.times do
        random_project_title = Faker::Marketing.buzzwords.capitalize

        while generated_titles.include?(random_project_title)
            random_project_title = Faker::Marketing.buzzwords.capitalize
        end
        generated_titles << random_project_title

        random_project_description = Faker::Lorem.paragraph
        new_project = Project.create!(
            title: random_project_title,
            description: random_project_description,
            owner_id: new_user.id
        )
        new_project.members << new_user
        
        selected_theme = list_themes.sample
        selected_theme.each do |list_title|
            random_color = Faker::Color.hex_color
            new_list = List.create!(
                title: list_title,
                project_id: new_project.id,
                color: random_color
            )

            num_tasks = Faker::Number.within(range: 3..7)
            num_tasks.times do
                random_task_title = Faker::Lorem.sentence(word_count: 3)
                while generated_titles.include?(random_task_title)
                    random_task_title = Faker::Lorem.sentence(word_count: 3)
                end
                new_task = Task.create!(
                    title: random_task_title,
                    list_id: new_list.id
                )
                new_task.user = new_user
                generated_titles << random_task_title
            end
        end
        puts "　 - 建立專案：#{random_project_title}"
    end
end

puts "建立資料中..."

create_or_show_users(5)

puts "資料建立完成"