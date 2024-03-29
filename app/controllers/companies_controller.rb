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
