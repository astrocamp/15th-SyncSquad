# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  add_flash_types :success, :info, :mail
  helper_method :current_company
  before_action :set_locale

  def default_url_options
    { lang: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:lang]
  end

  def current_company
    @current_company ||= Company.find_by(id: session[:__company_ticket__])
  end

  private

  def not_found
    render file: Rails.public_path.join('404.html'),
           status: 404,
           layout: false
  end

  def not_authorized
    flash[:alert] = t('main.not_authorized')
    redirect_back(fallback_location: root_path)
  end
end
