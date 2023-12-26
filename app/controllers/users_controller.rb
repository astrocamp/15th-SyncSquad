class UsersController < Devise::RegistrationsController
    def new
        @user = User.new
    end

    def create
        @company = Company.find(params[:company_id])
        @user = @company.users.build(user_params) # 創建與公司關聯的用戶
          if @user.save
            redirect_to root_path, notice: '員工建立成功'
          else
            redirect_to root_path, alert: '員工建立失敗'
          end
          
    end

    def company_params
        params.require(:company)
              .permit(:name, :email, :password, :password_confirmation)
    end

    def user_params
        params.require(:user)
              .permit(:name, :email, :password, :password_confirmation) 
    end
end
