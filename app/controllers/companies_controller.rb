class CompaniesController < ApplicationController
    def new
        @company = Company.new
      end
    
      def create
        @company = Company.new(company_params)
    
        if @company.save
          redirect_to root_path, notice: '公司建立成功'
        else
          render :new
        end
      end
    
      private
    
      def company_params
        params.require(:company)
              .permit(:name, :email, :password, :password_confirmation)
      end
end
