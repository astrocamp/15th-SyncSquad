# frozen_string_literal: true

class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      session[:__company_ticket__] = @company.id
      redirect_to root_path, success: t('company.creation_success')
    else
      redirect_to new_company_path, alert: t('company.creation_failed')
    end
  end

  def sign_in; end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])

    if @company.update(company_params)
      redirect_to company_path, notice: '更新成功'
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
