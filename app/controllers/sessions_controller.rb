# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    company = Company.login(params[:company])

    if company
      session[:__company_ticket__] = company.id
      redirect_to root_path, notice: t('company.login_success')
    else
      redirect_to sign_in_companies_path, alert: t('company.login_failed')
    end
  end

  def destroy
    session.delete(:__company_ticket__)
    redirect_to root_path, notice: t('company.logout_success')
  end
end
