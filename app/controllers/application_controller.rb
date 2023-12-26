# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  add_flash_types :success, :info, :mail
  helper_method :current_company

  def current_company
    Company.find_by(id: session[:__company_ticket__])
  end
  
  def not_found
    render file: Rails.public_path.join('404.html'),
           status: 404,
           layout: false
  end
end
