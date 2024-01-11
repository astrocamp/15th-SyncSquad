# frozen_string_literal: true

module Users
  module Registrations
    class SessionsController < Devise::SessionsController
      # before_action :configure_sign_in_params, only: [:create]

      # GET /resource/sign_in
      # def new
      #   super
      # end

      # POST /resource/sign_in
      def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message!(:success, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
      end

      # DELETE /resource/sign_out
      def destroy
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        set_flash_message! :success, :signed_out if signed_out
        yield if block_given?
        respond_to_on_destroy
      end

      def after_sign_out_path_for(_resource_or_scope)
        new_user_session_path
      end

      def after_sign_in_path_for(resource_or_scope)
        stored_location_for(resource_or_scope) || root_path
      end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_in_params
      #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
      # end
    end
  end
end
