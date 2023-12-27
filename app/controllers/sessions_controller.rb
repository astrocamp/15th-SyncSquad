# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    company = Company.login(params[:company])

    if company
      session[:__company_ticket__] = company.id
      redirect_to root_path, notice: '登入成功'
    else
      redirect_to sign_in_companies_path, alert: '登入失敗'
    end
  end

  def destroy
    session.delete(:__company_ticket__)
    redirect_to root_path, notice: '已登出'
  end
end
