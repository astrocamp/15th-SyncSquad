# frozen_string_literal: true

module Users
  module Registrations
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_sign_up_params, only: [:create]
      before_action :configure_account_update_params, only: [:update]

      # GET /resource/sign_up
      # def new
      #   super
      # end

      # POST /resource
      # def create
      #   super
      # end

      # GET /resource/edit
      # def edit
      #   super
      # end

      def update        
        if resource.update_without_password(account_update_params)
          set_flash_message :notice, :updated
          sign_in resource_name, resource, bypass: true
          redirect_to after_update_path_for(resource)
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      end
      # DELETE /resource
      # def destroy
      #   super
      # end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      # def cancel
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up,
                                          keys: %i[name nick_name gender birthday phone time_zone lang email role avatar]).push(:company_id)
      end

      # If you have extra params to permit, append them to the sanitizer.
      def configure_account_update_params
        devise_parameter_sanitizer.permit(:account_update,
                                          keys: %i[name nick_name gender birthday phone time_zone lang email role avatar].push(:company_id))
      end
      

      # The path used after sign up.
      # def after_sign_up_path_for(resource)
      #   super(resource)
      # end

      # The path used after sign up for inactive accounts.
      # def after_inactive_sign_up_path_for(resource)
      #   super(resource)
      # end
    end
  end
end
