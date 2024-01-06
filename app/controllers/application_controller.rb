# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  add_flash_types :success, :info, :mail
  helper_method :current_company, :company_signed_in?
  around_action :switch_locale

  def default_url_options
    { lang: I18n.locale }
  end

  def switch_locale(&)
    lang = params[:lang] || I18n.default_locale
    I18n.with_locale(lang, &)
  end

  def current_company
    @current_company || Company.find_by(id: session[:__company_ticket__])
  end

  def company_signed_in?
    current_company.present?
  end

  def authenticate_user_or_company!
    unless user_signed_in? || company_signed_in?
      redirect_to root_path, alert: "請先登入=="
    end
  end

  def not_found
    render file: Rails.public_path.join('404.html'),
          status: 404,
          layout: false
  end
end
