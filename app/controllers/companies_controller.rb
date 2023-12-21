# frozen_string_literal: true

class CompaniesController < ApplicationController
  def index; end

  def edit; end

  def show; end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: '創建公司成功'
    else
      render :new
    end
  end

  private

  def company_params
    params.require(:company)
          .permit(:name, :gui, :email, :password, :password_confirmation, :hr_name, :hr_email, :hr_password, :hr_password_confirmation)
  end
end
